#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
mkdir app && cd app
cat > main.go <<GO
package main
import "fmt"
func main() { fmt.Println("hello") }
GO
printf "module hello\ngo 1.24\n" > go.mod
cat > Dockerfile <<DOCKER
FROM golang:1.24 AS build
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o /hello .
FROM gcr.io/distroless/static
COPY --from=build /hello /hello
ENTRYPOINT ["/hello"]
DOCKER
docker buildx build --load -t hello:test .
docker run --rm hello:test
