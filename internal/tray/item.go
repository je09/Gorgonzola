package tray

import "github.com/getlantern/systray"

type Item struct {
	*systray.MenuItem
	Data     string
	StopChan chan struct{}
}

func NewTrayItem(menuItem *systray.MenuItem, data string) *Item {
	return &Item{MenuItem: menuItem, Data: data, StopChan: stopChan}
}

func (t *Item) Hide() {
	go func() { stopChan <- struct{}{} }()
	t.MenuItem.Hide()
}

func (t *Item) WatchClick(ch chan<- string) {
	for {
		select {
		case <-t.ClickedCh:
			ch <- t.Data
		case <-t.StopChan:
			break
		}
	}
}
