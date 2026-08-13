package styles

import "github.com/charmbracelet/lipgloss"

// Dreamcoder dark palette — mirrors the canonical Anthracite Steel dark
// tokens from DreamcoderThemes/dreamcoder/tokens.json (regenerated into
// src/dreamcoder_theme/palette_tokens.py). Values must stay byte-for-byte
// aligned with the canonical dark mode so every Dreamcoder surface shares one
// palette; dreamcoder_test.go locks the mapping and the WCAG contrast floors.
//
// Border semantics: the canonical "border" token (#17202B) is a low-contrast
// structural separator that fails the WCAG 3:1 UI floor against Primary, so
// the TUI's visible border role deliberately uses "border_ui" (#6A8497).
// BoxStyle binds its visible border to BorderUI, never to the canonical
// border token.
var (
	Primary    = lipgloss.Color("#070A13") // bg
	Secondary  = lipgloss.Color("#0D121A") // bg_soft / surface0
	Surface    = lipgloss.Color("#151C25") // surface1
	Text       = lipgloss.Color("#E6EDF3") // text
	Muted      = lipgloss.Color("#A8B5C2") // muted
	Subtle     = lipgloss.Color("#8795a2") // subtle
	Accent     = lipgloss.Color("#A5C7E8") // accent
	Accent2    = lipgloss.Color("#8FAFCB") // accent_2
	Diagnostic = lipgloss.Color("#4DAED6") // diagnostic
	Sage       = lipgloss.Color("#55C080") // sage
	Lavender   = lipgloss.Color("#B6C5D4") // lavender
	Mauve      = lipgloss.Color("#B48EAD") // mauve
	Success    = lipgloss.Color("#55C080") // sage — TUI success role uses the sage hue
	Error      = lipgloss.Color("#E38989") // error
	Warning    = lipgloss.Color("#E1C16D") // warning
	Comment    = lipgloss.Color("#aab7c4") // comment
	BorderUI   = lipgloss.Color("#6A8497") // border_ui — visible border role (see note above)
	BorderHi   = lipgloss.Color("#758A9C") // border_hi
	Focus      = lipgloss.Color("#A5C7E8") // focus
)

var (
	TitleStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(Accent).
			Background(Primary).
			Padding(1, 2)

	MenuItemStyle = lipgloss.NewStyle().
			Foreground(Text).
			Background(Primary).
			Padding(0, 2)

	DimItemStyle = lipgloss.NewStyle().
			Foreground(Subtle).
			Background(Primary).
			Padding(0, 2)

	SelectedStyle = lipgloss.NewStyle().
			Foreground(Accent).
			Background(Primary).
			Bold(true).
			Padding(0, 2)

	StatusBarStyle = lipgloss.NewStyle().
			Foreground(Muted).
			Background(Secondary).
			Padding(0, 1)

	BoxStyle = lipgloss.NewStyle().
			Background(Primary).
			Border(lipgloss.RoundedBorder()).
			BorderForeground(BorderUI).
			Padding(1, 2)

	CommentStyle = lipgloss.NewStyle().
			Foreground(Comment).
			Background(Primary)

	MutedStyle = lipgloss.NewStyle().
			Foreground(Muted).
			Background(Primary)

	SuccessStyle = lipgloss.NewStyle().
			Foreground(Success).
			Background(Primary).
			Padding(0, 2)

	ErrorStyle = lipgloss.NewStyle().
			Foreground(Error).
			Background(Primary).
			Padding(0, 2)

	WarningStyle = lipgloss.NewStyle().
			Foreground(Warning).
			Background(Primary).
			Padding(0, 2)

	ProgressBarStyle = lipgloss.NewStyle().
				Foreground(Accent).
				Background(Secondary)

	HelpStyle = lipgloss.NewStyle().
			Foreground(Comment).
			Background(Primary).
			Italic(true)
)
