# Dreamcoder Superiority Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [x]`) syntax for tracking.

**Goal:** Build the first production-quality foundation that moves Dreamcoder Dots beyond simple dotfiles into a managed, verifiable desktop product.

**Architecture:** Add a Python control-center module behind the existing `scripts/dreamcoder` entrypoint. Keep bash scripts as compatibility wrappers, but move structured health, profile, motion, and settings logic into focused Python modules with tests. Avoid GUI scope in this first slice; create a stable CLI/API contract that a future TUI/GUI can consume.

**Tech Stack:** Python standard library, existing bash entrypoints, existing pytest/unittest tests, Starship/Ghostty/Kitty/Hyprland validation commands.

---

### Task 1: Control Center CLI foundation

**Files:**
- Create: `scripts/dreamcoder_theme/control.py`
- Modify: `scripts/dreamcoder`
- Test: `tests/test_dreamcoder_control_center.py`

- [x] Add tests proving `settings`, `profile`, `motion`, and `doctor --json` commands expose stable machine-readable output.
- [x] Implement a focused Python module with small pure functions for profile/motion registries, settings persistence, and health report construction.
- [x] Route `./scripts/dreamcoder control|settings|profile|motion|doctor-json` into the Python module.
- [x] Verify with `python -m unittest tests/test_dreamcoder_control_center.py`.

### Task 2: Smart Doctor contract

**Files:**
- Modify: `scripts/dreamcoder_theme/control.py`
- Modify: `scripts/doctor.sh`
- Test: `tests/test_dreamcoder_control_center.py`

- [x] Represent each diagnostic as `{name, status, detail, repair}`.
- [x] Check critical paths, active theme mode, Fish/Starship wiring, Kitty duplicate include risk, Ghostty config presence, and systemd timer state.
- [x] Make `doctor.sh` call the structured doctor first, then keep legacy human output for compatibility.
- [x] Verify JSON is parseable and human report contains actionable repair commands.

### Task 3: Profiles and motion presets

**Files:**
- Modify: `scripts/dreamcoder_theme/control.py`
- Create: `profiles/dreamcoder/asus-vivobook15.json`
- Create: `profiles/dreamcoder/default.json`
- Test: `tests/test_dreamcoder_control_center.py`

- [x] Define profiles for `default` and `asus-vivobook15` with monitor scale, keyboard, repeat rate, shell, terminal mode, and performance notes.
- [x] Define motion presets `battery`, `balanced`, `fluid`, and `cinematic` with terminal cursor, Hyprland animation intent, and performance cost.
- [x] Implement `profile apply --dry-run` and `motion apply --dry-run` so changes are previewable before touching live configs.
- [x] Verify outputs remain deterministic and valid JSON.

### Task 4: Documentation and verification

**Files:**
- Modify: `README.md`
- Modify: `scripts/verify.sh`
- Test: full project verification

- [x] Document the new control center commands and quality gates.
- [x] Add control-center unit tests to `scripts/verify.sh`.
- [x] Run `python -m unittest`, `./scripts/verify-theme-health.py`, `./scripts/verify.sh`, `./scripts/dreamcoder status`, and `./scripts/dreamcoder doctor-json`.

### Task 5: Installer safety and repair foundation

**Files:**
- Modify: `scripts/dreamcoder_theme/control.py`
- Modify: `scripts/dreamcoder`
- Modify: `scripts/install.sh`
- Modify: `scripts/repair.sh`
- Test: `tests/test_dreamcoder_control_center.py`

- [x] Add `installer plan --json` with target classification before stow.
- [x] Treat direct repo symlinks and directories containing only repo-managed symlinks as managed, not conflicts.
- [x] Add manifest backup preflight to install and repair scripts with explicit rollback command.
- [x] Add tests for installer conflicts, managed symlinks, managed symlink directories, and install/repair backup wiring.
- [x] Verify with focused tests, structured doctor JSON, installer plan JSON, and full project verification.

### Task 6: Smart repair automation

**Files:**
- Modify: `scripts/dreamcoder_theme/control.py`
- Modify: `scripts/dreamcoder`
- Modify: `scripts/verify.sh`
- Modify: `README.md`
- Test: `tests/test_dreamcoder_control_center.py`

- [x] Add `repair plan --json` with `dreamcoder.repair-plan.v1` so doctor findings become machine-readable repair actions.
- [x] Separate safe automatic fixes from manual actions.
- [x] Add `repair apply --dry-run --json` and `repair apply --json` for safe repairs only.
- [x] Create backup manifests before applying safe repairs.
- [x] Verify with focused tests, dry-run contracts, and full project verification.

### Task 7: Control Center dashboard and modular refactor

**Files:**
- Modify: `scripts/dreamcoder_theme/control.py`
- Create: `scripts/dreamcoder_theme/core.py`
- Create: `scripts/dreamcoder_theme/backups.py`
- Create: `scripts/dreamcoder_theme/settings_store.py`
- Create: `scripts/dreamcoder_theme/profiles.py`
- Create: `scripts/dreamcoder_theme/motion.py`
- Create: `scripts/dreamcoder_theme/installer.py`
- Create: `scripts/dreamcoder_theme/doctor.py`
- Create: `scripts/dreamcoder_theme/repair_engine.py`
- Create: `scripts/dreamcoder_theme/dashboard.py`
- Create: `docs/DREAMCODER_CONTROL_CENTER.md`
- Test: `tests/test_dreamcoder_control_center.py`

