# 🚀 Dreamcoder Dotfiles

Una colección completa de configuraciones personalizadas para un entorno de desarrollo Linux optimizado y visualmente atractivo.

## 📋 Contenido

Este repositorio incluye configuraciones para:

- **🐚 ZSH & Bash** - Configuraciones de shell optimizadas
- **🖥️ Kitty** - Terminal moderno con temas personalizados
- **⚡ Fastfetch** - Información del sistema con imágenes personalizadas
- **✏️ Nano** - Editor de texto con sintaxis mejorada
- **🌟 Starship** - Prompt personalizado y moderno

## 🎯 Características

- ✅ **Instalación interactiva** con menú de selección
- 🔒 **Respaldos automáticos** con opción de restauración
- 🎨 **Temas personalizados** con esquema de colores Dreamcoder
- 📦 **Gestión de dependencias** integrada
- 🔧 **Configuraciones optimizadas** para desarrollo
- 🔄 **Sistema de actualización** unificado

## 🚀 Instalación Rápida

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/Dreamcoder_dots.git
cd Dreamcoder_dots

# Ejecutar setup interactivo (RECOMENDADO)
./dreamcoder-setup.sh

# O instalación completa automática
./dreamcoder-setup.sh --install-all
```

## 🎮 Modos de Uso

### 📋 **Modo Interactivo (Recomendado)**
```bash
./dreamcoder-setup.sh
```
- Menú visual con opciones claras
- Selección individual de configuraciones
- Instalación selectiva de herramientas
- Información del sistema en tiempo real

### ⚡ **Modo Línea de Comandos**
```bash
# Actualizar sistema
./dreamcoder-setup.sh --update

# Instalación completa automática
./dreamcoder-setup.sh --install-all

# Mostrar información del sistema
./dreamcoder-setup.sh --info

