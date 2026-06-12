package main

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
	"github.com/dreamcoder08/dreamcoder-dots/installer/cmd"
	"github.com/dreamcoder08/dreamcoder-dots/installer/pkg/version"
)

func main() {
	rootCmd := &cobra.Command{
		Use:     "dreamcoder-dots",
		Short:   "Dreamcoder OS - Token-governed visual operating layer",
		Version: version.Version,
		RunE: func(c *cobra.Command, args []string) error {
			fmt.Println("🎨 Dreamcoder OS Installer")
			fmt.Println("Run with --help to see available commands")
			return nil
		},
	}

	rootCmd.AddCommand(cmd.InstallCmd())
	rootCmd.AddCommand(cmd.RepairCmd())
	rootCmd.AddCommand(cmd.DoctorCmd())

	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
