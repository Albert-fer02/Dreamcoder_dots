# Dreamcoder OS

> Visual layer premium para **Gentleman.Dots + ML4W**.
> Café/Lúcuma. Ember Noir. Contraste saludable. Identidad.

[![CI](https://github.com/Gentleman-Programming/dreamcoder-dots/actions/workflows/theme-validation.yml/badge.svg)](https://github.com/Gentleman-Programming/dreamcoder-dots/actions/workflows/theme-validation.yml)
[![WCAG 4.5:1](https://img.shields.io/badge/WCAG-4.5%3A1-brightgreen)]()
[![APCA](https://img.shields.io/badge/APCA-75-brightgreen)]()
[![PyPI](https://img.shields.io/pypi/v/dreamcoder-theme)](https://pypi.org/project/dreamcoder-theme/)
[![License](https://img.shields.io/pypi/l/dreamcoder-theme)](./LICENSE)

---

## Quick Start — 3-Step Install

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

## ¿Por qué Dreamcoder?

| Feature               | Gentleman.Dots      | ML4W         | **dreamcoder-dots**            |
| --------------------- | ------------------- | ------------ | ------------------------------ |
| **Theme Engine**      | ❌ Catppuccin       | ✅ Matugen   | ✅ **Token-based + WCAG/APCA** |
| **Light/Dark/Dusk**   | ❌                  | ✅           | ✅ **+ Dusk transition**       |
| **AI Session Prompt** | ❌                  | ❌           | ✅ **Bleeding edge**           |
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
- 3 modos: Ember Noir (dark), Cocoa/Lúcuma (light), Dusk (transición)
- Starship prompt con 23 módulos y AI session state
- 9 funciones shell (extract, sysupdate, killport, etc.)
- Aliases modernos con graceful fallback (eza, bat, fd, rg, zoxide)
- Auto-theme-switching por horario (systemd timer)
- Python library para generación de temas (PyPI)

---

## Uso

### CLI

```bash
dreamcoder dark         # → Ember Noir OLED
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
