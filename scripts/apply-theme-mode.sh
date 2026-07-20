#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
MODE="${1:-light}"
WALLPAPER="${2:-${DREAMCODER_WALLPAPER:-}}"
ML4W_WALLPAPER="${ML4W_CACHE_DIR}/current_wallpaper"
[[ "${MODE}" == "light" || "${MODE}" == "dark" ]] || {
  printf 'Invalid mode: %s\n' "${MODE}" >&2
  exit 1
}
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
# --- Waybar: flip colors.css symlink to mode-specific variant BEFORE sync ---
# This ensures the Python sync writes to the correct variant file
# instead of overwriting the wrong one through a stale symlink.
WAYBAR_COLORS="${HOME}/.config/waybar/colors.css"
if [[ -L "${WAYBAR_COLORS}" ]]; then
  ln -sf "colors-${MODE}.css" "${WAYBAR_COLORS}"
fi
# --- Rofi: same treatment for colors.rasi symlink ---
ROFI_COLORS="${HOME}/.config/rofi/colors.rasi"
if [[ -L "${ROFI_COLORS}" ]]; then
  ln -sf "colors-${MODE}.rasi" "${ROFI_COLORS}"
fi
# --- Hyprland: flip colors.lua and colors.conf symlinks ---
HYPR_LUA="${HOME}/.config/hypr/colors.lua"
HYPR_CONF="${HOME}/.config/hypr/colors.conf"
if [[ -L "${HYPR_LUA}" ]]; then
  ln -sf "colors-${MODE}.lua" "${HYPR_LUA}"
fi
if [[ -L "${HYPR_CONF}" ]]; then
  ln -sf "colors-${MODE}.conf" "${HYPR_CONF}"
fi
# --- Hyprland: flip dreamcoder-colors.lua ---
HYPR_DC_LUA="${HOME}/.config/hypr/dreamcoder-colors.lua"
if [[ -L "${HYPR_DC_LUA}" ]]; then
  ln -sf "hypr-colors-${MODE}.lua" "${HYPR_DC_LUA}"
fi
# --- Kitty: flip colors-dreamcoder.conf and dreamcoder-ui.conf symlinks BEFORE sync ---
# This ensures the Python sync writes to the correct variant file
# instead of overwriting the wrong one through a stale symlink.
KITTY_DIR="${HOME}/.config/kitty"
if [[ -d "${KITTY_DIR}" ]]; then
  for _link in colors-dreamcoder.conf dreamcoder-ui.conf; do
    _target="${KITTY_DIR}/${_link}"
    if [[ -L "${_target}" ]]; then
      ln -sf "${_link%.conf}-${MODE}.conf" "${_target}"
    fi
  done
fi
# Ghostty uses native dual-mode (light:dreamcoder-light,dark:dreamcoder-dark)
# No symlink flipping needed — Ghostty auto-detects system theme
# --- Pi CLI: flip theme symlink ---
PI_SCRIPT="${DREAMCODER_DOTS_DIR}/DreamcoderPi/.pi/agent/scripts/pi-theme.sh"
if [[ -f "${PI_SCRIPT}" ]]; then
  DREAMCODER_THEME_MODE="${MODE}" bash "${PI_SCRIPT}" &>/dev/null || true
  printf '  pi theme switched to %s mode\n' "${MODE}"
fi

DREAMCODER_THEME_MODE="${MODE}" DREAMCODER_WALLPAPER="${WALLPAPER}" \
  PYTHONPATH="${DREAMCODER_DOTS_DIR}/src${PYTHONPATH:+:${PYTHONPATH}}" \
  "${DREAMCODER_DOTS_DIR}/scripts/sync-dreamcoder-theme.py"
command -v pkill >/dev/null && pkill -SIGUSR1 kitty 2>/dev/null || true
# Restart Waybar so it picks up the new colors.css immediately
if command -v pkill >/dev/null; then
  pkill waybar 2>/dev/null || true
  sleep 0.3
  "${HOME}/.config/waybar/launch.sh" 2>/dev/null || true
fi

