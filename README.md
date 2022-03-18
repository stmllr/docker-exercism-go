# Minimalistic Docker image for practicing the exercism go track


## Content

The docker image is based on the go:alpine. It ships:
 * golang
 * dlv, shadow, golint, golangci-lint
 * colorized bash
 * vim
 * exercism binary to download and submit exercises

## Build and Run

```
docker build . -t exercism:go
docker run -it --name go-exercism -v $(PWD):/exercism/exercises exercism:go
```


