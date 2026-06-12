package system

import (
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
)

// Platform holds detected system information
type Platform struct {
	OS          string
	Arch        string
	Distro      string
	HomeDir     string
	ConfigDir   string
	HasStow     bool
	HasGit      bool
	HasHomebrew bool
	HasCurl     bool
	HasWget     bool
}

// ExistingConfigs holds detected existing configurations
type ExistingConfigs struct {
	Nvim     bool
	Fish     bool
	Zsh      bool
	Nushell  bool
	Tmux     bool
	Zellij   bool
	Alacritty bool
	WezTerm  bool
	Kitty    bool
	Ghostty  bool
	Starship bool
	Fzf      bool
	Zoxide   bool
}

// DetectPlatform detects the current system platform
func DetectPlatform() Platform {
	home, _ := os.UserHomeDir()
	configDir := filepath.Join(home, ".config")
	if runtime.GOOS == "darwin" {
		configDir = filepath.Join(home, "Library", "Application Support")
	}

	return Platform{
		OS:          runtime.GOOS,
		Arch:        runtime.GOARCH,
		Distro:      detectDistro(),
		HomeDir:     home,
		ConfigDir:   configDir,
		HasStow:     commandExists("stow"),
		HasGit:      commandExists("git"),
		HasHomebrew: commandExists("brew"),
		HasCurl:     commandExists("curl"),
		HasWget:     commandExists("wget"),
	}
}

// DetectExistingConfigs detects existing tool configurations
func DetectExistingConfigs(homeDir string) ExistingConfigs {
	configs := ExistingConfigs{}

	// Neovim
	configs.Nvim = dirExists(filepath.Join(homeDir, ".config", "nvim")) ||
		fileExists(filepath.Join(homeDir, ".config", "nvim", "init.lua"))

	// Fish
	configs.Fish = dirExists(filepath.Join(homeDir, ".config", "fish")) ||
		fileExists(filepath.Join(homeDir, ".config", "fish", "config.fish"))

	// Zsh
	configs.Zsh = fileExists(filepath.Join(homeDir, ".zshrc")) ||
		dirExists(filepath.Join(homeDir, ".oh-my-zsh"))

	// Nushell
	configs.Nushell = dirExists(filepath.Join(homeDir, ".config", "nushell")) ||
		fileExists(filepath.Join(homeDir, ".config", "nushell", "config.nu"))

	// Tmux
	configs.Tmux = fileExists(filepath.Join(homeDir, ".tmux.conf")) ||
		dirExists(filepath.Join(homeDir, ".tmux"))

	// Zellij
	configs.Zellij = dirExists(filepath.Join(homeDir, ".config", "zellij"))

	// Alacritty
	configs.Alacritty = dirExists(filepath.Join(homeDir, ".config", "alacritty")) ||
		fileExists(filepath.Join(homeDir, ".config", "alacritty", "alacritty.toml"))

	// WezTerm
	configs.WezTerm = fileExists(filepath.Join(homeDir, ".wezterm.lua")) ||
		dirExists(filepath.Join(homeDir, ".config", "wezterm"))

	// Kitty
	configs.Kitty = dirExists(filepath.Join(homeDir, ".config", "kitty")) ||
		fileExists(filepath.Join(homeDir, ".config", "kitty", "kitty.conf"))

	// Ghostty
	configs.Ghostty = dirExists(filepath.Join(homeDir, ".config", "ghostty")) ||
		fileExists(filepath.Join(homeDir, ".config", "ghostty", "config"))

	// Starship
	configs.Starship = fileExists(filepath.Join(homeDir, ".config", "starship.toml"))

	// Fzf
	configs.Fzf = dirExists(filepath.Join(homeDir, ".fzf")) ||
		fileExists(filepath.Join(homeDir, ".fzfrc"))

	// Zoxide
	configs.Zoxide = commandExists("zoxide")

	return configs
}

func detectDistro() string {
	if runtime.GOOS == "darwin" {
		return "macos"
	}
	if data, err := os.ReadFile("/etc/os-release"); err == nil {
		content := string(data)
		if strings.Contains(content, "Arch") || strings.Contains(content, "arch") {
			return "arch"
		}
		if strings.Contains(content, "Fedora") || strings.Contains(content, "fedora") {
			return "fedora"
		}
		if strings.Contains(content, "Ubuntu") || strings.Contains(content, "ubuntu") || strings.Contains(content, "Debian") {
			return "debian"
		}
	}
	return "unknown"
}

func commandExists(cmd string) bool {
	_, err := exec.LookPath(cmd)
	return err == nil
}

func fileExists(path string) bool {
	_, err := os.Stat(path)
	return err == nil
}

func dirExists(path string) bool {
	info, err := os.Stat(path)
	return err == nil && info.IsDir()
}
