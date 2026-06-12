package views

import (
	"fmt"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/styles"
)

type Component struct {
	Name        string
	Description string
	Selected    bool
	Category    string
}

type ComponentsModel struct {
	components []Component
	cursor    int
	width     int
	height    int
}

func NewComponentsModel() ComponentsModel {
	components := []Component{
		{Name: "Kitty", Description: "GPU-accelerated terminal", Category: "Terminals", Selected: true},
		{Name: "Ghostty", Description: "Fast, feature-rich terminal", Category: "Terminals", Selected: false},
		{Name: "WezTerm", Description: "Cross-platform terminal", Category: "Terminals", Selected: false},
		{Name: "Alacritty", Description: "Minimal GPU terminal", Category: "Terminals", Selected: false},
		{Name: "Fish", Description: "Friendly interactive shell", Category: "Shells", Selected: true},
		{Name: "Zsh", Description: "Z shell", Category: "Shells", Selected: false},
		{Name: "Nushell", Description: "Modern structured shell", Category: "Shells", Selected: false},
		{Name: "Tmux", Description: "Terminal multiplexer", Category: "Multiplexers", Selected: false},
		{Name: "Zellij", Description: "Terminal workspace", Category: "Multiplexers", Selected: false},
		{Name: "Neovim", Description: "Hyperextensible editor", Category: "Editor", Selected: true},
	}

	return ComponentsModel{components: components}
}

func (m ComponentsModel) Init() tea.Cmd {
	return nil
}

func (m ComponentsModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
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
			if m.cursor < len(m.components)-1 {
				m.cursor++
			}
		case " ":
			m.components[m.cursor].Selected = !m.components[m.cursor].Selected
		case "enter":
			return NewInstallProgressModel(m.components), nil
		case "q", "ctrl+c":
			return m, tea.Quit
		case "esc":
			return NewWelcomeModel(), nil
		}
	}
	return m, nil
}

func (m ComponentsModel) View() string {
	title := styles.TitleStyle.Render("📦 Select Components")

	var items []string
	for i, comp := range m.components {
		checkbox := "[ ]"
		if comp.Selected {
			checkbox = "[✓]"
		}

		style := styles.MenuItemStyle
		if i == m.cursor {
			style = styles.SelectedStyle
		}

		item := fmt.Sprintf("%s %s — %s", checkbox, comp.Name, comp.Description)
		items = append(items, style.Render(item))
	}

	list := lipgloss.JoinVertical(lipgloss.Left, items...)
	hint := styles.CommentStyle.Render("Space to select, Enter to install, Esc to go back")

	return lipgloss.Place(
		m.width, m.height,
		lipgloss.Center, lipgloss.Center,
		lipgloss.JoinVertical(lipgloss.Center, title, "", list, "", hint),
	)
}
