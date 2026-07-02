# Tasks: Dreamcoder Theme Unificación

## Estimación

| Archivo                                                        | Líneas a cambiar | Riesgo |
| -------------------------------------------------------------- | ---------------- | ------ |
| `DreamcoderShell/.config/fish/conf.d/05-dreamcoder-theme.fish` | 1                | Bajo   |
| `DreamcoderTmux/.tmux.conf`                                    | ~25              | Medio  |
| `src/dreamcoder_theme/sync.py`                                 | ~3               | Bajo   |
| **Total estimado**                                             | ~29 líneas       |        |

Dentro del presupuesto de 400 líneas. Single PR.

---

## Tareas

### Task 1: Fish — corregir path de theme_dir

**Archivo**: `DreamcoderShell/.config/fish/conf.d/05-dreamcoder-theme.fish`  
**Línea**: 10  
**De**:

```fish
set -l theme_dir "$DREAMCODER_DOTS_DIR/themes/dreamcoder"
```

**A**:

```fish
set -l theme_dir "$DREAMCODER_DOTS_DIR/DreamcoderThemes/dreamcoder"
```

### Task 2: Tmux — agregar continuum + which-key

**Archivo**: `DreamcoderTmux/.tmux.conf`  
**Sección**: "Plugin: TPM"  
**Agregar después de tmux-resurrect**:

```tmux
# Auto-save cada 15 minutos
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @continuum-save-interval '15'
set -g @continuum-restore 'on'

# Which Key
set -g @plugin 'alexwforsythe/tmux-which-key'
```

### Task 3: Tmux — terminal features

**Archivo**: `DreamcoderTmux/.tmux.conf`  
**Después de la sección "Session Management"**  
**Agregar**:

```tmux
# ─── Terminal Features ─────────────────────────────
# Truecolor para terminales modernos y SSH
set -as terminal-features ",xterm-256color:RGB"
set -as terminal-features ",xterm-kitty:RGB"
set -as terminal-features ",tmux-256color:RGB"
set -as terminal-features ",screen-256color:RGB"
set -s extended-keys off
```

### Task 4: Tmux — remote session controls

**Archivo**: `DreamcoderTmux/.tmux.conf`  
**Antes de "TPM init"**  
**Agregar**:

```tmux
# ─── Remote Session Controls ───────────────────────
# Para conexiones desde Termius/Tailscale.
# Prefix Ctrl+a, luego d para detach sin matar procesos.
bind-key d detach-client
bind-key C-d detach-client
# Splits extra que no confligen con detach
bind-key - split-window -v -c "#{pane_current_path}"
bind-key | split-window -h -c "#{pane_current_path}"
```

### Task 5: Tmux — mobile control overlay

**Archivo**: `DreamcoderTmux/.tmux.conf`  
**Después de "TPM init"**  
**Agregar**:

```tmux
# ─── Mobile Control Overlay ────────────────────────
# Safe if missing
if-shell "test -f ~/.config/tmux/mobile-control.conf" \
  "source-file ~/.config/tmux/mobile-control.conf"
```

### Task 6: Sync — agregar tmux activo a sync_repo_snippets

**Archivo**: `src/dreamcoder_theme/sync.py`  
**Función**: `sync_repo_snippets`  
**Después de la línea de `tmux-dreamcoder-{v}.conf`**  
**Agregar**:

```python
repo_changes.append(
    write_if_changed(
        ROOT / "DreamcoderThemes/dreamcoder/tmux-dreamcoder.conf",
        tmux_content(active),
    )
)
```

### Task 7: Sync + test

1. Ejecutar `python -m dreamcoder_theme.sync` desde la raíz del repo
2. Verificar que `DreamcoderThemes/dreamcoder/tmux-dreamcoder.conf` se genera
3. Verificar que `~/.config/tmux/tmux-dreamcoder.conf` tiene colores actualizados

### Task 8: Verificación final

1. `fish -c 'source ~/.config/fish/conf.d/05-dreamcoder-theme.fish; echo $LS_COLORS'` → colores
2. `fish -c 'source ~/.config/fish/conf.d/05-dreamcoder-theme.fish; echo $FZF_DEFAULT_OPTS'` → `--color=`
3. `tmux start-server; tmux source-file ~/.tmux.conf 2>&1` → sin errores
4. `tmux show -g -p | rg continuum` → `@continuum-save-interval 15`
5. `cat ~/.config/tmux/tmux-dreamcoder.conf | head -5` → colores del modo activo
