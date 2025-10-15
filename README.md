# Dreamcoder Dotfiles

Configuraciones optimizadas para un entorno de desarrollo Linux moderno y productivo.

## Instalación

```bash
git clone https://github.com/Albert-fer02/Dreamcoder_dots.git
cd Dreamcoder_dots
./dreamcoder-setup.sh
```

## Características

- **🔒 Seguridad Mejorada**: Validación de entrada, sanitización de rutas, manejo seguro de sudo
- **⚡ Performance Optimizada**: Sistema de cache, lazy loading, operaciones asíncronas
- **🧩 Arquitectura Modular**: Módulos independientes con bajo acoplamiento
- **🛡️ Manejo de Errores**: Validación comprehensiva y recuperación de errores
- **📊 Testing Framework**: Suite completa de pruebas para validación
- **🔧 Mantenibilidad**: Código refactorizado, documentación mejorada, mejores prácticas

### Configuraciones Incluidas
- **ZSH** con Oh-My-Zsh y plugins optimizados + integración FZF mejorada
- **Bash** configuración alternativa para compatibilidad
- **Kitty** terminal con temas personalizados
- **Starship** prompt moderno con configuraciones separadas
- **PowerLevel10k** tema premium personalizado con diseño transparente ultra vibrante
- **Prompt Senior-Level** estructura profesional con instant prompt y transient
- **Paleta Vibrante** inspirada en Dracula/Material Design para máximo impacto visual
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
./dreamcoder-setup.sh --install-all       # Instalar todo
./dreamcoder-setup.sh --update            # Actualizar sistema
./dreamcoder-setup.sh --info              # Ver estado
./dreamcoder-setup.sh --diagnose-sudo     # Diagnosticar problemas con sudo
```

### 🔧 Solución de Problemas con Sudo

Si experimentas problemas con la entrada de contraseña:

```bash
# Diagnosticar problemas con sudo
./dreamcoder-setup.sh --diagnose-sudo

