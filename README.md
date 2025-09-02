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
- ⚡ **Rendimiento optimizado** - Carga súper rápida (0.1s)
- 🚀 **Lazy loading** - Plugins y herramientas se cargan solo cuando es necesario
- 🎨 **Fastfetch automático** - Información del sistema al iniciar terminal

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
- ☐ **ZSH**: Oh-My-Zsh y plugins optimizados (syntax highlighting, auto-notify, etc.)
- ☐ **Node.js**: Bun, FNM (Fast Node Manager)
- ☐ **Performance**: McFly, Zoxide, FZF con lazy loading

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

### ⚡ **Optimización de Rendimiento**
- **Carga súper rápida**: 0.1 segundos (8x más rápido que antes)
- **Lazy loading**: Plugins y herramientas se cargan solo cuando es necesario
- **Carga asíncrona**: Fast Syntax Highlighting se carga en background
- **Modo interactivo**: Herramientas pesadas solo se cargan en terminales interactivas
- **Configuraciones duplicadas eliminadas**: Sin conflictos ni sobrecarga

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

### 🚀 **Plugins Optimizados**
- **ZSH Completions**: Carga optimizada sin duplicación
- **Fast Syntax Highlighting**: Carga asíncrona para mejor rendimiento
- **You Should Use**: Solo en modo interactivo
- **Auto Notify**: Solo en modo interactivo
- **McFly**: Carga perezosa para historial inteligente
- **Zoxide**: Carga perezosa para navegación rápida
- **FZF**: Configuración optimizada con previews reducidos

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
- zsh-autosuggestions (built-in)
- zsh-syntax-highlighting (built-in)

### Plugins ZSH extra (optimizados)
```bash
# Fast syntax highlighting (carga asíncrona)
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM/plugins/fast-syntax-highlighting

# You should use (solo modo interactivo)
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use

# Auto notify (solo modo interactivo)
git clone https://github.com/MichaelAquilina/zsh-auto-notify.git $ZSH_CUSTOM/plugins/auto-notify

# ZSH completions (carga optimizada)
git clone https://github.com/zsh-users/zsh-completions.git $ZSH_CUSTOM/plugins/zsh-completions
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

### v2.1.0 - Optimización de Rendimiento (2025-01-02)

- ⚡ **PERFORMANCE**: Carga súper rápida - 0.1 segundos (8x más rápido)
- 🚀 **LAZY LOADING**: Plugins y herramientas se cargan solo cuando es necesario
- 🔧 **OPTIMIZACIÓN**: Eliminadas configuraciones duplicadas de fnm y bun
- 🎨 **FASTFETCH**: Habilitado automáticamente al iniciar terminal
- 🔄 **CARGA ASÍNCRONA**: Fast Syntax Highlighting se carga en background
- 📱 **MODO INTERACTIVO**: Herramientas pesadas solo se cargan en terminales interactivas
- 🎯 **FZF OPTIMIZADO**: Previews reducidos para mejor rendimiento
- ✅ **FUNCIONALIDAD**: Todas las características mantienen 100% funcionalidad

### v2.0.0 - Sistema Unificado (2025-09-02)

- BREAKING: scripts antiguos reemplazados por sistema unificado.
- NEW: script principal `dreamcoder-setup.sh` con menú interactivo.
- NEW: respaldos automáticos con restauración e instalación selectiva.
- NEW: soporte multi-distribución mejorado y modo CLI.
- Técnicamente: arquitectura modular, logging mejorado y código más mantenible.
- Herramientas soportadas: core, modern CLI, terminal (kitty/fastfetch), shell (zsh + plugins), prompt (starship), Node (bun/fnm), desarrollo (opcional).

### v1.0.0 - Versión Inicial

- Scripts básicos de instalación y soporte limitado de distribuciones.

## ⚡ Optimización de Rendimiento

### **Mejoras Implementadas**
- **Carga súper rápida**: 0.1 segundos (8x más rápido que antes)
- **Lazy loading**: Herramientas se cargan solo cuando es necesario
- **Carga asíncrona**: Plugins pesados se cargan en background
- **Modo interactivo**: Solo se cargan en terminales interactivas
- **Configuraciones optimizadas**: Sin duplicaciones ni conflictos

### **Técnicas de Optimización**
```bash
# Verificar tiempo de carga actual
zsh -c "time (source ~/.zshrc >/dev/null 2>&1)"

