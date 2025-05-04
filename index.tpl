{{ define "index" }}
<!Doctype html>
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Preorder List</title>
        <link rel="stylesheet" href="/static/main.css" />
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
                        <span>Book Series</span>
                        <input type="text" name="series" required />
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
                            <h3>
                                {{ .Title }}
                                {{ if .Series }}
                                    <div class="series">{{ .Series }}</div>
                                {{ end }}
                            </h3>
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
        <script src="/static/main.js"></script>
    </body>
</html>
{{ end }}
