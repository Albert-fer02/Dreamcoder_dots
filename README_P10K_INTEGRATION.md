# 🎨 Powerlevel10k DreamCoder - Guía de Integración

## 📚 Archivos Disponibles

### Para Instalación Completa:
- **`p10k_dreamcoder_minimal.zsh`** - Configuración completa standalone
  - Reemplaza completamente tu `~/.p10k.zsh`
  - Ideal si empiezas desde cero

### Para Integración en Configuración Existente:
- **`p10k_dreamcoder_integration.zsh`** - Snippets de integración
  - Solo las personalizaciones DreamCoder
  - Mantiene tu configuración actual
  - Copia y pega solo lo que necesitas

### Documentación:
- **`INSTALL_P10K_DREAMCODER.md`** - Guía de instalación detallada
- **`docs/PROMPTS_UNIFIED_V3.md`** - Documentación completa
- **`PROMPTS_SUMMARY.md`** - Resumen rápido

## 🚀 Instalación Rápida (3 métodos)

### Método A: Reemplazo Completo
```bash
cp ~/Documents/PROYECTOS/Dreamcoder_dots/p10k_dreamcoder_minimal.zsh ~/.p10k.zsh
exec zsh
```

### Método B: Integración Manual
```bash
# 1. Abre tu ~/.p10k.zsh
nano ~/.p10k.zsh

# 2. Copia las secciones de:
cat ~/Documents/PROYECTOS/Dreamcoder_dots/p10k_dreamcoder_integration.zsh

# 3. Modifica solo:
#    - POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
#    - POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS
#    - Agrega función prompt_custom_dreamcoder()
#    - Ajusta colores POWERLEVEL9K_*_FOREGROUND/BACKGROUND

# 4. Aplica
exec zsh
```

### Método C: Asistente de P10k + Personalización
```bash
# 1. Ejecuta el asistente de Powerlevel10k
p10k configure

# 2. Después de configurar, agrega personalizaciones DreamCoder:
nano ~/.p10k.zsh

# 3. Agrega al final (antes de las funciones finales):
function prompt_custom_dreamcoder() {
  p10k segment -f 15 -b 24 -t '⬢ DreamCoder'
}

# 4. Busca POWERLEVEL9K_LEFT_PROMPT_ELEMENTS y agrega:
#    custom_dreamcoder

# 5. Aplica
exec zsh
```

## 🎨 Personalización Visual

### Elementos del Prompt

**Left Prompt:**
```
 ⬢ DreamCoder user  ~/directory  branch [+2]
```

**Right Prompt:**
```
✓  ⏱1s  󰥔 14:30
```

### Paleta de Colores (256-color)

| Elemento | Color | Código | Hex Aprox |
|----------|-------|--------|-----------|
| Directory FG | Light gray | 250 | #bcbcbc |
| Directory BG | Dark slate | 234 | #1c1c1c |
| Git Clean FG | Black | 0 | #000000 |
| Git Clean BG | Golden | 220 | #ffd787 |
| Git Dirty FG | White | 15 | #ffffff |
| Git Dirty BG | Terracotta | 203 | #ff5f5f |
| OS Icon | Cyan | 81 | #5fd7ff |
| Badge BG | Deep Blue | 24 | #005f87 |
| Badge FG | White | 15 | #ffffff |

## 🔧 Secciones Clave a Modificar

### 1. Estructura del Prompt
```zsh
# En ~/.p10k.zsh, busca y modifica:
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon
  custom_dreamcoder  # ← Agregar esta línea
  context
  dir
  vcs
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status
  command_execution_time
  background_jobs
  time
)
```

### 2. Custom Badge
```zsh
# Agregar al final del archivo (antes de funciones finales):
function prompt_custom_dreamcoder() {
  p10k segment -f 15 -b 24 -t '⬢ DreamCoder'
}
```

### 3. Colores
```zsh
# Directory
typeset -g POWERLEVEL9K_DIR_FOREGROUND=250
typeset -g POWERLEVEL9K_DIR_BACKGROUND=234

# Git
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=0
typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=220
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=15
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=203

# OS Icon
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=81
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=235
```

## 📖 Referencias

- **Powerlevel10k**: https://github.com/romkatv/powerlevel10k
- **Customización**: https://github.com/romkatv/powerlevel10k#customization
- **Nerd Fonts**: https://www.nerdfonts.com

## ⚡ Tips Rápidos

### Ver Variables Actuales
```zsh
# Ver todos los POWERLEVEL9K_* configurados
typeset -p | grep POWERLEVEL9K | head -20
```

### Test de Colores
```bash
# Ver paleta 256 colores
for i in {0..255}; do
  printf "\e[48;5;%sm%3d\e[0m " "$i" "$i"
  (( (i + 1) % 16 == 0 )) && printf "\n"
done
```

### Recargar sin Reiniciar
```zsh
source ~/.p10k.zsh
```

### Modo de Depuración
```zsh
# Ver qué elementos están activos
echo $POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
echo $POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS
```

---

## 🌌 "Code is poetry written in light and logic" - DreamCoder

**v3.0** - Compatible con Powerlevel10k standard
