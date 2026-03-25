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
git clone https://github.com/Albert-fer02/Dreamcoder_dots.git ~/.dotfiles

# Stow everything
cd ~/.dotfiles
stow -t ~ Shell Kitty Ghostty Fastfetch
```

## Usage

- Edit configs in `~/.dotfiles/`
- Changes are reflected immediately (symlinks)
- Commit and push from `~/.dotfiles/`
