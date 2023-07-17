package buffer

import (
	"context"
	log "github.com/sirupsen/logrus"
	"golang.design/x/clipboard"
)

func Run(c chan<- string, selectCh <-chan string) {
	ch := clipboard.Watch(context.TODO(), clipboard.FmtText)
	for {
		select {
		case data := <-ch:
			log.Infof("got message from clipboard")
			c <- string(data)
		case selected := <-selectCh:
			log.Infof("got \"%-6s\" to restore", selected)
			clipboard.Write(clipboard.FmtText, []byte(selected))
		}
	}
}
