package cmd

import (
	"fmt"
	"os"
	"os/exec"
	"runtime"

	"github.com/fatih/color"
	"github.com/spf13/cobra"
)

func DoctorCmd() *cobra.Command {
	return &cobra.Command{
		Use:   "doctor",
		Short: "Check health of Dreamcoder OS installation",
		RunE: func(cmd *cobra.Command, args []string) error {
			green := color.New(color.FgGreen).SprintFunc()
			red := color.New(color.FgRed).SprintFunc()

			fmt.Println("🔍 Dreamcoder OS Doctor")
			fmt.Println("========================")
			fmt.Printf("Platform: %s/%s\n", runtime.GOOS, runtime.GOARCH)

			tools := map[string]string{
				"git":      "Version control",
				"stow":     "Symlink manager",
				"nvim":     "Editor",
				"fish":     "Shell",
				"kitty":    "Terminal",
				"ghostty":  "Terminal",
				"starship": "Prompt",
				"fzf":      "Fuzzy finder",
				"zoxide":   "Smart cd",
			}

			for tool, desc := range tools {
				if _, err := exec.LookPath(tool); err == nil {
					fmt.Printf("  %s %s (%s)\n", green("✓"), tool, desc)
				} else {
					fmt.Printf("  %s %s (%s) — not found\n", red("✗"), tool, desc)
				}
			}

			mode := os.Getenv("DREAMCODER_THEME_MODE")
			if mode == "" {
				mode = "dark"
			}
			fmt.Printf("\nTheme Mode: %s\n", mode)

			return nil
		},
	}
}
