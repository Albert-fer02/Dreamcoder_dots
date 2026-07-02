# Proposal: Dreamcoder Theme Unificación y Corrección

## Resumen Ejecutivo

El ecosistema Dreamcoder genera themes correctamente via `sync.py`, pero hay un
**path mismatch crítico** entre donde se escriben los archivos (DreamcoderThemes/)
y donde Fish los busca (themes/). Adicionalmente, tmux carece de features de
calidad de vida que gentleman-dots ya tiene resueltos.

## Targets

| #   | Target                          | Problema                                                    | Solución                                       |
| --- | ------------------------------- | ----------------------------------------------------------- | ---------------------------------------------- |
| 1   | Fish `05-dreamcoder-theme.fish` | Busca en `themes/dreamcoder/` (no existe)                   | Corregir path a `DreamcoderThemes/dreamcoder/` |
| 2   | `ls` / `eza` colores            | LS_COLORS/EZA_COLORS nunca se setean                        | Se arregla con #1                              |
| 3   | `fzf` colores                   | FZF_DEFAULT_OPTS sin --color                                | Se arregla con #1                              |
| 4   | tmux features                   | Sin continuum/which-key/terminal-features                   | Agregar desde gentleman-dots                   |
| 5   | tmux active conf                | No se genera `tmux-dreamcoder.conf` activo (solo variantes) | Agregar a `sync_active_targets`                |

## No Goals

- No se toca ghostty (ya funciona)
- No se toca starship (ya funciona)
- No se toca el pipeline de generación de tokens
- No se cambia la estructura del repo solo para esto

## Criterios de Aceptación

1. `source 05-dreamcoder-theme.fish` setea `$LS_COLORS`, `$EZA_COLORS`, `$FZF_DEFAULT_OPTS`
2. `ls -la` en ghostty muestra colores del theme Dreamcoder
3. `fzf` en ghostty muestra colores del theme Dreamcoder
4. tmux tiene continuum (auto-save cada 15min), which-key, terminal-features extendidas
5. `tmux source ~/.tmux.conf` no da errores
6. `dreamcoder-theme sync` regenera todo sin romper nada
