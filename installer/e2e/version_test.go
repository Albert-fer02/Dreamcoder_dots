package e2e

import (
	"testing"

	"github.com/dreamcoder08/dreamcoder-dots/installer/pkg/version"
)

func TestVersion(t *testing.T) {
	if version.Version == "" {
		t.Error("version should not be empty")
	}

	if version.Version == "dev" {
		t.Log("version is 'dev' (expected during development)")
	}
}

func TestVersionFormat(t *testing.T) {
	// Version should be semver or dev
	if version.Version != "dev" {
		// Basic semver check
		if len(version.Version) < 3 {
			t.Errorf("version %q seems too short", version.Version)
		}
	}
}
