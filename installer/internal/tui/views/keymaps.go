package views

import (
	"fmt"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/styles"
)

type KeymapsModel struct {
	width      int
	height     int
	cursor     int
	categories []string
	keymaps    map[string][]Keymap
	selected   string
}

func NewKeymapsModel() KeymapsModel {
	keymaps := GetKeymapsByCategory()
	categories := make([]string, 0, len(keymaps))
	for cat := range keymaps {
		categories = append(categories, cat)
	}
	return KeymapsModel{
		categories: categories,
		keymaps:   keymaps,
	}
}

func (m KeymapsModel) Init() tea.Cmd {
	return nil
}

func (m KeymapsModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
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
			if m.cursor < len(m.categories)-1 {
				m.cursor++
			}
		case "enter":
			if m.selected == "" {
				m.selected = m.categories[m.cursor]
			}
		case "esc":
			if m.selected != "" {
				m.selected = ""
			} else {
				return NewWelcomeModel(), nil
			}
		case "q", "ctrl+c":
			return m, tea.Quit
		}
	}
	return m, nil
}

func (m KeymapsModel) View() string {
	if m.selected != "" {
		return m.detailView()
	}
	return m.listView()
}

func (m KeymapsModel) listView() string {
	title := styles.TitleStyle.Render("⌨️  Neovim Keymaps")

	var items []string
	for i, cat := range m.categories {
		style := styles.MenuItemStyle
		if i == m.cursor {
			style = styles.SelectedStyle
		}
		count := len(m.keymaps[cat])
		item := fmt.Sprintf("%s (%d keymaps)", cat, count)
		items = append(items, style.Render(item))
	}

	list := lipgloss.JoinVertical(lipgloss.Left, items...)
	footer := styles.CommentStyle.Render("↑/↓ Navigate • Enter View Category • Esc Back • q Quit")

	return lipgloss.Place(
		m.width, m.height,
		lipgloss.Center, lipgloss.Center,
		lipgloss.JoinVertical(lipgloss.Center, title, "", list, "", footer),
	)
}

func (m KeymapsModel) detailView() string {
	title := styles.TitleStyle.Render(fmt.Sprintf("⌨️  %s Keymaps", m.selected))

	keymaps := m.keymaps[m.selected]
	var items []string
	for _, km := range keymaps {
		item := fmt.Sprintf("%-20s %s", km.Key, km.Description)
		items = append(items, styles.MenuItemStyle.Render(item))
	}

	list := lipgloss.JoinVertical(lipgloss.Left, items...)
	footer := styles.CommentStyle.Render("Esc Back to categories • q Quit")

	return lipgloss.Place(
		m.width, m.height,
		lipgloss.Center, lipgloss.Center,
		lipgloss.JoinVertical(lipgloss.Center, title, "", list, "", footer),
	)
}
