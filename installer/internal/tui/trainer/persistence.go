package trainer

import (
	"encoding/json"
	"os"
	"path/filepath"
)

func GetSavePath() string {
	home, _ := os.UserHomeDir()
	return filepath.Join(home, ".config", "dreamcoder", "vim-trainer.json")
}

func SavePlayer(player *Player) error {
	path := GetSavePath()
	os.MkdirAll(filepath.Dir(path), 0755)

	data, err := json.MarshalIndent(player, "", "  ")
	if err != nil {
		return err
	}

	return os.WriteFile(path, data, 0644)
}

func LoadPlayer() (*Player, error) {
	path := GetSavePath()

	data, err := os.ReadFile(path)
	if err != nil {
		return NewPlayer(), nil // Return fresh player if no save
	}

	var player Player
	if err := json.Unmarshal(data, &player); err != nil {
		return NewPlayer(), nil
	}

	return &player, nil
}
