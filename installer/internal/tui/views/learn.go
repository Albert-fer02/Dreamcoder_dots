package views

import (
	"fmt"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/styles"
)

type LearnModel struct {
	width    int
	height   int
	cursor   int
	tools    []ToolInfo
	selected *ToolInfo
}

func NewLearnModel() LearnModel {
	tools := GetToolsInfo()
	return LearnModel{tools: tools}
}

func (m LearnModel) Init() tea.Cmd {
	return nil
}

func (m LearnModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
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
			if m.cursor < len(m.tools)-1 {
				m.cursor++
			}
		case "enter":
			if m.selected == nil {
				tool := m.tools[m.cursor]
				m.selected = &tool
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

func (m LearnModel) View() string {
	if m.selected != nil {
		return m.detailView()
	}
	return m.listView()
}

func (m LearnModel) listView() string {
	title := styles.TitleStyle.Render("📚 Learn About Tools")

	var items []string
	for i, tool := range m.tools {
		style := styles.MenuItemStyle
		if i == m.cursor {
			style = styles.SelectedStyle
		}
		item := fmt.Sprintf("[%s] %s — %s", tool.Category, tool.Name, tool.Description)
		items = append(items, style.Render(item))
	}

	list := lipgloss.JoinVertical(lipgloss.Left, items...)
	footer := styles.CommentStyle.Render("↑/↓ Navigate • Enter View Details • Esc Back • q Quit")

	return lipgloss.Place(
		m.width, m.height,
		lipgloss.Center, lipgloss.Center,
		lipgloss.JoinVertical(lipgloss.Center, title, "", list, "", footer),
	)
}

func (m LearnModel) detailView() string {
	tool := m.selected

	title := styles.TitleStyle.Render(fmt.Sprintf("📖 %s", tool.Name))
	category := styles.CommentStyle.Render(fmt.Sprintf("Category: %s", tool.Category))
	website := styles.CommentStyle.Render(fmt.Sprintf("Website: %s", tool.Website))
	description := styles.MenuItemStyle.Render(tool.Description)

	// Features
	featuresTitle := styles.SelectedStyle.Render("Features:")
	var features []string
	for _, f := range tool.Features {
		features = append(features, styles.MenuItemStyle.Render(fmt.Sprintf("  • %s", f)))
	}
	featuresList := lipgloss.JoinVertical(lipgloss.Left, features...)

	// Pros
	prosTitle := styles.SelectedStyle.Render("Pros:")
	var pros []string
	for _, p := range tool.Pros {
		pros = append(pros, styles.MenuItemStyle.Render(fmt.Sprintf("  ✅ %s", p)))
	}
	prosList := lipgloss.JoinVertical(lipgloss.Left, pros...)

	// Cons
	consTitle := styles.SelectedStyle.Render("Cons:")
	var cons []string
	for _, c := range tool.Cons {
		cons = append(cons, styles.MenuItemStyle.Render(fmt.Sprintf("  ⚠️  %s", c)))
	}
	consList := lipgloss.JoinVertical(lipgloss.Left, cons...)

	footer := styles.CommentStyle.Render("Esc Back to list • q Quit")

	content := lipgloss.JoinVertical(
		lipgloss.Left,
		title,
		category,
		website,
		"",
		description,
		"",
		featuresTitle,
		featuresList,
		"",
		prosTitle,
		prosList,
		"",
		consTitle,
		consList,
		"",
		footer,
	)

	return lipgloss.Place(
		m.width, m.height,
		lipgloss.Center, lipgloss.Center,
		content,
	)
}
