# Spec: Dreamcoder Theme Unificación

## 1. Fish Theme Path Fix

### Archivo

`DreamcoderShell/.config/fish/conf.d/05-dreamcoder-theme.fish`

### Cambio

Línea 10: `set -l theme_dir` cambia de:

```fish
set -l theme_dir "$DREAMCODER_DOTS_DIR/themes/dreamcoder"
```

a:

```fish
set -l theme_dir "$DREAMCODER_DOTS_DIR/DreamcoderThemes/dreamcoder"
```

### Archivos que debe encontrar Fish

| Variable                     | Archivo esperado                             |
| ---------------------------- | -------------------------------------------- |
| `$LS_COLORS` / `$EZA_COLORS` | `{theme_dir}/ls-colors-dreamcoder-{mode}.sh` |
| `$FZF_DEFAULT_OPTS`          | `{theme_dir}/fzf-dreamcoder-{mode}.sh`       |

Donde `{mode}` = `dark` o `light` según `$DREAMCODER_THEME_MODE`.

---

## 2. Tmux — Agregar features de gentleman-dots

### Archivo

`DreamcoderTmux/.tmux.conf`

### Plugins a agregar (ya instalados en `~/.tmux/plugins/`)

- `tmux-plugins/tmux-continuum` — auto-save cada 15min
- `alexwforsythe/tmux-which-key` — popup de bindings

### Config a agregar

```tmux
# Auto-save cada 15 minutos
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @continuum-save-interval '15'
set -g @continuum-restore 'on'

# Which Key
set -g @plugin 'alexwforsythe/tmux-which-key'

# Terminal features para truecolor
set -as terminal-features ",xterm-256color:RGB"
set -as terminal-features ",xterm-kitty:RGB"
set -as terminal-features ",tmux-256color:RGB"
set -as terminal-features ",screen-256color:RGB"

# Remote session controls
bind-key d detach-client
bind-key C-d detach-client
bind-key - split-window -v -c "#{pane_current_path}"
bind-key | split-window -h -c "#{pane_current_path}"

# Mobile control overlay
if-shell "test -f ~/.config/tmux/mobile-control.conf" \
  "source-file ~/.config/tmux/mobile-control.conf"

# Extended keys off (compatibilidad)
set -s extended-keys off
```

### Orden de las secciones en el archivo

1. General (default-terminal, mouse, history, etc.) — ya existe
2. Key Bindings — ya existe
3. Plugin declarations (TPM, sensible, yank, vim-tmux-navigator, resurrect) — AGREGAR continuum + which-key
4. Terminal features — AGREGAR
5. Session Management — ya existe
6. Theme (Dreamcoder) — ya existe
7. Remote session controls — AGREGAR
8. Status Bar — ya existe
9. TPM init (keep last) — ya existe
10. Mobile overlay — AGREGAR

---

## 3. Tmux — Active theme en sync pipeline

### Archivo

`src/dreamcoder_theme/sync.py`

### En `sync_active_targets`, ya existe

```python
"tmux": write_if_changed(paths.tmux, tmux_content(active)),
```

Donde `paths.tmux` = `~/.config/tmux/tmux-dreamcoder.conf`

### Se debe agregar a `sync_repo_snippets`

El tmux-dreamcoder activo (sin sufijo dark/light) en el directorio del repo.

```python
write_if_changed(
    ROOT / "DreamcoderThemes/dreamcoder/tmux-dreamcoder.conf",
    tmux_content(active),
)
```

---

## 4. Tmux — `source-file` en el theme generado

### Archivo

`.tmux.conf` línea ~39:

```
source-file ~/.config/tmux/tmux-dreamcoder.conf
```

### El archivo `~/.config/tmux/tmux-dreamcoder.conf` es generado por

`sync_active_targets` → `write_if_changed(paths.tmux, tmux_content(active))`

Donde `paths.tmux` = `config_home / "tmux/tmux-dreamcoder.conf"` = `~/.config/tmux/tmux-dreamcoder.conf`

Esto YA funciona correctamente. Solo verificamos que se genera.

---

## 5. Ghostty — Estado actual

### Archivos

- Config: `~/.config/ghostty/config` → `theme = dreamcoder` (funciona)
- Theme: `~/.config/ghostty/themes/dreamcoder` (funciona, sync lo genera)
- Variantes: `~/.config/ghostty/themes/dreamcoder-dark` y `dreamcoder-light` (existen)

### No requiere cambios

---

## 6. Sync pipeline — resumen de generación

`dreamcoder-theme sync` (via `python -m dreamcoder_theme.sync`) ejecuta:

1. `sync_active_targets()` → escribe a paths activos (runtime)
2. `sync_repo_snippets()` → escribe variantes dark/light al repo
3. `sync_bat_theme_variants()` → escribe variantes tmTheme de bat

### Paths activos relevantes

| Target             | Path activo                                                                 |
| ------------------ | --------------------------------------------------------------------------- |
| Tmux               | `~/.config/tmux/tmux-dreamcoder.conf`                                       |
| Ghostty            | `~/.config/ghostty/themes/dreamcoder`                                       |
| Fzf (activo)       | `DreamcoderThemes/fzf-dreamcoder.sh` (no usado en runtime, solo repo)       |
| LS_COLORS (activo) | `DreamcoderThemes/ls-colors-dreamcoder.sh` (no usado en runtime, solo repo) |

### Paths de variantes (sourceados por Fish)

| Target        | Path variante                                                |
| ------------- | ------------------------------------------------------------ |
| LS_COLORS/EZA | `DreamcoderThemes/dreamcoder/ls-colors-dreamcoder-{mode}.sh` |
| FZF           | `DreamcoderThemes/dreamcoder/fzf-dreamcoder-{mode}.sh`       |
