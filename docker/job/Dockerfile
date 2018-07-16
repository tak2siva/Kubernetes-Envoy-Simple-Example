FROM golang:1.10.3-alpine3.7
RUN apk update
RUN apk add git
RUN go get k8s.io/client-go/...
RUN apk add vim