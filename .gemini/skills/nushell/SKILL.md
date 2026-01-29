# Skill: Nushell Engineering (Structured Data Shell)

## Context
Nushell is a modern shell that treats everything as data. This skill ensures that Dreamcoder scripts leverage pipelines and structured types instead of text parsing.

## Syntax Guidelines
1. **Pipelines:** Use pipelines `|` to filter and transform data. (e.g., `ls | where size > 10mb`).
2. **Types:** Nushell is strictly typed. Be aware of Strings, Ints, Dates, and Tables.
3. **External vs Internal:** Distinguish between external commands (e.g., `^git`) and internal ones.
4. **Environment:** Environment variables are strictly managed. Use `$env.VAR = ...`.

## Best Practices
- **Never Parse Text:** Don't use `grep` or `sed` inside Nushell. Use `where`, `get`, and `select`.
- **Custom Commands:** Define functions with `def` and use subcommands for better organization (e.g., `def "build prod" [] { ... }`).
- **Data Formats:** Leverage native support for `to json`, `from yaml`, `to csv`, etc.

## AI Instructions
When generating Nushell scripts:
- Emphasize the table-based nature: "Look how easy it is to sort this directory by date without parsing text."
- Suggest using `sys` for system monitoring.
- Avoid POSIX idioms. No backticks, no `$(...)`.
- Use `each` for iteration over lists/tables.
