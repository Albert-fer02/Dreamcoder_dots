# ADR-004: Shell Test Strategy

## Status

Accepted

## Context

The repository contains shell scripts in `scripts/` that handle installation,
repair, status reporting, wallpaper management, and theme mode switching.
These scripts are critical to the user experience — a broken install script
can leave the system in an inconsistent state.

Previously, shell scripts had no automated testing. Changes were validated
manually, which was error-prone and discouraged refactoring.

## Decision

### Framework — bats (Bash Automated Testing System)

We use [bats](https://github.com/bats-core/bats-core) for testing shell scripts:

- **Test location**: `shell-tests/`
- **File convention**: `test_<unit>.bats` per script or functional area
- **Helper**: `test_helper.bash` for shared setup, assertions, and utilities

### Static analysis — shellcheck

All shell scripts are analyzed with shellcheck:

- **Shell target**: `--shell=bash`
- **Scope**: All `.sh` files in `scripts/`
- **Level**: `style` (most thorough)
- **Disabled warnings**: SC3043 (`local` — we target bash, not POSIX sh)
- **Enforcement**: `shellcheck --shell=bash scripts/*.sh` in CI

### Test structure

```
shell-tests/
├── test_helper.bash      # Shared utilities: mkTemp, assert_output, etc.
├── test_status.bats       # Tests for status.sh
├── test_doctor.bats       # Tests for doctor functionality
├── test_repair.bats       # Tests for repair mode
└── test_verify.bats       # Tests for verify / health check
```

### What to test

- **Exit codes**: Scripts should return 0 on success, non-zero on failure
- **Output correctness**: Expected stdout/stderr for given inputs
- **Edge cases**: Missing files, broken symlinks, environment variable overrides
- **Idempotency**: Running the same command twice should produce the same result

### What not to test

- System-level side effects (e.g., actual wallpaper changes) — tested in CI
  via dry-run flags where available
- Third-party tools (waypaper, ml4w-hooks) — assume they work correctly

## Consequences

Positive:
- Shell regressions caught in CI before reaching users
- bats tests are fast and run in CI alongside Python tests
- shellcheck enforces consistent, safe shell scripting practices

Negative:
- bats must be installed in CI (apt or brew)
- Not all scripts can be fully tested without a running desktop environment
- Test coverage for shell is voluntary (no fail-under threshold)

## Compliance

- `bats shell-tests/` must pass (or be explicitly skipped if dependencies missing)
- `shellcheck --shell=bash scripts/*.sh` must pass before merge
- All new scripts in `scripts/` must add corresponding `shell-tests/test_*.bats`

## Alternatives Considered

- **shunit2**: Rejected — less actively maintained, steeper assertion syntax
- **zunit**: Rejected — zsh-specific, we target bash
- **Manual testing only**: Rejected — too error-prone for critical scripts
