# DreamcoderDots
<img width="1600" height="900" alt="Dreamcoder" src="https://github.com/user-attachments/assets/9e2e50d0-a792-46de-99e0-015d52786eb8" />


Personal Arch Linux dotfiles for the **Dreamcoder** identity.

This repo is focused on terminal identity, shell ergonomics, AI tooling, and
repeatable configuration. The visual system is intentionally stable: wallpaper
changes must not redefine the Dreamcoder brand.

## Identity

**Dreamcoder Prime** is the official daily theme.

```txt
background  #19120c
foreground  #eee0d5
accent      #fbb974
error       #ffb4ab
opacity     0.60
```

Principles:

- one visible name: **Dreamcoder**
- fixed Cocoa/Lúcuma-inspired palette
- Kitty and Ghostty should look equivalent
- Fastfetch always uses `Dreamcoder01.jpg`
- Starship uses `palette = "dreamcoder"`
- wallpaper changes may run ML4W/Matugen, but Dreamcoder reapplies itself

## Structure

```txt
.dotfiles/
├── Shell/      # Fish, Zsh, Bash, Starship
├── Kitty/      # Kitty config and Dreamcoder colors
├── Ghostty/    # Ghostty config and Dreamcoder theme
├── Fastfetch/  # Fastfetch config and Dreamcoder image
└── scripts/    # Sync and utility scripts
```

## Install

```bash
ln -s ~/somnyx/ops/dotfiles/dreamcoder-dots ~/.dotfiles
cd ~/.dotfiles
stow -t ~ Shell Kitty Ghostty Fastfetch
```

If cloning fresh:

```bash
git clone https://github.com/dreamcoder08/Dreamcoder_dots.git ~/.dotfiles
cd ~/.dotfiles
stow -t ~ Shell Kitty Ghostty Fastfetch
```

## Apply Dreamcoder identity

```bash
./scripts/sync-dreamcoder-theme.py
```

This writes the fixed Dreamcoder palette to:

- `~/.config/kitty/colors-matugen.conf`
- `~/.config/ghostty/themes/dreamcoder`
- `~/.config/starship.toml`

The filename `colors-matugen.conf` is kept for ML4W compatibility, but the
content is Dreamcoder-fixed.

## Wallpaper changes

ML4W can still change wallpapers. After Matugen runs, execute:

```bash
~/.dotfiles/scripts/sync-dreamcoder-theme.py
```

Kitty reloads automatically through `SIGUSR1` in `scripts/update-colors.sh`.
Ghostty writes the new theme file, then reload open windows with:

```txt
Ctrl + Shift + R
```

## Fastfetch

Fastfetch is pinned to:

```txt
~/.config/dreamcoder/Dreamcoder01.jpg
```

The repo keeps only this image for the Dreamcoder identity.

## GitHub MCP

GitHub MCP uses a private wrapper, not repo-stored secrets:

```txt
~/.local/bin/github-mcp-dreamcoder
~/.config/github/pat
```

The wrapper reads the token from the private file and launches the official
Dockerized GitHub MCP server. Never commit tokens to this repo.

## Usage

- Edit configs in `~/.dotfiles/`
- Run `./scripts/sync-dreamcoder-theme.py` after visual changes
- Validate Ghostty with `ghostty +validate-config`
- Validate Starship with `STARSHIP_CONFIG=Shell/.config/starship.toml starship explain`
- Commit and push from `~/.dotfiles/`
