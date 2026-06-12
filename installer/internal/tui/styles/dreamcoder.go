package styles

import "github.com/charmbracelet/lipgloss"

// Dreamcoder Dark palette
var (
	Primary    = lipgloss.Color("#100f0d")
	Secondary  = lipgloss.Color("#1a1714")
	Surface    = lipgloss.Color("#2a2520")
	Text       = lipgloss.Color("#e8dfd0")
	Accent     = lipgloss.Color("#d99555")
	Accent2    = lipgloss.Color("#c96a45")
	Diagnostic = lipgloss.Color("#5f95ca")
	Comment    = lipgloss.Color("#6b5f52")
	Border     = lipgloss.Color("#2a2520")
)

var (
	TitleStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(Accent).
			Padding(1, 2)

	MenuItemStyle = lipgloss.NewStyle().
			Foreground(Text).
			Padding(0, 2)

	SelectedStyle = lipgloss.NewStyle().
			Foreground(Accent).
			Bold(true).
			Padding(0, 2)

	StatusBarStyle = lipgloss.NewStyle().
			Foreground(Comment).
			Background(Secondary).
			Padding(0, 1)

	BoxStyle = lipgloss.NewStyle().
			Border(lipgloss.RoundedBorder()).
			BorderForeground(Border).
			Padding(1, 2)

	CommentStyle = lipgloss.NewStyle().
			Foreground(Comment)
)
