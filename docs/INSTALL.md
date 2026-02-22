# Installation Guide

## Quick Start

```bash
git clone https://github.com/yourname/dreamcoder-dotfiles.git
cd dreamcoder-dotfiles
make install
```

## Options

| Command | Description |
|---------|-------------|
| `make install` | Full install (packages + stow) |
| `make stow` | Only symlink configs |
| `make unstow` | Remove symlinks |
| `make test` | Validate configs |
| `make verify` | Check installation |

## Selective Install

Install specific modules:

```bash
stow shell nvim gitconfig
```

## Requirements

- Arch Linux (or Arch-based)
- Git, Stow

## Post-Install

1. Restart shell: `exec $SHELL`
2. Tmux plugins: `Prefix + I`
3. Neovim plugins: `:Lazy`

## Troubleshooting

### Symlink conflicts

```bash
# Remove existing configs
rm ~/.zshrc ~/.bashrc
make stow
```

### Missing tools

```bash
sudo pacman -S --needed fzf bat eza fd ripgrep zoxide
```

### Font issues

```bash
sudo pacman -S ttf-jetbrains-mono-nerd
```

## Uninstall

```bash
make unstow
rm -rf ~/.config/shell
```
