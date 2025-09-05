# Dreamcoder Dotfiles

Configuraciones optimizadas para un entorno de desarrollo Linux moderno y productivo.

## Instalación

```bash
git clone https://github.com/tu-usuario/Dreamcoder_dots.git
cd Dreamcoder_dots
./dreamcoder-setup.sh
```

## Características

- **ZSH** con Oh-My-Zsh y plugins optimizados + integración FZF mejorada
- **Bash** configuración alternativa para compatibilidad
- **Kitty** terminal con temas personalizados
- **Starship** prompt moderno con configuraciones separadas
- **PowerLevel10k** tema premium personalizado (p10k_dreamcoder)
- **Fastfetch** información del sistema con imágenes
- **Nano** editor mejorado con syntax highlighting
- **Herramientas CLI** modernas (eza, bat, fzf, zoxide, dust, duf, procs, bottom)
- **Sistema de respaldos** automático con gestión completa
- **Instalación modular** por categorías con soporte multi-distro
- **Arquitectura modular** con sistema de módulos independientes

## Uso

### Modo Interactivo
```bash
./dreamcoder-setup.sh
```

### Línea de Comandos
```bash
./dreamcoder-setup.sh --install-all    # Instalar todo
./dreamcoder-setup.sh --update         # Actualizar sistema
./dreamcoder-setup.sh --info           # Ver estado
```

## Configuraciones

### Shell
- **ZSH** - Configuración optimizada para desarrollo con integración FZF
- **ZSH Root** - Configuración segura para administrador
- **Bash** - Configuración alternativa compatible

### Terminal
- **Kitty** - Terminal moderno con GPU
- **Fastfetch** - Información del sistema visual con imágenes

### Prompt
- **Starship** - Prompt moderno y rápido
- **PowerLevel10k** - Tema premium personalizado (p10k_dreamcoder)
- **Starship Root** - Prompt con advertencias de seguridad

### Editores
- **Nano** - Editor mejorado con syntax highlighting

### Herramientas por Categoría
- **Core**: git, curl, wget, build tools (soporte multi-distro)
- **CLI Modernas**: eza, bat, fd, ripgrep, fzf, zoxide, dust, duf, procs, bottom, hyperfine, tokei
- **Terminal**: kitty, fastfetch
- **Desarrollo**: Docker, Docker Compose, Python tools

## Estructura

```
Dreamcoder_dots/
├── dreamcoder-setup.sh    # Script principal
├── lib/                   # Módulos del sistema
│   ├── core.sh           # Sistema principal y logging
│   ├── distro.sh         # Detección de distribuciones
│   ├── backup.sh         # Sistema de respaldos
│   ├── config.sh         # Gestión de configuraciones
│   ├── tools.sh          # Instalación de herramientas
│   └── ui.sh             # Interfaz de usuario
├── config/                # Archivos de configuración
│   ├── configs.conf      # Definición de dotfiles
│   └── tools.conf        # Herramientas por categoría
├── zshrc/                 # Configuraciones ZSH
├── bashrc/                # Configuraciones Bash
├── kitty/                 # Configuraciones Kitty
├── fastfetch/             # Configuraciones Fastfetch
├── nano/                  # Configuraciones Nano
├── starship.toml          # Configuración Starship
└── p10k_dreamcoder.zsh    # Tema PowerLevel10k personalizado
```

## Dependencias

### Arch Linux
```bash
sudo pacman -S zsh git curl wget base-devel
```

### Debian/Ubuntu
```bash
sudo apt install zsh git curl wget build-essential
```

### Red Hat/Fedora
```bash
sudo dnf install zsh git curl wget gcc gcc-c++ make
```

### Alpine Linux
```bash
sudo apk add zsh git curl wget build-base
```

## Optimizaciones

- **Carga rápida**: 0.1 segundos
- **Lazy loading**: Herramientas se cargan solo cuando es necesario
- **Carga asíncrona**: Plugins pesados en background
- **Configuraciones optimizadas**: Sin duplicaciones
- **Sistema modular**: Módulos independientes para fácil mantenimiento
- **Soporte multi-distro**: Detección automática de distribución
- **Gestión de respaldos**: Sistema completo de backup y restauración

## Resolución de Problemas

### Terminal lenta
```bash
# Verificar tiempo de carga
zsh -c "time (source ~/.zshrc >/dev/null 2>&1)"

# Recargar configuración
source ~/.zshrc
```

### Herramientas no encontradas
```bash
# Recargar shell
source ~/.zshrc

# Verificar PATH
echo $PATH
```

### Restaurar configuración
```bash
./dreamcoder-setup.sh
# Seleccionar "Gestionar respaldos"
```

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

**¿Problemas o sugerencias?** 💬 Abre un [issue](https://github.com/tu-usuario/Dreamcoder_dots/issues)