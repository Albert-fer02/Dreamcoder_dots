# Dreamcoder Workbench

> A health-first, terminal-native engineering environment built on **Gentleman.Dots + ML4W**.
> Café/Lúcuma. Anthracite Steel. Contraste saludable. Identidad.

[![Theme CI](https://github.com/Dreamcoder08/Dreamcoder_dots/actions/workflows/theme-validation.yml/badge.svg)](https://github.com/Dreamcoder08/Dreamcoder_dots/actions/workflows/theme-validation.yml)
[![ML4W Setup CI](https://github.com/Dreamcoder08/Dreamcoder_dots/actions/workflows/test-ml4w-setup.yml/badge.svg)](https://github.com/Dreamcoder08/Dreamcoder_dots/actions/workflows/test-ml4w-setup.yml)
[![WCAG 4.5:1](https://img.shields.io/badge/WCAG-4.5%3A1-brightgreen)]()
[![APCA](https://img.shields.io/badge/APCA-75-brightgreen)]()
[![PyPI](https://img.shields.io/pypi/v/dreamcoder-theme)](https://pypi.org/project/dreamcoder-theme/)
[![License](https://img.shields.io/pypi/l/dreamcoder-theme)](./LICENSE)

---

## Quick Start — 3-Step Install

Dreamcoder Workbench is a personal distribution layer that adds profiles, themes, generators, and verification around Gentleman.Dots and ML4W. It does not replace either upstream project.

### 1. Install Gentleman.Dots

```bash
brew install Gentleman-Programming/tap/gentleman-dots
gentleman-dots
```

→ O descargá desde [Gentleman.Dots](https://github.com/Gentleman-Programming/Gentleman.Dots)

**Te da**: Neovim (29 plugins LazyVim), Ghostty shaders (45+), Tmux/Zellij, Vim Trainer, Fish/Zsh/Nushell

### 2. Install ML4W OS

```bash
bash <(curl -s https://ml4w.com/os/stable)
```

→ [Documentación ML4W](https://ml4w.com/os/)

**Te da**: Hyprland completo (animaciones, keybinds, monitores), Waybar, Rofi, Dunst, GTK, Btop

### 3. Install Dreamcoder

```bash
git clone git@github.com:Dreamcoder08/Dreamcoder_dots.git ~/Documents/PROYECTOS/dreamcoder-dots
cd ~/Documents/PROYECTOS/dreamcoder-dots
./scripts/dreamcoder install
```

**Aplica**: Dreamcoder dark/light/dusk sobre toda la base de Gentleman + ML4W

**Agrega**: Starship prompt con AI session state, 9 funciones shell, aliases modernos, auto-theme-switching

---

## ML4W Integration — Profile-Driven Keybinding System

Dreamcoder integrates with [ML4W](https://ml4w.com) through a modular, profile-driven system.
All machine-specific keybindings live in JSON profiles, avoiding manual editing of ML4W-managed files.

### Architecture

```mermaid
flowchart LR
    P["DreamcoderProfiles/dreamcoder/<br/>&lt;machine&gt;.json"]
    S["profile.schema.json"]
    GEN["scripts/generate-custom-lua.sh"]
    ORCH["scripts/setup-hyprland.sh"]
    VER["scripts/verify-ml4w-setup.sh"]
    VAL["scripts/validate-ml4w-profiles.py"]
    CUSTOM["~/.config/hypr/custom.lua"]
    TST["tests/ml4w/*.bats"]

    P -->|jq + tmpl| GEN
    S -->|schema| VAL
    S -->|schema| GEN
    GEN -->|validate| VAL
    GEN --> CUSTOM
    ORCH -->|symlinks + generation| CUSTOM
    VER -->|post-reboot| CUSTOM
    TST -->|bats| GEN
    TST -->|bats| ORCH
```

### Workflow

1. **Edit profile**: `DreamcoderProfiles/dreamcoder/<machine>.json`
2. **Generate**: `./scripts/generate-custom-lua.sh --profile <machine>`
3. **Setup**: `./scripts/setup-hyprland.sh --profile <machine>`
4. **Verify (post-reboot)**: `./scripts/verify-ml4w-setup.sh`
5. **Validate (CI)**: `python3 scripts/validate-ml4w-profiles.py --ci`

### Profiles

| Profile           | Machine          | Keybindings                                     |
| ----------------- | ---------------- | ----------------------------------------------- |
| `default`         | Any generic      | Apps, workspaces, focus, theme, blue light      |
| `asus-vivobook15` | ASUS VivoBook 15 | Multimedia F row, brightness, backlight + all of the above |

Profile auto-detection reads **DMI hardware** (`/sys/class/dmi/id/product_name`,
`sys_vendor`) first, then falls back to the hostname. Hostname-only detection
was a bug: hosts named `archlinux` never matched `*asus*`, so the wrong profile
(with no multimedia or brightness binds) was generated silently.

### Binding contract (avoid duplicate binds)

`~/.config/hypr/conf/keybindings/dreamcoder.lua` (our curated ML4W variant) and
the generated `custom.lua` are BOTH loaded by `hyprland.lua`. They must not
define the same key — Hyprland executes ALL matching duplicate binds in
declaration order (e.g. `SUPER + F` fullscreens and immediately unfullscreens).

Per the official ML4W docs, shipped keybinding variations are overwritten on
updates, so custom bindings live in a separate **variant**. `conf/keybinding.lua`
(the selector) points at `dreamcoder.lua` instead of the stock `default.lua`.

- The **profile JSON owns** everything the generator can emit: apps, workspaces,
  focus/move, fullscreen/floating/split, screenshots, theme, hyprsunset, the
  multimedia F row and the keyboard backlight.
- The **`dreamcoder.lua` variant** is restricted to binds the generator
  **cannot** emit: native mouse drag/resize, workspace scroll, window swap,
  group toggle, scratchpad, ML4W actions (wallpaper, power, launcher,
  statusbar) and the XF86* multimedia keys as a hardware fallback.
- The stock `default.lua` stays untouched (defensive fallback if an ML4W
  update resets the selector; it is also curated to avoid duplicate binds).
- `setup-hyprland.sh` re-applies the selector + variant after ML4W updates.

If you add a keybinding, add it to the profile JSON and re-run the generator —
never to `dreamcoder.lua` unless it is a native-only bind.

### hyprctl dispatch is broken on Hyprland 0.55+ — native dispatchers used

Hyprland's Lua config parses `hyprctl dispatch <arg>` as Lua
(`hl.dispatch(<arg>)`), so legacy shell commands like
`hyprctl dispatch workspace 2` fail at runtime with a syntax error — the bind
appears registered but does nothing. `generate-custom-lua.sh` therefore
translates the following `hyprctl dispatch` commands in profiles to native
`hl.dsp.*` dispatchers:

| Shell command           | Native Lua dispatcher                                |
| ----------------------- | ---------------------------------------------------- |
| `hyprctl dispatch workspace N`     | `hl.dsp.focus({ workspace = N })`          |
| `hyprctl dispatch movetoworkspace N` | `hl.dsp.window.move({ workspace = N })`  |
| `hyprctl dispatch killactive`      | `hl.dsp.window.close()`                    |
| `hyprctl dispatch fullscreen 1`    | `hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })` |
| `hyprctl dispatch togglefloating`  | `hl.dsp.window.float({ action = "toggle" })` |
| `hyprctl dispatch togglesplit`     | `hl.dsp.layout("togglesplit")`             |
| `hyprctl dispatch movefocus <dir>` | `hl.dsp.focus({ direction = "<dir>" })`    |
| `hyprctl dispatch movewindow <dir>`| `hl.dsp.window.move({ direction = "<dir>" })` |

Any other command still falls back to `hl.dsp.exec_cmd(...)`.

### What setup-hyprland.sh does

1. **Symlinks** wlogout + swaync `colors.css` → waybar (single theme toggle point)
2. **Generates** `custom.lua` from JSON profile via `generate-custom-lua.sh`
3. **Installs** toggle script (`dreamcoder-toggle-theme.sh`) to `~/.config/hypr/scripts/`
4. **Applies** ML4W hooks (wallpaper, theme regeneration)
5. **Reloads** Hyprland

### Theme Toggle

| Shortcut            | Action                             |
| ------------------- | ---------------------------------- |
| `SUPER + SHIFT + D` | Toggle Dreamcoder light/dark theme |
| `SUPER + SHIFT + U` | Activate blue light filter (4000K) |
| `SUPER + SHIFT + I` | Deactivate blue light filter       |

### Testing

```bash
# Run all ML4W integration tests
bats tests/ml4w/*.bats

# Validate all profiles against schema
python3 scripts/validate-ml4w-profiles.py --ci

# Dry-run without system changes
./scripts/setup-hyprland.sh --profile default --dry-run
./scripts/generate-custom-lua.sh --profile default --dry-run
```

### File Layout

```
scripts/
├── generate-custom-lua.sh    # JSON → custom.lua generator with --validate
├── setup-hyprland.sh         # Idempotent orchestrator (symlinks + generation + hooks)
├── verify-ml4w-setup.sh      # Post-reboot health verification
└── validate-ml4w-profiles.py  # Schema + convention validation with --ci flag

ml4w_assets/
└── hypr/
    ├── custom.lua.tmpl        # Lua template for keybinding generation
    └── scripts/
        └── dreamcoder-toggle-theme.sh  # Theme toggle script

DreamcoderProfiles/dreamcoder/
├── profile.schema.json        # JSON Schema for machine profiles
├── default.json               # Default profile (theme toggle + blue light)
└── asus-vivobook15.json       # ASUS VivoBook 15 profile (all Fn keys)

tests/ml4w/
├── generate_custom_lua.bats   # 13 tests for the generator
├── setup_hyprland.bats        # 9 tests for the orchestrator
├── profile_validation.bats    # 11 tests for JSON profiles
└── setup.bash                 # BATS test helper
```

---

## ¿Por qué Dreamcoder?

| Feature               | Gentleman.Dots      | ML4W         | **dreamcoder-dots**            |
| --------------------- | ------------------- | ------------ | ------------------------------ |
| **Theme Engine**      | ❌ Catppuccin       | ✅ Matugen   | ✅ **Token-based + WCAG/APCA** |
| **Light/Dark/Dusk**   | ❌                  | ✅           | ✅ **+ Dusk transition**       |
| **AI Session Prompt** | ❌                  | ❌           | ✅ **Session-aware prompt**    |
| **Accesibilidad**     | ❌                  | ❌           | ✅ **WCAG 4.5:1 + APCA 75**    |
| **Neovim**            | ✅ 29 plugins       | ❌           | 🔶 Dreamcoder colorscheme      |
| **Hyprland**          | ❌                  | ✅ Completo  | 🔶 Color overlay               |
| **Shell Configs**     | ✅ Fish/Zsh/Nushell | ✅ Fish/Bash | 🔶 Aliases + functions         |
| **Ghostty Shaders**   | ✅ 45+ GLSL         | ❌           | 🔶 Usa los de Gentleman        |
| **Installer**         | ✅ Go TUI           | ✅ bash      | ✅ **Go TUI + Vim Trainer**    |
| **Prompt**            | ❌ Básico           | ❌ Básico    | ✅ **Starship 23 módulos**     |

> ✅ = lo tiene completo · 🔶 = dreamcoder aporta overlay · ❌ = no lo tiene

---

## Lo que dreamcoder NO reemplaza

Dreamcoder es una **capa visual**, no un reemplazo. Mantenés todo lo que ya te dan Gentleman y ML4W:

**De Gentleman.Dots se queda:**

- Neovim con 29 plugins (avante, copilot, blink, fzf-lua, oil, DAP...)
- Ghostty shaders (45+ GLSL effects)
- Tmux/Zellij con TPM y plugins
- Vim Mastery Trainer
- Fish/Zsh/Nushell base config

**De ML4W se queda:**

- Hyprland completo (animaciones, keybinds, monitores, layouts)
- Waybar, Rofi, Dunst configs
- GTK 3.0/4.0 settings
- Matugen color generation pipeline
- Btop, Chromium/Edge configs

**Dreamcoder aporta:**

- Tokens de color validados con WCAG 4.5:1 + APCA
- 3 modos: Anthracite Steel (dark), Cocoa/Lúcuma (light), Dusk (transición)
- Starship prompt con 23 módulos y AI session state
- 9 funciones shell (extract, sysupdate, killport, etc.)
- Aliases modernos con graceful fallback (eza, bat, fd, rg, zoxide)
- Auto-theme-switching por horario (systemd timer)
- Python library para generación de temas (PyPI)

---

## Uso

### CLI

```bash
dreamcoder dark         # → Anthracite Steel OLED
dreamcoder light        # → Dreamcoder Light
dreamcoder status       # → System status overview
dreamcoder doctor       # → Health check
```

### Theme Engine (Python)

```bash
pip install dreamcoder-theme
dreamcoder-theme sync   # Render all themes
dreamcoder-theme doctor # Check health
```

---

## Arquitectura

```mermaid
flowchart LR
    subgraph Tokens["Design Tokens"]
        PT["palette_tokens.py<br/>dark / light / dusk"]
    end
    subgraph Render["Renderers (28+ targets)"]
        R["renderers.py<br/>hub → leaf modules"]
    end
    subgraph Write["Writers"]
        W["writers.py<br/>write_if_changed()"]
    end
    subgraph Output["Theme Files"]
        O["Kitty, Ghostty, Nvim,<br/>Tmux, Starship, Hyprland,<br/>Codex, OpenCode, Pi, ..."]
    end
    Tokens --> Render --> Write --> Output
```

---

## Filosofía

Dreamcoder no es un rice neon. Es un banco de trabajo:

- **Salud primero**: sin blanco/negro puro, contraste fuerte, bajo brillo
- **Confort diario**: tipografía más grande, densidad de prompt calmada, modo día/noche automático
- **Identidad segundo**: calidez Cocoa/Lúcuma, cyan diagnóstico, colores editoriales

---

## Credits and upstream relationship

Dreamcoder Workbench builds on the upstream work of [Gentleman.Dots](https://github.com/Gentleman-Programming/Gentleman.Dots) and [ML4W](https://ml4w.com/). Their projects remain the source of the base environment; this repository contributes the Dreamcoder profiles, tokens, overlays, generators, and verification layer. See [docs/sources.md](docs/sources.md) for the repository-owned source manifest, pin mechanism, and ownership boundaries.

## Projecto

| Aspecto        | Detalle                            |
| -------------- | ---------------------------------- |
| **Estado**     | Active                             |
| **Versión**    | 1.0                                |
| **Licencia**   | MIT                                |
| **Docs**       | [docs/README.md](docs/README.md)   |
| **Contribuir** | [CONTRIBUTING.md](CONTRIBUTING.md) |

---

## SDD

Este proyecto usa Spec-Driven Development. Los planes están en [docs/superpowers/plans/](docs/superpowers/plans/).
