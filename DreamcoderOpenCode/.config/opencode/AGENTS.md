# Dreamcoder Dots — AI Agent Skills

## Code Review Rules

### Shell Scripts

- Max 30 lines per file
- Use `set -euo pipefail` for scripts
- Quote all variables: `"${var}"`
- Use `[[ ]]` instead of `[ ]` for tests

### Modularity

- One file = one purpose
- No duplicate code (DRY)
- Conditional loading: `command -v x && ...`

### Safety

- Safe sourcing: `[[ -f "$file" ]] && source "$file"`
- No hardcoded paths
- Fallback chains for optional tools

### Naming

- Aliases: lowercase, short (`gs`, `pacupd`)
- Functions: snake_case (`smart_cd`, `mkcd`)
- Env vars: UPPER_CASE (`PROJECTS_DIR`)

## Available Skills

| Skill                       | Description                                     | Path                                                  |
| --------------------------- | ----------------------------------------------- | ----------------------------------------------------- |
| `dreamcoder-theme-engine`   | Python theme engine: tokens, renderers, writers | [SKILL.md](skills/dreamcoder-theme-engine/SKILL.md)   |
| `dreamcoder-palette-tokens` | Token schema, WCAG/APCA guardrails, modes       | [SKILL.md](skills/dreamcoder-palette-tokens/SKILL.md) |

## Auto-invoke

When working on these areas, load the corresponding skill first:

- Theme engine / renderers → `dreamcoder-theme-engine`
- Colors / tokens → `dreamcoder-palette-tokens`
- Shell scripts → use code review rules above
