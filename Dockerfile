# ИСПОЛЬЗУЕМ ОФИЦИАЛЬНЫЙ ОБРАЗ GO ДЛЯ СБОРКИ
FROM golang:1.22-alpine AS builder
RUN apk add --no-cache git

# Скачиваем официальный исходный код tproxy-server от Telegram
RUN git clone https://github.com /app
WORKDIR /app

# Собираем бинарный файл сервера
RUN go build -o tproxy-server .

# ПЕРЕХОДИМ К МИНИМАЛЬНОМУ ОБРАЗУ ДЛЯ ЗАПУСКА
FROM alpine:latest
RUN apk add --no-cache ca-certificates

WORKDIR /root/
COPY --from=builder /app/tproxy-server .

# Render автоматически назначает порт через переменную среды $PORT.
# Мы запускаем сервер и указываем ему слушать этот порт.
CMD ./tproxy-server -listen 0.0.0.0:$PORT -secret $MTPROXY_SECRET
