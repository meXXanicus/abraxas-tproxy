# ЭТАП 1: сборка
FROM golang:1.22-alpine AS builder
ENV GO111MODULE=on CGO_ENABLED=0
RUN apk add --no-cache git
RUN go install github.com/ВЛАДЕЛЕЦ/РЕПО/cmd/tproxy-server@latest

# ЭТАП 2: запуск
FROM alpine:latest
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=builder /go/bin/tproxy-server .
CMD ["sh", "-c", "./tproxy-server --addr 0.0.0.0:${PORT} --secret ${MTPROXY_SECRET}"]
