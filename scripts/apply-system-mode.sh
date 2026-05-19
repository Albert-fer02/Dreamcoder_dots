#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-light}"
GTK3="${XDG_CONFIG_HOME:-${HOME}/.config}/gtk-3.0/settings.ini"
GTK4="${XDG_CONFIG_HOME:-${HOME}/.config}/gtk-4.0/settings.ini"
[[ "${MODE}" == "dark" ]] && GTK3_VALUE="1" || GTK3_VALUE="0"
[[ "${MODE}" == "dark" ]] && GTK4_VALUE="true" || GTK4_VALUE="false"
[[ "${MODE}" == "dark" ]] && SCHEME="prefer-dark" || SCHEME="prefer-light"

set_gtk_key() {
    local file="${1}" key="${2}" value="${3}"
    mkdir -p "$(dirname "${file}")"
    [[ -f "${file}" ]] || printf '[Settings]\n' >"${file}"
    if grep -q "^${key}=" "${file}"; then
        sed -i "s/^${key}=.*/${key}=${value}/" "${file}"
    else
        printf '%s=%s\n' "${key}" "${value}" >>"${file}"
    fi
}

set_gtk_key "${GTK3}" "gtk-application-prefer-dark-theme" "${GTK3_VALUE}"
set_gtk_key "${GTK4}" "gtk-application-prefer-dark-theme" "${GTK4_VALUE}"
command -v gsettings >/dev/null && gsettings set org.gnome.desktop.interface color-scheme "${SCHEME}" || true
