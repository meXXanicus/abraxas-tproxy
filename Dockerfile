# ЭТАП 1: Чистая компиляция внутри официального Go-окружения
FROM golang:1.22-alpine AS builder

# Включаем модули Go и скачиваем официальный пакет Telegram без использования git clone
ENV GO111MODULE=on
RUN go install ://github.com

# ЭТАП 2: Создание минимального финального образа для запуска
FROM alpine:latest
RUN apk add --no-cache ca-certificates

WORKDIR /root/

# Забираем чистый бинарный файл, который Go скомпилировал на первом этапе
COPY --from=builder /go/bin/tproxy-server .

# Запуск прокси-сервера на динамическом порту платформы Render
CMD ./tproxy-server --addr 0.0.0.0:$PORT --secret $MTPROXY_SECRET