# Ver ayuda
./dreamcoder-setup.sh --help
```

## 🗂️ Estructura del Proyecto

```
Dreamcoder_dots/
├── dreamcoder-setup.sh       # 🚀 Script principal (punto de entrada)
├── lib/                      # 📚 Sistema modular
│   ├── core.sh              # 🔧 Funciones básicas y utilidades
│   ├── distro.sh            # 🐧 Detección de distribuciones Linux
│   ├── backup.sh            # 🔒 Sistema de respaldos avanzado
│   ├── config.sh            # 📁 Gestión de configuraciones
│   ├── tools.sh             # 🛠️ Instalación de herramientas
│   └── ui.sh                # 🎨 Interfaz de usuario y menús
├── config/                   # ⚙️ Archivos de configuración
│   ├── configs.conf         # 📋 Configuraciones disponibles
│   └── tools.conf           # 🔧 Herramientas por categoría
├── bashrc/                   # Configuración de Bash
├── fastfetch/                # Configuración de Fastfetch + imágenes (9)
├── kitty/                    # Configuración de Kitty + colores
├── nano/                     # Configuración de Nano
├── zshrc/                    # Configuración de ZSH
├── starship.toml             # Configuración de Starship
└── README.md                 # Documentación unificada
```

## 🎛️ Menú Interactivo Modular

### 1. 📦 **Gestionar Configuraciones**
- 📋 Ver configuraciones disponibles
- 🔧 Instalar configuraciones (selectivo)
- 📂 Instalar por categoría (shell, terminal, editor, etc.)
- 📊 Ver estado de configuraciones

### 2. 🛠️ **Gestionar Herramientas**
Categorías de herramientas disponibles:
- ☐ **Core**: Paquetes básicos (git, curl, wget, build tools)
- ☐ **Modern CLI**: Herramientas modernas (eza, bat, fzf, ripgrep, etc.)
- ☐ **Terminal**: Kitty terminal y Fastfetch
- ☐ **Starship**: Prompt personalizado
- ☐ **ZSH**: Oh-My-Zsh y plugins (syntax highlighting, auto-notify, etc.)
- ☐ **Node.js**: Bun, FNM (Fast Node Manager)

### 3. 🚀 **Instalación Completa**
Instala todas las configuraciones y herramientas automáticamente.

### 4. 🔄 **Actualizar Sistema**
- Actualiza paquetes del sistema por distribución
- Actualiza Oh-My-Zsh y plugins automáticamente  
- Actualiza Starship, Bun y herramientas específicas
- Mantiene configuraciones sincronizadas

### 5. 🔙 **Gestionar Respaldos**
- 📋 Ver respaldos disponibles con timestamps
- 🔙 Restaurar todos los respaldos
- 🎯 Restaurar respaldo específico
- 🧹 Limpiar respaldos antiguos
- ✅ Verificar integridad de respaldos

### 6. ℹ️ **Información del Sistema**
Dashboard completo con:
- 🐧 Distribución Linux detectada
- 🔧 Herramientas instaladas con versiones
- 📁 Estado de configuraciones existentes
- 💾 Información de respaldos

### 7. ⚙️ **Configuración Avanzada**
- 🔧 Configurar variables de entorno
- 📝 Editar configuraciones
- 🧹 Limpiar sistema
- 📊 Generar reportes detallados

## 📦 Dependencias

Las dependencias se instalan automáticamente según tu distribución:

### **Arch Linux**
```bash
sudo pacman -S zsh git curl wget base-devel
```

### **Debian/Ubuntu**
```bash
sudo apt install zsh git curl wget build-essential
```

### **Red Hat/Fedora**
```bash
sudo dnf install zsh git curl wget gcc gcc-c++
```

## 🔧 Características Avanzadas

### 🔒 **Sistema de Respaldos**
- Respaldo automático antes de cada instalación
- Timestamp único para cada respaldo
- Función de restauración integrada
- Log detallado de cambios

### 🎨 **Detección Inteligente**
- Detecta distribución Linux automáticamente
- Adapta comandos de instalación según el sistema
- Verifica herramientas existentes antes de instalar

### 📋 **Gestión Modular**
- Configuraciones organizadas en diccionario
- Instalación independiente de cada componente
- Fácil agregar nuevas configuraciones

## 📦 Paquetes Recomendados

### Core (requerido)
```bash
sudo pacman -S zsh git curl wget
```

### Oh-My-Zsh
```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Herramientas CLI modernas
```bash
# Arch Linux
sudo pacman -S eza bat fd ripgrep fzf zoxide dust duf procs bottom hyperfine tokei bandwhich

# Ubuntu/Debian  
sudo apt install exa bat-cat fd-find ripgrep fzf zoxide dust duf procs btm hyperfine tokei bandwhich
```

### Starship prompt
```bash
curl -sS https://starship.rs/install.sh | sh
```

### McFly history
```bash
curl -LSfs https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sh
```

### Node.js tools
```bash
# Bun
curl -fsSL https://bun.sh/install | bash

# FNM (Fast Node Manager)
curl -fsSL https://fnm.vercel.app/install | bash
```

### Plugins ZSH (auto con Oh-My-Zsh)
- git (built-in)
- vi-mode (built-in) 
- history-substring-search (built-in)
- zsh-completions (built-in)

### Plugins ZSH extra (manual)
```bash
# Fast syntax highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM/plugins/fast-syntax-highlighting

# You should use
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use

# Auto notify
git clone https://github.com/MichaelAquilina/zsh-auto-notify.git $ZSH_CUSTOM/plugins/auto-notify
```

### Herramientas de seguridad (opcional)
```bash
# Instalar Go primero
sudo pacman -S go  # o sudo apt install golang-go

# Luego instalar herramientas
go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest  
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/OJ/gobuster/v3@latest

# Agregar a PATH en .zshenv
export PATH="$HOME/go/bin:$PATH"
```

### Herramientas de desarrollo (opcional)
```bash
# Docker
sudo pacman -S docker docker-compose
sudo systemctl enable docker

# Python tools
sudo pacman -S python-pip
pip install --user httpx-cli

# Network tools
sudo pacman -S nmap masscan
```

## 🏗️ Arquitectura (Resumen)

El sistema sigue una arquitectura modular con responsabilidades bien definidas:

