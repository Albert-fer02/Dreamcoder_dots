# Dreamcoder OS

Personal Arch Linux dotfiles for the **Dreamcoder** identity: a visual layer on top of
ML4W/Gentleman Dots focused on readability, eye comfort, and a premium coding experience.

## Philosophy

Dreamcoder is not a neon rice. It is a workbench:

- **health first**: no pure black/white primary backgrounds, strong contrast, low glare;
- **daily comfort**: larger terminal type, calmer prompt density, automatic day/night mode;
- **identity second**: Cocoa/Lúcuma warmth, diagnostic cyan, restrained editorial colors;
- **ML4W-compatible**: Dreamcoder owns colors and hooks, ML4W/Gentleman can keep layout behavior.

---

## `dreamcoder-theme` — Python Package

[![PyPI](https://img.shields.io/pypi/v/dreamcoder-theme)](https://pypi.org/project/dreamcoder-theme/)
[![Tests](https://github.com/Gentleman-Programming/dreamcoder-dots/actions/workflows/theme-validation.yml/badge.svg)](https://github.com/Gentleman-Programming/dreamcoder-dots/actions/workflows/theme-validation.yml)
[![Python](https://img.shields.io/pypi/pyversions/dreamcoder-theme)](https://pypi.org/project/dreamcoder-theme/)
[![License](https://img.shields.io/pypi/l/dreamcoder-theme)](https://github.com/Gentleman-Programming/dreamcoder-dots/blob/main/LICENSE)

The theme engine behind Dreamcoder OS. Generates color themes for **20+ targets** —
terminals, multiplexers, shells, editors, AI tools, desktop environments — from a
single set of design tokens.

### Installation

```bash
pip install dreamcoder-theme
```

### CLI Usage

```bash
# Render all themes to your config dirs
dreamcoder-theme sync

# Check health of installed themes
dreamcoder-theme doctor

# Inspect active theme paths
dreamcoder-theme paths

# See all available commands
dreamcoder-theme --help
```

### Library Usage

```python
from dreamcoder_theme.palette import adaptive_palette
from dreamcoder_theme.renderers import render_kitty, render_tmux

# Generate adaptive colors from a wallpaper
palette = adaptive_palette(wallpaper="/path/to/wallpaper.jpg")

# Render to specific formats
kitty_conf = render_kitty(palette)
tmux_conf = render_tmux(palette)
```

### What It Renders

| Category | Targets |
|---|---|
| Terminals | Kitty, Ghostty, WezTerm, Alacritty, Warp |
| Multiplexers | Tmux, Zellij |
| Shell | Starship, zsh-syntax-highlighting, LS_COLORS, fzf, Bat, Delta |
| AI Tools | OpenCode, Codex CLI, Pi CLI |
| Editors | Neovim (LSP, syntax, UI, plugins), VS Code / Antigravity |
| Desktop/WM | Hyprland, Waybar, Rofi |
| Apps | Firefox, Obsidian, Btop, Dunst, Cava |

---

## Full Dotfiles Installation

For the complete Dreamcoder OS desktop experience (Hyprland, Waybar, wallpapers,
systemd services, and all terminal/shell configs):

```bash
git clone git@github.com:Dreamcoder08/Dreamcoder_dots.git ~/Documents/PROYECTOS/dreamcoder-dots
cd ~/Documents/PROYECTOS/dreamcoder-dots
./scripts/dreamcoder install
```

`install.sh` stows the Dreamcoder modules, installs ML4W/Waypaper hooks, enables the
day/night timer, applies the current mode, and verifies the setup.

## Quick commands

```bash
./scripts/dreamcoder install      # first install / full reapply
./scripts/dreamcoder repair       # after ML4W or Gentleman updates
./scripts/dreamcoder doctor       # inspect current health/status
./scripts/dreamcoder verify       # symlinks + starship + theme health
./scripts/dreamcoder preview      # regenerate docs/dreamcoder-theme-preview.md
./scripts/dreamcoder auto         # apply light/dark for current time
./scripts/dreamcoder light        # force light mode
./scripts/dreamcoder dusk         # force dusk transitional mode
./scripts/dreamcoder dark         # force dark mode
./scripts/set-wallpaper.sh <file> # set wallpaper and refresh Dreamcoder
```

## Post-update repair

After updating ML4W, Gentleman Dots, Waypaper, or Hyprland configs, run:

```bash
cd ~/Documents/PROYECTOS/dreamcoder-dots
./scripts/dreamcoder repair
```

This reapplies hooks, restows modules, restarts the timer, refreshes the current
theme, and runs verification.

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for setup instructions, test runner, and
pull request guidelines.
