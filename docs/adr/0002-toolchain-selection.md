# ADR-002: Python and Shell Quality Toolchain

## Status

Accepted

## Context

The project had no standardized linting, formatting, or type checking. Shell
scripts had no static analysis. This led to inconsistent code style and
preventable bugs.

## Decision

### Python — Ruff (linter + formatter)

We replace the implicit flake8/isort/pyupgrade combination with Ruff:
- **Why**: Ruff is 10-100x faster, replaces multiple tools, has built-in
  formatter compatible with Black, and is configured entirely in
  `pyproject.toml`
- **Level**: E, F, I, N, W, UP, YTT, ASYNC, SIM, PL, RUF
- **Line length**: 100
- **Formatter**: Built-in `ruff format` (compatible with Black)

### Python — Mypy (type checker)

We adopt Mypy in strict mode:
- **Why**: Catches type errors before runtime, documents interfaces,
  enables safer refactoring
- **Level**: Strict (`strict = true`)
- **Overrides**: PyQt6 gets `ignore_missing_imports = true` (no stubs available)

### Shell — shellcheck

We adopt shellcheck for all shell scripts:
- **Why**: Industry standard, catches common shell scripting bugs
- **Level**: `style` (most thorough)
- **Disabled**: SC3043 (`local` — we target bash, not POSIX sh)

### Pre-commit integration

All tools run as pre-commit hooks on every commit, providing fast feedback.

## Consequences

Positive:
- Consistent code style enforced automatically
- Type errors caught in CI instead of production
- Shell scripts get the same quality bar as Python code

Negative:
- Initial migration: Ruff may flag existing code (fixed automatically where possible)
- Mypy strict mode will report errors in existing code (addressed in Phase 2)
- All contributors must have these tools installed (pre-commit handles this)

## Compliance

- `ruff check` must pass before merge
- `ruff format --check` must pass before merge
- `mypy` must pass before merge (Phase 2 target — currently advisory)
- `shellcheck --shell=bash` must pass for all `.sh` files in `scripts/`

## Alternatives Considered

- **Black** as formatter: Rejected in favor of Ruff's built-in formatter
  (compatible, fewer dependencies)
- **Pyright/Pylance**: Rejected in favor of Mypy (more widely adopted community
  standard for open-source Python)
- **Flake8 + isort**: Rejected in favor of Ruff (single tool, faster)
