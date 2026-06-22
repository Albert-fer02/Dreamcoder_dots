package cmd

import (
	"fmt"
	"os"

	"github.com/fatih/color"
	"github.com/spf13/cobra"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/system"
)

func InstallCmd() *cobra.Command {
	var (
		components []string
		themeMode  string
		dryRun     bool
	)

	cmd := &cobra.Command{
		Use:   "install",
		Short: "Install Dreamcoder OS components",
		RunE: func(cmd *cobra.Command, args []string) error {
			green := color.New(color.FgGreen).SprintFunc()
			yellow := color.New(color.FgYellow).SprintFunc()
			red := color.New(color.FgRed).SprintFunc()

			platform := system.DetectPlatform()

			fmt.Println("📦 Dreamcoder OS Installer")
			fmt.Printf("Platform: %s/%s (%s)\n", platform.OS, platform.Arch, platform.Distro)

			// Check for stow
			if !platform.HasStow {
				fmt.Printf("  %s stow is required but not installed\n", red("✗"))
				fmt.Println("  Install stow: https://www.gnu.org/software/stow/")
				return fmt.Errorf("stow not found")
			}
			fmt.Printf("  %s stow found\n", green("✓"))

			// Check existing configs
			configs := system.DetectExistingConfigs(platform.HomeDir)
			printExistingConfigs(configs)

			// Backup if requested
			if backup, _ := cmd.Flags().GetBool("backup"); backup {
				fmt.Println("\n📦 Backing up existing configurations...")
				backupDir, manifest, err := system.CreateBackup(platform, components)
				if err != nil {
					fmt.Printf("  %s Backup failed: %v\n", red("✗"), err)
					return err
				}
				fmt.Printf("  %s Backup created: %s (%d files)\n", green("✓"), backupDir, len(manifest.Files))
			}

			if dryRun {
				fmt.Println("\n🔍 Dry run — would install:")
				for _, comp := range components {
					fmt.Printf("  - %s\n", comp)
				}
				return nil
			}

			// Install components
			fmt.Println("\n📦 Installing components...")
			var installed, failed int
			for _, comp := range components {
				fmt.Printf("  Installing %s... ", comp)
				if err := installComponent(comp, platform); err != nil {
					fmt.Printf("%s %v\n", red("✗"), err)
					failed++
					continue
				}
				fmt.Printf("%s\n", green("✓"))
				installed++
			}

			// Summary
			fmt.Printf("\n✅ Installation complete: %s installed", yellow(fmt.Sprintf("%d", installed)))
			if failed > 0 {
				fmt.Printf(", %s failed", red(fmt.Sprintf("%d", failed)))
			}
			fmt.Println()

			return nil
		},
	}

	cmd.Flags().StringSliceVarP(&components, "components", "c",
		[]string{"kitty", "fish", "nvim"}, "Components to install")
	cmd.Flags().StringVarP(&themeMode, "theme", "t", "dark", "Theme mode (dark/light/dusk)")
	cmd.Flags().Bool("backup", true, "Backup existing configs before install")
	cmd.Flags().BoolVar(&dryRun, "dry-run", false, "Show what would be installed without doing it")

	return cmd
}

func installComponent(component string, platform system.Platform) error {
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

	dotfilesDir := findDotfilesDir(platform.HomeDir)
	_, err := system.RunCommand("stow", "-d", dotfilesDir, "-t", platform.HomeDir, module)
	return err
}

func findDotfilesDir(homeDir string) string {
	// Common dotfiles locations
	candidates := []string{
		homeDir + "/Documents/PROYECTOS/dreamcoder-dots",
		homeDir + "/Projects/dreamcoder-dots",
		homeDir + "/code/dreamcoder-dots",
		homeDir + "/dreamcoder-dots",
	}

	for _, path := range candidates {
		if _, err := os.Stat(path); err == nil {
			return path
		}
	}

	// Fallback
	return homeDir + "/Documents/PROYECTOS/dreamcoder-dots"
}

func printExistingConfigs(configs system.ExistingConfigs) {
	green := color.New(color.FgGreen).SprintFunc()
	dim := color.New(color.FgHiBlack).SprintFunc()

	var detected []string
	if configs.Nvim {
		detected = append(detected, "nvim")
	}
	if configs.Fish {
		detected = append(detected, "fish")
	}
	if configs.Zsh {
		detected = append(detected, "zsh")
	}
	if configs.Tmux {
		detected = append(detected, "tmux")
	}
	if configs.Kitty {
		detected = append(detected, "kitty")
	}
	if configs.Ghostty {
		detected = append(detected, "ghostty")
	}
	if configs.WezTerm {
		detected = append(detected, "wezterm")
	}
	if configs.Alacritty {
		detected = append(detected, "alacritty")
	}
	if configs.Starship {
		detected = append(detected, "starship")
	}
	if configs.Fzf {
		detected = append(detected, "fzf")
	}
	if configs.Zoxide {
		detected = append(detected, "zoxide")
	}

	if len(detected) > 0 {
		fmt.Printf("\n  %s Existing configs: %s\n", green("✓"), dim(fmt.Sprintf("%v", detected)))
	} else {
		fmt.Println("\n  No existing configs detected")
	}
}
