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
./scripts/dreamcoder sync
./scripts/generate-palette-tokens.py
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

Canonical palettes (see `themes/dreamcoder/tokens.json`):

**Dark — Ember Noir OLED**

```txt
bg          #100f0d
text        #e8dfd0
accent      #d99555
accent_2    #c96a45
error       #ed8a7a
focus       #5f8f8f
opacity     0.76
```

**Light — Cocoa/Lúcuma**

```txt
bg          #f3eadc
text        #17120d
accent      #824f16
accent_2    #a7471c
error       #842f24
focus       #0f6570
opacity     0.96
```

Rules:

- visible theme name is `Dreamcoder`
- edit colors only in `themes/dreamcoder/tokens.json`, then `./scripts/dreamcoder sync`
- Starship palette is `dreamcoder`
- Ghostty theme is `dreamcoder` / `dreamcoder-dark` / `dreamcoder-light`
- Fastfetch logo is `Dreamcoder01.jpg`
- do not commit secrets or tokens

## GitHub MCP

GitHub MCP is configured outside the repo using:

```txt
~/.local/bin/github-mcp-dreamcoder
~/.config/github/pat
```

Never print or commit the token.
