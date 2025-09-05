# Dreamcoder Dotfiles

Configuraciones optimizadas para un entorno de desarrollo Linux moderno y productivo.

## Instalación

```bash
git clone https://github.com/tu-usuario/Dreamcoder_dots.git
cd Dreamcoder_dots
./dreamcoder-setup.sh
```

## Características

- **ZSH** con Oh-My-Zsh y plugins optimizados
- **Kitty** terminal con temas personalizados
- **Starship** prompt moderno
- **Fastfetch** información del sistema
- **Herramientas CLI** modernas (eza, bat, fzf, zoxide, mcfly)
- **Sistema de respaldos** automático
- **Instalación modular** por categorías

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
- **ZSH** - Configuración optimizada para desarrollo
- **ZSH Root** - Configuración segura para administrador

### Terminal
- **Kitty** - Terminal moderno con GPU
- **Fastfetch** - Información del sistema visual

### Prompt
- **Starship** - Prompt moderno y rápido
- **Starship Root** - Prompt con advertencias de seguridad

### Herramientas
- **Core**: git, curl, wget, build tools
- **CLI Modernas**: eza, bat, fd, ripgrep, fzf, zoxide, mcfly
- **Node.js**: Bun, FNM
- **Desarrollo**: Docker, Python tools

## Estructura

```
Dreamcoder_dots/
├── dreamcoder-setup.sh    # Script principal
├── lib/                   # Módulos del sistema
├── config/                # Archivos de configuración
├── zshrc/                 # Configuraciones ZSH
├── starship/              # Configuraciones Starship
├── kitty/                 # Configuraciones Kitty
└── fastfetch/             # Configuraciones Fastfetch
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
sudo dnf install zsh git curl wget gcc gcc-c++
```

## Optimizaciones

- **Carga rápida**: 0.1 segundos
- **Lazy loading**: Herramientas se cargan solo cuando es necesario
- **Carga asíncrona**: Plugins pesados en background
- **Configuraciones optimizadas**: Sin duplicaciones

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