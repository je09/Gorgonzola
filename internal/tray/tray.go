package tray

import (
	_ "embed"
	"github.com/getlantern/systray"
	log "github.com/sirupsen/logrus"
	"gorgonzola/internal/config"
	"gorgonzola/internal/md5"
	"strings"
)

var (
	stopChan chan struct{}
)

type Tray struct {
	clipboard    []*Item
	SelectedChan chan string
	clipboardSet map[string]struct{}
}

func NewTray(ch chan string) *Tray {
	return &Tray{SelectedChan: ch}
}

func (t *Tray) Run(cChan <-chan string) {
	t.clipboardSet = make(map[string]struct{})
	go t.watch(cChan)
	systray.Run(onReady, onExit)
}

func (t *Tray) watch(cChan <-chan string) {
	for {
		select {
		case data := <-cChan:
			t.addNewEntry(data)
		case <-stopChan:
			break
		}
	}
}

func (t *Tray) addNewEntry(data string) {
	hash := md5.Hash(data)
	// data's been copied already, skipping.
	if _, ok := t.clipboardSet[hash]; ok {
		log.Infof("item with hash %s already exists", hash)
		return
	}

	t.clipboardShift()
	text := t.textTrim(data)
	t.clipboardSet[hash] = struct{}{}

	item := NewTrayItem(systray.AddMenuItem(strings.TrimSpace(text), strings.TrimSpace(data)), data)
	t.clipboard = append(t.clipboard, item)
	go item.WatchClick(t.SelectedChan)
}

func (t *Tray) clipboardShift() {
	if len(t.clipboard) >= config.MaxItems {
		firstHash := md5.Hash(t.clipboard[0].Data)
		delete(t.clipboardSet, firstHash)
		t.clipboard[0].Hide()
		t.clipboard = t.clipboard[1:]
	}
}

func (t *Tray) textTrim(data string) string {
	text := data
	r := []rune(data)
	if len(r) >= config.TextLength {
		text = string(r[:config.TextLength])
	}

	return text
}
