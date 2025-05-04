package main

import (
	"github.com/indeedhat/icl"
)

const dbFile = "db/preorder.icl"

type preorderList struct {
	Version   int        `icl:"version"`
	Preorders []preorder `icl:"preorder"`
}

type preorder struct {
	Title       string `icl:"title"`
	User        string `icl:"user"`
	ReleaseDate string `icl:"release_date"`
}

func save(list *preorderList) error {
	return icl.MarshalFile(*list, dbFile)
}

func load() (*preorderList, error) {
	var list preorderList
	if err := icl.UnMarshalFile(dbFile, &list); err != nil {
		return nil, err
	}

	return &list, nil
}
