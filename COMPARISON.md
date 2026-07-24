# Dreamcoder OS — Comparison

> ¿Por qué necesitás Dreamcoder si ya tenés Gentleman.Dots + ML4W?
> Porque Dreamcoder es la capa que ninguno de los dos tiene: **salud visual, identidad, y AI integration**.

## Feature Comparison

| Feature               | Gentleman.Dots         | ML4W                | **dreamcoder-dots**            |
| --------------------- | ---------------------- | ------------------- | ------------------------------ |
| **Theme Engine**      | ❌ Catppuccin estático | ✅ Matugen dinámico | ✅ **Token-based + WCAG/APCA** |
| **Dark/Light/Dusk**   | ❌ Solo dark           | ✅ Light/Dark       | ✅ **+ Dusk transition mode**  |
| **Accesibilidad**     | ❌                     | ❌                  | ✅ **WCAG 4.5:1 + APCA 75**    |
| **AI Session Prompt** | ❌                     | ❌                  | ✅ **Bleeding edge en 2026**   |
| **Neovim Plugins**    | ✅ 29 (LazyVim)        | ❌                  | 🔶 Dreamcoder colorscheme      |
| **Hyprland Config**   | ❌                     | ✅ Completo         | 🔶 Color overlay               |
| **Shell Configs**     | ✅ Fish/Zsh/Nushell    | ✅ Fish/Bash        | 🔶 Aliases + 9 functions       |
| **Ghostty Shaders**   | ✅ 45+ GLSL            | ❌                  | 🔶 Usa los de Gentleman        |
| **Go TUI Installer**  | ✅ Bubbletea           | ✅ bash             | ✅ Bubbletea + Vim Trainer     |
| **Starship Prompt**   | ❌ Básico              | ❌ Básico           | ✅ **23 módulos + AI state**   |
| **Python Theme Lib**  | ❌                     | ❌                  | ✅ **Publicada en PyPI**       |
| **Homebrew Formula**  | ✅                     | ❌                  | ✅                             |
| **Vim Trainer**       | ✅ RPG-style           | ❌                  | ✅ RPG-style                   |
| **Auto Theme Switch** | ❌                     | ✅ Manual           | ✅ **Systemd timer**           |
| **CI/CD**             | ❌                     | ❌                  | ✅ GitHub Actions              |

> ✅ = lo provee · 🔶 = dreamcoder overlay · ❌ = no lo provee

---

## Lo que se queda de Gentleman.Dots

Después de instalar Dreamcoder, TODO lo de Gentleman sigue funcionando exactamente igual:

| Componente           | Qué se queda                      | Cómo lo usa Dreamcoder                              |
| -------------------- | --------------------------------- | --------------------------------------------------- |
| **Neovim**           | init.lua + 29 plugins             | Agrega `colorscheme dreamcoder` al init.lua         |
| **Ghostty shaders**  | 45+ GLSL                          | Usa `dreamcoder-cursor-pulse.glsl` por defecto      |
| **Tmux**             | `~/.tmux.conf` con TPM + kanagawa | `apply-theme-mode.sh` sobreescribe colores kanagawa |
| **Zellij**           | `config.kdl` con plugins          | Cambia `theme "dreamcoder-{mode}"`                  |
| **Fish/Zsh/Nushell** | Configs base                      | Agrega `conf.d/dreamcoder-*.fish`                   |
| **Vim Trainer**      | RPG completo                      | Sin cambios                                         |
| **Starship**         | Config base (si existe)           | Reemplaza con 23 módulos                            |

## Lo que se queda de ML4W

| Componente      | Qué se queda                           | Cómo lo usa Dreamcoder                            |
| --------------- | -------------------------------------- | ------------------------------------------------- |
| **Hyprland**    | hyprland.conf + animaciones + keybinds | Agrega `colors.{conf,lua}` con variables de color |
| **Waybar**      | `config.jsonc` + `style.css`           | Genera `colors.css` con `@import`                 |
| **Rofi**        | `config.rasi`                          | Genera `colors.rasi` con `@import`                |
| **Dunst**       | `dunstrc`                              | Genera `dreamcoder-dunst.conf` con `[include]`    |
| **GTK 3.0/4.0** | `settings.ini`                         | Switchea `prefer-dark-theme` en runtime           |
| **Btop**        | `btop.conf`                            | Agrega `dreamcoder.theme`                         |
| **Matugen**     | Pipeline de colores                    | Dreamcoder corre matugen en cada mode switch      |

---

## Lo que Dreamcoder AGREGA

### Token Engine with WCAG/APCA

```json
{
  "guardrails": {
    "minimum_text_contrast": 4.5,
    "minimum_apca_body": 75,
    "avoid_pure_black_white": true
  }
}
```

Ningún otro dotfiles hace esto. Cada color está validado contra WCAG 4.5:1 y APCA.

### 3 Modos de Color

| Modo     | Nombre          | BG        | Accent    | Uso         |
| -------- | --------------- | --------- | --------- | ----------- |
| 🌙 Dark  | Anthracite Steel OLED | `#100f0d` | `#d99555` | 18:00-07:00 |
| ☀️ Light | Cocoa/Lúcuma    | `#f3eadc` | `#824f16` | 07:00-16:00 |
| 🌆 Dusk  | Transición      | `#ebe4d6` | `#8a5520` | 16:00-18:00 |

### AI Session State en el Prompt

Cuando Claude Code o OpenCode están activos, el prompt muestra:

```
⎔ claude-4 42K
```

(solo visible cuando hay una sesión activa)

### 9 Shell Functions

| Función      | Para qué                          |
| ------------ | --------------------------------- |
| `extract`    | Descomprime CUALQUIER formato     |
| `sysupdate`  | Actualiza pacman + brew + flatpak |
| `ports`      | Muestra puertos en escucha        |
| `killport`   | Mata proceso en un puerto         |
| `dots`       | Cd al repo dreamcoder             |
| `cheat`      | TLDR para help rápido             |
| `http`       | HTTPie wrapper                    |
| `logs`       | Journalctl wrapper                |
| `tm-session` | Tmux session picker               |

### Modern CLI Aliases

```bash
alias ll='eza -la --icons'     # mejor ls
alias cat='bat --paging=never' # mejor cat
alias find='fd'                # mejor find
alias grep='rg'                # mejor grep
alias cd='z'                   # zoxide smart cd
alias ps='procs'               # mejor ps
alias top='btm'                # mejor htop
alias du='dua'                 # mejor du
alias df='duf'                 # mejor df
alias sed='sd'                 # mejor sed
alias help='tldr'              # mejor man
```

Todos con graceful fallback si la herramienta no está instalada.

---

## Resumen Visual

```
Sin Dreamcoder:
┌─────────────────────────────────────────────┐
│  Gentleman.Dots: Catppuccin                │
│  ML4W: Matugen colors                      │
│  Sin WCAG, sin AI prompt, sin dusk mode    │
└─────────────────────────────────────────────┘

Con Dreamcoder:
┌─────────────────────────────────────────────┐
│  Gentleman.Dots: Neovim, shaders, tmux     │
│  ML4W: Hyprland, waybar, rofi, dunst       │
│  Dreamcoder: tokens WCAG/APCA + AI prompt  │
└─────────────────────────────────────────────┘
```
