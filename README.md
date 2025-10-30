# Dreamcoder Dotfiles

Configuraciones optimizadas para un entorno de desarrollo Linux moderno y productivo.

## Instalación

```bash
git clone https://github.com/Albert-fer02/Dreamcoder_dots.git
cd Dreamcoder_dots
./install.sh
```

## Características

- **🔧 Instalación Simplificada**: Script único y directo para Arch Linux
- **⚡ Configuración Rápida**: Sin complejidad innecesaria, solo lo esencial
- **🎨 Temas Modernos**: PowerLevel10k transparente con paleta vibrante
- **🛡️ Respaldos Automáticos**: Backup automático de configuraciones existentes
- **📦 Herramientas Esenciales**: Solo las herramientas realmente necesarias

### Configuraciones Incluidas
- **ZSH** con Oh-My-Zsh y plugins esenciales (autosuggestions, syntax-highlighting)
- **Bash** configuración alternativa para compatibilidad
- **Kitty** terminal con tema personalizado
- **Tmux** multiplexor con tema Tokyo Night y atajos optimizados
- **Starship** prompt moderno y rápido
- **PowerLevel10k** tema premium transparente con paleta vibrante
- **Fastfetch** información del sistema con imagen personalizada
- **Nano** editor con syntax highlighting mejorado

## Uso

### Instalación Completa (Recomendado)
```bash
./install.sh
```

### Opciones Disponibles
```bash
./install.sh                    # Instalación completa (por defecto)
./install.sh --skip-packages    # Solo configuraciones (sin sudo)
./install.sh update             # Actualizar desde GitHub
./install.sh help               # Mostrar ayuda
```

### Si no tienes permisos sudo
```bash
# Instala manualmente los paquetes:
sudo pacman -S --needed zsh git curl wget kitty fastfetch nano starship zsh-autosuggestions zsh-syntax-highlighting fzf bat eza fd ripgrep zoxide tmux github-cli jq stow pass btop

# Luego instala solo las configuraciones:
./install.sh --skip-packages
```

## Configuraciones

### Shell
- **ZSH** - Configuración optimizada para desarrollo con integración FZF
- **ZSH Root** - Configuración segura para administrador
- **Bash** - Configuración alternativa compatible

### Terminal
- **Kitty** - Terminal moderno con GPU
- **Tmux** - Multiplexor con tema Tokyo Night, prefijo Ctrl+a, y navegación optimizada
- **Fastfetch** - Información del sistema visual con imágenes

