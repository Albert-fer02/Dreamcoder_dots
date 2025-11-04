# 🎨 DreamCoder Prompts v3.0 - UNIFIED

## 📋 Resumen de Configuración

**Versión**: 3.0 - Unified
**Fecha**: 2025-11-03
**Estado**: ✅ COMPLETADO

Se han unificado las configuraciones de prompts en una sola fuente de verdad:

### 🌟 Configuraciones Principales

| Shell | Prompt | Archivo | Paleta |
|-------|--------|---------|--------|
| **ZSH** | Powerlevel10k | `~/.p10k.zsh` | DreamCoder Minimal |
| **BASH** | Starship | `~/.config/starship.toml` | DreamCoder Verse |

---

## 🎯 Powerlevel10k (ZSH)

### Ubicación
- **Configuración**: `~/.p10k.zsh`
- **Backup original**: `p10k_backup_original.zsh`
- **Alternativa**: `~/.p10k_dreamcoder.zsh` (tema anterior)

### Características

```zsh
# Minimal & Cinematic Design
✨ Left Prompt:
  • OS Icon ()
  • DreamCoder Badge (⬢ DreamCoder)
  • User (username@host)
  • Directory (󰉋 with smart truncation)
  • Git Status ( + changes)

🎬 Right Prompt:
  • Status (✓ / ✗)
  • Execution Time (⏱ Xs)
  • Background Jobs ()
  • Clock (󰥔 HH:MM)
```

### Paleta de Colores

```conf
# Based on DreamCoder Kitty colors
DIR:        #bcbcbc (250) on #1c1c1c (234)  # Light gray on dark
VCS_CLEAN:  #000000 (0)   on #ffd787 (220)  # Black on golden
VCS_DIRTY:  #ffffff (15)  on #ff5f5f (203)  # White on terracotta
TIME:       #bcbcbc (250) on #1c1c1c (234)  # Light gray
OS_ICON:    #5fd7ff (81)  on #262626 (235)  # Cyan
BADGE:      #ffffff (15)  on #005f87 (24)   # White on deep blue
```

### Aplicar Configuración

```bash
# Método 1: Reiniciar ZSH
exec zsh

# Método 2: Recargar configuración
source ~/.p10k.zsh

# Método 3: Automático al abrir terminal nueva
# (ya está configurado en ~/.zshrc)
```

---

## 🚀 Starship (BASH)

### Ubicación
- **Configuración**: `~/.config/starship.toml`
- **Backup Neon**: `starship-neon-backup.toml`
- **Alternativa antigua**: `starship-dreamcoder-verse.toml`

### Características

```toml
# Professional & Productive Design
📐 Single Line Format:
   OS  user  directory  git_branch  git_status
  nodejs  python  rust  golang  docker  k8s
   duration  jobs  status
  ❯

🎨 Colores DreamCoder Verse:
  • Cyan Selection (#83d3e3) - username, duration, character
  • Aqua Green (#7FB3A8) - git added, python, nodejs
  • Soft Terracotta (#D49A7A) - errors, rust
  • Golden Wheat (#E0C180) - git status, bun
  • Soft Blue (#7fb3d4) - os, docker
  • Gentle Lavender (#C5A5D4) - git branch, java
  • Cyan Water (#4da6b8) - directory, golang
```

### Paleta de Colores

```toml
# Soft Productive Aesthetic
CHARACTER:     #83d3e3  # Cyan claro
ERROR:         #D49A7A  # Terracota suave
OS:            #7fb3d4  # Azul suave
USERNAME:      #83d3e3  # Cyan claro
DIRECTORY:     #4da6b8  # Cyan agua
GIT_BRANCH:    #C5A5D4  # Lila suave
GIT_STATUS:    #E0C180  # Dorado trigo
GIT_ADDED:     #7FB3A8  # Verde-agua
GIT_DELETED:   #D49A7A  # Terracota
NODEJS:        #7FB3A8  # Verde-agua
PYTHON:        #7FB3A8  # Verde-agua
RUST:          #D49A7A  # Terracota
GOLANG:        #4da6b8  # Cyan
DOCKER:        #7fb3d4  # Azul suave
```

### Aplicar Configuración

```bash
# Ya está aplicado automáticamente
# El bashrc carga starship en cada sesión

# Para probar cambios:
exec bash
```

---

## 🎨 Requisitos del Sistema

### ✅ Verificación Completa

```bash
# 1. Shells
zsh --version      # ✅ v5.9
bash --version     # ✅ v5.3

# 2. Prompts
ls ~/.oh-my-zsh/custom/themes/powerlevel10k  # ✅ P10k instalado
starship --version                            # ✅ v1.23.0

# 3. Nerd Fonts
fc-list | grep -i "meslo"  # ✅ MesloLGS NF instalado
fc-list | grep -i "nerd"   # ✅ Múltiples Nerd Fonts

# 4. Terminal (Kitty)
cat ~/.config/kitty/kitty.conf | grep font_family
# ✅ font_family: MesloLGS NF
```

### 📦 Componentes Instalados

- [x] **ZSH** 5.9
- [x] **Bash** 5.3
- [x] **Powerlevel10k** (latest)
- [x] **Starship** 1.23.0
- [x] **MesloLGS Nerd Font** + variantes
- [x] **Kitty Terminal** con configuración DreamCoder
- [x] **Oh-My-Zsh** con plugins

