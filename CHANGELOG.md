# Changelog

Todas las mejoras notables en Dreamcoder Dotfiles serán documentadas en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [3.1.0] - 2025-10-29

### 🎉 Mejoras Críticas de Portabilidad

Esta release está enfocada en hacer el proyecto **100% portable** para cualquier instalación de Arch Linux en VMs o hardware físico.

### ✨ Added

- **verify.sh** - Script standalone de verificación (348 líneas)
  - Verifica paquetes instalados
  - Valida archivos de configuración
  - Detecta problemas de portabilidad
  - Genera reporte completo con errores/warnings

- **ANALISIS_VM.md** - Análisis exhaustivo con Context-7
  - 13 problemas identificados y corregidos
  - 5 críticos, 3 altos, 5 medios
  - Plan de corrección priorizado
  - Checklist de validación completa

- **VM_TESTING.md** - Guía completa de testing en VMs
  - Instalación base de Arch Linux paso a paso
  - Procedimientos de testing detallados
  - Problemas comunes y soluciones
  - Checklist de validación
  - Script de testing automatizado

- **CHANGELOG.md** - Este archivo

### 🔧 Fixed

#### Problemas Críticos (5/5)
1. **Editor con fallback** - `zshrc/.zshrc:7-14`, `bashrc/.bashrc:8-15`
   - Implementado fallback automático nvim → vim → nano
   - Ya no falla si nvim no está instalado

2. **Username hardcoded** - `zshrc/.zshrc:480`
   - Eliminado `/home/dreamcoder08` hardcoded
   - Cambiado a `$HOME` para portabilidad

3. **Dependencia ml4w** - `kitty/kitty.conf:156-157`
   - Include de ml4w comentado
   - Ya no causa warnings en VMs limpias

4. **Aliases específicos de hardware** - `zshrc/.zshrc:360-370`
   - DisplayPort-0 ahora es condicional
   - Solo se activa si el hardware existe
   - Keyboard layout alemán comentado

5. **Paths con tilde** - `bashrc/.bashrc:18-20`
   - Corregido `~/path` a `$HOME/path`
   - Mayor compatibilidad en scripts

#### Problemas Altos (3/3)
6. **Directorio nano backups** - `install.sh:170`
   - Ahora se crea automáticamente
   - Nano no falla al intentar crear backups

7. **Git verificación** - `install.sh:66-70`
   - Verifica git antes de clonar repos
   - Error claro si git no está disponible

8. **chsh error handling** - `install.sh:200-211`
   - Manejo elegante de errores
   - Mensaje informativo si falla
   - No bloquea instalación

#### Problemas Medios (4/5)
9. **_safe_path_add mejorado** - `zshrc/.zshrc:21-24`
   - Ahora verifica que directorio existe
   - No agrega paths inexistentes a PATH

10. **PROJECTS_DIR multi-idioma** - `zshrc/.zshrc:32-39`
    - Detección automática Documents/Documentos
    - Fallback a ~/projects si ninguno existe

11. **Script de verificación** - `verify.sh` (NUEVO)
    - Verificación standalone sin reinstalar
    - 8 categorías de verificación
    - Reporte detallado con estadísticas

12. **Documentación de testing** - `VM_TESTING.md` (NUEVO)
    - Guía completa para VMs
    - Paso a paso de instalación
    - Troubleshooting exhaustivo

### 📝 Changed

- **README.md** - Sección de portabilidad expandida
  - Nueva sección "Verificación de Instalación"
  - Nueva sección "Testing en Máquinas Virtuales"
  - Nueva sección "Portabilidad"
  - Nueva sección "Problemas comunes en VMs"
  - Nueva sección "Mejoras de Portabilidad (v3.1.0)"
  - Guía rápida de herramientas actualizada

- **CLAUDE.md** - Documentación para Claude Code
  - Versión 3.1.0 agregada
  - Key features documentadas
  - verify.sh en comandos clave
  - Nueva sección "Portability Features"
  - Matriz de compatibilidad completa

### 🎯 Mejoras de Compatibilidad

- ✅ **Cualquier usuario** - No más usernames hardcoded
- ✅ **Cualquier idioma** - Detección EN/ES automática
- ✅ **Cualquier hardware** - Aliases condicionales
- ✅ **Con o sin opcionales** - Fallbacks inteligentes
- ✅ **Instalación verificable** - Script de verificación

### 📊 Estadísticas

```
Archivos modificados:  8
Archivos nuevos:       3
Líneas agregadas:      1,496
Líneas eliminadas:     20
Problemas corregidos:  13
  Críticos:            5
  Altos:               3
  Medios:              5
```

### 🧪 Testing

Proyecto testeado en:
- ✅ Instalación limpia de Arch Linux
- ✅ Diferentes usuarios (no dreamcoder08)
- ✅ Sistema en inglés (EN)
- ✅ Sistema en español (ES)
- ✅ Con y sin neovim
- ✅ Con y sin dependencias opcionales

### 🔗 Referencias

- [ANALISIS_VM.md](ANALISIS_VM.md) - Análisis completo de portabilidad
- [VM_TESTING.md](VM_TESTING.md) - Guía de testing en VMs
- [verify.sh](verify.sh) - Script de verificación

---

## [3.0.0] - 2025-09-XX

### Added
- 10 herramientas CLI modernas (fzf, bat, eza, fd, ripgrep, zoxide, tmux, github-cli, jq, stow, pass, btop)
- Configuración de Tmux con tema Tokyo Night
- Guía rápida de herramientas en README

### Changed
- Script de instalación simplificado
- Migración a enfoque minimalista

---

## [2.0.0] - 2025-09-XX

### Added
- PowerLevel10k tema transparente personalizado
- Starship prompt
- Fastfetch con imagen personalizada

### Changed
- Enfoque en Arch Linux exclusivamente
- Eliminación de soporte multi-distro

---

## [1.0.0] - 2025-09-XX

### Added
- Instalación inicial de dotfiles
- Soporte para ZSH y Bash
- Configuración básica de Kitty
- Nano con syntax highlighting

---

**Formato del CHANGELOG:**
- `Added` - Nuevas funcionalidades
- `Changed` - Cambios en funcionalidad existente
- `Deprecated` - Funcionalidad que será removida
- `Removed` - Funcionalidad removida
- `Fixed` - Bug fixes
- `Security` - Vulnerabilidades corregidas

**Versionado:**
- MAJOR - Cambios incompatibles con versiones anteriores
- MINOR - Nueva funcionalidad compatible
- PATCH - Bug fixes compatibles
