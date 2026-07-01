# SDD Plan 01: Overlay Compatibility — Gentleman.Dots + ML4W

> **Goal:** Guarantee that dreamcoder-dots theme hooks work flawlessly on top of both Gentleman.Dots and ML4W installations. The user installs Gentleman → ML4W → dreamcoder, and everything just works.
> **Strategy:** Verify every theme hook path, include name, and file reference against BOTH base repos. Fix mismatches.
> **Priority:** 🔴 CRITICAL — prerequisite for everything else
> **Estimated diff:** ~300 lines across 15+ files (mostly fixes)

## Context

dreamcoder-dots is designed as a **visual overlay** — it generates color files that get `@import`ed or `[include]`d by the base configs from Gentleman.Dots and ML4W. But there are **friction points**:

- Path mismatches: dreamcoder writes to `~/.config/hypr/colors.conf` but ML4W includes from `~/.config/hypr/colors.conf`? Verificar.
- File naming: `dunst-dreamcoder-dark.conf` vs what dunstrc expects
- Include syntax differences: Lua vs conf vs CSS imports
- Mode switching: dreamcoder auto-switches dark/light, pero los includes tienen que actualizarse dinámicamente

## What to Verify

### Layer 1: Gentleman.Dots Overlay

| Component    | dreamcoder hook                   | Gentleman base                            | Integration Status               |
| ------------ | --------------------------------- | ----------------------------------------- | -------------------------------- |
| **Ghostty**  | `themes/dreamcoder-{mode}`        | `GentlemanGhostty/config` `theme = ...`   | 🔍 Verify path resolution        |
| **Kitty**    | `colors-dreamcoder-{mode}.conf`   | `GentlemanKitty/kitty.conf` `include`     | 🔍 Verify include directive      |
| **Tmux**     | `dreamcoder-{mode}.conf`          | `GentlemanTmux/tmux.conf` `source-file`   | 🔍 Verify source-file path       |
| **Zellij**   | `dreamcoder-{mode}.kdl`           | `GentlemanZellij/zellij/config.kdl`       | 🔍 Verify theme reference        |
| **Nvim**     | `colors/dreamcoder-{mode}.lua`    | `GentlemanNvim/nvim/init.lua` colorscheme | ✅ Works (verify LazyVim compat) |
| **Starship** | `starship-{mode}.toml`            | `starship.toml`                           | ✅ Works via env var             |
| **Fish**     | `conf.d/05-dreamcoder-theme.fish` | `GentlemanFish/fish/config.fish`          | 🔍 Verify no conflicts           |

### Layer 2: ML4W Overlay

| Component     | dreamcoder hook                | ML4W base                    | Integration Status        |
| ------------- | ------------------------------ | ---------------------------- | ------------------------- |
| **Hyprland**  | `hypr-colors-{mode}.conf`      | `hypr/colors.conf`           | 🔍 Verify variable naming |
| **Waybar**    | `waybar-{mode}.css`            | `waybar/style.css` `@import` | 🔍 Verify CSS import      |
| **Rofi**      | `rofi-{mode}.rasi`             | `rofi/config.rasi` `@import` | 🔍 Verify rasi import     |
| **Dunst**     | `dunst-dreamcoder-{mode}.conf` | `dunst/dunstrc` `[include]`  | 🔍 Verify include works   |
| **Btop**      | `btop-dreamcoder-{mode}.theme` | `btop/btop.conf` `theme =`   | 🔍 Verify theme selection |
| **GTK**       | `colors.css`                   | `gtk-3.0/gtk.css` `@import`  | 🔍 Verify path            |
| **Fastfetch** | —                              | Already has own config       | ✅ No action needed       |

## Acceptance Criteria

1. Install Gentleman.Dots → install ML4W → run `./scripts/dreamcoder install`
2. All terminal colors show dreamcoder palette (dark mode = Ember Noir, light = Cocoa/Lúcuma)
3. No "file not found" errors in any application log
4. `DREAMCODER_THEME_MODE=light` switches ALL components to light simultaneously
5. `DREAMCODER_THEME_MODE=dark` switches ALL components back to dark
6. No duplicate color definitions (dreamcoder doesn't conflict with base theme)

## Tasks

### Task 1: Audit Gentleman.Dots Integration

- Clone both repos fresh
- Run dreamcoder's install hooks
- Check EVERY app for correct color loading
- Document any path/include mismatches

### Task 2: Audit ML4W Integration

- Same process for ML4W base
- Pay special attention to hyprland variable naming (ML4W uses `$COLOR` vs dreamcoder's `$dcCOLOR`)

### Task 3: Fix Path Mismatches

- Update `renderers_*.py` to output correct paths for each base
- Update `install-dreamcoder-hooks.sh` for any symlink/include path changes
- Update `settings.py` ThemePaths if needed

### Task 4: Add CI Check

- Add GitHub workflow step that installs on a base config and verifies colors load
- Create test that validates all hook files exist at expected paths

## Risks

- **ML4W updates**: ML4W changes file names between versions — need version detection or tolerance
- **Gentleman.Dots updates**: Same risk. Consider pinning compatible versions in docs
- **Order matters**: Install Gentleman → ML4W → dreamcoder. If order changes, hooks point to wrong base