### Prompt
- **Starship** - Prompt moderno y rápido
- **PowerLevel10k Transparente** - Tema premium con diseño transparente ultra vibrante
  - 🌈 Paleta inspirada en Dracula + Material Design + Neon themes
  - 👤 Usuario en azul plata elegante (#87ceeb)
  - 💎 Background 100% transparente para integración perfecta
  - ⚡ Iconos modernos Nerd Font v3 (󰣇  󰉋 󰘬 etc.)
  - 🎯 Elementos contextuales inteligentes (Python, Node, Docker)
  - 🚀 Performance optimizado con instant prompt y transient
  - 📐 Two-line design con arrow contextual azul/rojo
- **Starship Root** - Prompt con advertencias de seguridad

### Editores
- **Nano** - Editor mejorado con syntax highlighting

### Paquetes Instalados
- **Esenciales**: zsh, git, curl, wget
- **Terminal**: kitty, fastfetch
- **Editor**: nano con syntax highlighting
- **Prompt**: starship
- **ZSH Plugins**: zsh-autosuggestions, zsh-syntax-highlighting
- **Navegación Moderna**: zoxide (navegación inteligente), fzf (fuzzy finder)
- **Búsqueda y Archivos**: ripgrep (búsqueda rápida), fd (find moderno)
- **Visualización**: bat (cat mejorado), eza (ls moderno)
- **Productividad**: tmux (multiplexor), github-cli (gestión GitHub), jq (procesador JSON)
- **Gestión**: stow (dotfiles manager), pass (gestor de contraseñas)
- **Monitoreo**: btop (monitor de sistema visual)

## Estructura del Proyecto

```
Dreamcoder_dots/
├── install.sh                 # Script de instalación simplificado
├── .p10k.zsh                  # Configuración base PowerLevel10k
├── p10k_dreamcoder.zsh        # Tema PowerLevel10k transparente vibrante
├── starship.toml              # Configuración Starship
├── Dreamcoder.jpg             # Imagen para fastfetch
├── zshrc/                     # Configuraciones ZSH
│   └── .zshrc
├── bashrc/                    # Configuraciones Bash
│   └── .bashrc
├── kitty/                     # Configuraciones Kitty
│   ├── kitty.conf
│   └── colors-dreamcoder.conf
├── tmux/                      # Configuraciones Tmux
│   └── .tmux.conf
├── fastfetch/                 # Configuraciones Fastfetch
└── nano/                      # Configuraciones Nano
    └── .nanorc
```

## Dependencias

### Arch Linux (Único sistema soportado)
```bash
sudo pacman -S zsh git curl wget kitty fastfetch nano starship zsh-autosuggestions zsh-syntax-highlighting fzf bat eza fd ripgrep zoxide tmux github-cli jq stow pass btop
```

## Herramientas CLI Modernas Incluidas

### 🧭 Navegación y Búsqueda
- **Zoxide** - Navegación inteligente por directorios (reemplazo de `cd`)
- **FZF** - Búsqueda difusa interactiva (Ctrl+T archivos, Ctrl+R historial)
- **Ripgrep (rg)** - Búsqueda ultrarrápida en archivos (mejor que grep)
- **fd** - Búsqueda de archivos moderna (reemplazo de `find`)

### 📊 Visualización
- **Bat** - `cat` con syntax highlighting y paginación
- **Eza** - `ls` moderno con iconos y colores
- **Btop** - Monitor de sistema visual e interactivo

### 🛠️ Productividad
- **Tmux** - Multiplexor de terminal con sesiones persistentes
- **GitHub CLI (gh)** - Gestión de GitHub desde terminal
- **JQ** - Procesador JSON para scripts y depuración

### 🔐 Gestión
- **GNU Stow** - Administrador de dotfiles con symlinks
- **Pass** - Gestor de contraseñas cifradas con GPG

## Optimizaciones

- **Instalación directa**: Sin abstracciones innecesarias
- **Enfoque Arch Linux**: Aprovecha pacman y AUR
- **Respaldos automáticos**: Backup con timestamp antes de cambios
- **Configuraciones limpias**: Sin duplicaciones ni complejidad
- **Prompt optimizado**: PowerLevel10k con instant prompt
- **Colores vibrantes**: Paleta transparente para máximo impacto visual
- **Herramientas modernas**: CLI tools configuradas y listas para usar

## PowerLevel10k Transparente - Características Técnicas

### 🎨 Diseño Visual
- **Background Transparente**: Se integra perfectamente con cualquier terminal/wallpaper
- **Paleta Ultra Vibrante**: Colores saturados inspirados en temas modernos
- **Separadores Minimalistas**: Espacios simples para máxima limpieza
- **Iconos Modernos**: Nerd Font v3 con iconos vectoriales profesionales

### ⚡ Performance Senior-Level
- **Instant Prompt**: Arranque ultrarrápido con verbose mode
- **Transient Prompt**: Historial limpio con `always` mode
- **Elementos Contextuales**: Solo aparecen cuando son relevantes
- **Git Optimizado**: Para repositorios grandes con límites configurados

### 🎯 Elementos del Prompt
```
󰣇 dreamcoder08 ~/Documentos/PROYECTOS ✨ main ❯
↑    ↑           ↑                    ↑   ↑   ↑
│    │           │                    │   │   └─ Arrow contextual
│    │           │                    │   └─────── Git branch
│    │           │                    └─────────── Git status
│    │           └──────────────────────────────── Directory path
│    └────────────────────────────────────────── Usuario (azul plata)
└─────────────────────────────────────────────── OS Icon (Arch)
```

### 🌈 Paleta de Colores
- **Azul Eléctrico**: `#79a7ff` - OS icon, Git untracked, Docker
- **Azul Plata**: `#87ceeb` - Nombre de usuario elegante
- **Verde Lima**: `#a3d977` - Git clean, Python, Node.js
- **Amarillo Dorado**: `#ffcb6b` - Git modified, Python env
- **Rojo Coral**: `#ff5f87` - Git conflicts, errores, root user
- **Púrpura Neón**: `#d197ff` - Execution time, home directory
- **Cyan Brillante**: `#7fdbff` - Git staged, home folder
- **Naranja Mandarina**: `#ffb86c` - Background jobs, sudo user

## Guía Rápida de Herramientas

### Tmux - Cheat Sheet
```bash
# Iniciar tmux
tmux

# Atajos principales (Prefijo: Ctrl+a)
Ctrl+a |        # Split vertical
Ctrl+a -        # Split horizontal
Alt+Arrows      # Navegar entre paneles (sin prefijo)
Shift+Arrows    # Navegar entre ventanas
Ctrl+Arrows     # Redimensionar paneles
Ctrl+a c        # Nueva ventana
Ctrl+a d        # Detach sesión
Ctrl+a z        # Zoom pane
Ctrl+a r        # Recargar configuración
Ctrl+a S        # Sincronizar paneles

# Gestión de sesiones
tmux ls                    # Listar sesiones
tmux attach -t nombre      # Reconectar a sesión
tmux new -s nombre         # Nueva sesión con nombre
tmux kill-session -t nombre # Eliminar sesión
```

### FZF - Búsqueda Interactiva
```bash
Ctrl+T          # Buscar archivos
Ctrl+R          # Buscar en historial
Ctrl+F          # Fuzzy cd
```

### Zoxide - Navegación Inteligente
```bash
cd directorio   # Navega y recuerda
z directorio    # Salta a directorio frecuente
z part          # Búsqueda difusa de directorios
```

### Ripgrep - Búsqueda Rápida
```bash
rg "patrón"                 # Buscar en archivos
rg "patrón" -t js           # Solo archivos .js
rg "patrón" --hidden        # Incluir archivos ocultos
```

### GitHub CLI
```bash
gh repo create              # Crear repositorio
gh pr create                # Crear pull request
gh issue list               # Listar issues
gh pr status                # Estado de PRs
```

### JQ - Procesador JSON
```bash
echo '{"name":"test"}' | jq '.name'     # Extraer campo
cat data.json | jq '.[] | .id'          # Procesar array
curl api.com/data | jq '.'              # Formatear JSON
```

## Resolución de Problemas

### Terminal lenta
```bash
# Verificar tiempo de carga
zsh -c "time (source ~/.zshrc >/dev/null 2>&1)"

# Recargar configuración
source ~/.zshrc

# Aplicar prompt transparente
source ~/Documentos/PROYECTOS/Dreamcoder_dots/p10k_dreamcoder.zsh
```

### Herramientas no encontradas
```bash
# Recargar shell
source ~/.zshrc

# Verificar PATH
echo $PATH
```

### Restaurar configuración
Los respaldos se crean automáticamente en `~/.config/dreamcoder-backup-TIMESTAMP/`

## Contribuciones

1. Fork el repositorio
2. Crea una rama: `git checkout -b mi-feature`
3. Commit: `git commit -am 'Add mi-feature'`
4. Push: `git push origin mi-feature`
5. Abre un Pull Request

## Licencia

MIT License - Ver [LICENSE](LICENSE) para más detalles.

---

**¿Te gusta el proyecto?** ⭐ ¡Dale una estrella!

**¿Problemas o sugerencias?** 💬 Abre un [issue](https://github.com/Albert-fer02/Dreamcoder_dots/issues)