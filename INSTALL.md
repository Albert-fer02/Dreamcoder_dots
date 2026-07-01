# Dreamcoder OS — Installation Guide

> Instalación completa en 3 pasos: Gentleman.Dots → ML4W → Dreamcoder.

## Prerequisitos

- **Arch Linux** (o derivado)
- `git`, `stow`, `python3` instalados
- Conexión a internet

---

## Paso 1: Gentleman.Dots

Gentleman.Dots provee la base para Neovim, shells, terminales, y multiplexers.

### Opción A: Homebrew (recomendado)

```bash
brew install Gentleman-Programming/tap/gentleman-dots
gentleman-dots
```

### Opción B: Descarga directa

```bash
curl -fsSL https://github.com/Gentleman-Programming/Gentleman.Dots/releases/latest/download/gentleman-installer-linux-amd64 -o gentleman.dots
chmod +x gentleman.dots
./gentleman.dots
```

### Opción C: Manual

```bash
git clone https://github.com/Gentleman-Programming/Gentleman.Dots.git
cd Gentleman.Dots
./install.sh
```

Seguí el installer TUI para seleccionar:

- Shell: Fish (recomendado), Zsh, o Nushell
- Terminal: Ghostty (recomendado) o Kitty
- Multiplexer: Tmux o Zellij
- Editor: Neovim

> Más info: [Gentleman.Dots](https://github.com/Gentleman-Programming/Gentleman.Dots)

---

## Paso 2: ML4W OS

ML4W provee la base completa de escritorio Hyprland.

```bash
bash <(curl -s https://ml4w.com/os/stable)
```

Esto instala:

- **Hyprland**: animaciones, keybinds, monitores, layouts, ventanas, workspaces
- **Waybar**: barra de estado con módulos
- **Rofi**: lanzador de apps
- **Dunst**: notificaciones
- **GTK 3.0/4.0**: tema y config
- **Btop**: monitor de sistema
- **Matugen**: generación dinámica de colores

> Más info: [ML4W OS](https://ml4w.com/os/)

---

## Paso 3: Dreamcoder

Dreamcoder aplica su capa visual sobre Gentleman + ML4W.

### Clonar

```bash
git clone git@github.com:Dreamcoder08/Dreamcoder_dots.git ~/Documents/PROYECTOS/dreamcoder-dots
cd ~/Documents/PROYECTOS/dreamcoder-dots
```

### Instalar

```bash
./scripts/dreamcoder install
```

Esto:

1. Crea backups de configs existentes
2. Stowea los módulos (Shell, Kitty, Ghostty, Fastfetch, Warp, Bat, Systemd)
3. Instala los hooks de tema para cada app
4. Activa el timer systemd para auto-theme-switching
5. Corre el primer sync de temas

### Verificar

```bash
./scripts/dreamcoder doctor     # Health check completo
./scripts/dreamcoder status      # System status
```

---

## Post-Instalación

### Tmux

Si usás Tmux con TPM:

```bash
tmux
prefix + I   # Instalar plugins
```

### Neovim

Abrí Neovim. LazyVim instala los plugins automáticamente:

```bash
nvim
:Lazy sync
```

### Auto Theme Switching

El timer systemd se activa automáticamente. Para verificar:

```bash
systemctl --user status dreamcoder-theme-auto.timer
```

El timer cambia entre modos según el horario:

- **07:00-16:00** → Light
- **16:00-18:00** → Dusk
- **18:00-07:00** → Dark

---

## Troubleshooting

### "Theme files not found"

Asegurate de haber instalado Gentleman.Dots y ML4W primero. Dreamcoder es un overlay, no un reemplazo.

### "Error: stow not found"

```bash
sudo pacman -S stow
```

### "Colors not updating"

```bash
dreamcoder dark    # Force dark mode
dreamcoder light   # Force light mode
```

### "Neovim colorscheme not loading"

Agregá esto a `~/.config/nvim/init.lua`:

```lua
vim.cmd.colorscheme("dreamcoder")
```

---

## Referencias

- [Gentleman.Dots](https://github.com/Gentleman-Programming/Gentleman.Dots)
- [ML4W OS](https://ml4w.com/os/)
- [Dreamcoder SDD Plans](docs/superpowers/plans/)
- [Architecture Docs](docs/architecture/)
