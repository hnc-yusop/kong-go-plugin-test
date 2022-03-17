FROM golang:alpine AS builder

RUN apk add --no-cache git gcc libc-dev curl
RUN mkdir /go-plugins
RUN wget https://raw.githubusercontent.com/Kong/go-plugins/master/go-hello.go -O /go-plugins/go-hello.go

RUN cd /go-plugins && \
    go mod init kong-go-plugin && \
    go get github.com/Kong/go-pdk && \
    go mod tidy && \
    go build go-hello.go

FROM kong
COPY --from=builder  /go-plugins/go-hello /usr/local/bin/
RUN /usr/local/bin/go-hello -dump
