# ADR-001: Monorepo Project Structure Layout

## Status

Accepted

## Context

The dreamcoder-dots repository started as a personal dotfiles collection and
grew organically. The main Python package `dreamcoder_theme` lived inside
`scripts/`, which doesn't follow standard Python packaging conventions. Shell
scripts were mixed with Python code, and there was no clear separation between
source code, tests, and tooling.

## Decision

We restructure the repository to follow a standard monorepo layout:

```
src/                    # Python source packages
  dreamcoder_theme/     # Main theme engine package
scripts/                # Shell scripts only
tests/                  # Python tests
shell-tests/            # bats tests for shell scripts
docs/                   # Documentation
  adr/                  # Architecture Decision Records
  superpowers/          # Design docs and implementation plans
```

Key decisions:
- Python package moves from `scripts/` to `src/` following PEP 517/518
- All shell scripts use `.sh` extension for consistent tooling
- `pyproject.toml` is the single source of truth for Python config
- Tool config (Ruff, Mypy, shellcheck) lives in `pyproject.toml` or root dotfiles

## Consequences

Positive:
- Standard Python packaging layout (pip, build, setuptools all work correctly)
- Clear separation of concerns at the directory level
- Tooling can target specific directories without exclusion lists

Negative:
- Existing imports or scripts that reference `scripts/dreamcoder_theme/` will
  break until updated (none should, since it's installed as a package)
- Any hardcoded paths in CI/CD need updating

## Compliance

- `pyproject.toml` must point `[tool.setuptools.packages.find]` to `src/`
- All new Python packages must live under `src/`
- Shell scripts must live under `scripts/` with `.sh` extension
