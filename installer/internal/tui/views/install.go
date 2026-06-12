package views

import (
	"fmt"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/styles"
)

type InstallProgressModel struct {
	components []Component
	current    int
	width      int
	height     int
	done       bool
}

func NewInstallProgressModel(components []Component) InstallProgressModel {
	return InstallProgressModel{components: components}
}

func (m InstallProgressModel) Init() tea.Cmd {
	return nil
}

func (m InstallProgressModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
	case tea.KeyMsg:
		switch msg.String() {
		case "enter":
			if m.done {
				return NewWelcomeModel(), nil
			}
			// Simulate progress
			if m.current < len(m.components) {
				m.current++
			}
			if m.current >= len(m.components) {
				m.done = true
			}
		case "q", "ctrl+c":
			return m, tea.Quit
		}
	}
	return m, nil
}

func (m InstallProgressModel) View() string {
	title := styles.TitleStyle.Render("📦 Installing Components")

	var items []string
	for i, comp := range m.components {
		status := "⏳ Pending"
		style := styles.CommentStyle

		if i < m.current {
			status = "✅ Done"
			style = styles.MenuItemStyle
		} else if i == m.current && !m.done {
			status = "🔄 Installing..."
			style = styles.SelectedStyle
		}

		item := fmt.Sprintf("%s %s", status, comp.Name)
		items = append(items, style.Render(item))
	}

	list := lipgloss.JoinVertical(lipgloss.Left, items...)

	hint := "Press Enter to continue"
	if m.done {
		hint = "✅ Installation complete! Press Enter to return"
	}

	return lipgloss.Place(
		m.width, m.height,
		lipgloss.Center, lipgloss.Center,
		lipgloss.JoinVertical(lipgloss.Center, title, "", list, "", styles.CommentStyle.Render(hint)),
	)
}