---

## 🔄 Cambiar Entre Prompts

### ZSH (Powerlevel10k) → BASH (Starship)

```bash
exec bash
```

### BASH (Starship) → ZSH (Powerlevel10k)

```bash
exec zsh
```

### Configurar Shell por Defecto

```bash
# Ver shell actual
echo $SHELL

# Cambiar a ZSH permanentemente
chsh -s $(which zsh)

# Cambiar a BASH permanentemente
chsh -s $(which bash)
```

---

## 📁 Estructura de Archivos

```
Dreamcoder_dots/
├── starship.toml                   # ✅ Starship Verse (principal)
├── starship-neon-backup.toml       # 💾 Backup Neon Cyber
├── starship-dreamcoder-verse.toml  # 📜 Origen Verse
├── p10k_dreamcoder_minimal.zsh     # ✅ P10k Minimal (fuente)
├── p10k_dreamcoder.zsh             # 📜 P10k anterior
├── p10k_backup_original.zsh        # 💾 Backup original
├── bashrc/.bashrc                  # 🐚 Bash config
├── bash_profile/.bash_profile      # 🐚 Bash login
├── zshrc/.zshrc                    # 🐚 ZSH config
└── kitty/
    ├── kitty.conf                  # 🖥️ Terminal config
    └── colors-dreamcoder.conf      # 🎨 Color scheme
```

### Instalados en ~

```
~/.p10k.zsh                 → p10k_dreamcoder_minimal.zsh
~/.p10k_dreamcoder.zsh      → Tema anterior (disponible)
~/.config/starship.toml     → starship.toml (Verse)
~/.bashrc                   → bashrc/.bashrc
~/.bash_profile             → bash_profile/.bash_profile
~/.zshrc                    → zshrc/.zshrc
~/.config/kitty/kitty.conf  → kitty/kitty.conf
```

---

## 🛠️ Scripts de Utilidad

### Test de Colores P10k

```bash
./test_p10k_colors.sh
```

### Verificación de Bash

```bash
./verify_bash.sh
```

### Verificación de Enlaces

```bash
./check_links.sh
```

---

## 🎯 Comandos Rápidos

### Limpiar Cache de Fastfetch

```bash
ffresh   # Alias creado en bashrc
# O manualmente:
rm -rf ~/.cache/fastfetch && fastfetch --logo-recache true
```

### Recargar Prompts

```bash
# ZSH
source ~/.zshrc

# BASH
source ~/.bashrc

# O simplemente
exec zsh   # Reiniciar ZSH
exec bash  # Reiniciar BASH
```

### Probar Glyphs de Nerd Font

```bash
# En cualquier shell
echo " "  # Git branch
echo "󰉋 "  # Folder
echo "⬢ "  # Hex badge
echo "❯ "  # Prompt
echo " "  # OS
```

---

## 📊 Comparación de Diseños

### Powerlevel10k (ZSH)

**Pros:**
- ✅ Altamente personalizable
- ✅ Muy rápido (instant prompt)
- ✅ Transient prompt (historial limpio)
- ✅ Right prompt con info adicional
- ✅ Iconos grandes y visibles

**Cons:**
- ❌ Solo para ZSH
- ❌ Configuración más compleja

### Starship (BASH)

**Pros:**
- ✅ Cross-shell (bash, zsh, fish, etc.)
- ✅ Configuración simple (TOML)
- ✅ Single line (más espacio)
- ✅ Paleta profesional y suave
- ✅ Performance optimizado

**Cons:**
- ❌ Menos opciones que P10k
- ❌ No tiene transient prompt

---

## 🎨 Personalización

### Modificar Colores P10k

Edita `~/.p10k.zsh`:

```zsh
# Cambiar color de directorio
typeset -g POWERLEVEL9K_DIR_FOREGROUND=250
typeset -g POWERLEVEL9K_DIR_BACKGROUND=234

# Cambiar color de git
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=0
typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=220
```

### Modificar Colores Starship

Edita `~/.config/starship.toml`:

```toml
[character]
success_symbol = "[❯](bold #83d3e3)"  # Cambiar cyan
error_symbol = "[❯](bold #D49A7A)"    # Cambiar terracota

[directory]
style = "bold #4da6b8"  # Cambiar cyan agua
```

---

## 📚 Referencias

- **Powerlevel10k**: https://github.com/romkatv/powerlevel10k
- **Starship**: https://starship.rs
- **Nerd Fonts**: https://www.nerdfonts.com
- **DreamCoder Kitty**: [kitty/colors-dreamcoder.conf](../kitty/colors-dreamcoder.conf)

---

## ✨ Changelog

### v3.0 (2025-11-03)
- ✅ Unificado P10k minimal como configuración principal ZSH
- ✅ Unificado Starship Verse como configuración principal BASH
- ✅ Creado bash_profile para shells de login
- ✅ Corregido TERM en bashrc para starship
- ✅ Agregado alias `ffresh` para cache de fastfetch
- ✅ Documentación completa de ambos prompts

### v2.0 (Anterior)
- Starship Neon Cyber aesthetic
- Powerlevel10k DreamCoder theme

---

**🌌 "Code is poetry written in light and logic" - DreamCoder**
