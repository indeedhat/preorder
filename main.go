package main

import (
	"embed"
	_ "embed"
	"encoding/json"
	"html/template"
	"io"
	"log"
	"net/http"
	"os"
	"sync"

	_ "github.com/joho/godotenv/autoload"
)

var saveMux sync.Mutex

//go:embed index.tpl
var indexFs embed.FS
var indexTpl *template.Template

func main() {
	var err error

	indexTpl, err = template.ParseFS(indexFs, "*.tpl")
	if err != nil {
		log.Fatal("failed to parse index template")
	}

	mux := http.NewServeMux()
	mux.HandleFunc("GET /", handleGet)
	mux.HandleFunc("POST /create", handleCreate)

	log.Print(http.ListenAndServe(":8081", mux))
}

func basicAuth(rw http.ResponseWriter, r *http.Request) bool {
	user, pass, ok := r.BasicAuth()
	if !ok || user != os.Getenv("BASIC_AUTH_USER") || pass != os.Getenv("BASIC_AUTH_PASS") {
		rw.Header().Set("WWW-Authenticate", `Basic realm="Restricted"`)
		rw.WriteHeader(http.StatusUnauthorized)
		rw.Write([]byte("Unauthorized"))
		return false
	}

	return true
}

func handleGet(rw http.ResponseWriter, r *http.Request) {
	if !basicAuth(rw, r) {
		return
	}

	list, err := load()
	if err != nil {
		log.Fatal("failed to load preorder list")
	}

	if err = indexTpl.ExecuteTemplate(rw, "index", list); err != nil {
		rw.WriteHeader(http.StatusInternalServerError)
		rw.Write([]byte("Failed to render index page"))
	}
}

type createRequest struct {
	Title       string `json:"title"`
	User        string `json:"user"`
	ReleaseDate string `json:"release_date"`
}

func handleCreate(rw http.ResponseWriter, r *http.Request) {
	if !basicAuth(rw, r) {
		return
	}

	saveMux.Lock()
	defer saveMux.Unlock()

	body, err := io.ReadAll(r.Body)
	if err != nil {
		log.Print("read body error")
		rw.WriteHeader(http.StatusInternalServerError)
		rw.Write([]byte("failed to parse request body"))
		return
	}

	var req createRequest
	if err := json.Unmarshal(body, &req); err != nil {
		log.Print("unmarshal error")
		rw.WriteHeader(http.StatusUnprocessableEntity)
		rw.Write([]byte("Invalid request json"))
		return
	}

	list, err := load()
	if err != nil {
		log.Print("load error")
		rw.WriteHeader(http.StatusInternalServerError)
		rw.Write([]byte("failed to load preorder list"))
		return
	}

	list.Preorders = append(
		[]preorder{{
			Title:       req.Title,
			User:        req.User,
			ReleaseDate: req.ReleaseDate,
		}},
		list.Preorders...,
	)

	if err := save(list); err != nil {
		log.Print("save error", err)
		rw.WriteHeader(http.StatusInternalServerError)
		rw.Write([]byte("failed to save preorder list"))
		return
	}

	rw.WriteHeader(http.StatusCreated)
}
