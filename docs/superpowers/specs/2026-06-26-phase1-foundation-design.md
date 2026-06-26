# Phase 1 — Foundation: Monorepo Restructure & Quality Tooling

**Date:** 2026-06-26
**Status:** Approved
**Project:** dreamcoder-dots

---

## Overview

Phase 1 establishes the structural and quality foundation for the dreamcoder-dots monorepo. It restructures the layout so the project follows Python packaging conventions, configs quality tooling across Python and shell, sets up EditorConfig, ADRs, and polishes the pre-commit and Makefile.

---

## S1 — Monorepo Layout Restructure

### Current problems

- `dreamcoder_theme` lives under `scripts/`, which is atypical for a pip-installable Python package
- Shell scripts are mixed with Python code in `scripts/`
- No clear separation between tests, source, and tooling
- `pyproject.toml` references the old layout

### New layout

```
dreamcoder-dots/
├── src/
│   └── dreamcoder_theme/     # moved from scripts/
│       ├── __init__.py
│       ├── cli/
│       ├── core/
│       ├── plugins/
│       ├── services/
│       ├── ui/
│       └── utils/
├── scripts/                  # shell scripts only
│   ├── bspwm/                # grouped by topic
│   ├── polybar/
│   ├── setup/
│   └── utils/
├── tests/                    # Python tests
│   ├── conftest.py
│   ├── test_theme.py
│   ├── test_plugins/
│   └── test_cli/
├── shell-tests/              # bats tests for shell scripts
│   ├── test_helper.bash
│   └── test_*.bats
├── pyproject.toml            # [project] points to src/
├── Makefile
├── .pre-commit-config.yaml
├── .editorconfig
├── .shellcheckrc
├── docs/
│   ├── adr/                  # Architecture Decision Records
│   └── superpowers/specs/    # Design docs
└── ...
```

### Key decisions

- `pyproject.toml` uses `[project]` with `package-dir` or `src` as source root
- All shell scripts in `scripts/` get a `.sh` extension where missing
- `shell-tests/` keeps bats tests isolated from Python tests
- No code changes inside the moved files — pure structural move

---

## S2 — Python Quality Tooling

### Current problems

- No linter/formatter standardization (likely flake8/isort manually)
- No type checking
- Inconsistent formatting

### Solution

| Tool | Role | Config |
|---|---|---|
| **Ruff** | Linter + formatter | `pyproject.toml` under `[tool.ruff]` |
| **Mypy** | Static type checker | `pyproject.toml` under `[tool.mypy]` |

### Ruff config

- `target-version = "py311"`
- `line-length = 100`
- Select: `E`, `F`, `I`, `N`, `W`, `UP`, `YTT`, `ASYNC`, `SIM`, `PL`, `RUF`
- `ignore = ["E501"]` (we use line-length instead)
- Formatter enabled via `ruff format`

### Mypy config

- `strict = true`
- `python_version = "3.11"`
- Override for PyQt6 stubs: `ignore-missing-imports` on `PyQt6.*`
- Follow imports enabled for incremental checking

### Pre-commit integration

Both tools run as pre-commit hooks: `ruff check`, `ruff format --check`, `mypy`.

---

## S3 — Shell Quality Tooling

### Current problems

- 42 shell scripts with no linting
- No consistent style
- Common shellcheck warnings (SC3043 — `local` in POSIX)

### Solution

| Tool | Role | Config |
|---|---|---|
| **shellcheck** | Static analysis | `.shellcheckrc` + pre-commit |

### shellcheck config

- Level: `style`
- `.shellcheckrc`: `disable=SC3043` (we use `local` in bash scripts)
- Pre-commit hook runs on `scripts/**/*.sh`

### EditorConfig for shell

```ini
[*.sh]
indent_style = space
indent_size = 2
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
```

---

## S4 — EditorConfig, ADRs, Pre-commit Polish

### EditorConfig

Root `.editorconfig` covering:
- `[*]` — global rules (utf-8, trim trailing, final newline)
- `[*.py]` — indent 4 spaces
- `[*.sh]` — indent 2 spaces
- `[*.{yml,yaml}]` — indent 2 spaces
- `[Makefile]` — indent_style = tab

### ADR tooling

- Use `adr-tools` from AUR (`sudo pacman -S adr-tools`)
- Directory: `docs/adr/`
- ADR-001: **Project structure layout** — documents the monorepo layout decisions
- ADR-002: **Toolchain selection** — documents Ruff, Mypy, shellcheck choices

### Pre-commit full config

| Hook | ID | Stages |
|---|---|---|
| Ruff check | `ruff check` | pre-commit |
| Ruff format | `ruff format --check` | pre-commit |
| Mypy | `mypy` | pre-commit |
| shellcheck | `shellcheck` | pre-commit |
| check-yaml | `check-yaml` | pre-commit |
| end-of-file-fixer | `end-of-file-fixer` | pre-commit |
| trailing-whitespace | `trailing-whitespace` | pre-commit |

### Makefile targets

```makefile
lint: python-lint shell-lint type-check
python-lint: ruff-check ruff-format
shell-lint: shellcheck
type-check: mypy
format: ruff-format
adr:        # list ADRs
```

---

## Files to change

| Action | File |
|---|---|
| Move | `scripts/dreamcoder_theme/` → `src/dreamcoder_theme/` |
| Modify | `pyproject.toml` — add ruff, mypy, src layout |
| Create | `.pre-commit-config.yaml` |
| Create | `.editorconfig` |
| Create | `.shellcheckrc` |
| Create | `docs/adr/0001-project-structure.md` |
| Create | `docs/adr/0002-toolchain-selection.md` |
| Create | `tests/conftest.py` |
| Create | `shell-tests/test_helper.bash` |
| Modify | `Makefile` — add lint, format, type-check targets |
| Modify | `.gitignore` — add `src/dreamcoder_theme.egg-info/` |

## Non-goals

- No code changes to `dreamcoder_theme` internals (Phase 2)
- No shell script rewrites (Phase 2)
- No CI/CD changes (Phase 4)
- No bats tests beyond scaffolding (Phase 2)
