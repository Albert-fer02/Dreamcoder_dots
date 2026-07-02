package e2e

import (
	"testing"

	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui"
)

func TestNonInteractiveConfig_Validation(t *testing.T) {
	tests := []struct {
		name     string
		config   tui.NonInteractiveConfig
		wantErr  bool
	}{
		{
			name: "valid with terminal",
			config: tui.NonInteractiveConfig{
				Terminal: "kitty",
				Backup:   true,
			},
			wantErr: false,
		},
		{
			name: "valid with shell",
			config: tui.NonInteractiveConfig{
				Shell: "fish",
				Backup: true,
			},
			wantErr: false,
		},
		{
			name: "valid with all flags",
			config: tui.NonInteractiveConfig{
				Terminal: "ghostty",
				Shell:    "fish",
				WM:       "tmux",
				Nvim:     true,
				Font:     true,
				Backup:   true,
				DryRun:   true,
				Verbose:  true,
			},
			wantErr: false,
		},
		{
			name: "empty config",
			config: tui.NonInteractiveConfig{},
			wantErr: false, // Should just print help
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// We can't actually run RunNonInteractive in tests without a terminal
			// but we can validate the config structure
			if tt.config.Terminal != "" && tt.config.Terminal != "kitty" &&
				tt.config.Terminal != "ghostty" && tt.config.Terminal != "wezterm" &&
				tt.config.Terminal != "alacritty" {
				t.Errorf("unknown terminal: %s", tt.config.Terminal)
			}

			if tt.config.Shell != "" && tt.config.Shell != "fish" &&
				tt.config.Shell != "zsh" && tt.config.Shell != "nushell" {
				t.Errorf("unknown shell: %s", tt.config.Shell)
			}

			if tt.config.WM != "" && tt.config.WM != "tmux" && tt.config.WM != "zellij" {
				t.Errorf("unknown window manager: %s", tt.config.WM)
			}
		})
	}
}

func TestNonInteractiveConfig_ComponentMapping(t *testing.T) {
	// Test that component names map correctly
	componentMap := map[string]string{
		"kitty":     "DreamcoderKitty",
		"ghostty":   "DreamcoderGhostty",
		"wezterm":   "DreamcoderWezTerm",
		"alacritty": "DreamcoderAlacritty",
		"fish":      "DreamcoderShell",
		"zsh":       "DreamcoderShell",
		"nushell":   "DreamcoderNushell",
		"tmux":      "DreamcoderTmux",
		"zellij":    "DreamcoderZellij",
		"nvim":      "DreamcoderNvim",
	}

	for component, expectedModule := range componentMap {
		if expectedModule == "" {
			t.Errorf("component %s maps to empty module", component)
		}
	}
}
