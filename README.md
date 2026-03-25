# DreamcoderDots

<div align="center">
  <p><em>Custom Arch Linux workstation - modular dotfiles with terminal velocity</em></p>
</div>

[![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-blue?logo=arch-linux)](https://archlinux.org/)
[![GNU Stow](https://img.shields.io/badge/Deploy-GNU%20Stow-orange)](https://www.gnu.org/software/stow/)

Personal Arch Linux environment: shell configs, terminal tooling, editor setup.

## Quick Start

```bash
git clone https://github.com/Albert-fer02/Dreamcoder_dots.git
cd Dreamcoder_dots
make install
```

## Structure

```
DreamcoderDots/
├── .zshrc, .bashrc, .zshenv     # Shell configs
├── .p10k.zsh                    # Powerlevel10k
├── Fish/                        # Fish shell
├── Ghostty/                     # Ghostty terminal
├── Kitty/                       # Kitty terminal
├── Nushell/                     # Nushell
├── Nvim/                        # Neovim
├── Tmux/                        # Tmux
├── Zellij/                      # Zellij
├── DreamcoderInstaller/         # Rust installer
├── opencode/, claude/           # AI tools
├── scripts/, infra/             # Helpers
└── docs/
```

## Commands

| Command | Description |
|---------|-------------|
| `make install` | Run full install flow |
| `make stow` | Deploy via GNU Stow |
| `make unstow` | Remove symlinks |
| `make backup` | Backup current state |
| `make verify` | Verify installation |

## Requirements

- Arch Linux
- Git
- GNU Stow
- Make
