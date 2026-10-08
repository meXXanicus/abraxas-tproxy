# Используем легковесный образ Alpine Linux
FROM alpine:latest

# Устанавливаем необходимые пакеты (curl для скачивания и сертификаты для SSL)
RUN apk add --no-cache ca-certificates curl

WORKDIR /root/

# Напрямую скачиваем самый свежий официальный релиз tproxy-server для Linux x86_64
RUN curl -L -o tproxy-server https://github.com && \
    chmod +x tproxy-server

# Запускаем прокси на порту, который выделил нам Render, передавая секрет
CMD ./tproxy-server --addr 0.0.0.0:$PORT --secret $MTPROXY_SECRET

