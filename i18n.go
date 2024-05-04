package main

import (
	"encoding/json"
	"errors"
	"log/slog"
	"os"
)

var Translations = map[string]string{}

func LoadLanguage(language string) error {
	filename := "i18n/" + language + ".json"

	if _, err := os.Stat(filename); errors.Is(err, os.ErrNotExist) {
		return err
	}

	fileContents, err := os.ReadFile(filename)
	if err != nil {
		slog.Error("error reading file",
			"error", err,
			"file", filename)
		return err
	}

	err = json.Unmarshal(fileContents, &Translations)
	return err
}

func TranslatableText(id string) string {
	if v, ok := Translations[id]; !ok {
		return id
	} else {
		return v
	}
}