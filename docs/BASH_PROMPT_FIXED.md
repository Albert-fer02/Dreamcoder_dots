# 🔧 Bash Prompt Configuration - Fixed

## Problema Identificado

El prompt de Bash no mostraba las configuraciones de Starship correctamente. El análisis reveló varios problemas:

### 1. **Cache de Fastfetch**
- Las imágenes antiguas se mostraban debido al cache de fastfetch
- **Solución**: Agregado alias `ffresh` para limpiar cache

### 2. **Configuración de TERM**
- En shells no-interactivos, TERM puede ser "dumb"
- Starship falla silenciosamente cuando `TERM=dumb`
- **Solución**: Forzar `TERM=xterm-256color` al inicio del bashrc

### 3. **Orden de Inicialización**
- Zoxide y Starship compiten por el `PROMPT_COMMAND`
- **Solución**: Starship maneja esto automáticamente guardando el PROMPT_COMMAND anterior en `STARSHIP_PROMPT_COMMAND`

## Soluciones Aplicadas

### ✅ bashrc/.bashrc

```bash
# IMPORTANTE: Configurar TERM antes del check de interactividad
if [[ -z "$TERM" ]] || [[ "$TERM" == "dumb" ]]; then
    export TERM="xterm-256color"
fi
export COLORTERM="${COLORTERM:-truecolor}"

# Orden correcto:
# 1. Cargar zoxide primero
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash --cmd cd)"
fi

# 2. Cargar starship después
# Starship automáticamente preserva el PROMPT_COMMAND de zoxide
if command -v starship &>/dev/null; then
    export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$HOME/.config/starship.toml}"
    eval "$(starship init bash)"
fi
```

### ✅ starship.toml

- Corregido `expiry_symbol` → `expiration_symbol` en sección `[aws]`
- Esto eliminaba un warning de configuración

### ✅ bash_profile/.bash_profile

Creado nuevo archivo para shells de login:

```bash
# Asegurar TERM antes de cargar bashrc
export TERM="${TERM:-xterm-256color}"
export COLORTERM="${COLORTERM:-truecolor}"

# Source bashrc si existe y es interactivo
if [[ -f "$HOME/.bashrc" ]] && [[ $- == *i* ]]; then
    source "$HOME/.bashrc"
fi
```

### ✅ Alias Útiles

```bash
# Limpiar cache de fastfetch
alias ffresh='rm -rf ~/.cache/fastfetch && fastfetch --logo-recache true'

# Editor con argumentos (función en lugar de alias)
v() { $EDITOR "$@"; }
vim() { $EDITOR "$@"; }
```

## ¿Cómo Funciona?

### Flujo de Inicialización

1. **Shell de Login** (`bash -l`):
   - Carga `.bash_profile`
   - `.bash_profile` configura TERM
   - `.bash_profile` source `.bashrc`

2. **Shell Interactivo** (`bash -i`):
   - Carga `.bashrc` directamente
   - Check: `[[ $- != *i* ]] && return`
   - Configura TERM si es necesario
   - Inicializa zoxide
   - Inicializa starship

### PROMPT_COMMAND Explicado

```bash
# Después de inicializar zoxide:
PROMPT_COMMAND="__zoxide_hook;"

# Después de inicializar starship:
PROMPT_COMMAND="starship_precmd"
STARSHIP_PROMPT_COMMAND="__zoxide_hook;"
```

**Starship ejecuta zoxide desde dentro de `starship_precmd`:**

```bash
# Dentro de starship_precmd:
if [[ -n "${STARSHIP_PROMPT_COMMAND-}" ]]; then
    eval "$STARSHIP_PROMPT_COMMAND"  # Ejecuta __zoxide_hook
fi

# Luego genera el prompt de starship
PS1="$(starship prompt ...)"
```

## Verificación

### Script de Verificación

Creado `verify_bash.sh`:

```bash
./verify_bash.sh
```

Verifica:
- ✅ Archivos sincronizados (MD5)
- ✅ Starship inicializado
- ✅ Zoxide funcional
- ✅ TERM configurado correctamente
- ⚠️  Cache de fastfetch

### Test Manual

```bash
# Abrir bash interactivo
exec bash

# O con TERM explícito
TERM=xterm-256color bash -i

# Verificar configuración
echo "TERM: $TERM"
echo "PROMPT_COMMAND: $PROMPT_COMMAND"
echo "STARSHIP_PROMPT_COMMAND: $STARSHIP_PROMPT_COMMAND"
type starship_precmd
```

## Archivos Modificados

1. `bashrc/.bashrc` - Configuración principal de Bash
2. `bash_profile/.bash_profile` - Nuevo archivo para login shells
3. `starship.toml` - Corrección de warning AWS
4. `install.sh` - Agregada instalación de bash_profile
5. `verify_bash.sh` - Script de verificación

## Referencias

- [Starship Prompt](https://starship.rs)
- [Zoxide](https://github.com/ajeetdsouza/zoxide)
- [Bash Startup Files](https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html)

---

**Versión**: 3.2.1
**Fecha**: 2025-11-03
**Estado**: ✅ RESUELTO
