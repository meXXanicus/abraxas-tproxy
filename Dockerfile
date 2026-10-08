# ШАГ 1: Скачиваем Go и компилируем прокси из официального репозитория Telegram
FROM golang:1.22-alpine AS builder

# Устанавливаем git, необходимый для загрузки зависимостей Go
RUN apk add --no-cache git

# Скачиваем и компилируем tproxy-server напрямую через утилиту Go
RUN go install ://github.com

# ШАГ 2: Создаем чистый минимальный образ для запуска
FROM alpine:latest
RUN apk add --no-cache ca-certificates

WORKDIR /root/

# Копируем скомпилированный на первом шаге чистый бинарник
COPY --from=builder /go/bin/tproxy-server .

# Запуск сервера на порту Render с вашим секретом
CMD ./tproxy-server --addr 0.0.0.0:$PORT --secret $MTPROXY_SECRET
