package main

import (
	"gorgonzola/internal/buffer"
	"gorgonzola/internal/tray"
)

func main() {
	// clipboard channel.
	cbChan := make(chan string)
	// restore channel.
	rbChan := make(chan string)

	t := tray.NewTray(rbChan)
	go buffer.Run(cbChan, rbChan)
	t.Run(cbChan)
}
