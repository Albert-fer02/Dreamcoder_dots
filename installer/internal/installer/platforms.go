package installer

import (
	"os"
	"os/exec"
	"runtime"
	"strings"
)

type Platform struct {
	OS      string
	Arch    string
	Distro  string
	HasStow bool
	HasGit  bool
}

func DetectPlatform() Platform {
	p := Platform{
		OS:      runtime.GOOS,
		Arch:    runtime.GOARCH,
		Distro:  detectDistro(),
		HasStow: commandExists("stow"),
		HasGit:  commandExists("git"),
	}
	return p
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
