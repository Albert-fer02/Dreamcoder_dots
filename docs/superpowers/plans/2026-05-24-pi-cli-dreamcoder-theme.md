# PI CLI Dreamcoder Theme Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Generate and select the Dreamcoder theme globally for PI CLI.

**Architecture:** Extend `scripts/sync-dreamcoder-theme.py` with a PI theme writer that maps canonical Dreamcoder tokens to PI CLI's 51-token JSON schema. The existing mode pipeline remains the orchestrator, so `./scripts/dreamcoder light/dusk/dark/auto` regenerates the active PI theme.

**Tech Stack:** Bash, Python 3 standard library, PI CLI theme JSON schema.

---

### Task 1: Add tests for PI theme generation

**Files:**
- Create: `tests/test_pi_theme_generation.py`

- [x] Write a test that runs the sync script in a temporary home/config environment and asserts `dreamcoder.json` exists with 51 PI tokens.
- [x] Write a test that asserts `settings.json` preserves existing keys and sets `theme` to `dreamcoder`.
- [x] Run the tests and verify they fail before implementation.

### Task 2: Implement PI theme generation

**Files:**
- Modify: `scripts/sync-dreamcoder-theme.py`

- [x] Add PI output path variables.
- [x] Add `ensure_pi_theme_settings()`.
- [x] Add `pi_theme_content()` mapping Dreamcoder tokens to PI CLI's required schema.
- [x] Wire PI output into the sync `changed` map and repo variants.

### Task 3: Update verification and docs

**Files:**
- Modify: `scripts/verify.sh`
- Modify: `README.md`

- [x] Add global PI theme/settings validation to `verify.sh`.
- [x] Document PI CLI as a generated/selected theme target.
- [x] Run tests, compile, theme sync, and verification.