- core.sh: núcleo, logging, carga de módulos, prerrequisitos y manejo de errores.
- distro.sh: detección de distribución, instalación y actualización por distro.
- backup.sh: creación, restauración, limpieza e integridad de respaldos.
- config.sh: instalación de dotfiles, selección por categoría y post-instalación.
- tools.sh: instalación/actualización de herramientas, ecosistema ZSH y PATHs.
- ui.sh: menús, info del sistema, confirmaciones y opciones avanzadas.

Archivos de configuración:
- config/configs.conf: nombre=origen|destino|descripcion|categoria
- config/tools.conf: categorías por distro en formato INI simple.

Flujos de ejecución soportados: interactivo vía menú y por argumentos CLI.

Principios: separación de responsabilidades, modularidad, extensibilidad, robustez y usabilidad.

Ventajas: mantenibilidad, escalabilidad, testabilidad y reutilización.

## 📋 Changelog (Resumen)

### v2.0.0 - Sistema Unificado (2025-09-02)

- BREAKING: scripts antiguos reemplazados por sistema unificado.
- NEW: script principal `dreamcoder-setup.sh` con menú interactivo.
- NEW: respaldos automáticos con restauración e instalación selectiva.
- NEW: soporte multi-distribución mejorado y modo CLI.
- Técnicamente: arquitectura modular, logging mejorado y código más mantenible.
- Herramientas soportadas: core, modern CLI, terminal (kitty/fastfetch), shell (zsh + plugins), prompt (starship), Node (bun/fnm), desarrollo (opcional).

### v1.0.0 - Versión Inicial

- Scripts básicos de instalación y soporte limitado de distribuciones.

## 🛠️ Personalización

### **Agregar Nueva Configuración**
1. Crea directorio con tus archivos de configuración
2. Edita el array `CONFIGS` en `dreamcoder-setup.sh`:
```bash
["mi_config"]="mi_directorio/archivo|$HOME/.mi_config|Descripción"
```

### **Agregar Nueva Herramienta**
1. Agrega la lógica de instalación en la función `install_tools()`
2. Incluye la categoría en `select_tools()`

## 📋 Comandos Útiles

### **Verificar Instalación**
```bash
./dreamcoder-setup.sh --info
```

### **Solo Actualizar**
```bash
./dreamcoder-setup.sh --update
```

### **Reinstalar Configuración Específica**
Usa el modo interactivo y selecciona solo lo que necesitas.

## 🚨 Resolución de Problemas

### **Error: "Distribución no soportada"**
El script soporta Arch Linux, Debian/Ubuntu y Red Hat/Fedora. Para otras distribuciones, instala manualmente las dependencias.

### **Error de permisos**
```bash
chmod +x dreamcoder-setup.sh
```

### **Herramientas no encontradas después de instalación**
```bash
# Recargar configuración del shell
source ~/.zshrc  # o ~/.bashrc

# O reiniciar terminal
```

### **Restaurar configuración anterior**
```bash
./dreamcoder-setup.sh
# Selecciona "Restaurar respaldos" del menú
```

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! 

1. Fork el repositorio
2. Crea una rama para tu característica: `git checkout -b mi-feature`
3. Commit tus cambios: `git commit -am 'Add mi-feature'`
4. Push a la rama: `git push origin mi-feature`
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver [LICENSE](LICENSE) para más detalles.

## 🙏 Agradecimientos

- Configuraciones inspiradas en la comunidad de dotfiles
- [Oh-My-Zsh](https://ohmyz.sh/) y su ecosistema de plugins
- [Starship](https://starship.rs/) por el prompt moderno
- [Kitty](https://sw.kovidgoyal.net/kitty/) terminal
- Herramientas CLI modernas: [eza](https://github.com/eza-community/eza), [bat](https://github.com/sharkdp/bat), [fzf](https://github.com/junegunn/fzf)

---

**¿Te gusta el proyecto?** ⭐ ¡Dale una estrella!

**¿Tienes preguntas o sugerencias?** 💬 Abre un [issue](https://github.com/tu-usuario/Dreamcoder_dots/issues)

**Desarrollado con ❤️ por la comunidad**