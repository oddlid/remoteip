package main

import (
	"net/http"
	"github.com/tomasen/realip"
)

func showip(w http.ResponseWriter, r *http.Request) {
	ip := realip.FromRequest(r)
	w.Write([]byte(ip))
}

func main() {
	http.HandleFunc("/", showip)
	http.ListenAndServe(":1234", nil)
}
