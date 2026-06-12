package e2e

import (
	"os"
	"path/filepath"
	"runtime"
	"testing"

	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/system"
)

func TestDetectPlatform(t *testing.T) {
	platform := system.DetectPlatform()

	if platform.OS != runtime.GOOS {
		t.Errorf("expected OS %s, got %s", runtime.GOOS, platform.OS)
	}

	if platform.Arch != runtime.GOARCH {
		t.Errorf("expected Arch %s, got %s", runtime.GOARCH, platform.Arch)
	}

	if platform.HomeDir == "" {
		t.Error("HomeDir should not be empty")
	}

	if platform.ConfigDir == "" {
		t.Error("ConfigDir should not be empty")
	}
}

func TestDetectExistingConfigs(t *testing.T) {
	homeDir := t.TempDir()

	// Create some config directories to detect
	os.MkdirAll(filepath.Join(homeDir, ".config", "nvim"), 0755)
	os.MkdirAll(filepath.Join(homeDir, ".config", "fish"), 0755)
	os.MkdirAll(filepath.Join(homeDir, ".config", "kitty"), 0755)
	os.WriteFile(filepath.Join(homeDir, ".tmux.conf"), []byte("# tmux config"), 0644)

	configs := system.DetectExistingConfigs(homeDir)

	if !configs.Nvim {
		t.Error("should detect nvim config")
	}

	if !configs.Fish {
		t.Error("should detect fish config")
	}

	if !configs.Kitty {
		t.Error("should detect kitty config")
	}

	if !configs.Tmux {
		t.Error("should detect tmux config")
	}

	if configs.Zsh {
		t.Error("should not detect zsh config when not present")
	}

	if configs.Ghostty {
		t.Error("should not detect ghostty config when not present")
	}
}

func TestDetectExistingConfigs_Empty(t *testing.T) {
	homeDir := t.TempDir()
	configs := system.DetectExistingConfigs(homeDir)

	if configs.Nvim || configs.Fish || configs.Tmux || configs.Kitty || configs.Ghostty {
		t.Error("should not detect any configs in empty directory")
	}
}
