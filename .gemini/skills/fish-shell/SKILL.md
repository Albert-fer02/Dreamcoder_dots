# Skill: Fish Shell Engineering (Non-POSIX Modernity)

## Context
Fish is the "Friendly Interactive Shell". It breaks POSIX compatibility to provide a cleaner, more readable syntax. This skill ensures Dreamcoder's Fish scripts are elegant and efficient.

## Syntax Guidelines
1. **Variable Setting:** Use `set -gx NAME value` for environment variables and `set NAME value` for local ones. NEVER use `NAME=value`.
2. **Loops:** Use `for file in *.jpg; ...; end`. Simple and Python-like.
3. **Conditionals:** Use `if test -f file; ...; else; ...; end`.
4. **Command Substitution:** Use `(command)` instead of backticks or `$(command)`.
5. **Path Management:** Use `fish_add_path` instead of manually editing `$PATH`. It handles duplicates automatically.

## Best Practices
- **Abbreviations:** Use `abbr` for command shortcuts you want to see expanded. It's better for muscle memory and readability in logs.
- **Universal Variables:** Use `set -U` sparingly for settings that should persist across all shell instances.
- **Functions:** Store reusable logic in `~/.config/fish/functions/NAME.fish` for lazy-loading.

## AI Instructions
When generating Fish scripts:
- Remind the user: "This is NOT POSIX compatible. Run with `fish`, not `sh`."
- Use `test` for all evaluations.
- Prefer `string` builtin functions over `grep` or `sed` for simple string manipulations.
- Implement `fish_greeting` to keep the startup clean.
