# Design: Dreamcoder Theme Unificación

## Arquitectura de la solución

### Flujo de datos del theme

```
tokens.json ──► dreamcoder-theme sync ──► sync_active_targets() ──► Archivos activos (runtime)
                    │                              │
                    │                              └──► sync_repo_snippets() ──► Variantes dark/light (repo)
                    │
                    └──► Fish 05-dreamcoder-theme.fish ──► sourcea variante según $DREAMCODER_THEME_MODE
```

### El problema actual

```
sync escribe variantes a:  DreamcoderThemes/dreamcursor/ls-colors-dreamcoder-light.sh  ✅
Fish busca en:             themes/dreamcursor/ls-colors-dreamcoder-light.sh              ❌ inexistente
```

### La solución

```
sync escribe variantes a:  DreamcoderThemes/dreamcursor/ls-colors-dreamcoder-light.sh  ✅
Fish busca en:             DreamcoderThemes/dreamcursor/ls-colors-dreamcoder-light.sh  ✅ (corregido)
```

Un solo cambio: la línea `set -l theme_dir` en Fish.

---

## Cambios detallados

### Cambio 1: Fish theme path

**File**: `DreamcoderShell/.config/fish/conf.d/05-dreamcoder-theme.fish`
**Línea**: 10
**De**: `set -l theme_dir "$DREAMCODER_DOTS_DIR/themes/dreamcoder"`
**A**: `set -l theme_dir "$DREAMCODER_DOTS_DIR/DreamcoderThemes/dreamcoder"`
**Riesgo**: Bajo. Solo cambia una ruta de búsqueda. Si hay error, no rompe el shell, solo no setea las vars.

### Cambio 2: Tmux features de gentleman-dots

**File**: `DreamcoderTmux/.tmux.conf`
**Sección**: "Plugin: TPM" — agregar 2 plugins
**Sección**: después de "Key Bindings" — agregar terminal-features
**Sección**: después de "TPM init" — agregar remote controls + mobile overlay
**Sección**: al principio — agregar `extended-keys off`
**Riesgo**: Medio. Plugins ya instalados en `~/.tmux/plugins/`. Solo hay que cargarlos con TPM.

### Cambio 3: Sync — active tmux en repo

**File**: `src/dreamcoder_theme/sync.py`
**Función**: `sync_repo_snippets`
**Agregar**: `write_if_changed(ROOT / "DreamcoderThemes/dreamcoder/tmux-dreamcoder.conf", tmux_content(active))`
**Riesgo**: Bajo. Solo replica lo que ya hace para otros targets.

---

## Prueba de regresión

Para cada cambio, verificar:

1. **Fish path**: `fish -c 'source ~/.config/fish/conf.d/05-dreamcoder-theme.fish; echo $LS_COLORS'` debe mostrar colores
2. **fzf**: `fish -c 'source ~/.config/fish/conf.d/05-dreamcoder-theme.fish; echo $FZF_DEFAULT_OPTS'` debe incluir `--color=`
3. **tmux**: `tmux start-server; tmux source-file ~/.tmux.conf; tmux show -g -p | rg continuum` debe mostrar `@continuum-save-interval 15`
4. **Sync**: `cd dreamcoder-dots && python -m dreamcoder_theme.sync` debe salir sin errores
5. **Tmux theme**: `cat ~/.config/tmux/tmux-dreamcoder.conf` debe tener colores del modo activo
