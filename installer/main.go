package main

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
	"github.com/dreamcoder08/dreamcoder-dots/installer/cmd"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui"
	"github.com/dreamcoder08/dreamcoder-dots/installer/pkg/version"
)

func main() {
	rootCmd := &cobra.Command{
		Use:     "dreamcoder-dots",
		Short:   "Dreamcoder OS - Token-governed visual operating layer",
		Version: version.Version,
		RunE: func(c *cobra.Command, args []string) error {
			return tui.RunTUI()
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
