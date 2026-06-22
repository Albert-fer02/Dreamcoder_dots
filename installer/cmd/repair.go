package cmd

import (
	"fmt"

	"github.com/fatih/color"
	"github.com/spf13/cobra"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/system"
)

func RepairCmd() *cobra.Command {
	return &cobra.Command{
		Use:   "repair",
		Short: "Reapply symlinks after upstream updates",
		RunE: func(cmd *cobra.Command, args []string) error {
			green := color.New(color.FgGreen).SprintFunc()
			yellow := color.New(color.FgYellow).SprintFunc()
			red := color.New(color.FgRed).SprintFunc()

			platform := system.DetectPlatform()

			fmt.Println("🔧 Repairing Dreamcoder OS...")
			fmt.Printf("Platform: %s/%s (%s)\n", platform.OS, platform.Arch, platform.Distro)

			if !platform.HasStow {
				fmt.Printf("  %s stow is required but not installed\n", red("✗"))
				return fmt.Errorf("stow not found")
			}

			// Detect what's installed and re-stow
			configs := system.DetectExistingConfigs(platform.HomeDir)
			components := detectInstalledComponents(configs)

			if len(components) == 0 {
				fmt.Println("  No components detected to repair")
				return nil
			}

			fmt.Printf("  Detected components: %s\n", yellow(fmt.Sprintf("%v", components)))

			var repaired int
			for _, comp := range components {
				fmt.Printf("  Re-stowing %s... ", comp)
				if err := repairComponent(comp, platform); err != nil {
					fmt.Printf("%s %v\n", red("✗"), err)
					continue
				}
				fmt.Printf("%s\n", green("✓"))
				repaired++
			}

			fmt.Printf("\n✅ Repair complete: %s components re-stowed\n", yellow(fmt.Sprintf("%d", repaired)))
			return nil
		},
	}
}

func repairComponent(comp string, platform system.Platform) error {
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

	module, ok := moduleMap[comp]
	if !ok {
		return fmt.Errorf("unknown component: %s", comp)
	}

	dotfilesDir := findDotfilesDir(platform.HomeDir)

	// Remove stale symlinks that point to other repos (not stow-managed)
	removeStaleSymlinks(dotfilesDir, module)

	// Delete then fresh stow
	_, _ = system.RunCommand("stow", "-d", dotfilesDir, "-t", platform.HomeDir, "--delete", module)
	_, err := system.RunCommand("stow", "-d", dotfilesDir, "-t", platform.HomeDir, module)
	return err
}

// removeStaleSymlinks finds and removes symlinks in target that point
// outside our dotfiles directory (e.g., from gentleman-dots or other repos)
func removeStaleSymlinks(dotfilesDir, module string) {
	// Walk the stow module directory to find expected targets
	_ = filepath.Walk(dotfilesDir+"/"+module, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return nil
		}
		relPath, err := filepath.Rel(dotfilesDir+"/"+module, path)
		if err != nil {
			return nil
		}
		if relPath == "." {
			return nil
		}

		target := filepath.Join(dotfilesDir, "..", relPath)
		link, err := os.Readlink(target)
		if err != nil {
			return nil // not a symlink
		}

		// If symlink doesn't point into our dotfiles dir, remove it
		if !strings.Contains(link, dotfilesDir) {
			os.Remove(target)
		}

		return nil
	})
}

func detectInstalledComponents(configs system.ExistingConfigs) []string {
	var components []string

	if configs.Nvim {
		components = append(components, "nvim")
	}
	if configs.Fish {
		components = append(components, "fish")
	}
	if configs.Zsh {
		components = append(components, "zsh")
	}
	if configs.Tmux {
		components = append(components, "tmux")
	}
	if configs.Kitty {
		components = append(components, "kitty")
	}
	if configs.Ghostty {
		components = append(components, "ghostty")
	}
	if configs.WezTerm {
		components = append(components, "wezterm")
	}
	if configs.Alacritty {
		components = append(components, "alacritty")
	}
	if configs.Nushell {
		components = append(components, "nushell")
	}
	if configs.Zellij {
		components = append(components, "zellij")
	}

	return components
}
