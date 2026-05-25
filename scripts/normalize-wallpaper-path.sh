#!/usr/bin/env bash
set -euo pipefail

RAW="${1:-}"
PATH_VALUE="${RAW#file://}"
PATH_VALUE="${PATH_VALUE#\'}"
PATH_VALUE="${PATH_VALUE%\'}"
PATH_VALUE="${PATH_VALUE#\"}"
PATH_VALUE="${PATH_VALUE%\"}"
PATH_VALUE="${PATH_VALUE//\\ / }"

case "${PATH_VALUE}" in
    \~/*) PATH_VALUE="${HOME}/${PATH_VALUE#"~/"}" ;;
esac

if [[ ! -f "${PATH_VALUE}" ]]; then
    ALT="${HOME}/Pictures/wallpapers/$(basename "${PATH_VALUE}")"
    [[ -f "${ALT}" ]] && PATH_VALUE="${ALT}"
fi

printf '%s\n' "${PATH_VALUE}"
