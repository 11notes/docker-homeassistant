package main

import (
	"os"

	"github.com/11notes/go-eleven"
)

const SECRETS = "/homeassistant/etc/packages/secrets.yaml"

func main() {
	if _, err := os.Stat(SECRETS); !os.IsNotExist(err) {
		if err := eleven.Container.FileContentReplaceEnv(SECRETS); err != nil {
			eleven.Log("WRN", "could not replace variables: %s", err.Error())
		}
	}

	eleven.Container.Run("/usr/local/bin", "python", []string{"-m", "homeassistant", "--config", "/homeassistant/etc"}, []string{})
}