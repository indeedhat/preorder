{{ define "index" }}
<!Doctype html>
<html>
    <head>
        <title>Preorder List</title>
        <style>
            * {
                box-sizing: border-box;
            }
            html, body {
                margin: 0;
                padding: 0;
            }

            header {
                padding: 8px;
                border-bottom: 1px solid black;
                display: flex;
            }
            header h1 {
                flex-grow: 1
            }
            header .search {
                display: flex;
                align-items: center;
                justify-content: center;
            }

            section {
                padding: 8px;
                border-bottom: 1px solid black;
            }

            section#form {

            }
            section#form label {
                display: block;
            }
            section#form label span {
                display: inline-block;
                width: 100px;
            }

            article {
                display: flex;
                margin: 0 8px;
                border-bottom: 1px solid #ccc;
            }
            article:last-of-type {
                border: none;
            }
            article h3 {
                flex-grow: 1;
            }
            article .meta {
                display: flex;
                align-items: end;
                justify-content: center;
                flex-direction: column;
            }
            article .meta time {
                font-weight: bold;
                color: #aaa;
            }
            article .meta .name {
                font-weight: bold;
                color: #666;
            }
        </style>
    </head>
    <body>
        <header>
            <h1>Audiobook Preorder</h1>
            <div class="search">
                <input type="search" id="search" placeholder="Live Search..." />
            </div>
        </header>
        <main>
            <section id="form">
                <form>
                    <label>
                        <span>Book Title*</span>
                        <input type="text" name="title" required />
                    </label>
                    <label>
                        <span>User</span>
                        <input type="text" name="user" />
                    </label>
                    <label>
                        <span>Release Date</span>
                        <input type="date" name="release_date" />
                    </label>
                    <button type="submit">Save</button>
                </form>
            </section>
            <section id="list">
                {{ if .Preorders }}
                    {{ range .Preorders }}
                        <article>
                            <h3>{{ .Title }}</h3>
                            <div class="meta">
                               <time title="Release date">{{ or .ReleaseDate "Unknown" }}</time>
                               <div class="name">{{ or .User "Anonymous" }}</div>
                            </div>
                        </article>
                    {{ end }}
                {{ else }}
                    <div class="notice">There are no pre orders to display</div>
                {{ end }}
            </section>
        </main>
        <script>
            const $form = document.querySelector("section#form form")
            $form.addEventListener("submit", async e => {
                e.preventDefault()

                const data = new FormData($form)
                const resp = await fetch("/create", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: JSON.stringify({
                        title: data.get("title"),
                        user: data.get("user") || "",
                        release_date: data.get("release_date") || ""
                    })
                })

                if (!resp.ok) {
                    alert(`Error: ${resp.text()}`)
                    return;
                }

                location.reload()
            })

            const $search = document.getElementById("search")
            $search.addEventListener("keyup", e => {
                console.log("keyup")
                const $articles = document.getElementsByTagName("article")
                for (let i = 0; i < $articles.length; i++) {
                    const $article = $articles[i]
                    if ($search.value === "") {
                        $article.style.display = "flex";
                        continue
                    }

                    const title = $article.querySelector("h3").innerHTML.toLowerCase()
                    console.log({ $article, title, search: $search.value.toLowerCase(), cond:  title.includes($search.value.toLowerCase()) })
                    $article.style.display = title.includes($search.value.toLowerCase())
                        ? "flex"
                        : "none"
                }
            })
        </script>
    </body>
</html>
{{ end }}
