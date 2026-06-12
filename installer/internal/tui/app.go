package tui

import (
	tea "github.com/charmbracelet/bubbletea"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/views"
)

func RunTUI() error {
	p := tea.NewProgram(views.NewWelcomeModel(), tea.WithAltScreen())
	_, err := p.Run()
	return err
}