# --- tmux integration: propagate theme to running sessions ---
KANAGAWA_DIR="${HOME}/.tmux/plugins/tmux-kanagawa"
if command -v tmux >/dev/null 2>&1; then
  # Start a headless server if none exists so options persist for new sessions
  if ! tmux list-sessions &>/dev/null 2>&1; then
    tmux start-server 2>/dev/null || true
    sleep 0.1
  fi
  # Update global environment so NEW panes/windows inherit the right vars
  tmux set-environment -g DREAMCODER_THEME_MODE "${MODE}" 2>/dev/null || true
  tmux set-environment -g COLORFGBG "${CLI_COLORFGBG}" 2>/dev/null || true

  # Switch tmux-kanagawa theme variant to match Dreamcoder mode
  # SOURCE OF TRUTH: colors MUST match DreamcoderThemes/dreamcoder/tokens.json
  # When updating tokens, update BOTH light AND dark sections here.
  if [[ -d "${KANAGAWA_DIR}" ]]; then
    case "${MODE}" in
    light)
      KANAGAWA_VARIANT="lotus"
      # Dreamcoder Light palette — source: tokens.json modes.light.{text,accent,error,...}
      tmux set-option -g @ukiyo-color-text "#17120d" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-bg-bar "#e6d7c4" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-bg-pane "#f3eadc" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-info "#0d4a68" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-notice "#a7471c" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-accent "#824f16" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-muted "#352e22" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-error "#842f24" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-alert "#654300" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-highlight "#0f6570" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-selection "#c8ad89" 2>/dev/null || true
      # Restore default plugin color order (fg=bg_pane claro sobre bg=color)
      tmux set-option -gu "@ukiyo-git-colors" 2>/dev/null || true
      tmux set-option -gu "@ukiyo-cpu-usage-colors" 2>/dev/null || true
      tmux set-option -gu "@ukiyo-ram-usage-colors" 2>/dev/null || true
      ;;
    dark)
      KANAGAWA_VARIANT="dragon"
      # Dreamcoder Anthracite Steel palette — source: tokens.json modes.dark.{text,accent,error,...}
      tmux set-option -g @ukiyo-color-text "#E6EDF3" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-bg-bar "#0D121A" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-bg-pane "#070A13" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-accent "#A5C7E8" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-info "#7CB3D9" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-notice "#8FAFCB" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-muted "#A8B5C2" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-error "#E69AA4" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-alert "#D9B36C" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-highlight "#A5C7E8" 2>/dev/null || true
      tmux set-option -g @ukiyo-color-selection "#202A35" 2>/dev/null || true
      # Swap plugin color order: fg=bg_bar (oscuro) sobre bg=color vibrante
      tmux set-option -g @ukiyo-git-colors "accent bg_bar" 2>/dev/null || true
      tmux set-option -g @ukiyo-cpu-usage-colors "notice bg_bar" 2>/dev/null || true
      tmux set-option -g @ukiyo-ram-usage-colors "info bg_bar" 2>/dev/null || true
      ;;
    esac
    tmux set-option -g @ukiyo-theme "kanagawa/${KANAGAWA_VARIANT}" 2>/dev/null || true
    # Reload plugin to apply new theme colors immediately
    bash "${KANAGAWA_DIR}/ukiyo.tmux" 2>/dev/null || true
  fi

  # Source standalone tmux theme (pane borders, mode, bell colors)
  # When kanagawa is active, skip status-bar lines to preserve kanagawa layout
  TMUX_THEME="${HOME}/.config/tmux/tmux-dreamcoder.conf"
  if [[ -f "${TMUX_THEME}" && ! -d "${KANAGAWA_DIR}" ]]; then
    tmux source-file "${TMUX_THEME}" 2>/dev/null || true
  elif [[ -f "${TMUX_THEME}" && -d "${KANAGAWA_DIR}" ]]; then
    # Kanagawa active: only source color lines, skip status-bar layout
    grep -vE '^(set -g status-(left|right|position|interval|justify)|setw -g window-status-(format|current-format|separator))' \
      "${TMUX_THEME}" | tmux source-file /dev/stdin 2>/dev/null || true
  fi

  printf '  tmux environment and theme updated for %s mode\n' "${MODE}"
fi
# --- /tmux integration ---

# --- Herdr: switch config symlink + reload ---
HERDR_SCRIPT="${DREAMCODER_DOTS_DIR}/scripts/herdr-theme-switch.sh"
if [[ -f "${HERDR_SCRIPT}" ]]; then
  bash "${HERDR_SCRIPT}" "${MODE}"
  printf '  herdr theme switched to %s mode\n' "${MODE}"
fi
# --- /Herdr ---

printf '✓ Dreamcoder %s mode applied\n' "${MODE}"

# --- Post-sync: fix any stale symlinks ---
# Waybar colors.css, Rofi colors.rasi, and Hyprland colors.lua/colors.conf
# are written directly by sync-dreamcoder-theme.py (which runs AFTER matugen).
# Only Dunst needs a symlink check since its config is a plain file in the repo.
DOTS_DIR="${DREAMCODER_DOTS_DIR:-${HOME}/Documents/PROYECTOS/dreamcoder-dots}"
DUNST_CONF="${HOME}/.config/dunst/dreamcoder-dunst.conf"
WARP_THEME="${HOME}/.local/share/warp-terminal/themes/Dreamcoder.yaml"
WARP_VARIANT="${DOTS_DIR}/DreamcoderWarp/.local/share/warp-terminal/themes/Dreamcoder-${MODE^}.yaml"

if [[ -L "${DUNST_CONF}" ]]; then
  target=$(readlink "${DUNST_CONF}")
  case "${target}" in
  *dunst-dreamcoder-dark.conf | *dunst-dreamcoder-light.conf)
    ln -sf "${DOTS_DIR}/DreamcoderThemes/dreamcoder/dunst-dreamcoder.conf" "${DUNST_CONF}"
    ;;
  esac
fi

# Warp: flip active theme symlink to mode-specific variant
[[ -f "${WARP_VARIANT}" ]] && ln -sf "${WARP_VARIANT}" "${WARP_THEME}"

# Btop: flip theme symlink to mode-specific variant
BTOP_THEME="${HOME}/.config/btop/themes/dreamcoder.theme"
if [[ -L "${BTOP_THEME}" ]]; then
  ln -sf "dreamcoder-${MODE}.theme" "${BTOP_THEME}"
fi

# Zellij: update theme in config.kdl
ZELLIJ_CONF="${HOME}/.config/zellij/config.kdl"
if [[ -f "${ZELLIJ_CONF}" ]]; then
  sed -i "s/^theme \".*\"/theme \"dreamcoder-${MODE}\"/" "${ZELLIJ_CONF}"
fi
