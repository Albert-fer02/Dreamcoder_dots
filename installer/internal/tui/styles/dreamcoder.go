package styles

import "github.com/charmbracelet/lipgloss"

// Dreamcoder Dark palette — matches palette_tokens.py exactly
// for consistent legibility across all Dreamcoder surfaces.
var (
	Primary    = lipgloss.Color("#100f0d")  // bg
	Secondary  = lipgloss.Color("#181512")  // bg_soft
	Surface    = lipgloss.Color("#2b231b")  // surface1
	Text       = lipgloss.Color("#e8dfd0")  // text
	Muted      = lipgloss.Color("#c7b9aa")  // muted
	Subtle     = lipgloss.Color("#938274")  // subtle
	Accent     = lipgloss.Color("#d99555")  // accent
	Accent2    = lipgloss.Color("#c96a45")  // accent_2
	Diagnostic = lipgloss.Color("#5f95ca")  // diagnostic
	Sage       = lipgloss.Color("#4db35f")  // sage
	Lavender   = lipgloss.Color("#d4b4e6")  // lavender
	Mauve      = lipgloss.Color("#e29cb4")  // mauve
	Success    = lipgloss.Color("#4db35f")  // sage (green)
	Error      = lipgloss.Color("#ed8a7a")  // error
	Warning    = lipgloss.Color("#e8b866")  // warning
	Comment    = lipgloss.Color("#b8a99a")  // comment (was #6b5f52 — too dark!)
	Border     = lipgloss.Color("#756052")  // border (was #2a2520 — invisible!)
	BorderHi   = lipgloss.Color("#c8b195")  // border_hi
	Focus      = lipgloss.Color("#5f8f8f")  // focus
)

var (
	TitleStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(Accent).
			Padding(1, 2)

	MenuItemStyle = lipgloss.NewStyle().
			Foreground(Text).
			Padding(0, 2)

	DimItemStyle = lipgloss.NewStyle().
			Foreground(Subtle).
			Padding(0, 2)

	SelectedStyle = lipgloss.NewStyle().
			Foreground(Accent).
			Bold(true).
			Padding(0, 2)

	StatusBarStyle = lipgloss.NewStyle().
			Foreground(Muted).
			Background(Secondary).
			Padding(0, 1)

	BoxStyle = lipgloss.NewStyle().
			Border(lipgloss.RoundedBorder()).
			BorderForeground(Border).
			Padding(1, 2)

	CommentStyle = lipgloss.NewStyle().
			Foreground(Comment)

	MutedStyle = lipgloss.NewStyle().
			Foreground(Muted)

	SuccessStyle = lipgloss.NewStyle().
			Foreground(Success).
			Padding(0, 2)

	ErrorStyle = lipgloss.NewStyle().
			Foreground(Error).
			Padding(0, 2)

	WarningStyle = lipgloss.NewStyle().
			Foreground(Warning).
			Padding(0, 2)

	ProgressBarStyle = lipgloss.NewStyle().
				Foreground(Accent).
				Background(Secondary)

	HelpStyle = lipgloss.NewStyle().
			Foreground(Comment).
			Italic(true)
)
