package tui

import (
	"fmt"
	"os"

	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/system"
)

// NonInteractiveConfig holds CLI flags for non-interactive mode
type NonInteractiveConfig struct {
	Shell       string
	Terminal    string
	WM          string
	Nvim        bool
	Font        bool
	Backup      bool
	DryRun      bool
	Verbose     bool
}

// RunNonInteractive executes installation without TUI
func RunNonInteractive(config NonInteractiveConfig) error {
	platform := system.DetectPlatform()

	fmt.Println("🎨 Dreamcoder OS - Non-Interactive Installer")
	fmt.Printf("Platform: %s/%s (%s)\n", platform.OS, platform.Arch, platform.Distro)

	// Build component list from flags
	var components []string

	if config.Terminal != "" && config.Terminal != "none" {
		components = append(components, config.Terminal)
	}

	if config.Shell != "" && config.Shell != "none" {
		components = append(components, config.Shell)
	}

	if config.WM != "" && config.WM != "none" {
		components = append(components, config.WM)
	}

	if config.Nvim {
		components = append(components, "nvim")
	}

	if len(components) == 0 {
		fmt.Println("No components specified. Use --help for usage.")
		return nil
	}

	fmt.Printf("Components: %v\n", components)

	// Backup existing configs if requested
	if config.Backup {
		fmt.Println("\n📦 Backing up existing configurations...")
		backupDir, manifest, err := system.CreateBackup(platform, components)
		if err != nil {
			return fmt.Errorf("backup failed: %w", err)
		}
		fmt.Printf("Backup created: %s (%d files)\n", backupDir, len(manifest.Files))
	}

	if config.DryRun {
		fmt.Println("\n🔍 Dry run - would install:")
		for _, comp := range components {
			fmt.Printf("  - %s\n", comp)
		}
		return nil
	}

	// Install components
	fmt.Println("\n📦 Installing components...")
	for _, comp := range components {
		fmt.Printf("  Installing %s...\n", comp)
		if err := installComponent(comp, platform); err != nil {
			fmt.Fprintf(os.Stderr, "  ❌ Failed to install %s: %v\n", comp, err)
			continue
		}
		fmt.Printf("  ✅ %s installed\n", comp)
	}

	fmt.Println("\n✅ Installation complete!")
	return nil
}

func installComponent(component string, platform system.Platform) error {
	// Map component to stow module
	moduleMap := map[string]string{
		"kitty":     "Kitty",
		"ghostty":   "Ghostty",
		"wezterm":   "WezTerm",
		"alacritty": "Alacritty",
		"fish":      "Shell",
		"zsh":       "Shell",
		"nushell":   "Nushell",
		"tmux":      "Tmux",
		"zellij":    "Zellij",
		"nvim":      "Nvim",
	}

	module, ok := moduleMap[component]
	if !ok {
		return fmt.Errorf("unknown component: %s", component)
	}

	// Run stow
	dotfilesDir := fmt.Sprintf("%s/Documents/PROYECTOS/dreamcoder-dots", platform.HomeDir)
	_, err := system.RunCommand("stow", "-d", dotfilesDir, "-t", platform.HomeDir, module)
	return err
}
