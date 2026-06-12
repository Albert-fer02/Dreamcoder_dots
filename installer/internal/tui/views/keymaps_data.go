package views

// Keymap holds keybinding information
type Keymap struct {
	Key         string
	Description string
	Category    string
}

// GetNeovimKeymaps returns all configured Neovim keymaps
func GetNeovimKeymaps() []Keymap {
	return []Keymap{
		// General
		{Key: "Space", Description: "Leader key", Category: "General"},
		{Key: "Space e", Description: "Open file explorer", Category: "General"},
		{Key: "Space f", Description: "Find files", Category: "General"},
		{Key: "Space s", Description: "Search", Category: "General"},
		{Key: "Space w", Description: "Save file", Category: "General"},
		{Key: "Space q", Description: "Quit", Category: "General"},
		{Key: "Space /", Description: "Search in file", Category: "General"},
		{Key: "Space ,", Description: "Switch buffer", Category: "General"},

		// Navigation
		{Key: "h", Description: "Move left", Category: "Navigation"},
		{Key: "j", Description: "Move down", Category: "Navigation"},
		{Key: "k", Description: "Move up", Category: "Navigation"},
		{Key: "l", Description: "Move right", Category: "Navigation"},
		{Key: "w", Description: "Next word", Category: "Navigation"},
		{Key: "b", Description: "Previous word", Category: "Navigation"},
		{Key: "e", Description: "End of word", Category: "Navigation"},
		{Key: "0", Description: "Start of line", Category: "Navigation"},
		{Key: "$", Description: "End of line", Category: "Navigation"},
		{Key: "gg", Description: "Start of file", Category: "Navigation"},
		{Key: "G", Description: "End of file", Category: "Navigation"},
		{Key: "Ctrl-d", Description: "Half page down", Category: "Navigation"},
		{Key: "Ctrl-u", Description: "Half page up", Category: "Navigation"},

		// Editing
		{Key: "i", Description: "Insert mode", Category: "Editing"},
		{Key: "a", Description: "Append after cursor", Category: "Editing"},
		{Key: "A", Description: "Append at end of line", Category: "Editing"},
		{Key: "o", Description: "New line below", Category: "Editing"},
		{Key: "O", Description: "New line above", Category: "Editing"},
		{Key: "x", Description: "Delete character", Category: "Editing"},
		{Key: "dd", Description: "Delete line", Category: "Editing"},
		{Key: "dw", Description: "Delete word", Category: "Editing"},
		{Key: "d$", Description: "Delete to end of line", Category: "Editing"},
		{Key: "yy", Description: "Yank line", Category: "Editing"},
		{Key: "yw", Description: "Yank word", Category: "Editing"},
		{Key: "p", Description: "Paste after", Category: "Editing"},
		{Key: "P", Description: "Paste before", Category: "Editing"},
		{Key: "u", Description: "Undo", Category: "Editing"},
		{Key: "Ctrl-r", Description: "Redo", Category: "Editing"},
		{Key: ".", Description: "Repeat last change", Category: "Editing"},

		// Visual
		{Key: "v", Description: "Visual mode", Category: "Visual"},
		{Key: "V", Description: "Visual line mode", Category: "Visual"},
		{Key: "Ctrl-v", Description: "Visual block mode", Category: "Visual"},
		{Key: ">", Description: "Indent", Category: "Visual"},
		{Key: "<", Description: "Dedent", Category: "Visual"},
		{Key: "=", Description: "Auto-indent", Category: "Visual"},

		// Search
		{Key: "/", Description: "Search forward", Category: "Search"},
		{Key: "?", Description: "Search backward", Category: "Search"},
		{Key: "n", Description: "Next search result", Category: "Search"},
		{Key: "N", Description: "Previous search result", Category: "Search"},
		{Key: "*", Description: "Search word under cursor", Category: "Search"},
		{Key: "#", Description: "Search word backward", Category: "Search"},

		// Window
		{Key: "Ctrl-w h", Description: "Move to left window", Category: "Window"},
		{Key: "Ctrl-w j", Description: "Move to window below", Category: "Window"},
		{Key: "Ctrl-w k", Description: "Move to window above", Category: "Window"},
		{Key: "Ctrl-w l", Description: "Move to right window", Category: "Window"},
		{Key: "Ctrl-w v", Description: "Split vertical", Category: "Window"},
		{Key: "Ctrl-w s", Description: "Split horizontal", Category: "Window"},
		{Key: "Ctrl-w c", Description: "Close window", Category: "Window"},

		// LazyVim specific
		{Key: "Space e", Description: "Toggle explorer", Category: "LazyVim"},
		{Key: "Space fe", Description: "Find files in explorer", Category: "LazyVim"},
		{Key: "Space gb", Description: "Git blame", Category: "LazyVim"},
		{Key: "Space gc", Description: "Git commit", Category: "LazyVim"},
		{Key: "Space gp", Description: "Git push", Category: "LazyVim"},
		{Key: "Space ht", Description: " Telescope", Category: "LazyVim"},
		{Key: "Space cc", Description: "Code actions", Category: "LazyVim"},
		{Key: "Space cr", Description: "Rename symbol", Category: "LazyVim"},
		{Key: "Space cd", Description: "Show diagnostics", Category: "LazyVim"},
		{Key: "Space cf", Description: "Format file", Category: "LazyVim"},
	}
}

// GetKeymapsByCategory returns keymaps grouped by category
func GetKeymapsByCategory() map[string][]Keymap {
	keymaps := GetNeovimKeymaps()
	categories := make(map[string][]Keymap)
	for _, km := range keymaps {
		categories[km.Category] = append(categories[km.Category], km)
	}
	return categories
}
