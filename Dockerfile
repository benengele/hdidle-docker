FROM golang:1.19.2-alpine3.16 AS build

RUN apk add build-base

WORKDIR /app
COPY hd-idle/go.sum hd-idle/go.mod hd-idle/hd-idle.8 hd-idle/*.go .
COPY hd-idle/diskstats diskstats
COPY hd-idle/io io
COPY hd-idle/sgio sgio
COPY hd-idle/vendor vendor
RUN go mod download
RUN go build
RUN go test ./... -race -cover


FROM alpine:3.16
COPY --from=build /app/hd-idle /app/hd-idle

ENTRYPOINT [ "/app/hd-idle" ]