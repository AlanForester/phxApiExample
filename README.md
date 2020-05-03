# Api

To start your server:

  * Run with `make up`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## visited_links
~~~
curl -X "POST" "http://localhost:4000/visited_links" \
     -H 'Content-Type: application/json' \
     -d $'{
  "links": [
    "https://ya.ru",
    "https://ya.ru?q=123",
    "funbox.ru",
    "https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor"
  ]
}'
~~~

## visited_domains
~~~
curl "http://localhost:4000/visited_domains?from=3&to=3213213232342"
~~~