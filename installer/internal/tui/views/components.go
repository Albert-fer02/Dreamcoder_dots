package views

import (
	"fmt"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/dotfiles"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/styles"
)

type ComponentsModel struct {
	components []dotfiles.Component
	cursor     int
	width      int
	height     int
}

func NewComponentsModel() ComponentsModel {
	return ComponentsModel{
		components: dotfiles.KnownComponents(),
	}
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
	if m.width == 0 {
		m.width = 80
	}
	if m.height == 0 {
		m.height = 24
	}

	title := styles.TitleStyle.Render("📦 Select Components to Install")

	// Group by category
	categories := make(map[string][]dotfiles.Component)
	var catOrder []string
	for _, c := range m.components {
		if _, ok := categories[c.Category]; !ok {
			catOrder = append(catOrder, c.Category)
		}
		categories[c.Category] = append(categories[c.Category], c)
	}

	var sections []string
	for _, cat := range catOrder {
		header := styles.BoxStyle.Render(fmt.Sprintf(" %s ", cat))
		sections = append(sections, header)

		for _, c := range categories[cat] {
			checkbox := "  [ ]"
			style := styles.MenuItemStyle
			if c.Selected {
				checkbox = "  [✓]"
				style = styles.SelectedStyle
			}

			// Find index for cursor highlighting
			idx := indexOf(m.components, c.Name)
			if idx == m.cursor {
				checkbox = "  ▶"
				if c.Selected {
					checkbox = "  ▶✓"
				}
				style = styles.SelectedStyle
			}

			item := fmt.Sprintf("%s %s — %s", checkbox, c.Name, c.Description)
			sections = append(sections, style.Render(item))
		}
		sections = append(sections, "")
	}

	list := lipgloss.JoinVertical(lipgloss.Left, sections...)

	// Summary bar
	selected := 0
	for _, c := range m.components {
		if c.Selected {
			selected++
		}
	}
	summary := styles.StatusBarStyle.Render(fmt.Sprintf(
		" %d/%d selected | Space: toggle | Enter: install | Esc: back | q: quit",
		selected, len(m.components),
	))

	content := lipgloss.JoinVertical(
		lipgloss.Center,
		title,
		"",
		list,
		summary,
	)

	return lipgloss.Place(
		m.width, m.height,
		lipgloss.Center, lipgloss.Center,
		content,
	)
}

func indexOf(comps []dotfiles.Component, name string) int {
	for i, c := range comps {
		if c.Name == name {
			return i
		}
	}
	return -1
}