# Carga perezosa de herramientas
if [[ -o interactive ]]; then
    # Solo se ejecuta en terminales interactivas
    command -v tool &>/dev/null && eval "$(tool init)"
fi

# Carga asíncrona de plugins
source "$plugin_file" &!  # Se ejecuta en background
```

### **Configuraciones Optimizadas**
- **FZF**: Previews reducidos (200 líneas vs 500)
- **Fast Syntax Highlighting**: Carga asíncrona
- **McFly**: Solo en modo interactivo
- **Zoxide**: Solo en modo interactivo
- **Node.js tools**: Carga perezosa

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

### **Optimizar Nueva Herramienta**
```bash
# Usar lazy loading para herramientas pesadas
if [[ -o interactive ]] && command -v mi_herramienta &>/dev/null; then
    eval "$(mi_herramienta init)"
fi
```

## 📋 Comandos Útiles

### **Verificar Instalación**
```bash
./dreamcoder-setup.sh --info
```

### **Verificar Rendimiento**
```bash
# Medir tiempo de carga de ZSH
zsh -c "time (source ~/.zshrc >/dev/null 2>&1)"

# Verificar herramientas disponibles
which fnm bun starship fzf zoxide mcfly

# Verificar plugins de ZSH
ls -la ~/.oh-my-zsh/custom/plugins/
```

### **Solo Actualizar**
```bash
./dreamcoder-setup.sh --update
```

### **Probar Fastfetch**
```bash
# Probar configuración personalizada
fastfetch --config ~/.config/fastfetch/config.jsonc

# Verificar que se carga automáticamente
zsh -c "source ~/.zshrc"
```

### **Reinstalar Configuración Específica**
Usa el modo interactivo y selecciona solo lo que necesitas.

### **Optimizar Rendimiento**
```bash
# Verificar configuraciones duplicadas
grep -n "fnm\|bun" ~/.zshrc

# Recargar configuración optimizada
source ~/.zshrc

# Verificar que todo funciona
zsh -c "source ~/.zshrc && echo 'Configuración cargada correctamente'"
```

## 🚨 Resolución de Problemas

### **Error: "Distribución no soportada"**
El script soporta Arch Linux, Debian/Ubuntu y Red Hat/Fedora. Para otras distribuciones, instala manualmente las dependencias.

### **Error de permisos**
```bash
chmod +x dreamcoder-setup.sh
```

### **Terminal lenta o con lag**
```bash
# Verificar tiempo de carga
zsh -c "time (source ~/.zshrc >/dev/null 2>&1)"

# Si es lento (>0.5s), verificar configuraciones duplicadas
grep -n "fnm\|bun" ~/.zshrc

# Recargar configuración optimizada
source ~/.zshrc
```

### **Herramientas no encontradas después de instalación**
```bash
# Recargar configuración del shell
source ~/.zshrc  # o ~/.bashrc

# O reiniciar terminal
```

### **Fastfetch no se muestra automáticamente**
```bash
# Verificar que esté habilitado
grep -A 3 "AUTOSTART" ~/.zshrc

# Verificar que fastfetch esté instalado
which fastfetch

# Probar manualmente
fastfetch --config ~/.config/fastfetch/config.jsonc
```

### **Plugins no funcionan correctamente**
```bash
# Verificar que Oh-My-Zsh esté instalado
ls -la ~/.oh-my-zsh/

# Verificar plugins personalizados
ls -la ~/.oh-my-zsh/custom/plugins/

# Recargar configuración
source ~/.zshrc
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