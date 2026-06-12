package views

import (
	"fmt"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/styles"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/trainer"
)

type VimTrainerModel struct {
	player *trainer.Player
	module int
	lesson int
	width  int
	height int
}

func NewVimTrainerModel() VimTrainerModel {
	player, _ := trainer.LoadPlayer()
	return VimTrainerModel{player: player}
}

func (m VimTrainerModel) Init() tea.Cmd {
	return nil
}

func (m VimTrainerModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
	case tea.KeyMsg:
		switch msg.String() {
		case "q", "ctrl+c":
			trainer.SavePlayer(m.player)
			return NewComponentsModel(), nil
		case "1":
			m.module = 1
		case "2":
			m.module = 2
		case "3":
			m.module = 3
		}
	}
	return m, nil
}

func (m VimTrainerModel) View() string {
	title := styles.TitleStyle.Render("🎮 VIM MASTERY TRAINER")

	// Player stats
	stats := fmt.Sprintf("⭐ Lv%d %d XP — %s", m.player.Level, m.player.XP, m.player.Title)

	// Module list
	modules := []string{
		"✅ 1. Horizontal Movement",
		"✅ 2. Vertical Movement",
		"🔓 3. Text Objects",
		"🔒 4. Change & Repeat",
		"🔒 5. Substitution",
		"🔒 6. Macros & Registers",
		"🔒 7. Regex Search",
	}

	moduleList := lipgloss.JoinVertical(lipgloss.Left, modules...)

	// Editor placeholder
	editor := styles.BoxStyle.Width(50).Height(10).Render("Practice here...")

	leftPanel := lipgloss.JoinVertical(lipgloss.Left,
		styles.MenuItemStyle.Render(stats),
		"",
		moduleList,
	)

	rightPanel := editor

	content := lipgloss.JoinHorizontal(lipgloss.Top, leftPanel, "  ", rightPanel)

	hint := styles.CommentStyle.Render("Press 1-7 to select module, q to quit")

	return lipgloss.Place(
		m.width, m.height,
		lipgloss.Center, lipgloss.Center,
		lipgloss.JoinVertical(lipgloss.Center, title, "", content, "", hint),
	)
}
