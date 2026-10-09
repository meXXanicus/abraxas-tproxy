package main

import (
	"log"
	"os"
	"os/exec"
)

func main() {
	// 1. Считываем порт и секретный ключ, переданные платформой Render
	port := os.Getenv("PORT")
	secret := os.Getenv("MTPROXY_SECRET")

	log.Println("Initializing safe compile-and-run sequence for Telegram TProxy...")

	// 2. Запускаем компиляцию и выполнение кода Telegram ОДНОЙ командой.
	// Флаг @latest автоматически скачает исходники, а движок Go соберет их строго под архитектуру текущего процессора Render.
	cmdRun := exec.Command("go", "run", "://github.com", "--addr", "0.0.0.0:"+port, "--secret", secret)
	
	// Перенаправляем логи компиляции и работы в консоль Render
	cmdRun.Stdout = os.Stdout
	cmdRun.Stderr = os.Stderr

	log.Println("Compiling and launching official binary...")
	if err := cmdRun.Run(); err != nil {
		log.Fatalf("Process terminated: %v", err)
	}
}
