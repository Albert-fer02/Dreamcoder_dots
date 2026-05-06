# DreamcoderDots

Personal dotfiles - managed via GNU Stow.

## Structure

```
.dotfiles/           ← Repo (symlinked to ~/somnyx/ops/dotfiles/dreamcoder-dots)
├── Shell/           # .zshrc, .bashrc, .p10k.zsh, etc.
├── Kitty/           # ~/.config/kitty
├── Ghostty/         # ~/.config/ghostty
└── Fastfetch/       # ~/.config/fastfetch
```

## Install

```bash
# Clone somewhere and symlink to ~/.dotfiles
ln -s ~/somnyx/ops/dotfiles/dreamcoder-dots ~/.dotfiles

# Or clone fresh
git clone https://github.com/dreamcoder08/Dreamcoder_dots.git ~/.dotfiles

# Stow everything
cd ~/.dotfiles
stow -t ~ Shell Kitty Ghostty Fastfetch
```

## Dreamcoder

- Starship prompt: `Shell/.config/starship.toml`
- Ghostty theme: `Ghostty/.config/ghostty/themes/dreamcoder`
- Ghostty config uses `theme = dreamcoder`

## Dynamic wallpaper colors

`scripts/sync-dreamcoder-theme.py` reads the active ML4W wallpaper,
asks Matugen for the full dark palette, and regenerates Ghostty +
Starship colors. If no wallpaper is found, it falls back to Kitty's
`colors-matugen.conf`.

```bash
./scripts/update-colors.sh /path/to/wallpaper.jpg
```

## Prompt

Dreamcoder uses one official Starship prompt. It stays segmented and
premium, but keeps noise low with SSH-only hostname, contextual runtime
modules, improved Git status, and wallpaper-driven colors.

## Usage

- Edit configs in `~/.dotfiles/`
- Changes are reflected immediately (symlinks)
- Commit and push from `~/.dotfiles/`
