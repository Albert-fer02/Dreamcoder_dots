# Proposal: Full Installation Integration — Gentleman.Dots + ML4W + Dreamcoder

> **SDD Change:** `001-dreamcoder-full-install`
> **Priority:** 🔴 CRITICAL
> **Estimated diff:** ~800 lines across 25+ files

## Executive Summary

dreamcoder-dots está diseñado como una **capa visual** sobre Gentleman.Dots + ML4W, pero la integración actual tiene **gaps detectados** que impiden una instalación verdaderamente sólida. Esta propuesta cubre desde la corrección de hooks rotos hasta la verificación CI, pasando por un doctor que detecte todo, un instalador idempotente, y auto-theme switching funcional.

## Current Pain Points

| # | Problema | Impacto |
|---|----------|---------|
| 1 | `dreamcoder-colors.conf` existe en `~/.config/hypr/` pero **no se importa** en hyprland.lua. Los colores de Hyprland son ML4W default, no dreamcoder | ❌ Visual inconsistency |
| 2 | **Btop** no tiene theme dreamcoder. Usa matugen (ML4W) | ❌ Missing integration |
| 3 | **Auto-theme timer** no está activo (systemd units existen pero `enable --now` no se corrió) | ⚠️ Manual switching only |
| 4 | **Doctor** no verifica Btop, GTK, Nvim colorscheme, Hypr dreamcoder import | ⚠️ Blind spots |
| 5 | **Instalador** sin backup manifest ni rollback command en la ruta install | ⚠️ Not safe to re-run |
| 6 | **Working tree sucio**: cambios del SDD anterior (000-dreamcoder-theme-unification) sin commitecar | ⚠️ No clean baseline |
| 7 | **Sin CI** que verifique integración cross-repo | ❌ Regressions invisibles |
| 8 | **Waybar style.css** import de dreamcoder colors no verificado | ⚠️ Broken @import? |
| 9 | **Bat theme** existe en disco pero no verificado en integración | ⚠️ Unknown state |
| 10 | Firefox, Obsidian, Cava themes existentes en repo pero no deployados ni verificados | ⚠️ Missing targets |

## Targets

| # | Target | Capa | Descripción |
|---|--------|------|-------------|
| T1 | **Clean baseline** | All | Commitear o descartar cambios del working tree del SDD anterior, dejar repo limpio |
| T2 | **Hyprland dreamcoder-colors** | ML4W | Agregar `source`/`require` de dreamcoder-colors.conf en hyprland.lua |
| T3 | **Btop dreamcoder theme** | ML4W | Deployar `btop-dreamcoder.theme` desde DreamcoderThemes a `~/.config/btop/themes/` |
| T4 | **Auto-theme timer activo** | Dreamcoder | `systemctl --user enable --now dreamcoder-theme-auto.timer` en install + verify |
| T5 | **Doctor mejorado** | Dreamcoder | Agregar checks para Btop, GTK, Nvim colorscheme, Hypr import, Bat, Firefox, Obsidian, Cava |
| T6 | **Instalador idempotente** | Dreamcoder | Backup manifest pre-install, rollback command, safe re-run |
| T7 | **Repair catalog extendido** | Dreamcoder | Agregar acciones repair para los targets faltantes |
| T8 | **CI integration test** | CI | GitHub Action que clone Gentleman + ML4W, aplique dreamcoder, verifique hooks |
| T9 | **Waybar @import verification** | ML4W | Verificar que style.css importa dreamcoder colors.css correctamente |
| T10 | **Documentación de instalación** | Docs | Actualizar Linux.md con pasos precisos, troubleshooting, y verify checklist |

## Non-Goals

- No se cambia el pipeline de generación de tokens ni renderers
- No se agregan nuevos targets a la theme engine (solo deploy de los existentes)
- No se reescribe el installer en Go (solo mejorar el bash existente)
- No se toca la estructura del repo (los prefijos Dreamcoder* se mantienen)
- No se agregan profiles de hardware nuevos

## Acceptance Criteria

1. `dreamcoder dark` cambia **todos** los componentes (Hyprland, Waybar, Rofi, Dunst, Kitty, Ghostty, Tmux, Nvim, Starship, Fish, Btop, Bat, Zellij, Pi, OpenCode, Warp) a Ember Noir sin errores
2. `dreamcoder light` cambia **todos** a Cocoa/Lúcuma sin errores
3. `dreamcoder doctor` detecta cualquier componente faltante y sugiere reparación
4. `./scripts/install.sh` se puede correr múltiples veces sin romper nada
5. Auto-theme switching funciona via systemd timer
6. CI pasa con un clone fresco de Gentleman + ML4W
7. Sin errores en logs de ningún componente después del switching

## Approach

### Phase 1: Baseline & Quick Fixes (T1-T4)

1. Limpiar working tree (stash/discard/commit cambios previos)
2. Arreglar import de dreamcoder-colors.conf en Hyprland
3. Deployar btop-dreamcoder.theme
4. Activar systemd timer

### Phase 2: Safety & Diagnostics (T5-T7)

1. Extender doctor.sh con todos los targets
2. Agregar backup manifest + rollback a install.sh
3. Extender repair catalog

### Phase 3: CI & Docs (T8-T10)

1. GitHub Action de integración
2. Verificar Waybar @import
3. Actualizar docs de instalación

## Risks

- **ML4W updates**: Si ML4W cambia paths/nombres de archivos, los hooks se rompen
- **Gentleman.Dots updates**: Mismo riesgo. Versión actual: v2.9.12
- **Working tree**: Si el usuario no quiere commitecar los cambios previos, hay que stash o discardear
- **Auto-theme timer**: Depende de systemd --user, que necesita lingering habilitado
- **doctor sobre Btop**: Btop espera un archivo .theme con formato específico
