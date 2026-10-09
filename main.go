package main

import (
	"log"
	"os"
	"os/exec"
)

func main() {
	// 1. Принудительно скачиваем утилиту Telegram во время старта
	log.Println("Downloading tproxy-server...")
	cmdGet := exec.Command("go", "install", "://github.com")
	cmdGet.Stdout = os.Stdout
	cmdGet.Stderr = os.Stderr
	if err := cmdGet.Run(); err != nil {
		log.Fatalf("Failed to download: %v", err)
	}

	// 2. Получаем выданные платформой Render переменные
	port := os.Getenv("PORT")
	secret := os.Getenv("MTPROXY_SECRET")

	// 3. Запускаем бинарник Telegram с правильными аргументами
	log.Println("Starting tproxy-server on port " + port)
	cmdRun := exec.Command("/opt/render/project/go/bin/tproxy-server", "--addr", "0.0.0.0:"+port, "--secret", secret)
	cmdRun.Stdout = os.Stdout
	cmdRun.Stderr = os.Stderr
	if err := cmdRun.Run(); err != nil {
		log.Fatalf("Server crashed: %v", err)
	}
}
