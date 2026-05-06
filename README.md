# DreamcoderDots

Personal dotfiles - managed via GNU Stow.

## Structure

```
.dotfiles/           ← Repo (symlinked to ~/somnyx/ops/dotfiles/dreamcoder-dots)
├── Shell/           # .zshrc, .bashrc, .p10k.zsh, etc.
├── Kitty/           # ~/.config/kitty
├── Ghostty/         # ~/.config/ghostty
├── Fastfetch/       # ~/.config/fastfetch
└── Codex-App/       # Dreamcoder theme assets only
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

## Dreamcoder Cocoa/Lúcuma

- Starship prompt: `Shell/.config/starship.toml`
- Ghostty theme: `Ghostty/.config/ghostty/themes/cocoa-lucuma`
- Ghostty config uses `theme = cocoa-lucuma`

## Usage

- Edit configs in `~/.dotfiles/`
- Changes are reflected immediately (symlinks)
- Commit and push from `~/.dotfiles/`
