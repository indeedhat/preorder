const $form = document.querySelector("section#form form")
$form.addEventListener("submit", async e => {
    e.preventDefault()

    const data = new FormData($form)
    const resp = await fetch("/create", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: JSON.stringify({
            title: data.get("title"),
            series: data.get("series") || "",
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
$search.addEventListener("keyup", () => {
    const $articles = document.getElementsByTagName("article")
    for (let i = 0; i < $articles.length; i++) {
        const $article = $articles[i]
        if ($search.value === "") {
            $article.style.display = "flex";
            continue
        }

        const title = $article.querySelector("h3").innerHTML.toLowerCase()
        $article.style.display = title.includes($search.value.toLowerCase())
            ? "flex"
            : "none"
    }
})
