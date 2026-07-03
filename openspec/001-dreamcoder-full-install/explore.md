# Explore: Full Installation Integration — Gentleman.Dots + ML4W + Dreamcoder

> **Date:** 2026-07-02
> **Hardware:** ASUS VivoBook 15, 1920x1080, x86_64
> **OS:** Arch Linux rolling

## Current State Summary

### Gentleman.Dots Layer

| Component | Status | Details |
|-----------|--------|---------|
| **Nvim** | ✅ | colors/dreamcoder.lua exists, `vim.cmd.colorscheme("dreamcoder")` in init.lua |
| **Tmux** | ✅ | Sources GentlemanTmux/tmux.conf via `GENTLEMAN_DOTS_DIR`, dreamcoder color overlay works |
| **Ghostty** | ✅ | Symlinked to repo, theme files (dreamcoder, dreamcoder-dark, dreamcoder-light) present |
| **Kitty** | ✅ | Symlinked to repo, colors-dreamcoder.conf include works, dark/light variants exist |
| **Fish** | ✅ | 05-dreamcoder-theme.fish already fixed to DreamcoderThemes path, LS_COLORS/EZA_COLORS/FZF work |
| **Zellij** | ✅ | Config symlinked, dreamcoder-dark/light themes defined |
| **Starship** | ✅ | Symlinked, dreamcoder palette with light/dark palettes |
| **Desktop Entry** | ❌ | dreamcoder CLI at ~/.local/bin/dreamcoder but no desktop entry for auto-start |

### ML4W Layer

| Component | Status | Details |
|-----------|--------|---------|
| **Hyprland** | ⚠️ | colors.lua/colors.conf symlinked to light variants ✅, but `dreamcoder-colors.conf` exists at `~/.config/hypr/` and is NOT imported in hyprland.lua. Colors come from ML4W matugen output |
| **Waybar** | ✅ | colors.css symlinked to colors-light.css, dark/light variants exist |
| **Rofi** | ✅ | colors.rasi symlinked to colors-light.rasi, dark/light variants exist |
| **Dunst** | ✅ | dreamcoder-dunst.conf symlinked to repo, include in dunstrc works |
| **Btop** | ❌ | Uses matugen theme (ML4W default), no dreamcoder btop theme installed |
| **GTK** | ⚠️ | GTK config exists at ~/.config/gtk-3.0/ but not verified for dreamcoder colors |

### Dreamcoder-Specific Features

| Feature | Status | Details |
|---------|--------|---------|
| **Theme switching** | ⚠️ | `dreamcoder light/dark` runs apply-theme-mode.sh which flips symlinks (Waybar, Rofi, Hypr). Works MOSTLY but some components (Btop, Nvim) may not follow |
| **Doctor** | ⚠️ | Exists at scripts/doctor.sh and control center, but doesn't verify all integration hooks (Btop, GTK, Nvim, Hypr import of dreamcoder-colors.conf) |
| **Installer** | ⚠️ | install.sh exists, detects GENTLEMAN_DOTS_DIR, installs symlinks. But no idempotency guarantee, no manifest-based rollback in install flow |
| **Auto-theme timer** | ❌ | Systemd units exist but inactive (no `systemctl --user enable --now dreamcoder-theme-auto.timer` ran) |
| **Backup manifests** | ⚠️ | One old backup from 2026-05-31 exists, but current state has no manifest |
| **CI/CD integration test** | ❌ | No CI step that clones Gentleman+ML4W, applies dreamcoder, and verifies hooks |
| **Repair** | ⚠️ | repair.sh exists, repair-engine.py has catalog, but hasn't been verified against full integration matrix |

### Key Gaps Found

1. **Btop**: No dreamcoder theme, uses ML4W's matugen. DreamcoderThemes has `btop-dreamcoder.theme` but it's not deployed
2. **Hyprland dreamcoder-colors.conf**: File exists but hyprland.lua doesn't import it — colors come from ML4W's `require("colors")` → colors.lua → colors-light.lua (ML4W defaults, NOT dreamcoder tokens)
3. **Waybar style.css**: Could not find an ML4W style.css that imports dreamcoder colors — need to verify if @import works
4. **No active auto-theme timer**: Units exist but not enabled
5. **Doctor coverage**: Doesn't check Btop, GTK, Nvim colorscheme loading, Hypr dreamcoder import
6. **Git state**: Working tree has uncommitted changes from the previous SDD change (000-dreamcoder-theme-unification) — Fish path fix (already done), Tmux plugin additions, sync changes
7. **No desktop entry**: dreamcoder CLI is in PATH but no .desktop for autostart
8. **Bat theme**: Themes exist (~/.config/bat/themes/) but config integration not verified

