export PORT=${port}
export {{range service "counter@dc1"}}COUNTING_SERVICE_URL=http://{{.Address}}:{{.Port}}{{end}}
${directory}/dashboard
