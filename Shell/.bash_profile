set -euo pipefail
export TERM="${TERM:-xterm-256color}"
BASHRC="${HOME}/.bashrc"
CARGO_ENV="${HOME}/.cargo/env"
LOCAL_BIN="${HOME}/.local/bin"
if [[ ":${PATH}:" != *":${LOCAL_BIN}:"* ]]; then
    export PATH="${LOCAL_BIN}:${PATH}"
fi
if [[ "${-}" == *i* ]]; then
    [[ -f "${BASHRC}" ]] && source "${BASHRC}"
fi
[[ -f "${CARGO_ENV}" ]] && source "${CARGO_ENV}"
