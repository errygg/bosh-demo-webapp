{{range service "consul-counter@dc1"}}COUNTING_SERVICE_URL=http://{{.Address}}:{{.Port}}{{end}}
