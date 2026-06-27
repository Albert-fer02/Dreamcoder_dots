# Phase 2 — Quality Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task.

**Goal:** Make quality tooling enforceable — Mypy strict passes, coverage 80%+, shell scripts lint-free and tested, CI blocks on regressions.

**Architecture:** Purely additive work (annotations, tests, CI steps). No structural changes.

**Tech Stack:** Python 3.11+, Mypy strict, pytest-cov, bats (for shell), shellcheck

## Global Constraints

- `mypy src/` must exit 0 with `strict=true` (no `# type: ignore[override]` or module-level ignores)
- Coverage: `pytest --cov=dreamcoder_theme --cov-fail-under=80` must pass
- `shellcheck --shell=bash scripts/*.sh` must exit 0
- `ruff check src/ tests/` must not introduce new warnings
- `ruff format --check src/ tests/` must pass
- All existing tests must continue passing (78 pass, fix the 1 pre-existing README failure)

---
**Current baseline (Phase 1 complete, 14 commits ahead of origin/main):**
- Mypy: 79 errors in 6 files
- Coverage: ~7% (tracking broken with `src/` layout)
- Shellcheck: 8 warnings (SC2015×4, SC2034×2, SC1090×2)
- CI: tests with `continue-on-error`, no quality checks

### Task 1: Mypy — annotate nvim renderers (4 files)

**Files:**
- Modify: `src/dreamcoder_theme/renderers_extra_nvim_syntax.py`
- Modify: `src/dreamcoder_theme/renderers_extra_nvim_lsp.py`
- Modify: `src/dreamcoder_theme/renderers_extra_nvim_ui.py`
- Modify: `src/dreamcoder_theme/renderers_extra_nvim_plugins.py`

**Approach:** Add missing parameter and return type annotations. All functions return `list[str]` or `None`. Parameters are typed as `Hl`, `dict[str, str]`, `str`. Add overloaded signatures where needed.

**Verify:** `mypy src/` — errors in these 4 files should drop to ~0 (currently ~36 total)

**Commit:** `git commit -m "fix: add type annotations to nvim renderer modules"`

### Task 2: Mypy — annotate cli_parser.py

**Files:**
- Modify: `src/dreamcoder_theme/cli_parser.py`

**Approach:** Add type annotations to `build_parser()` and all subparser builder functions. Return type is `argparse.ArgumentParser`. Fix any `no-untyped-call` issues within the file.

**Verify:** `mypy src/` — errors in cli_parser.py should drop to ~0 (currently ~15)

**Commit:** `git commit -m "fix: add type annotations to cli_parser"`

### Task 3: Mypy — annotate sync.py

**Files:**
- Modify: `src/dreamcoder_theme/sync.py`

**Approach:** Add type annotations for all function parameters and return types. Fix `subprocess.run()` calls to use `capture_output=True`. Fix `union-attr` issues with proper `isinstance()` checks or assert. Heaviest annotation lift (~30 errors).

**Verify:** `mypy src/` — clean (0 errors)

**Commit:** `git commit -m "fix: add type annotations to sync module"`

### Task 4: Coverage — fix tracking + test writers.py

**Files:**
- Modify: `pyproject.toml: [tool.coverage.run] source`
- Create: `tests/test_dreamcoder_writers.py`
- Modify: `shell-tests/test_helper.bash` (if needed)

**Approach:**
1. Fix `pyproject.toml` coverage source: change `source = ["dreamcoder_theme"]` to `source = ["src/dreamcoder_theme"]`
2. Write tests for `writers.py` covering: `write_if_changed`, `valid_starship`, `write_variant_files`, `cleanup_opencode_themes`, `ensure_codex_theme_config`
3. Use `tmp_path` fixture for file I/O testing

**Verify:** `pytest tests/test_dreamcoder_writers.py -v` — all pass; `pytest --cov=dreamcoder_theme` — coverage increases

**Commit:** `git commit -m "feat: add tests for writers module and fix coverage tracking"`

### Task 5: Coverage — test sync.py + audit.py

**Files:**
- Create: `tests/test_dreamcoder_sync.py`
- Create: `tests/test_dreamcoder_audit.py` (extend existing or create focused tests)

**Approach:**
1. Test `sync.py`: mock file system state, verify `main()` flows, test variant loading, test theme path resolution
2. Test `audit.py`: test `catalog_repairs()`, `assess_dreamcoder_health()` with controlled inputs

**Verify:** `pytest tests/test_dreamcoder_sync.py tests/test_dreamcoder_audit.py -v` — all pass; coverage reaches ~50%+

**Commit:** `git commit -m "feat: add tests for sync and audit modules"`

### Task 6: Shell — fix shellcheck warnings

**Files:**
- Modify: `scripts/doctor.sh`
- Modify: `scripts/verify.sh`
- Modify: `scripts/dreamcoder-maintenance.sh`
- Modify: `scripts/dreamcoder-lib.sh`
- Modify: `scripts/theme-auto.sh`
- Modify: `scripts/install-dreamcoder-hooks.sh`

**Approach:**
1. SC2015 (×4): Replace `A && B || C` with explicit `if A; then B; else C; fi` in doctor.sh, verify.sh, dreamcoder-maintenance.sh
2. SC2034 (×2): In dreamcoder-lib.sh, add `export DREAMCODER_MODULES` or add `# shellcheck disable=SC2034` with comment explaining the variable is used by sourcing scripts
3. SC1090 (×2): In theme-auto.sh and install-dreamcoder-hooks.sh, add `# shellcheck source=...` with the known relative path to the sourced file

**Verify:** `shellcheck --shell=bash scripts/*.sh scripts/dreamcoder` — 0 warnings

**Commit:** `git commit -m "fix: resolve shellcheck warnings (SC2015, SC2034, SC1090)"`

### Task 7: Shell — bats tests

**Files:**
- Modify: `shell-tests/test_helper.bash`
- Create: `shell-tests/test_doctor.bats`
- Create: `shell-tests/test_verify.bats`
- Create: `shell-tests/test_repair.bats`
- Create: `shell-tests/test_status.bats`

**Approach:**
1. Ensure `test_helper.bash` correctly loads scripts using `load` or `source`
2. Write bats tests for `doctor.sh --help`, `verify.sh` (dry-run), `repair.sh --help`, `status.sh` (help/usage)
3. Each test: run the script with expected args, check output for expected strings

**Verify:** `bats shell-tests/` — all pass

**Commit:** `git commit -m "feat: add bats tests for shell scripts"`

### Task 8: CI hardening + README fix

**Files:**
- Modify: `.github/workflows/theme-validation.yml`
- Modify: `README.md` (or fix the test assertion)

**Approach:**
1. Add quality check steps to CI: ruff check, ruff format --check, mypy, shellcheck, coverage
2. Remove `continue-on-error` from test step
3. Fix the pre-existing README test failure: either update the test assertion or add the expected link to README (simpler: update the test to match current README)

**Verify:** CI workflow file is valid YAML

**Commit:** `git commit -m "ci: add quality checks and fix README test"`

---

## Verification

After all tasks:
```bash
make lint          # ruff check + ruff format --check + shellcheck + mypy
make test          # pytest — 79 pass (fixed README test)
make coverage      # pytest --cov=dreamcoder_theme — 80%+
bats shell-tests/  # all pass
```

## Rollback

Each task is a single commit. To roll back: `git revert <commit>` for that task's changes.
