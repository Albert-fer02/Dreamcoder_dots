package system

import (
	"encoding/json"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"time"
)

// BackupManifest holds backup metadata
type BackupManifest struct {
	Timestamp  time.Time         `json:"timestamp"`
	Platform   Platform          `json:"platform"`
	Components []string          `json:"components"`
	Files      []BackupEntry     `json:"files"`
}

// BackupEntry represents a single backed up file
type BackupEntry struct {
	Source      string `json:"source"`
	Destination string `json:"destination"`
	IsDir       bool   `json:"is_dir"`
}

// RunCommand executes a command and returns output
func RunCommand(name string, args ...string) (string, error) {
	cmd := exec.Command(name, args...)
	output, err := cmd.CombinedOutput()
	if err != nil {
		return string(output), fmt.Errorf("command failed: %s %s: %w", name, args, err)
	}
	return string(output), nil
}

// RunCommandInteractive executes a command with real-time output
func RunCommandInteractive(name string, args ...string) error {
	cmd := exec.Command(name, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	return cmd.Run()
}

// CopyFile copies a file from src to dst
func CopyFile(src, dst string) error {
	sourceFile, err := os.Open(src)
	if err != nil {
		return fmt.Errorf("failed to open source: %w", err)
	}
	defer sourceFile.Close()

	// Create destination directory if needed
	dstDir := filepath.Dir(dst)
	if err := os.MkdirAll(dstDir, 0755); err != nil {
		return fmt.Errorf("failed to create destination dir: %w", err)
	}

	destFile, err := os.Create(dst)
	if err != nil {
		return fmt.Errorf("failed to create destination: %w", err)
	}
	defer destFile.Close()

	if _, err := io.Copy(destFile, sourceFile); err != nil {
		return fmt.Errorf("failed to copy: %w", err)
	}

	// Copy permissions
	sourceInfo, err := os.Stat(src)
	if err != nil {
		return fmt.Errorf("failed to stat source: %w", err)
	}
	if err := os.Chmod(dst, sourceInfo.Mode()); err != nil {
		return fmt.Errorf("failed to set permissions: %w", err)
	}

	return nil
}

// CopyDir recursively copies a directory
func CopyDir(src, dst string) error {
	return filepath.Walk(src, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// Calculate relative path
		relPath, err := filepath.Rel(src, path)
		if err != nil {
			return err
		}

		dstPath := filepath.Join(dst, relPath)

		if info.IsDir() {
			return os.MkdirAll(dstPath, info.Mode())
		}

		return CopyFile(path, dstPath)
	})
}

// BackupConfig backs up an existing configuration
func BackupConfig(backupDir, baseDir, src string) (BackupEntry, error) {
	entry := BackupEntry{}

	// Check if source exists
	info, err := os.Stat(src)
	if os.IsNotExist(err) {
		return entry, nil // Nothing to backup
	}
	if err != nil {
		return entry, fmt.Errorf("failed to stat source: %w", err)
	}

	entry.Source = src

	// Calculate destination path in backup
	relPath, err := filepath.Rel(baseDir, src)
	if err != nil {
		return entry, fmt.Errorf("failed to calculate relative path: %w", err)
	}

	dst := filepath.Join(backupDir, relPath)
	entry.Destination = dst
	entry.IsDir = info.IsDir()

	if info.IsDir() {
		if err := CopyDir(src, dst); err != nil {
			return entry, fmt.Errorf("failed to backup directory: %w", err)
		}
	} else {
		if err := CopyFile(src, dst); err != nil {
			return entry, fmt.Errorf("failed to backup file: %w", err)
		}
	}

	return entry, nil
}

// RestoreConfig restores a backed up configuration
func RestoreConfig(entry BackupEntry) error {
	if entry.Source == "" || entry.Destination == "" {
		return nil
	}

	// Remove current config if it exists
	if entry.IsDir {
		os.RemoveAll(entry.Source)
	} else {
		os.Remove(entry.Source)
	}

	// Create parent directory
	if err := os.MkdirAll(filepath.Dir(entry.Source), 0755); err != nil {
		return fmt.Errorf("failed to create parent dir: %w", err)
	}

	// Copy from backup
	if entry.IsDir {
		return CopyDir(entry.Destination, entry.Source)
	}
	return CopyFile(entry.Destination, entry.Source)
}

