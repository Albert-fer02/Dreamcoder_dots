package views

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/system"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/styles"
)

type RestoreModel struct {
	width     int
	height    int
	cursor    int
	backups   []string
	platform  system.Platform
 restorationDone bool
}

func NewRestoreModel() RestoreModel {
	platform := system.DetectPlatform()
	backups := findBackups(platform.HomeDir)
	return RestoreModel{
		platform: platform,
		backups:  backups,
	}
}

func (m RestoreModel) Init() tea.Cmd {
	return nil
}

func (m RestoreModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
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
			if m.cursor < len(m.backups)-1 {
				m.cursor++
			}
		case "enter":
			if len(m.backups) > 0 && !m.restorationDone {
				backupDir := m.backups[m.cursor]
				if err := system.RestoreBackup(backupDir); err != nil {
					fmt.Printf("Warning: %v\n", err)
				}
				m.restorationDone = true
			}
		case "esc":
			return NewWelcomeModel(), nil
		case "q", "ctrl+c":
			return m, tea.Quit
		}
	}
	return m, nil
}

func (m RestoreModel) View() string {
	title := styles.TitleStyle.Render("📋 Restore from Backup")

	if m.restorationDone {
		content := styles.MenuItemStyle.Render("✅ Backup restored successfully!")
		footer := styles.CommentStyle.Render("Press Enter to continue • q Quit")
		return lipgloss.Place(
			m.width, m.height,
			lipgloss.Center, lipgloss.Center,
			lipgloss.JoinVertical(lipgloss.Center, title, "", content, "", footer),
		)
	}

	if len(m.backups) == 0 {
		content := styles.CommentStyle.Render("No backups found")
		footer := styles.CommentStyle.Render("Press Esc to go back • q Quit")
		return lipgloss.Place(
			m.width, m.height,
			lipgloss.Center, lipgloss.Center,
			lipgloss.JoinVertical(lipgloss.Center, title, "", content, "", footer),
		)
	}

	var items []string
	for i, backup := range m.backups {
		style := styles.MenuItemStyle
		if i == m.cursor {
			style = styles.SelectedStyle
		}
		// Extract timestamp from backup name
		name := filepath.Base(backup)
		name = strings.TrimPrefix(name, ".dreamcoder-backup-")
		item := fmt.Sprintf("📦 Backup: %s", name)
		items = append(items, style.Render(item))
	}

	list := lipgloss.JoinVertical(lipgloss.Left, items...)
	footer := styles.CommentStyle.Render("↑/↓ Navigate • Enter Restore • Esc Back • q Quit")

	return lipgloss.Place(
		m.width, m.height,
		lipgloss.Center, lipgloss.Center,
		lipgloss.JoinVertical(lipgloss.Center, title, "", list, "", footer),
	)
}

func findBackups(homeDir string) []string {
	var backups []string
	entries, err := os.ReadDir(homeDir)
	if err != nil {
		return backups
	}

	for _, entry := range entries {
		if entry.IsDir() && strings.HasPrefix(entry.Name(), ".dreamcoder-backup-") {
			backups = append(backups, filepath.Join(homeDir, entry.Name()))
		}
	}

	return backups
}
