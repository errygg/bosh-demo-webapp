all: deps build

.PHONY: deps
deps:
	go get -d -v github.com/dustin/go-broadcast/...

.PHONY: build
build: deps
	go build -o pcf-consul-webapp-demo src/pcf-consul-webapp-demo/main.go src/pcf-consul-webapp-demo/rooms.go src/pcf-consul-webapp-demo/template.go