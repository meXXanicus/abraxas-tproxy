package main

import (
	"io"
	"log"
	"net/http"
	"net/http/httputil"
	"net/url"
	"os"
)

func main() {
	// Telegram API URL
	target, err := url.Parse("https://telegram.org")
	if err != nil {
		log.Fatalf("Ошибка парсинга URL: %v", err)
	}

	// Создаем обратный прокси (Reverse Proxy)
	proxy := httputil.NewSingleHostReverseProxy(target)

	// Настраиваем подмену заголовка Host, чтобы Telegram принимал запросы
	originalDirector := proxy.Director
	proxy.Director = func(req *http.Request) {
		originalDirector(req)
		req.Host = target.Host
	}

	// Маршрут для проверки работоспособности (Health Check)
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		io.WriteString(w, "⚡ Proxy is running!")
	})

	// Все остальные запросы отправляем в прокси
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Запрос: %s %s", r.Method, r.URL.Path)
		proxy.ServeHTTP(w, r)
	})

	// Получаем порт из переменных окружения Render (по умолчанию 8080)
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("Старт прокси на порту %s...", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatalf("Ошибка запуска сервера: %v", err)
	}
}
