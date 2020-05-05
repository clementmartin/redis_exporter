# builder image
FROM golang:alpine AS builder

RUN apk update && apk add --no-cache git

WORKDIR $GOPATH/src

RUN git clone https://github.com/oliver006/redis_exporter.git
WORKDIR $GOPATH/src/redis_exporter
RUN git checkout v1.6.0
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/redis_exporter

# deployment image
FROM scratch
COPY --from=builder /go/bin/redis_exporter /redis_exporter
EXPOSE 9121
ENTRYPOINT ["/redis_exporter"]
