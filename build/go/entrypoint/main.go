package main

import (
	"os"
	"syscall"

	"github.com/11notes/go/v2"
)

const SECRETS = "/homeassistant/etc/packages/secrets.yaml"

func main() {
	if _, err := os.Stat(SECRETS); !os.IsNotExist(err) {
		if err := eleven.Container.EnvSubst(SECRETS); err != nil {
			eleven.Log("WRN", "could not replace variables", err.Error())
		}
	}
	if err := os.Symlink("/proc/self/fd/1", "/homeassistant/etc/home-assistant.log"); err != nil {
		eleven.LogFatal("could not redirect log to stdout")
	}
	eleven.Log("INF", "starting Home Assistant")
	if err := syscall.Exec("/usr/local/bin/python", []string{"python", "-m", "homeassistant", "--config", "/homeassistant/etc"}, os.Environ()); err != nil {
		os.Exit(1)
	}
}