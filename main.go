package main

import (
	"log"
	"os"
	"os/exec"
)

func main() {
	// 1. Скачиваем готовый официальный бинарник Telegram для Linux (без использования go install)
	log.Println("Downloading pre-compiled tproxy-server...")
	cmdDownload := exec.Command("curl", "-L", "-o", "tproxy-binary", "https://github.com")
	cmdDownload.Stdout = os.Stdout
	cmdDownload.Stderr = os.Stderr
	if err := cmdDownload.Run(); err != nil {
		log.Fatalf("Failed to download binary via curl: %v", err)
	}

	// 2. Делаем файл исполняемым в системе Linux
	cmdChmod := exec.Command("chmod", "+x", "tproxy-binary")
	if err := cmdChmod.Run(); err != nil {
		log.Fatalf("Failed to set executable permissions: %v", err)
	}

	// 3. Считываем порты и секрет из конфигурации Render
	port := os.Getenv("PORT")
	secret := os.Getenv("MTPROXY_SECRET")

	// 4. Запускаем чистый прокси-сервер
	log.Println("Starting official tproxy-server on port " + port)
	cmdRun := exec.Command("./tproxy-binary", "--addr", "0.0.0.0:"+port, "--secret", secret)
	cmdRun.Stdout = os.Stdout
	cmdRun.Stderr = os.Stderr
	if err := cmdRun.Run(); err != nil {
		log.Fatalf("Server crashed: %v", err)
	}
}

