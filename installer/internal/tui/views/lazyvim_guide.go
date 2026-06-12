package views

// LazyVimGuide holds LazyVim educational content
type LazyVimGuide struct {
	Section  string
	Content  string
}

// GetLazyVimGuide returns the complete LazyVim guide
func GetLazyVimGuide() []LazyVimGuide {
	return []LazyVimGuide{
		{
			Section: "What is LazyVim?",
			Content: `LazyVim is a Neovim setup powered by lazy.nvim plugin manager.
It provides a pre-configured Neovim experience with:
- LSP (Language Server Protocol) for code intelligence
- Treesitter for syntax highlighting
- Telescope for fuzzy finding
- Completion with nvim-cmp
- Git integration with gitsigns.nvim
- And 100+ other plugins`,
		},
		{
			Section: "Leader Key",
			Content: `The leader key is set to SPACE by default.
All LazyVim keymaps start with Space.
For example: Space + e = Toggle file explorer`,
		},
		{
			Section: "File Explorer",
			Content: `Open file explorer: Space + e
Navigate: j/k or arrow keys
Open file: Enter
Create file: a
Create directory: A
Delete: d
Rename: r
Copy: y
Paste: p
Toggle hidden files: .`,
		},
		{
			Section: "Finding Files",
			Content: `Find files: Space + f + f
Find text: Space + s + g
Find word under cursor: Space + s + w
Recent files: Space + f + r
Git files: Space + f + g
File explorer: Space + e`,
		},
		{
			Section: "Code Navigation",
			Content: `Go to definition: gd
Go to references: gr
Go to type definition: gy
Go to implementation: gi
Show hover documentation: K
Show signature help: Ctrl-k
Code actions: Space + c + a
Rename symbol: Space + c + r
Format file: Space + c + f
Show diagnostics: Space + c + d`,
		},
		{
			Section: "Git Integration",
			Content: `Git blame line: Space + g + b
Git commit: Space + g + c
Git push: Space + g + p
Git diff: Space + g + d
Git status: :Git
LazyGit integration: :LazyGit`,
		},
		{
			Section: "Terminal",
			Content: `Toggle terminal: Ctrl + \
Horizontal split terminal: Space + t + h
Vertical split terminal: Space + t + v
Float terminal: Space + t + f
Hide terminal: Escape in terminal mode`,
		},
		{
			Section: "Windows & Splits",
			Content: `Split horizontal: Space + w + s
Split vertical: Space + w + v
Close window: Space + w + c
Move to window: Space + w + h/j/k/l
Equalize splits: Space + w + =
Maximize window: Space + w + m`,
		},
		{
			Section: "Buffers",
			Content: `Switch buffer: Space + ,
Close buffer: Space + b + d
Next buffer: Space + b + n
Previous buffer: Space + b + p
Buffer explorer: Space + b + e`,
		},
		{
			Section: "Search & Replace",
			Content: `Search forward: /
Search backward: ?
Next result: n
Previous result: N
Replace in file: :%s/old/new/g
Replace in selection: :s/old/new/g
Live search: Space + /`,
		},
		{
			Section: "Session Management",
			Content: `Save session: :mksession
Load session: :source Session.vim
Autosave session: Enabled by default
Restore session: :SessionRestore`,
		},
		{
			Section: "Tips & Tricks",
			Content: `Macro recording: q + register + actions + q
Play macro: @ + register
Repeat macro: @@
Block select: Ctrl + v
Multi-cursor: Ctrl + n
Insert mode from normal: i/a/o
Visual mode: v/V/Ctrl-v
Command mode: :
Replace mode: R`,
		},
	}
}