# Ejecutar test de corrección
chmod +x test_sudo_fix.sh && ./test_sudo_fix.sh
```

**Problemas comunes y soluciones:**

1. **Secuencias de escape ANSI** (`^[[A^[[A^[[A`]):
   - ✅ **Solucionado**: Eliminado timeout problemático
   - ✅ **Mejorado**: Mejor manejo de entrada de contraseña

2. **Contraseña no aceptada**:
   - Verifica que tu usuario esté en el grupo `sudo`
   - Ejecuta: `sudo usermod -aG sudo $USER`
   - Reinicia la sesión después de agregar al grupo

3. **Problemas en entorno gráfico**:
   - Intenta ejecutar en una terminal sin interfaz gráfica
   - O usa: `sudo -A` si tienes un askpass configurado

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

### Herramientas por Categoría
- **Core**: git, curl, wget, build tools (soporte multi-distro)
- **CLI Modernas**: eza, bat, fd, ripgrep, fzf, zoxide, dust, duf, procs, bottom, hyperfine, tokei
- **Terminal**: kitty, fastfetch
- **Desarrollo**: Docker, Docker Compose, Python tools

## Testing

### Ejecutar Tests
```bash
# Ejecutar suite completa de pruebas
./test/test_framework.sh

# Ejecutar pruebas específicas
./test/test_framework.sh --security    # Solo pruebas de seguridad
./test/test_framework.sh --performance # Solo pruebas de performance
```

### Cobertura de Tests
- ✅ **Seguridad**: Validación de entrada, sanitización de rutas, manejo de sudo
- ✅ **Funcionalidad**: Carga de módulos, detección de distribución
- ✅ **Performance**: Sistema de cache, operaciones optimizadas
- ✅ **Configuración**: Validación de archivos de configuración

## Estructura del Proyecto

```
Dreamcoder_dots/
├── dreamcoder-setup.sh        # Script principal mejorado
├── SECURITY.md                # Guías de seguridad y hardening
├── test/                      # Framework de testing
│   └── test_framework.sh      # Suite completa de pruebas
├── lib/                       # Módulos del sistema (mejorados)
│   ├── core.sh               # Sistema principal con validaciones
│   ├── distro.sh             # Detección de distribuciones
│   ├── backup.sh             # Sistema de respaldos
│   ├── config.sh             # Gestión de configuraciones segura
│   ├── tools.sh              # Instalación de herramientas
│   └── ui.sh                 # Interfaz de usuario con validaciones
├── config/                    # Archivos de configuración
│   ├── configs.conf          # Definición de dotfiles
│   └── tools.conf            # Herramientas por categoría
├── zshrc/                     # Configuraciones ZSH
├── bashrc/                    # Configuraciones Bash
├── kitty/                     # Configuraciones Kitty
├── fastfetch/                 # Configuraciones Fastfetch
├── nano/                      # Configuraciones Nano
├── starship.toml              # Configuración Starship
└── p10k_dreamcoder.zsh        # Tema PowerLevel10k transparente vibrante
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

## Mejoras Implementadas

### 🔒 Seguridad Mejorada
- **Validación de entrada**: Sanitización completa de todas las entradas de usuario
- **Prevención de path traversal**: Detección y bloqueo de ataques de directorio transversal
- **Manejo seguro de sudo**: Validación apropiada de privilegios con timeout
- **Protección contra command injection**: Uso de arrays para argumentos de comandos
- **Validación de URLs**: Verificación segura de URLs antes de descargar

### ⚡ Performance Optimizada
- **Sistema de cache**: Cache inteligente para operaciones costosas (detección de distro)
- **Lazy loading**: Módulos se cargan solo cuando son necesarios
- **Operaciones asíncronas**: Procesamiento en background para tareas no críticas
- **Optimización de bucles**: Reducción de operaciones redundantes
- **Gestión de memoria**: Limpieza automática de cache antiguo

### 🧩 Arquitectura Modular Mejorada
- **Funciones refactorizadas**: Descomposición de funciones monolíticas
- **Separación de responsabilidades**: Cada módulo tiene un propósito claro
- **Interfaz consistente**: Patrones uniformes de manejo de errores
- **Configuración externa**: Archivos de configuración separados del código
- **Extensibilidad**: Fácil adición de nuevas funcionalidades

### 🛡️ Manejo de Errores Robusto
- **Validación comprehensiva**: Verificación de precondiciones
- **Recuperación de errores**: Continuación de operaciones cuando es posible
- **Logging mejorado**: Seguimiento detallado de eventos y errores
- **Mensajes informativos**: Retroalimentación clara al usuario
- **Limpieza automática**: Recursos liberados correctamente en caso de error

### 📊 Testing Framework
- **Pruebas de seguridad**: Validación de vulnerabilidades conocidas
- **Pruebas de funcionalidad**: Verificación de operaciones críticas
- **Pruebas de performance**: Medición de mejoras de velocidad
- **Cobertura automática**: Ejecución de todas las pruebas con un comando
- **Reportes detallados**: Resultados claros y accionables

## Optimizaciones

- **Carga rápida**: 0.1 segundos (mejorado con cache)
- **Lazy loading**: Herramientas se cargan solo cuando es necesario
- **Carga asíncrona**: Plugins pesados en background
- **Configuraciones optimizadas**: Sin duplicaciones
- **Sistema modular**: Módulos independientes para fácil mantenimiento
- **Soporte multi-distro**: Detección automática de distribución
- **Gestión de respaldos**: Sistema completo de backup y restauración
- **Prompt Ultra Optimizado**: Instant prompt + transient + estructura senior-level
- **Colores Vibrantes**: Máximo impacto visual con legibilidad perfecta

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

**¿Problemas o sugerencias?** 💬 Abre un [issue](https://github.com/Albert-fer02/Dreamcoder_dots/issues)