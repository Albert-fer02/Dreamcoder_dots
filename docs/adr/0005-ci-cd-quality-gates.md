# ADR-005: CI/CD Quality Gates

## Status

Accepted

## Context

The project needed automated quality enforcement after every change. Without
CI/CD, code could be merged with lint errors, type errors, failing tests,
or low coverage — all of which were previously caught only during ad-hoc
manual review.

## Decision

### CI Pipeline — GitHub Actions

One workflow (`theme-validation.yml`) handles both CI checks and CD publishing:

### Triggers

- **Push** to `main` — full CI run
- **Pull request** against `main` — full CI run
- **Tag push** `v*` — CI + PyPI publish

### Checks (run in order)

| # | Check | Tool | Comment |
|---|-------|------|---------|
| 1 | Lint | `ruff check src/ tests/` | Blocks on any violation |
| 2 | Format | `ruff format --check src/ tests/` | Blocks on style drift |
| 3 | Types | `mypy src/` | Strict mode, blocks on errors |
| 4 | Shell | `shellcheck --shell=bash scripts/*.sh` | Blocks on any warning |
| 5 | Tests | `pytest tests/ -v --tb=short` | Blocks on failures |
| 6 | Coverage | `pytest --cov=dreamcoder_theme --cov-fail-under=40` | Blocks below 40% |
| 7 | Theme health | `verify-theme-health.py` | Advisory only |
| 8 | Theme preview | `generate-theme-preview.py` | Advisory only |
| 9 | Uncommitted diff | `git diff --exit-code` | Advisory; warns if preview stale |

### Python version matrix

Tests run on Python 3.11 and 3.12 to ensure compatibility.

### CD — PyPI Publishing

When a tag matching `v*` is pushed:

1. All CI checks pass first (`needs: [test]`)
2. Package is built with `python -m build`
3. Published to PyPI via `pypa/gh-action-pypi-publish` with trusted
   publishing (OIDC) — no API tokens needed

### Failure semantics

- **Hard failures** (checks 1-6): Block the PR/tag. A red CI status prevents merge.
- **Soft failures** (checks 7-9): `continue-on-error: true`. Warnings appear
  in logs but don't block the pipeline.

### Pre-commit (local gate)

Before CI, pre-commit hooks provide instant feedback:

- `ruff` (lint + fix)
- `ruff-format`
- `mypy` (strict)
- `shellcheck`
- `dreamcoder-theme-validate` (custom)
- `dreamcoder-preview-regenerate` (custom)

## Consequences

Positive:
- Every PR is automatically checked for quality
- PyPI publishing is fully automated with zero-trust deployment
- Pre-commit catches issues before they reach CI

Negative:
- CI takes ~2-3 minutes per run
- Soft-failure checks can be ignored — need periodic manual review
- PyPI publishing requires properly formatted version tags

## Compliance

- All CI checks must pass before merging to `main`
- Tag pushes `v*` publish to PyPI automatically
- Pre-commit must pass before committing (config in `.pre-commit-config.yaml`)

## Alternatives Considered

- **Self-hosted runners**: Rejected — not needed for current scale, adds
  maintenance burden
- **Codecov upload**: Deferred — coverage reporting via terminal is sufficient
  for now
- **Separate publish workflow**: Rejected — merged into a single workflow with
  `needs:` dependency; simpler and faster
