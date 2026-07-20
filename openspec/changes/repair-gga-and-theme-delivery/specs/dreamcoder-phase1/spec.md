# Dreamcoder Theme Phase 1 Specification

## Purpose

Provide independently verifiable Phase 1 theme evidence and delivery without contaminating the pre-existing workspace state.

## Requirements

### Requirement: Exact Phase 1 manifest

Phase 1 evidence and delivery MUST contain exactly these nine paths and no others: `.github/workflows/theme-validation.yml`, `DreamcoderThemes/dreamcoder/tokens.json`, `DreamcoderThemes/dreamcoder/tokens.schema.json`, `docs/DREAMCODER_DESIGN_SYSTEM.md`, `scripts/apply-theme-mode.sh`, `scripts/verify-theme-health.py`, `src/dreamcoder_theme/palette_tokens.py`, `tests/test_token_parity.py`, and `tests/test_theme_health.py`.

#### Scenario: Scope is isolated from workspace dirt

- GIVEN the repository has 93 pre-existing dirty paths
- WHEN the intended Phase 1 scope is enumerated and evidenced
- THEN the manifest contains exactly nine approved paths
- AND no unrelated path is staged, reset, cleaned, stashed, altered, or included

### Requirement: Theme data and generated parity

The Phase 1 content MUST pass token/schema validation and MUST demonstrate parity between canonical and generated/static representations using exact commands, environment, timestamps, outputs, and exit statuses.

#### Scenario: Valid theme artifacts are evidenced

- GIVEN the nine-path content is selected without reclassifying unrelated changes
- WHEN schema, token, synchronization, and parity checks run
- THEN each check passes and its evidence identifies the scoped inputs and outputs

### Requirement: Theme health and focused tests

Phase 1 MUST provide theme-health guardrail evidence and focused results for token parity and theme health tests. Runtime evidence MUST include the command and scenario result, or explicitly record `N/A` with its reason.

#### Scenario: Focused validation passes

- GIVEN the exact nine-path Phase 1 content
- WHEN the theme health checks and focused tests run
- THEN all required checks pass with reproducible command results and no unrelated files are modified

### Requirement: Repository rollback boundary

Rollback MUST restore only intended Phase 1 changes within the nine-path manifest using captured pre-work identities. It MUST preserve unrelated pre-existing content and MUST NOT be implemented as repository-wide reset or cleanup.

#### Scenario: Phase 1 is reverted safely

- GIVEN Phase 1 validation or delivery is rejected
- WHEN rollback is requested
- THEN only the intended nine-path changes are restored or removed
- AND the 93 pre-existing dirty paths remain untouched
