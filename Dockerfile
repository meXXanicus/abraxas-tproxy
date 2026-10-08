# ШАГ 1: Компиляция официального исходного кода Telegram
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Скачиваем архив с исходным кодом актуальной ветки master и распаковываем его
ADD https://github.com .
RUN tar -xzf master.tar.gz --strip-components=1

# Собираем исполняемый бинарный файл
RUN CGO_ENABLED=0 GOOS=linux go build -o tproxy-server .


# ШАГ 2: Минимальный финальный контейнер для Render
FROM alpine:latest
RUN apk add --no-cache ca-certificates

WORKDIR /root/

# Переносим скомпилированный прокси-сервер
COPY --from=builder /app/tproxy-server .

# Команда запуска на порту Render с передачей вашего секрета
CMD ./tproxy-server --addr 0.0.0.0:$PORT --secret $MTPROXY_SECRET
