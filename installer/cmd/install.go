package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var (
	components []string
	themeMode  string
)

func InstallCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "install",
		Short: "Install Dreamcoder OS components",
		RunE: func(cmd *cobra.Command, args []string) error {
			fmt.Println("📦 Installing Dreamcoder OS components...")
			fmt.Printf("Components: %v\n", components)
			fmt.Printf("Theme mode: %s\n", themeMode)

			// TODO: Implement actual installation
			fmt.Println("Installation logic will be implemented in Task 8")
			return nil
		},
	}

	cmd.Flags().StringSliceVarP(&components, "components", "c",
		[]string{"kitty", "fish", "nvim"}, "Components to install")
	cmd.Flags().StringVarP(&themeMode, "theme", "t", "dark", "Theme mode (dark/light/dusk)")

	return cmd
}
