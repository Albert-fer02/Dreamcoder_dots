# 🌌 Starship Themes - DreamCoder Collection

Esta guía presenta los temas de Starship disponibles para Dreamcoder Dotfiles, con diferentes estéticas cinematográficas.

---

## 🎨 Temas Disponibles

### 1. 🌌 **DreamCoder Verse** (NUEVO - Recomendado)
**Archivo:** `starship-dreamcoder-verse.toml`

**Estética:** Cinematic Tech-Noir × Quantum Minimalism × Cyber-Monolith

**Descripción:**
Prompt cinematográfico inspirado en Blade Runner, con elementos de arquitectura paramétrica (Zaha Hadid) y estética cuántica. Combina oscuridad profunda con neones vibrantes y geometría holográfica.

**Paleta de Colores:**
```
🔵 Quantum Cyan:    #00D9FF, #4FD1C5  (acentos primarios)
🟣 Plasma Purple:   #7C3AED, #A78BFA  (git, packages)
🟡 Quantum Gold:    #FFD700           (warnings, bun)
🔴 Neon Pink:       #FF0080           (errors, danger)
🟢 Matrix Green:    #48BB78           (success, node)
⚪ Liquid Silver:   #A0D9E8, #A0AEC0  (text, duration)
⚫ Dark Monolith:   #2D3748           (structure)
```

**Símbolos Signature:**
```
◢ ◣ ◤ ◥  → Quantum arrows (cursores direccionales)
▸ ◊ ◈    → Holographic separators (separadores de profundidad)
╭─ ╰─    → Monolith structure (altar de terminal)
⚡ 󰆓 ~ + → Energy field indicators
```

**Preview:**
```
╭─ 󰣇 ▸dreamcoder08◊~/Documents/Projects◈ main[+2]◊ 󱑍 2s
╰─◢
```

**Características:**
- ✨ Layout de dos líneas (cinematic depth)
- 🎭 Separadores holográficos únicos
- 🌈 Neones vibrantes sobre fondo oscuro
- ⚡ Optimizado para performance (< 30ms)
- 🎬 Simbología inspirada en sci-fi
- 🧠 Indicadores de "AI consciousness"

**Instalación:**
```bash
cp starship-dreamcoder-verse.toml ~/.config/starship.toml
source ~/.zshrc
```

---

### 2. ⚡ **Elite** (Actual - Productividad)
**Archivo:** `starship.toml`

**Estética:** Professional × Performance × Information-Dense

**Descripción:**
Prompt profesional enfocado en máxima productividad. Información densa pero organizada, con colores sutiles y símbolos claros.

**Paleta de Colores:**
```
🔵 Blue:    #50C7E3, #6A9BD1  (primary, directories)
🟢 Green:   N/A                (success implicit)
🟡 Yellow:  #FFD93D            (git status, python)
🔴 Red:     #FF6B6B            (errors, rust)
⚪ Cyan:    #A8DADC            (username, terraform)
```

**Preview:**
```
󰣇 dreamcoder08 ~/Documents/Projects  main[✓]  16.8.1 ⏱ 1s
❯
```

**Características:**
- 📊 Single line (espacio máximo)
- 🎯 Información técnica completa
- ⚙️ Métricas de git detalladas
- 🚀 Detección de múltiples runtimes
- 📦 Version numbers visibles

---

## 🎭 Comparación de Temas

| Feature | DreamCoder Verse | Elite |
|---------|------------------|-------|
| **Líneas** | 2 (cinematic) | 1 (compact) |
| **Estética** | Tech-Noir futurista | Profesional clean |
| **Separadores** | Holográficos (◊▸◈) | Espacios simples |
| **Colores** | Neones vibrantes | Sutiles pasteles |
| **Performance** | Optimizado | Optimizado |
| **Info Density** | Media (visual) | Alta (text) |
| **Target** | Creativo, cinematográfico | Productividad, desarrollo |

---

## 🎨 Filosofías de Diseño

### DreamCoder Verse
```
"El terminal como un altar de código —
 masivo, oscuro, con grabados luminosos.
 Cada comando es un ritual,
 cada prompt un portal cuántico."
```

**Inspiraciones:**
- 🎬 Blade Runner (tech-noir atmosphere)
- 🏛️ Zaha Hadid (parametric architecture)
- ⚛️ Quantum computing (particle aesthetics)
- 🌌 Sci-fi cinema (volumetric lighting)

### Elite
```
"Información primero, estética segundo.
 Todo a la vista, nada que ocultar.
 Métricas precisas para decisiones rápidas."
```

**Inspiraciones:**
- 💼 IDE profesionales (VSCode, JetBrains)
- 📊 Dashboards de monitoring
- ⚡ Terminal efficiency (Oh-My-Zsh, Spaceship)

---

## 🔧 Customización Avanzada

### Activar módulos opcionales en DreamCoder Verse

**1. Time Display (coordenadas temporales):**
```toml
[time]
disabled = false  # Cambiar a false
format = '[󰥔 $time](bold dimmed #718096)'
time_format = "%H:%M"
```

**2. Battery (energy core):**
```toml
[battery]
disabled = false  # Cambiar a false en laptops
```

**3. Memory Usage (neural load):**
```toml
[memory_usage]
disabled = false  # Para monitoreo de sistema
threshold = 75
```

**4. AI Mode Indicator:**
```toml
[custom.ai_mode]
disabled = false  # Si usas Cursor, Claude Code, etc.
```

