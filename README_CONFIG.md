# 🚀 Configuraciones Dreamcoder Dots

## 📋 Configuraciones Disponibles

### 🐚 **Shell Configurations**
- **`zsh`** - Configuración optimizada de ZSH para usuario normal
  - Herramientas modernas: `eza`, `bat`, `fd`, `rg`, `fzf`, `zoxide`, `mcfly`
  - Plugins: git, vi-mode, autosuggestions, syntax-highlighting
  - Prompt: Starship con configuración personalizada

- **`zsh-root`** - Configuración segura de ZSH para root
  - Herramientas de administración: `duf`, `dust`, `btm`, `procs`
  - Prompt: Starship con advertencias visuales de root
  - Enfoque en seguridad y administración del sistema

### 🎨 **Prompt Configurations**
- **`starship`** - Prompt moderno para usuario
  - Optimizado para desarrollo frontend
  - Información de Git, Node.js, Python, etc.
  - Tema personalizado con colores

- **`starship-root`** - Prompt para administrador
  - **⚠️ ROOT ⚠️** parpadeante visible
  - Solo información esencial del sistema
  - Sin herramientas de desarrollo

### 🖥️ **Terminal & System**
- **`kitty`** - Terminal moderno con GPU
- **`fastfetch`** - Sistema de información visual
- **`nano`** - Editor de texto mejorado

## 🔧 **Instalación**

### Instalación Automática (Recomendado)
```bash
# Instalar todas las configuraciones
./dreamcoder-setup.sh --configs

# Instalación completa (configs + herramientas)
./dreamcoder-setup.sh --install-all
```

### Instalación Selectiva
```bash
# Usar el menú interactivo
./dreamcoder-setup.sh

# Seleccionar: "1. Gestionar configuraciones" 
# Luego: "2. Instalar configuraciones (selectivo)"
```

## 🛡️ **Configuraciones de Root**

Las configuraciones de root (`zsh-root`, `starship-root`) requieren permisos administrativos:

```bash
# El script maneja automáticamente sudo para estas configuraciones
sudo ./dreamcoder-setup.sh --configs

# O desde el menú interactivo (pedirá sudo cuando sea necesario)
./dreamcoder-setup.sh
```

## 📦 **Herramientas Requeridas**

### Para Usuario (zsh)
```bash
sudo pacman -S eza bat fd ripgrep fzf zoxide mcfly starship
```

### Para Root (zsh-root)
```bash
sudo pacman -S eza bat fd ripgrep duf dust bottom procs starship
```

### Terminal
```bash
sudo pacman -S kitty fastfetch
```

## 🔄 **Aplicar Configuraciones**

### ZSH Usuario
```bash
# Recargar configuración
source ~/.zshrc

# Cambiar shell a ZSH (si es necesario)
chsh -s $(which zsh)
```

### ZSH Root
```bash
# Cambiar shell de root a ZSH
sudo chsh -s $(which zsh) root

# Probar configuración como root
sudo su -
```

## 📁 **Estructura de Archivos**

```
zshrc/
├── .zshrc              # Configuración principal de usuario
└── root_example.zsh    # Configuración segura para root

starship/
├── starship.toml       # Prompt para usuario
└── starship_root.toml  # Prompt para root (seguro)

kitty/                  # Terminal configuration
fastfetch/             # System info configuration  
```

## 🎯 **Características Principales**

### Configuración Usuario
- ✅ Herramientas modernas de productividad
- ✅ Desarrollo frontend optimizado
- ✅ Navegación inteligente con `zoxide`
- ✅ Historial mejorado con `mcfly`
- ✅ Búsqueda rápida con `fzf`

### Configuración Root
- 🛡️ Seguridad como prioridad
- ⚠️ Advertencias visuales constantes  
- 🔧 Herramientas de administración del sistema
- ❌ Sin herramientas de desarrollo
- 📊 Monitoreo del sistema integrado

## 🚨 **Advertencias Importantes**

1. **Root Safety**: Las configuraciones de root están diseñadas para ser seguras y obvias
2. **Backup**: El sistema crea respaldos automáticos (excepto para root)
3. **Dependencies**: Instala las herramientas requeridas para funcionalidad completa
4. **Shell Change**: Recuerda cambiar el shell por defecto si es necesario

## 🔍 **Verificación de Instalación**

```bash
# Verificar estado de todas las configuraciones
./dreamcoder-setup.sh --verify

# Ver información del sistema
./dreamcoder-setup.sh --info
```

¡Disfruta tu nuevo entorno optimizado! 🚀