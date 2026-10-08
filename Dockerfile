# ШАГ 1: Компиляция репозитория в контейнере Go
FROM golang:1.22-alpine AS builder

# Устанавливаем git, так как менеджер пакетов Go использует его для скачивания кода
RUN apk add --no-cache git

# Для go install указывается чистый путь к репозиторию БЕЗ https:// в начале
RUN go install ://github.com

# ШАГ 2: Сборка финального чистого образа для работы в Render
FROM alpine:latest
RUN apk add --no-cache ca-certificates

WORKDIR /root/

# Переносим бинарный файл, который Go успешно скомпилировал на первом шаге
COPY --from=builder /go/bin/tproxy-server .

# Запуск прокси-сервера
CMD ./tproxy-server --addr 0.0.0.0:$PORT --secret $MTPROXY_SECRET