// CreateBackup creates a full backup of existing configs
func CreateBackup(platform Platform, components []string) (string, BackupManifest, error) {
	// Create backup directory with timestamp
	timestamp := time.Now().Format("2006-01-02-150405")
	backupDir := filepath.Join(platform.HomeDir, ".dreamcoder-backup-"+timestamp)

	if err := os.MkdirAll(backupDir, 0755); err != nil {
		return "", BackupManifest{}, fmt.Errorf("failed to create backup dir: %w", err)
	}

	manifest := BackupManifest{
		Timestamp:  time.Now(),
		Platform:   platform,
		Components: components,
		Files:      []BackupEntry{},
	}

	// Paths to backup for each component
	backupPaths := getBackupPaths(platform, components)

	for _, src := range backupPaths {
		entry, err := BackupConfig(backupDir, platform.HomeDir, src)
		if err != nil {
			fmt.Printf("Warning: failed to backup %s: %v\n", src, err)
			continue
		}
		if entry.Source != "" {
			manifest.Files = append(manifest.Files, entry)
		}
	}

	// Write manifest to backup directory
	manifestPath := filepath.Join(backupDir, "manifest.json")
	manifestData, err := json.MarshalIndent(manifest, "", "  ")
	if err != nil {
		return backupDir, manifest, fmt.Errorf("failed to marshal manifest: %w", err)
	}
	if err := os.WriteFile(manifestPath, manifestData, 0644); err != nil {
		return backupDir, manifest, fmt.Errorf("failed to write manifest: %w", err)
	}

	return backupDir, manifest, nil
}

// RestoreBackup restores from a backup directory
func RestoreBackup(backupDir string) error {
	// Read manifest
	manifestPath := filepath.Join(backupDir, "manifest.json")
	data, err := os.ReadFile(manifestPath)
	if os.IsNotExist(err) {
		return fmt.Errorf("no manifest found in backup directory")
	}
	if err != nil {
		return fmt.Errorf("failed to read manifest: %w", err)
	}

	var manifest BackupManifest
	if err := json.Unmarshal(data, &manifest); err != nil {
		return fmt.Errorf("failed to parse manifest: %w", err)
	}

	// Restore each file from manifest
	for _, entry := range manifest.Files {
		if entry.Destination == "" {
			continue
		}

		// Remove current config
		if entry.IsDir {
			os.RemoveAll(entry.Source)
		} else {
			os.Remove(entry.Source)
		}

		// Create parent directory
		if err := os.MkdirAll(filepath.Dir(entry.Source), 0755); err != nil {
			fmt.Printf("Warning: failed to create dir for %s: %v\n", entry.Source, err)
			continue
		}

		// Copy from backup
		if entry.IsDir {
			if err := CopyDir(entry.Destination, entry.Source); err != nil {
				fmt.Printf("Warning: failed to restore %s: %v\n", entry.Source, err)
			}
		} else {
			if err := CopyFile(entry.Destination, entry.Source); err != nil {
				fmt.Printf("Warning: failed to restore %s: %v\n", entry.Source, err)
			}
		}
	}

	return nil
}

// getBackupPaths returns paths to backup for given components
func getBackupPaths(platform Platform, components []string) []string {
	var paths []string
	home := platform.HomeDir

	componentPaths := map[string][]string{
		"kitty":     {filepath.Join(home, ".config", "kitty")},
		"ghostty":   {filepath.Join(home, ".config", "ghostty")},
		"wezterm":   {filepath.Join(home, ".wezterm.lua"), filepath.Join(home, ".config", "wezterm")},
		"alacritty": {filepath.Join(home, ".config", "alacritty")},
		"fish":      {filepath.Join(home, ".config", "fish")},
		"zsh":       {filepath.Join(home, ".zshrc"), filepath.Join(home, ".oh-my-zsh")},
		"nushell":   {filepath.Join(home, ".config", "nushell")},
		"tmux":      {filepath.Join(home, ".tmux.conf"), filepath.Join(home, ".tmux")},
		"zellij":    {filepath.Join(home, ".config", "zellij")},
		"nvim":      {filepath.Join(home, ".config", "nvim")},
		"starship":  {filepath.Join(home, ".config", "starship.toml")},
	}

	for _, comp := range components {
		if p, ok := componentPaths[comp]; ok {
			paths = append(paths, p...)
		}
	}

	return paths
}
