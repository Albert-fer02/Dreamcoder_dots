# Code Review Rules

## Shell Scripts
- Max 30 lines per file
- Use `set -euo pipefail` for scripts
- Quote all variables: `"${var}"`
- Use `[[ ]]` instead of `[ ]` for tests

## Modularity
- One file = one purpose
- No duplicate code (DRY)
- Conditional loading: `command -v x && ...`

## Safety
- Safe sourcing: `[[ -f "$file" ]] && source "$file"`
- No hardcoded paths
- Fallback chains for optional tools

## Naming
- Aliases: lowercase, short (`gs`, `pacupd`)
- Functions: snake_case (`smart_cd`, `mkcd`)
- Env vars: UPPER_CASE (`PROJECTS_DIR`)
