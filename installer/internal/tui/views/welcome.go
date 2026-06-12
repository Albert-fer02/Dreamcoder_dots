package views

import (
	"fmt"
	"os/exec"
	"runtime"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/system"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/styles"
)

type WelcomeModel struct {
	width    int
	height   int
	cursor   int
	platform system.Platform
	configs  system.ExistingConfigs
	options  []string
}

func NewWelcomeModel() WelcomeModel {
	platform := system.DetectPlatform()
	configs := system.DetectExistingConfigs(platform.HomeDir)

	options := []string{
		"🚀 Start Installation",
		"📚 Learn About Tools",
		"⌨️  Neovim Keymaps",
		"📖 LazyVim Guide",
		"🎮 Vim Trainer",
		"📋 Restore from Backup",
		"🔍 Doctor (Health Check)",
		"❌ Exit",
	}

	return WelcomeModel{
		platform: platform,
		configs:  configs,
		options:  options,
	}
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
		case "up", "k":
			if m.cursor > 0 {
				m.cursor--
			}
		case "down", "j":
			if m.cursor < len(m.options)-1 {
				m.cursor++
			}
		case "enter":
			switch m.cursor {
			case 0: // Start Installation
				return NewComponentsModel(), nil
			case 1: // Learn About Tools
				return NewLearnModel(), nil
			case 2: // Neovim Keymaps
				return NewKeymapsModel(), nil
			case 3: // LazyVim Guide
				return NewLazyVimModel(), nil
			case 4: // Vim Trainer
				return NewVimTrainerModel(), nil
			case 5: // Restore from Backup
				return NewRestoreModel(), nil
			case 6: // Doctor
				return NewDoctorModel(), nil
			case 7: // Exit
				return m, tea.Quit
			}
		case "q", "ctrl+c":
			return m, tea.Quit
		}
	}
	return m, nil
}

func (m WelcomeModel) View() string {
	logo := `
   ╔═══════════════════════════════════════════════╗
   ║                                               ║
   ║   🎨 DREAMCODER OS                            ║
   ║   Token-governed visual operating layer       ║
   ║                                               ║
   ╚═══════════════════════════════════════════════╝
`

	// Platform info
	platformInfo := fmt.Sprintf("Platform: %s/%s", m.platform.OS, m.platform.Arch)
	if m.platform.Distro != "" {
		platformInfo += fmt.Sprintf(" (%s)", m.platform.Distro)
	}

	// Existing configs detection
	configStatus := m.getConfigStatus()

	// Menu
	var menuItems []string
	for i, opt := range m.options {
		style := styles.MenuItemStyle
		if i == m.cursor {
			style = styles.SelectedStyle
		}
		menuItems = append(menuItems, style.Render(opt))
	}

	menu := lipgloss.JoinVertical(lipgloss.Left, menuItems...)

	// Footer
	footer := styles.CommentStyle.Render("↑/↓ Navigate • Enter Select • q Quit")

	content := lipgloss.JoinVertical(
		lipgloss.Center,
		styles.TitleStyle.Render(logo),
		styles.MenuItemStyle.Render(platformInfo),
		"",
		configStatus,
		"",
		menu,
		"",
		footer,
	)

	return lipgloss.Place(
		m.width, m.height,
		lipgloss.Center, lipgloss.Center,
		content,
	)
}

func (m WelcomeModel) getConfigStatus() string {
	var detected []string

	if m.configs.Nvim {
		detected = append(detected, "Neovim")
	}
	if m.configs.Fish {
		detected = append(detected, "Fish")
	}
	if m.configs.Zsh {
		detected = append(detected, "Zsh")
	}
	if m.configs.Tmux {
		detected = append(detected, "Tmux")
	}
	if m.configs.Kitty {
		detected = append(detected, "Kitty")
	}
	if m.configs.Ghostty {
		detected = append(detected, "Ghostty")
	}

	if len(detected) == 0 {
		return styles.CommentStyle.Render("No existing configs detected")
	}

	status := fmt.Sprintf("Detected: %s", strings.Join(detected, ", "))
	return styles.MenuItemStyle.Render(status)
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
