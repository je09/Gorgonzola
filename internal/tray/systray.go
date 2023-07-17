package tray

import (
	"fmt"
	"github.com/getlantern/systray"
	log "github.com/sirupsen/logrus"
	"gorgonzola/icon"
	"gorgonzola/internal/config"
)

func onReady() {
	systray.SetIcon(icon.Bytes)
	systray.SetTooltip(config.AppName)
	quit := systray.AddMenuItem("Quit", fmt.Sprintf("Quit %s", config.AppName))
	systray.AddSeparator()

	go func() {
		for {
			select {
			case <-quit.ClickedCh:
				systray.Quit()
				return
			}
		}
	}()
}

func onExit() {
	log.Infof("stopped by user")
	go func() { stopChan <- struct{}{} }()
}
