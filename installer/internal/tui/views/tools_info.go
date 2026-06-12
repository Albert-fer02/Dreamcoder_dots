package views

// ToolInfo holds educational content about a tool
type ToolInfo struct {
	Name        string
	Category    string
	Description string
	Website     string
	Features    []string
	Pros        []string
	Cons        []string
}

// GetToolsInfo returns educational content for all supported tools
func GetToolsInfo() []ToolInfo {
	return []ToolInfo{
		// Terminals
		{
			Name:        "Kitty",
			Category:    "Terminal",
			Description: "GPU-based terminal emulator with advanced features",
			Website:     "https://sw.kovidgoyal.net/kitty/",
			Features:    []string{"GPU acceleration", "Tabs and splits", "Image rendering", "Custom themes", "Extensible via kittens"},
			Pros:        []string{"Fast rendering", "Rich feature set", "Active development", "Great documentation"},
			Cons:        []string{"No Windows support", "Can be complex for beginners"},
		},
		{
			Name:        "Ghostty",
			Category:    "Terminal",
			Description: "Fast, feature-rich terminal emulator",
			Website:     "https://ghostty.org/",
			Features:    []string{"GPU acceleration", "Native UI", "Tabs and splits", "Custom shaders", "Wayland support"},
			Pros:        []string{"Extremely fast", "Native feel", "Modern codebase"},
			Cons:        []string{"Newer project", "Limited Windows support"},
		},
		{
			Name:        "WezTerm",
			Category:    "Terminal",
			Description: "Lua-configurable terminal emulator",
			Website:     "https://wezfurlong.org/wezterm/",
			Features:    []string{"Lua configuration", "GPU acceleration", "Tabs and splits", "SSH multiplexing", "Cross-platform"},
			Pros:        []string{"Powerful Lua config", "Cross-platform", "Great performance"},
			Cons:        []string{"Lua learning curve", "Larger binary size"},
		},
		{
			Name:        "Alacritty",
			Category:    "Terminal",
			Description: "Minimal, fast terminal emulator",
			Website:     "https://alacritty.org/",
			Features:    []string{"GPU acceleration", "TOML configuration", "Vi mode", "Custom keybindings"},
			Pros:        []string{"Extremely fast", "Simple configuration", "Minimal resource usage"},
			Cons:        []string{"No tabs (use multiplexer)", "Limited features compared to others"},
		},
		// Shells
		{
			Name:        "Fish",
			Category:    "Shell",
			Description: "Friendly interactive shell with great defaults",
			Website:     "https://fishshell.com/",
			Features:    []string{"Auto-suggestions", "Syntax highlighting", "Tab completion", "Web-based configuration"},
			Pros:        []string{"Works out of the box", "Great completions", "User-friendly"},
			Cons:        []string{"Not POSIX compatible", "Different syntax from bash"},
		},
		{
			Name:        "Zsh",
			Category:    "Shell",
			Description: "Powerful shell with extensive customization",
			Website:     "https://www.zsh.org/",
			Features:    []string{"Oh My Zsh", "Plugins", "Themes", "Auto-completion", "Globbing"},
			Pros:        []string{"Highly customizable", "POSIX compatible", "Huge ecosystem"},
			Cons:        []string{"Configuration can be complex", "Slower startup than fish"},
		},
		{
			Name:        "Nushell",
			Category:    "Shell",
			Description: "Modern shell with structured data",
			Website:     "https://www.nushell.sh/",
			Features:    []string{"Structured data", "Pipes on structured data", "Cross-platform", "Plugin system"},
			Pros:        []string{"Data-oriented", "Modern syntax", "Great for data processing"},
			Cons:        []string{"Different from traditional shells", "Smaller ecosystem"},
		},
		// Multiplexers
		{
			Name:        "Tmux",
			Category:    "Multiplexer",
			Description: "Terminal multiplexer for session management",
			Website:     "https://github.com/tmux/tmux",
			Features:    []string{"Sessions", "Windows", "Panes", "Scriptable", "Plugin system"},
			Pros:        []string{"Battle-tested", "Widely available", "Very stable"},
			Cons:        []string{"Configuration can be complex", "Learning curve"},
		},
		{
			Name:        "Zellij",
			Category:    "Multiplexer",
			Description: "Modern terminal workspace with floating panes",
			Website:     "https://zellij.dev/",
			Features:    []string{"Floating panes", "Layouts", "WebAssembly plugins", "Session management"},
			Pros:        []string{"Modern design", "Easy to use", "Great defaults"},
			Cons:        []string{"Younger project", "Fewer plugins than tmux"},
		},
		// Editors
		{
			Name:        "Neovim",
			Category:    "Editor",
			Description: "Hyperextensible Vim-based text editor",
			Website:     "https://neovim.io/",
			Features:    []string{"Lua configuration", "LSP support", "Treesitter", "Plugin ecosystem", "Terminal emulator"},
			Pros:        []string{"Extremely powerful", "Huge plugin ecosystem", "Fast and lightweight"},
			Cons:        []string{"Steep learning curve", "Configuration complexity"},
		},
	}
}

// GetToolsByCategory returns tools grouped by category
func GetToolsByCategory() map[string][]ToolInfo {
	tools := GetToolsInfo()
	categories := make(map[string][]ToolInfo)
	for _, tool := range tools {
		categories[tool.Category] = append(categories[tool.Category], tool)
	}
	return categories
}
