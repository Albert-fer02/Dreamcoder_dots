# CLAUDE.md

DreamcoderDots - Personal Arch Linux dotfiles configuration.

## Project Overview

Modular dotfiles system for Arch Linux: shell configs (ZSH, Bash, Fish), terminals (Kitty, Ghostty, Zellij), editor (Neovim), and AI tools integration.

## Key Commands

```bash
./install.sh              # Full installation
./install.sh --skip-packages  # Skip packages
./verify.sh              # Verify installation
```

## File Structure

```
├── .zshrc, .bashrc       # Shell configs
├── Fish/                 # Fish shell
├── Ghostty/              # Ghostty terminal
├── Kitty/                # Kitty terminal  
├── Nvim/                 # Neovim
├── Tmux/                 # Tmux
├── Zellij/               # Zellij
├── opencode/             # OpenCode integration
├── claude/               # Claude AI integration
└── scripts/              # Install scripts
```

## Architecture

- Modular: each folder = one tool/subsystem
- Reproducible: install, stow, backup flows
- Arch Linux focused

## Guidelines

- Keep configs modular and portable
- Use `$HOME` instead of hardcoded paths
- Prefer direct solutions over abstractions
