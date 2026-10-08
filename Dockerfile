# ШАГ 1: СБОРКА ИСХОДНОГО КОДА
FROM golang:1.22-alpine AS builder
RUN apk add --no-cache git

# Клонируем официальный репозиторий tproxy-server (без лишних пробелов)
RUN git clone https://github.com /app
WORKDIR /app

# Компилируем бинарник для Linux
RUN CGO_ENABLED=0 GOOS=linux go build -o tproxy-server .

# ШАГ 2: МИНИМАЛЬНЫЙ ОБРАЗ ДЛЯ ЗАПУСКА
FROM alpine:latest
RUN apk add --no-cache ca-certificates curl

WORKDIR /root/
COPY --from=builder /app/tproxy-server .

# Запуск прокси с передачей порта и секретного ключа
CMD ./tproxy-server --addr 0.0.0.0:$PORT --secret $MTPROXY_SECRET