### Crear variante monocromática

Para un look más minimalista, cambiar todos los colores a escala de grises:

```toml
# Reemplazar en starship-dreamcoder-verse.toml:
#00D9FF → #FFFFFF  (white)
#7C3AED → #A0AEC0  (gray-400)
#FFD700 → #CBD5E0  (gray-300)
#FF0080 → #FC8181  (soft red solo para errores)
```

---

## 📸 Screenshots Conceptuales

### DreamCoder Verse en acción:

```
╭─ 󰣇 ▸dreamcoder08◊~/proj/api-server◈ develop[~3 +2 -1]▸ 18.2.0◊ 󱑍 3.2s
╰─◢ npm run dev

╭─ 󰣇 ▸dreamcoder08◊~/proj/rust-cli◈ main[✓]▸  1.75◊ 󱑍 1s
╰─◢ cargo build --release

╭─ 󰣇 ▸dreamcoder08◊~/proj/python-ml◈ feature/model[~5]▸  3.11(.venv)◊ 󱑍 500ms
╰─◢✗ pytest failed
```

### Elite en acción:

```
󰣇 dreamcoder08 ~/proj/api-server  develop[~3 +2 -1]  18.2.0 ⏱ 3s
❯ npm run dev

󰣇 dreamcoder08 ~/proj/rust-cli  main[✓]  1.75 ⏱ 1s
❯ cargo build --release

󰣇 dreamcoder08 ~/proj/python-ml  feature/model[~5]  3.11(.venv) ⏱ 500ms
❯ pytest
```

---

## 🎯 Cuándo usar cada tema

### Usa **DreamCoder Verse** si:
- ✅ Valoras la estética cinematográfica
- ✅ Trabajas en proyectos creativos/personales
- ✅ Quieres un terminal único e inspirador
- ✅ Te gusta el sci-fi y el tech-noir
- ✅ Haces streaming/presentaciones

### Usa **Elite** si:
- ✅ Prioridad absoluta en productividad
- ✅ Trabajas en entorno corporativo
- ✅ Necesitas máxima información visible
- ✅ Prefieres estética minimalista
- ✅ Tienes monitor pequeño (necesitas espacio)

---

## 🔄 Cambiar entre temas rápidamente

Crear aliases en tu `.zshrc`:

```bash
# Agregar al final de ~/.zshrc

# Switch to DreamCoder Verse theme
alias theme-verse='cp ~/Documents/PROYECTOS/Dreamcoder_dots/starship-dreamcoder-verse.toml ~/.config/starship.toml && echo "✨ DreamCoder Verse activado"'

# Switch to Elite theme
alias theme-elite='cp ~/Documents/PROYECTOS/Dreamcoder_dots/starship.toml ~/.config/starship.toml && echo "⚡ Elite activado"'

# Show current theme
alias theme-show='head -5 ~/.config/starship.toml | grep -E "(VERSE|ELITE)"'
```

**Uso:**
```bash
theme-verse   # Activar DreamCoder Verse
theme-elite   # Activar Elite
theme-show    # Ver tema actual
```

---

## 🎨 Galería de Variantes Futuras

### Planeadas para futuras versiones:

**1. Matrix Rain** - Verde monocromático estilo Matrix
**2. Synthwave Sunset** - Purples y pinks retro
**3. Arctic Minimalism** - Blancos y azules hielo
**4. Tokyo Neon** - Inspirado en cyberpunk japonés
**5. Monochrome Pro** - Blanco y negro absoluto

---

## 🛠️ Troubleshooting

### Los símbolos no se ven bien

**Problema:** Aparecen cuadrados □ o símbolos raros

**Solución:**
```bash
# Instalar Nerd Font
sudo pacman -S ttf-meslo-nerd-font-powerlevel10k

# O cualquier Nerd Font:
sudo pacman -S ttf-firacode-nerd ttf-jetbrains-mono-nerd
```

### Colores se ven mal

**Problema:** Los colores no coinciden con los ejemplos

**Solución:**
```bash
# 1. Verificar terminal con soporte true color
echo $COLORTERM  # Debe decir "truecolor" o "24bit"

# 2. Verificar que kitty use colores RGB
grep "term" ~/.config/kitty/kitty.conf
# Debe tener: term xterm-kitty

# 3. Recargar starship
source ~/.zshrc
```

### Prompt muy lento

**Problema:** El prompt tarda > 100ms en aparecer

**Solución:**
```bash
# 1. Verificar tiempo de carga
time starship prompt

# 2. Deshabilitar módulos pesados
# En starship.toml, agregar:
[git_status]
disabled = true  # Temporal para testing

# 3. Reducir timeout
command_timeout = 100  # En lugar de 500
```

---

## 📚 Referencias

- [Starship Documentation](https://starship.rs)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [Color Palette Generator](https://coolors.co)
- [Blade Runner Color Palette](https://www.color-hex.com/color-palette/1013636)

---

## 🎬 Créditos

**DreamCoder Verse Theme**
- Diseñado por: Albert Fernández (DreamCoder08)
- Inspirado en: Blade Runner, Ghost in the Shell, Zaha Hadid
- Paleta: Tech-Noir × Quantum × Cyberpunk fusion
- Versión: 1.0.0
- Fecha: 2025-10-29

---

**"En el código, encontramos el universo —
en el terminal, lo navegamos."** 🌌