- [x] Split the oversized Control Center implementation into focused modules under 250 lines each.
- [x] Keep `control.py` as a thin CLI entrypoint.
- [x] Add `dashboard --json` with `dreamcoder.dashboard.v1` as the future TUI/GUI contract.
- [x] Add `dashboard --markdown` as a visual operator summary.
- [x] Document the dashboard, safety model, contracts, and quality gates.
- [x] Verify with focused tests and full project verification.

### Task 8: Settings schema and validation contracts

**Files:**
- Modify: `scripts/dreamcoder_theme/settings_store.py`
- Modify: `scripts/dreamcoder_theme/control.py`
- Modify: `scripts/verify.sh`
- Modify: `README.md`
- Modify: `docs/DREAMCODER_CONTROL_CENTER.md`
- Test: `tests/test_dreamcoder_control_center.py`

- [x] Add `settings schema --json` with `dreamcoder.settings-schema.v1` for future TUI/GUI forms.
- [x] Add `settings validate --json` with `dreamcoder.settings-validation.v1`.
- [x] Reject invalid values for known settings at write time.
- [x] Preserve unknown settings with warnings for forward compatibility.
- [x] Add schema/validation commands to verification gates and docs.

### Task 9: Terminal settings TUI contract

**Files:**
- Create: `scripts/dreamcoder_theme/tui.py`
- Create: `tests/test_dreamcoder_tui.py`
- Modify: `scripts/dreamcoder_theme/control.py`
- Modify: `scripts/dreamcoder_theme/cli_handlers.py`
- Modify: `scripts/dreamcoder_theme/cli_parser.py`
- Modify: `scripts/dreamcoder`
- Modify: `scripts/verify.sh`
- Modify: `README.md`
- Modify: `docs/DREAMCODER_CONTROL_CENTER.md`

- [x] Add `tui render` as a dependency-free terminal settings UI.
- [x] Add `tui render --json` with `dreamcoder.tui.v1`.
- [x] Add `tui set <key> <value> --dry-run --json` with `dreamcoder.tui-apply.v1`.
- [x] Reuse dashboard and settings schema contracts instead of duplicating UI rules.
- [x] Add TUI command verification and tests.

### Task 10: Generated visual operator documentation

**Files:**
- Create: `scripts/dreamcoder_theme/docs_report.py`
- Create: `tests/test_dreamcoder_docs_report.py`
- Create on demand: `docs/generated/DREAMCODER_OPERATOR_REPORT.md`
- Modify: `scripts/dreamcoder_theme/cli_handlers.py`
- Modify: `scripts/dreamcoder_theme/cli_parser.py`
- Modify: `scripts/dreamcoder_theme/control.py`
- Modify: `scripts/dreamcoder`
- Modify: `scripts/verify.sh`
- Modify: `README.md`
- Modify: `docs/DREAMCODER_CONTROL_CENTER.md`

- [x] Add `docs report --json` with `dreamcoder.docs-report.v1`.
- [x] Add `docs report --markdown` for visual operator documentation.
- [x] Add `docs report --write --json` to generate `docs/generated/DREAMCODER_OPERATOR_REPORT.md`.
- [x] Include visual dashboard, TUI preview, safety model, quality gates, contracts, and competitive checklist.
- [x] Add docs report tests and verification gates.

### Task 11: Competitive capability audit

**Files:**
- Create: `scripts/dreamcoder_theme/audit.py`
- Create: `tests/test_dreamcoder_audit.py`
- Modify: `scripts/dreamcoder_theme/cli_handlers.py`
- Modify: `scripts/dreamcoder_theme/cli_parser.py`
- Modify: `scripts/dreamcoder_theme/control.py`
- Modify: `scripts/dreamcoder`
- Modify: `scripts/verify.sh`
- Modify: `README.md`
- Modify: `docs/DREAMCODER_CONTROL_CENTER.md`

- [x] Add `audit compare --json` with `dreamcoder.audit.v1`.
- [x] Add `audit compare --markdown` for human review.
- [x] Score achieved/partial/missing capability criteria.
- [x] Include remaining gaps so the goal is not falsely marked complete.
- [x] Add audit tests and verification gates.

### Task 12: Expanded safe repair catalog

**Files:**
- Modify: `scripts/dreamcoder_theme/repair_engine.py`
- Modify: `scripts/dreamcoder_theme/audit.py`
- Modify: `scripts/dreamcoder_theme/cli_handlers.py`
- Modify: `scripts/dreamcoder_theme/cli_parser.py`
- Modify: `scripts/verify.sh`
- Modify: `README.md`
- Modify: `docs/DREAMCODER_CONTROL_CENTER.md`
- Create: `tests/test_dreamcoder_repair_catalog.py`

- [x] Add `repair catalog --json` with `dreamcoder.repair-catalog.v1`.
- [x] Add safe restore actions for missing managed Kitty, Ghostty, Starship, Fish, and active Kitty colors.
- [x] Keep restore actions safe by only restoring missing paths from repo-managed sources.
- [x] Add tests for catalog, planning, apply, and backup manifests.
- [x] Update audit so smart repair is scored from catalog capability, not only current machine drift.
