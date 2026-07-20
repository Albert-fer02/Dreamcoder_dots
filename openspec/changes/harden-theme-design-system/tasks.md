# Tasks: Harden Theme Design System

## Review Workload Forecast

| Field                   | Value                |
| ----------------------- | -------------------- |
| Estimated changed lines | 700–1,000            |
| 400-line budget risk    | High                 |
| Chained PRs recommended | Yes                  |
| Suggested split         | PR 1 → PR 2 → PR 3   |
| Delivery strategy       | feature-branch-chain |
| Chain strategy          | feature-branch-chain |

Decision needed before apply: No (resolved: `feature-branch-chain`, Phase 2 / PR 2)
Chained PRs recommended: Yes
Chain strategy: feature-branch-chain
400-line budget risk: High

Delivery path resolved by the maintainer: `feature-branch-chain`. The slices below are autonomous and reversible.

## Phase 1 — Contract and evaluator foundation (PR 1)

- [x] Add `DreamcoderThemes/dreamcoder/design-system.json` with the six-target terminal-first inventory, layered role provenance, explicit dark/light/dusk coverage, mappings, matrix rows, and declared artifact ownership; validate that it contains no independent color authority. <!-- sdd-owner: implementation -->
- [x] Add `DreamcoderThemes/dreamcoder/design-system.schema.json` and update `DreamcoderThemes/dreamcoder/tokens.schema.json` to require the three supported modes and enforced canonical roles; add schema-focused tests under `tests/`. <!-- sdd-owner: implementation -->
- [x] Add pure role, target, parity, matrix, and finding models in `src/dreamcoder_theme/design_system.py`, including stable finding ordering and repository-relative diagnostics. <!-- sdd-owner: implementation -->
- [x] Add adapter coverage for Kitty, Ghostty, Warp, Starship, tmux, and OpenCode using existing renderer callables only; make missing dusk coverage and silent omissions fail with explicit mappings required for unsupported fields. <!-- sdd-owner: implementation -->
- [x] Add RED/GREEN tests under `tests/` for canonical role traceability, unknown/cyclic derivations, complete three-mode parity, missing dusk roles, missing mappings, matrix coverage, and deterministic finding order. <!-- sdd-owner: implementation -->
- [x] Run `python -m pytest tests/ -v` and the focused contract tests; confirm no runtime mode activation or unrelated renderer behavior changed. <!-- sdd-owner: implementation -->

## Phase 2 — Generation, health validation, and OpenCode ownership (PR 2)

- [x] Refactor `scripts/generate-palette-tokens.py` into write-free load/enrich/render functions with deterministic headers and `--check`; report `GENERATED_DRIFT` with canonical source, generated path, and regeneration command. <!-- sdd-owner: implementation -->
- [x] Update `scripts/verify-theme-health.py` to run schema, canonical synchronization, six-target in-memory rendering for all modes, parity, matrix, and declared-artifact checks in stable order with nonzero exit on errors. <!-- sdd-owner: implementation -->
- [x] Execute the design's OpenCode investigation against `DreamcoderOpenCode/.config/opencode/*.json`, `settings.theme_paths()`, `sync_active_targets()`, `sync_repo_snippets()`, and `.opencode/themes/dreamcoder.json`; record whether byte drift exists before changing classification. <!-- sdd-owner: implementation -->
- [x] Replace OpenCode discovery with the declared `.opencode/themes` contract, preserving `.opencode/themes/dreamcoder.json` as the checked-in default and excluding `DreamcoderOpenCode/.config/opencode/opencode.json` by ownership. <!-- sdd-owner: implementation -->
- [x] Add focused OpenCode tests under `tests/` for valid default output, dark/light/dusk in-memory output, malformed/corrupt/stale content, missing selected text, missing dusk coverage, unexpected theme files, and configuration-file exclusion. <!-- sdd-owner: implementation -->
- [x] Add regression tests for exact generated-token synchronization and representative stale/corrupt artifacts; regenerate `.opencode/themes/dreamcoder.json` only if the investigation proves drift. <!-- sdd-owner: implementation -->
- [x] Run the health command twice with isolated temporary state and differing irrelevant environment variables; verify equivalent findings and exit status. <!-- sdd-owner: implementation -->

## Phase 3 — CI, hooks, documentation, and integration (PR 3)

- [ ] Remove `continue-on-error: true` from the theme-health step in `.github/workflows/theme-validation.yml` while keeping preview generation separate. <!-- sdd-owner: implementation -->
- [ ] Correct `.pre-commit-config.yaml` path filters to cover `DreamcoderThemes/dreamcoder/`, contract schemas, generator, six terminal-first renderers, `src/dreamcoder_theme/palette_tokens.py`, and `scripts/verify-theme-health.py`. <!-- sdd-owner: implementation -->
- [ ] Document the inventory, layered provenance rules, state/contrast matrix, regeneration command, OpenCode lifecycle, and diagnostic codes in `docs/DREAMCODER_DESIGN_SYSTEM.md` and `docs/configuration/theme-system.md`. <!-- sdd-owner: implementation -->
- [ ] Add integration assertions for CI wiring and pre-commit path coverage under `tests/`; verify no all-renderer screenshot baseline is introduced. <!-- sdd-owner: implementation -->
- [ ] Run `python -m pytest tests/ -v`, the coverage command with the 40% threshold, `ruff check src/ tests/`, `mypy src/`, and `pre-commit run --all-files`; resolve only findings within the scoped contract paths. <!-- sdd-owner: implementation -->
- [ ] Review generated terminal-first diffs textually and confirm visual identity, runtime activation behavior, rollback boundaries, and clean-checkout local/CI parity. <!-- sdd-owner: implementation -->

## Parent-owned review and lifecycle gates

- [ ] Start or reuse the bounded implementation review for the applied slice and classify all findings before merge. <!-- sdd-owner: parent -->
- [ ] Validate the content-bound review receipt at pre-commit/pre-push/pre-PR gates using the native review validator. <!-- sdd-owner: parent -->
