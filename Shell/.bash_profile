set -euo pipefail
export TERM="${TERM:-xterm-256color}"
BASHRC="${HOME}/.bashrc"
CARGO_ENV="${HOME}/.cargo/env"
if [[ "${-}" == *i* ]]; then
    [[ -f "${BASHRC}" ]] && source "${BASHRC}"
fi
[[ -f "${CARGO_ENV}" ]] && source "${CARGO_ENV}"
