# Dreamcoder Dotfiles

<div align="center">
  <img src="dreamcoder.webp" width="250" />
  <p><em>Modular dotfiles for Arch Linux</em></p>
</div>

[![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-blue?logo=arch-linux)](https://archlinux.org/)
[![GNU Stow](https://img.shields.io/badge/Deploy-GNU%20Stow-orange)](https://www.gnu.org/software/stow/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

## Quick Start

```bash
git clone https://github.com/yourname/dreamcoder-dotfiles.git
cd dreamcoder-dotfiles
make install
```

## Structure

```
dotfiles/
├── shell/          # Zsh, Bash, Starship
│   └── .config/shell/
│       ├── core/       # PATH, XDG, editor
│       ├── aliases/    # Grouped by domain
│       └── functions/  # Reusable functions
├── nvim/           # Neovim (LazyVim)
├── kitty/          # Terminal
├── ghostty/        # Terminal
├── tmux/           # Multiplexer
├── gitconfig/      # Git config
├── fastfetch/      # System info
├── scripts/        # Install, verify
├── tests/          # Validation tests
├── docs/           # Documentation
└── Makefile        # Task runner
```

## Commands

| Command | Description |
|---------|-------------|
| `make install` | Full installation |
| `make stow` | Symlink configs only |
| `make unstow` | Remove symlinks |
| `make test` | Run validation |
| `make verify` | Check installation |

## Architecture

- **Modular**: Each folder = one tool
- **DRY**: Shared shell modules (bash/zsh)
- **Safe**: Fallbacks for optional tools
- **Portable**: No hardcoded paths

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for details.

## Requirements

- Arch Linux
- Git, Stow

## Post-Install

1. `exec $SHELL` - Restart shell
2. `Prefix + I` - Install tmux plugins
3. `:Lazy` - Install neovim plugins
