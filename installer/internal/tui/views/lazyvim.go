package views

import (
	"fmt"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/styles"
)

type LazyVimModel struct {
	width    int
	height   int
	cursor   int
	guide    []LazyVimGuide
	selected *LazyVimGuide
}

func NewLazyVimModel() LazyVimModel {
	guide := GetLazyVimGuide()
	return LazyVimModel{guide: guide}
}

func (m LazyVimModel) Init() tea.Cmd {
	return nil
}

func (m LazyVimModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
	case tea.KeyMsg:
		switch msg.String() {
		case "up", "k":
			if m.cursor > 0 {
				m.cursor--
			}
		case "down", "j":
			if m.cursor < len(m.guide)-1 {
				m.cursor++
			}
		case "enter":
			if m.selected == nil {
				section := m.guide[m.cursor]
				m.selected = &section
			}
		case "esc":
			if m.selected != nil {
				m.selected = nil
			} else {
				return NewWelcomeModel(), nil
			}
		case "q", "ctrl+c":
			return m, tea.Quit
		}
	}
	return m, nil
}

func (m LazyVimModel) View() string {
	if m.selected != nil {
		return m.detailView()
	}
	return m.listView()
}

func (m LazyVimModel) listView() string {
	title := styles.TitleStyle.Render("📖 LazyVim Guide")

	var items []string
	for i, section := range m.guide {
		style := styles.MenuItemStyle
		if i == m.cursor {
			style = styles.SelectedStyle
		}
		items = append(items, style.Render(section.Section))
	}

	list := lipgloss.JoinVertical(lipgloss.Left, items...)
	footer := styles.CommentStyle.Render("↑/↓ Navigate • Enter Read Section • Esc Back • q Quit")

	return lipgloss.Place(
		m.width, m.height,
		lipgloss.Center, lipgloss.Center,
		lipgloss.JoinVertical(lipgloss.Center, title, "", list, "", footer),
	)
}

func (m LazyVimModel) detailView() string {
	title := styles.TitleStyle.Render(fmt.Sprintf("📖 %s", m.selected.Section))
	content := styles.MenuItemStyle.Render(m.selected.Content)
	footer := styles.CommentStyle.Render("Esc Back to sections • q Quit")

	return lipgloss.Place(
		m.width, m.height,
		lipgloss.Center, lipgloss.Center,
		lipgloss.JoinVertical(lipgloss.Center, title, "", content, "", footer),
	)
}
