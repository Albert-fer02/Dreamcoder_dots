package e2e

import (
	"testing"

	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/views"
)

func TestGetToolsInfo(t *testing.T) {
	tools := views.GetToolsInfo()

	if len(tools) == 0 {
		t.Fatal("should return at least one tool")
	}

	// Verify each tool has required fields
	for _, tool := range tools {
		if tool.Name == "" {
			t.Error("tool Name should not be empty")
		}

		if tool.Category == "" {
			t.Errorf("tool %s should have a Category", tool.Name)
		}

		if tool.Description == "" {
			t.Errorf("tool %s should have a Description", tool.Name)
		}

		if tool.Website == "" {
			t.Errorf("tool %s should have a Website", tool.Name)
		}

		if len(tool.Features) == 0 {
			t.Errorf("tool %s should have at least one Feature", tool.Name)
		}

		if len(tool.Pros) == 0 {
			t.Errorf("tool %s should have at least one Pro", tool.Name)
		}
	}
}

func TestGetToolsByCategory(t *testing.T) {
	categories := views.GetToolsByCategory()

	expectedCategories := []string{"Terminal", "Shell", "Multiplexer", "Editor"}
	for _, cat := range expectedCategories {
		if _, ok := categories[cat]; !ok {
			t.Errorf("missing category: %s", cat)
		}
	}
}

func TestGetKeymapsByCategory(t *testing.T) {
	categories := views.GetKeymapsByCategory()

	if len(categories) == 0 {
		t.Fatal("should return at least one category")
	}

	for cat, keymaps := range categories {
		if len(keymaps) == 0 {
			t.Errorf("category %s should have at least one keymap", cat)
		}

		for _, km := range keymaps {
			if km.Key == "" {
				t.Errorf("keymap in %s should have a Key", cat)
			}

			if km.Description == "" {
				t.Errorf("keymap %s should have a Description", km.Key)
			}
		}
	}
}

func TestGetLazyVimGuide(t *testing.T) {
	guide := views.GetLazyVimGuide()

	if len(guide) == 0 {
		t.Fatal("should return at least one section")
	}

	for _, section := range guide {
		if section.Section == "" {
			t.Error("section should have a Section title")
		}

		if section.Content == "" {
			t.Errorf("section %s should have Content", section.Section)
		}
	}
}
