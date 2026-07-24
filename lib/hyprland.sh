#!/usr/bin/env bash
# ── Dreamcoder Dots — Hyprland / ML4W Utilities ─────────────────────
set -euo pipefail

reload_hyprland() {
    if optional_command hyprctl; then
        hyprctl reload >/dev/null 2>&1 || true
    fi
}

restart_waybar() {
    if is_gui_session && optional_command pkill; then
        pkill waybar 2>/dev/null || true
        sleep 0.3
        local launch_script="${HOME}/.config/waybar/launch.sh"
        [[ -f "${launch_script}" ]] && "${launch_script}" 2>/dev/null || true
    fi
}

signal_kitty() {
    if is_gui_session && optional_command pkill; then
        pkill -SIGUSR1 kitty 2>/dev/null || true
    fi
}
