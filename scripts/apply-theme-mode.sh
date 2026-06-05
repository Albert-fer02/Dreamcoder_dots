#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
MODE="${1:-light}"
WALLPAPER="${2:-${DREAMCODER_WALLPAPER:-}}"
ML4W_WALLPAPER="${ML4W_CACHE_DIR}/current_wallpaper"
[[ "${MODE}" == "light" || "${MODE}" == "dark" ]] || { printf 'Invalid mode: %s\n' "${MODE}" >&2; exit 1; }
if [[ -z "${WALLPAPER}" && -f "${ML4W_WALLPAPER}" ]]; then WALLPAPER="$(cat "${ML4W_WALLPAPER}")"; fi

CURSOR_CLI_ENV="${CACHE_HOME:-${HOME}/.cache}/dreamcoder/cursor-cli.env"
case "${MODE}" in
    light) CLI_COLORFGBG="0;15" ;;
    dark) CLI_COLORFGBG="15;0" ;;
esac
mkdir -p "$(dirname "${CURSOR_CLI_ENV}")"
printf 'export COLORFGBG="%s"\nexport DREAMCODER_THEME_MODE="%s"\nexport COLORTERM="truecolor"\nexport FORCE_COLOR="3"\nexport CLICOLOR_FORCE="1"\nunset NO_COLOR\n' "${CLI_COLORFGBG}" "${MODE}" >"${CURSOR_CLI_ENV}"

"${DREAMCODER_DOTS_DIR}/scripts/apply-system-mode.sh" "${MODE}"
if [[ -n "${WALLPAPER}" && -f "${WALLPAPER}" ]] && command -v matugen >/dev/null; then
    matugen image "${WALLPAPER}" -m "${MODE}" >/dev/null 2>&1 || true
fi
DREAMCODER_THEME_MODE="${MODE}" DREAMCODER_WALLPAPER="${WALLPAPER}" \
    "${DREAMCODER_DOTS_DIR}/scripts/sync-dreamcoder-theme.py"
command -v pkill >/dev/null && pkill -SIGUSR1 kitty 2>/dev/null || true

# --- tmux integration: propagate theme to running sessions ---
KANAGAWA_DIR="${HOME}/.tmux/plugins/tmux-kanagawa"
if command -v tmux >/dev/null 2>&1 && tmux list-sessions &>/dev/null 2>&1; then
    # Update global environment so NEW panes/windows inherit the right vars
    tmux set-environment -g DREAMCODER_THEME_MODE "${MODE}" 2>/dev/null || true
    tmux set-environment -g COLORFGBG "${CLI_COLORFGBG}" 2>/dev/null || true

    # Switch tmux-kanagawa theme variant to match Dreamcoder mode
    if [[ -d "${KANAGAWA_DIR}" ]]; then
        case "${MODE}" in
            light)
                KANAGAWA_VARIANT="lotus"
                # Override default lotus colors with Dreamcoder Light palette
                tmux set-option -g @ukiyo-color-text    "#17120d" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-bg-bar  "#e6d7c4" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-bg-pane "#f3eadc" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-info    "#15516e" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-notice  "#a7471c" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-accent  "#824f16" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-muted   "#3d3228" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-error   "#842f24" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-alert   "#654300" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-highlight "#0f6570" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-selection "#c8ad89" 2>/dev/null || true
                # Restore default plugin color order (fg=bg_pane claro sobre bg=color)
                tmux set-option -gu "@ukiyo-git-colors"        2>/dev/null || true
                tmux set-option -gu "@ukiyo-cpu-usage-colors"  2>/dev/null || true
                tmux set-option -gu "@ukiyo-ram-usage-colors"  2>/dev/null || true
                ;;
            dark)
                KANAGAWA_VARIANT="dragon"
                # Dreamcoder Ember Noir OLED palette: fondos profundos, colores vibrantes
                tmux set-option -g @ukiyo-color-text    "#f0e7dc" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-bg-bar  "#1d1613" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-bg-pane "#15100d" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-accent  "#e6a15c" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-info    "#b8bf84" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-notice  "#d66f50" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-muted   "#c7b9aa" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-error   "#e98272" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-alert   "#e8b866" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-highlight "#e6a15c" 2>/dev/null || true
                tmux set-option -g @ukiyo-color-selection "#3e2c22" 2>/dev/null || true
                # Swap plugin color order: fg=bg_bar (oscuro) sobre bg=color vibrante
                tmux set-option -g @ukiyo-git-colors         "accent bg_bar"   2>/dev/null || true
                tmux set-option -g @ukiyo-cpu-usage-colors   "notice bg_bar"  2>/dev/null || true
                tmux set-option -g @ukiyo-ram-usage-colors   "info bg_bar"    2>/dev/null || true
                ;;
        esac
        tmux set-option -g @ukiyo-theme "kanagawa/${KANAGAWA_VARIANT}" 2>/dev/null || true
        # Reload plugin to apply new theme colors immediately
        bash "${KANAGAWA_DIR}/ukiyo.tmux" 2>/dev/null || true
    fi

    printf '  tmux environment and theme updated for %s mode\n' "${MODE}"
fi
# --- /tmux integration ---

printf '✓ Dreamcoder %s mode applied\n' "${MODE}"

# --- Post-sync: fix any stale symlinks ---
# Waybar colors.css, Rofi colors.rasi, and Hyprland colors.lua/colors.conf
# are written directly by sync-dreamcoder-theme.py (which runs AFTER matugen).
# Only Dunst needs a symlink check since its config is a plain file in the repo.
DOTS_DIR="${DREAMCODER_DOTS_DIR:-${HOME}/Documents/PROYECTOS/dreamcoder-dots}"
DUNST_CONF="${HOME}/.config/dunst/dreamcoder-dunst.conf"
if [[ -L "${DUNST_CONF}" ]]; then
    target=$(readlink "${DUNST_CONF}")
    case "${target}" in
        *dunst-dreamcoder-dark.conf|*dunst-dreamcoder-light.conf)
            ln -sf "${DOTS_DIR}/themes/dreamcoder/dunst-dreamcoder.conf" "${DUNST_CONF}"
            ;;
    esac
fi
