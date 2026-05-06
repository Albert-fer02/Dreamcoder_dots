# CLAUDE.md

DreamcoderDots is the personal Arch Linux dotfiles repo for the **Dreamcoder**
identity.

## Project overview

This repo manages terminal and shell configuration for a fixed visual identity:

- Kitty
- Ghostty
- Fish/Zsh/Bash
- Starship
- Fastfetch
- AI tooling integration

The theme strategy is **identity-first**. Do not replace Dreamcoder colors with
wallpaper-derived palettes unless explicitly requested.

## Important commands

```bash
./scripts/sync-dreamcoder-theme.py
bash -n scripts/update-colors.sh
ghostty +validate-config
STARSHIP_CONFIG=Shell/.config/starship.toml starship explain
fish -n Shell/.config/fish/config.fish
```

## Structure

```txt
├── Shell/      # shell configs, Starship, Fish conf.d
├── Kitty/      # Kitty config and Dreamcoder colors
├── Ghostty/    # Ghostty config and Dreamcoder theme
├── Fastfetch/  # Fastfetch config and Dreamcoder01 image
└── scripts/    # sync/update helpers
```

## Dreamcoder identity

Official daily palette:

```txt
background  #19120c
foreground  #eee0d5
accent      #fbb974
error       #ffb4ab
opacity     0.60
```

Rules:

- visible theme name is `Dreamcoder`
- Starship palette is `dreamcoder`
- Ghostty theme is `dreamcoder`
- Fastfetch logo is `Dreamcoder01.jpg`
- do not reintroduce `Codex-App/`
- do not commit secrets or tokens

## GitHub MCP

GitHub MCP is configured outside the repo using:

```txt
~/.local/bin/github-mcp-dreamcoder
~/.config/github/pat
```

Never print or commit the token.
