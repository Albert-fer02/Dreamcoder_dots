# Phase 2 — Quality: Coverage, Type Safety, Shell Quality, CI Hardening

> **Status:** Draft
> **Phase:** 2 of 4 (Foundation → **Quality** → Documentation → Polish)

## Overview

Phase 1 established the monorepo foundation (layout, tooling, pre-commit).
Phase 2 makes quality tooling *enforceable*: Mypy strict passes, coverage
reaches 80%+, shell scripts are tested and lint-free, and CI blocks on
regressions.

## Scope

### S1 — Mypy Strict (79 errors → 0)

**Goal:** `mypy src/` exits 0 with `strict=true`.

79 errors across 6 files:

| File | Error count | Dominant codes |
|---|---|---|
| `src/dreamcoder_theme/sync.py` | ~30 | `no-untyped-def`, `no-untyped-call`, `arg-type` |
| `src/dreamcoder_theme/cli_parser.py` | ~15 | `no-untyped-def`, `no-untyped-call` |
| `src/dreamcoder_theme/renderers_extra_nvim_syntax.py` | ~8 | `no-untyped-def` |
| `src/dreamcoder_theme/renderers_extra_nvim_lsp.py` | ~8 | `no-untyped-def` |
| `src/dreamcoder_theme/renderers_extra_nvim_ui.py` | ~10 | `no-untyped-def`, `return-value` |
| `src/dreamcoder_theme/renderers_extra_nvim_plugins.py` | ~8 | `no-untyped-def` |

**Rules:**
- Do NOT add `# type: ignore` at module level or on whole functions.
- Add missing type annotations for parameters and return types.
- Use `list[str]`, `dict[str, str]`, `Any` only when type is truly dynamic.
- For `subprocess.run()` calls: use `capture_output=True` instead of
  `stdout=subprocess.PIPE, stderr=subprocess.PIPE`.
- No changes to public API signatures of previously typed functions.

### S2 — Coverage 80%+

**Goal:** `pytest --cov=dreamcoder_theme --cov-fail-under=80` passes.

**Fix coverage tracking:**
- `pyproject.toml`: `[tool.coverage.run]` → `source = ["src/dreamcoder_theme"]`
  (currently `["dreamcoder_theme"]` which resolves differently with `src/` layout)
- Verify `conftest.py` injects `src/` into `sys.path`

**Target untested modules (0% coverage):**

| Module | Lines | Priority |
|---|---|---|
| `sync.py` | 102 | High — core orchestration |
| `tui.py` | 36 | Low — interactive TUI (ui_test) |
| `visual_regression.py` | 32 | Low — visual diff (ui_test) |
| `writers.py` | 142 | High — file I/O functions |
| `audit.py` | 80 | Medium — health reporting |
| `cli_parser.py` | 150 | Medium — argument parsing |

**Priority:** Write tests for `sync.py` and `writers.py` first (highest ROI).
`tui.py` and `visual_regression.py` can be deferred if interactive.

**Coverage floor:** `fail_under = 80` in pyproject.toml.
Existing modules must maintain their current coverage level.

### S3 — Shell Quality

**Goal:** `shellcheck --shell=bash scripts/*.sh` exits 0, bats tests exist.

**Fix 8 shellcheck warnings:**

| Code | Count | File(s) | Fix |
|---|---|---|---|
| SC2015 | 4 | doctor.sh, verify.sh, dreamcoder-maintenance.sh | Replace `A && B || C` with `if A; then B; else C; fi` |
| SC2034 | 2 | dreamcoder-lib.sh | Add `export` or `# shellcheck disable=SC2034` with justification |
| SC1090 | 2 | theme-auto.sh, install-dreamcoder-hooks.sh | Add `# shellcheck source=...` directive or refactor |

**Bats tests:**
- Fix `shell-tests/test_helper.bash` if needed (Phase 1 scaffolding)
- Write tests for: `scripts/doctor.sh --help`, `scripts/verify.sh`,
  `scripts/repair.sh --help`, `scripts/status.sh`
- Run: `bats shell-tests/`
- Add to CI

### S4 — CI Hardening

**Goal:** CI blocks on quality regressions.

**Current CI** (`.github/workflows/theme-validation.yml`):
- Runs pytest on 3.11 + 3.12
- `continue-on-error: true` on tests (workaround for pre-existing failure)
- Theme health check + preview generation
- PyPI publish on tags

**Add to CI:**
```yaml
- name: Lint (Ruff)
  run: ruff check src/ tests/

- name: Format check (Ruff)
  run: ruff format --check src/ tests/

- name: Type check (Mypy)
  run: mypy src/

- name: Shellcheck
  run: find scripts/ -name '*.sh' -exec shellcheck --shell=bash {} +

- name: Coverage
  run: python -m pytest tests/ --cov=dreamcoder_theme --cov-fail-under=80
```

**Changes:**
- Remove `continue-on-error` from test step (once the pre-existing README test
  is fixed or the assertion updated)
- All new quality steps use `continue-on-error: false` (fail CI on violation)
- Keep Python matrix (3.11, 3.12)

### Out of scope

- Ruff warnings (PLR2004, N806, F841, etc.): Phase 3 or 4, cosmetic/style
- bats for ALL shell scripts: target the 4 key scripts only
- `tui.py` / `visual_regression.py` coverage: deferred to Phase 3 if still needed

## Architecture

No structural changes. Phase 2 is purely additive (annotations, tests, CI steps).

## Testing

- `pytest tests/` — 78+ tests pass (1 pre-existing README failure fixed)
- `mypy src/` — 0 errors
- `shellcheck --shell=bash scripts/*.sh` — 0 warnings
- `ruff check src/ tests/` — same 60 pre-existing warnings (no regressions)
- `ruff format --check src/ tests/` — clean
- `bats shell-tests/` — all pass

## Risks

- **Mypy strict on `sync.py`**: heaviest annotation lift. If too risky,
  split into smaller PR or add targeted `# type: ignore` with TODOs.
- **Coverage 80%**: `writers.py` is 142 lines of file I/O — testing may
  require temp directories and mocking. Manageable.
- **CI hardening**: the pre-existing README test failure must be fixed
  before removing `continue-on-error`. Options: (a) update the assertion,
  (b) remove the test, (c) fix README to include the expected link.

## Compliance

- `mypy src/` must pass before merge
- `pytest --cov=dreamcoder_theme --cov-fail-under=80` must pass before merge
- `shellcheck --shell=bash` must pass for all `scripts/*.sh` before merge
- `ruff check src/ tests/` must not introduce new warnings
- `ruff format --check src/ tests/` must pass before merge
