package e2e

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/system"
)

func TestCopyFile(t *testing.T) {
	srcDir := t.TempDir()
	dstDir := t.TempDir()

	srcFile := filepath.Join(srcDir, "test.txt")
	dstFile := filepath.Join(dstDir, "test.txt")

	content := []byte("hello world")
	os.WriteFile(srcFile, content, 0644)

	err := system.CopyFile(srcFile, dstFile)
	if err != nil {
		t.Fatalf("CopyFile failed: %v", err)
	}

	dstContent, err := os.ReadFile(dstFile)
	if err != nil {
		t.Fatalf("failed to read destination: %v", err)
	}

	if string(dstContent) != string(content) {
		t.Errorf("expected %q, got %q", content, dstContent)
	}
}

func TestCopyFile_CreatesDirs(t *testing.T) {
	srcDir := t.TempDir()
	dstDir := t.TempDir()

	srcFile := filepath.Join(srcDir, "test.txt")
	dstFile := filepath.Join(dstDir, "nested", "dir", "test.txt")

	os.WriteFile(srcFile, []byte("content"), 0644)

	err := system.CopyFile(srcFile, dstFile)
	if err != nil {
		t.Fatalf("CopyFile failed: %v", err)
	}

	if _, err := os.Stat(dstFile); os.IsNotExist(err) {
		t.Error("destination file should exist")
	}
}

func TestCopyDir(t *testing.T) {
	srcDir := t.TempDir()
	dstDir := t.TempDir()

	// Create source structure
	os.MkdirAll(filepath.Join(srcDir, "sub"), 0755)
	os.WriteFile(filepath.Join(srcDir, "file1.txt"), []byte("content1"), 0644)
	os.WriteFile(filepath.Join(srcDir, "sub", "file2.txt"), []byte("content2"), 0644)

	err := system.CopyDir(srcDir, filepath.Join(dstDir, "copy"))
	if err != nil {
		t.Fatalf("CopyDir failed: %v", err)
	}

	// Verify
	for _, path := range []string{"file1.txt", "sub/file2.txt"} {
		dstPath := filepath.Join(dstDir, "copy", path)
		if _, err := os.Stat(dstPath); os.IsNotExist(err) {
			t.Errorf("expected %s to exist", path)
		}
	}
}

func TestBackupConfig(t *testing.T) {
	backupDir := t.TempDir()
	srcDir := t.TempDir()

	// Create source config
	os.MkdirAll(filepath.Join(srcDir, ".config", "nvim"), 0755)
	os.WriteFile(filepath.Join(srcDir, ".config", "nvim", "init.lua"), []byte("vim.g.mapleader = ' '"), 0644)

	srcPath := filepath.Join(srcDir, ".config", "nvim")
	entry, err := system.BackupConfig(backupDir, srcDir, srcPath)
	if err != nil {
		t.Fatalf("BackupConfig failed: %v", err)
	}

	if entry.Source != srcPath {
		t.Errorf("expected source %s, got %s", srcPath, entry.Source)
	}

	if !entry.IsDir {
		t.Error("expected IsDir to be true")
	}
}

func TestBackupConfig_NonExistent(t *testing.T) {
	backupDir := t.TempDir()
	homeDir := t.TempDir()
	entry, err := system.BackupConfig(backupDir, homeDir, "/nonexistent/path")

	if err != nil {
		t.Fatalf("BackupConfig should not fail for nonexistent source: %v", err)
	}

	if entry.Source != "" {
		t.Error("entry.Source should be empty for nonexistent source")
	}
}

func TestCreateBackup(t *testing.T) {
	homeDir := t.TempDir()
	platform := system.Platform{
		OS:      "linux",
		Arch:    "amd64",
		HomeDir: homeDir,
	}

	// Create some configs
	os.MkdirAll(filepath.Join(homeDir, ".config", "nvim"), 0755)
	os.WriteFile(filepath.Join(homeDir, ".config", "nvim", "init.lua"), []byte("test"), 0644)
	os.WriteFile(filepath.Join(homeDir, ".tmux.conf"), []byte("test"), 0644)

	backupDir, manifest, err := system.CreateBackup(platform, []string{"nvim", "tmux"})
	if err != nil {
		t.Fatalf("CreateBackup failed: %v", err)
	}

	if backupDir == "" {
		t.Error("backupDir should not be empty")
	}

	if len(manifest.Files) == 0 {
		t.Error("manifest should have backed up files")
	}

	// Verify backup directory exists
	if _, err := os.Stat(backupDir); os.IsNotExist(err) {
		t.Error("backup directory should exist")
	}
}

func TestRestoreBackup(t *testing.T) {
	homeDir := t.TempDir()
	platform := system.Platform{
		OS:      "linux",
		Arch:    "amd64",
		HomeDir: homeDir,
	}

	// Create and backup
	os.MkdirAll(filepath.Join(homeDir, ".config", "nvim"), 0755)
	os.WriteFile(filepath.Join(homeDir, ".config", "nvim", "init.lua"), []byte("original"), 0644)

	backupDir, _, err := system.CreateBackup(platform, []string{"nvim"})
	if err != nil {
		t.Fatalf("CreateBackup failed: %v", err)
	}

	// Modify original
	os.WriteFile(filepath.Join(homeDir, ".config", "nvim", "init.lua"), []byte("modified"), 0644)

	// Restore
	err = system.RestoreBackup(backupDir)
	if err != nil {
		t.Fatalf("RestoreBackup failed: %v", err)
	}

	// Verify restored content
	content, err := os.ReadFile(filepath.Join(homeDir, ".config", "nvim", "init.lua"))
	if err != nil {
		t.Fatalf("failed to read restored file: %v", err)
	}

	if string(content) != "original" {
		t.Errorf("expected 'original', got %q", string(content))
	}
}