### Working Tree State

```bash
M .gitmodules
M .pi/settings.json
M CHANGELOG.md
M DreamcoderGhostty/.config/ghostty/config
M DreamcoderKitty/.config/kitty/colors-matugen.conf
M DreamcoderNushell/.config/nushell/config.nu
M DreamcoderNushell/.config/nushell/dreamcoder-dark.nu
M DreamcoderNushell/.config/nushell/dreamcoder-light.nu
M DreamcoderShell/.config/fish/conf.d/05-dreamcoder-theme.fish  # Already fixed!
M DreamcoderZellij/.config/zellij/config.kdl
M DreamcoderZellij/.config/zellij/dreamcoder-dark.kdl
M DreamcoderZellij/.config/zellij/dreamcoder-light.kdl
M scripts/fastfetch.sh
M scripts/install.sh
M src/dreamcoder_theme/sync.py
?? openspec/001-dreamcoder-full-install/
```

### Integration Diagram

```
User's System (Arch Linux, ASUS VivoBook 15)
│
├── Gentleman.Dots (~/Gentleman.Dots/)
│   ├── Neovim (29 plugins LazyVim)
│   ├── Tmux (TPM, Kanagawa, continuum, which-key)
│   ├── Ghostty (45+ GLSL shaders)
│   ├── Kitty config
│   ├── Fish/Zsh/Nushell base config
│   └── Starship prompt (Kanagawa theme)
│
├── ML4W (~/.config/hypr/, ~/.config/waybar/, etc.)
│   ├── Hyprland (animations, keybinds, monitors)
│   ├── Waybar (status bar with themeswitcher)
│   ├── Rofi (app launcher)
│   ├── Dunst (notifications)
│   ├── Btop (system monitor, matugen theme)
│   └── GTK (3.0/4.0 colors)
│
└── Dreamcoder-overlay (~/Documents/PROYECTOS/dreamcoder-dots/)
    ├── Token engine (tokens.json → sync.py → 28 targets)
    ├── Ghostty theme:  dreamcoder (mode-tracked)        ✅
    ├── Kitty theme:    colors-dreamcoder-{mode}.conf     ✅
    ├── Tmux:           tmux-dreamcoder-{mode}.conf        ✅
    ├── Fish:           05-dreamcoder-theme.fish             ✅
    ├── Starship:       starship-{mode}.toml (env var)     ✅
    ├── Waybar:         colors-{mode}.css (@import)        ✅
    ├── Rofi:           colors-{mode}.rasi (@import)       ✅
    ├── Dunst:          dreamcoder-dunst.conf ([include])  ✅
    ├── Zellij:         dreamcoder-{mode}.kdl              ✅
    ├── Nvim:           colors/dreamcoder.lua              ✅
    ├── Hypr colors:    dreamcoder-colors.conf             ❌ Not imported
    ├── Btop:           btop-dreamcoder.theme              ❌ Not deployed
    ├── Bat:            Dreamcoder-{mode}.tmTheme          ⚠️ Exists, not verified
    ├── Pi agent:       dreamcoder.json                     ✅
    ├── OpenCode:       tui.json theme=dreamcoder           ✅
    ├── Warp:           Dreamcoder-{mode}.yaml              ✅
    ├── Firefox:        firefox-dreamcoder-{mode}.css       ⚠️ Not verified
    ├── Obsidian:       obsidian-dreamcoder-{mode}.css     ⚠️ Not verified
    ├── Cava:           cava-dreamcoder.config              ⚠️ Not verified
    │
    ├── Scripts:
    │   ├── apply-theme-mode.sh    ✅ Flips symlinks + sync + restart
    │   ├── doctor.sh              ⚠️ Missing Btop, GTK, Nvim, Hypr import
    │   ├── install.sh             ⚠️ No manifest-based rollback
    │   ├── repair.sh              ⚠️ Not verified against full matrix
    │   ├── verify.sh              ⚠️ Doesn't test all components
    │   └── theme-auto.sh          ❌ Timer not active
    │
    └── CI:                         ❌ No integration verification
```
