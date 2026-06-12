package views

import (
	"fmt"
	"os/exec"
	"runtime"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/styles"
)

type WelcomeModel struct {
	width  int
	height int
}

func NewWelcomeModel() WelcomeModel {
	return WelcomeModel{}
}

func (m WelcomeModel) Init() tea.Cmd {
	return nil
}

func (m WelcomeModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
	case tea.KeyMsg:
		switch msg.String() {
		case "enter":
			return NewComponentsModel(), nil
		case "q", "ctrl+c":
			return m, tea.Quit
		}
	}
	return m, nil
}

func (m WelcomeModel) View() string {
	logo := `
   ╔═══════════════════════════════════════╗
   ║                                       ║
   ║   🎨 DREAMCODER OS                    ║
   ║                                       ║
   ║   Token-governed visual operating     ║
   ║   layer for the discerning developer  ║
   ║                                       ║
   ╚═══════════════════════════════════════╝
`
	platform := fmt.Sprintf("Platform: %s/%s", runtime.GOOS, runtime.GOARCH)
	distro := detectDistro()
	if distro != "" {
		platform += fmt.Sprintf(" (%s)", distro)
	}
	hint := "Press Enter to continue, q to quit"

	return lipgloss.Place(
		m.width, m.height,
		lipgloss.Center, lipgloss.Center,
		lipgloss.JoinVertical(
			lipgloss.Center,
			styles.TitleStyle.Render(logo),
			styles.MenuItemStyle.Render(platform),
			"",
			styles.CommentStyle.Render(hint),
		),
	)
}

func detectDistro() string {
	if runtime.GOOS == "darwin" {
		return "macOS"
	}
	if data, err := exec.Command("cat", "/etc/os-release").Output(); err == nil {
		content := string(data)
		if strings.Contains(content, "Arch") {
			return "Arch Linux"
		}
		if strings.Contains(content, "Fedora") {
			return "Fedora"
		}
		if strings.Contains(content, "Ubuntu") || strings.Contains(content, "Debian") {
			return "Ubuntu/Debian"
		}
	}
	return ""
}
