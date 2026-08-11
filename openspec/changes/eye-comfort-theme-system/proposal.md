# Proposal: Eye-Comfort Theme System

## Intent

Establish the first eye-comfort product slice for Dreamcoder OS: a user-selectable **Night/Dim rendering profile** for every currently active theme target, backed by one canonical contrast implementation and blocking visual-health gates.

Night/Dim is not a new brand palette. It is a deterministic brightness- and saturation-reduced derivation of Dreamcoder's dark **Anthracite Steel** identity. It preserves semantic roles and target behavior while reducing emitted luminance and chroma for late-session use. The light **Cocoa/Lúcuma** and standard dark identities remain canonical in `DreamcoderThemes/dreamcoder/tokens.json`.

The governing policy becomes dual and explicit:

- WCAG 2.2 contrast remains the legal accessibility floor, including at least 4.5:1 for semantic text.
- APCA becomes an independent, blocking perceptual gate throughout token validation, rendering, previews, tests, and `scripts/verify-theme-health.py`; passing WCAG does not waive an APCA failure, and passing APCA does not waive WCAG.

The product outcome is that a user can run `dreamcoder night`, receive a coherent dimmed Dreamcoder identity across all 32 active sync targets, and trust that the result cannot be written or accepted by CI when either accessibility gate fails.

## Current-State Gap

Dreamcoder already has broad renderer coverage and a blocking health command, but it does not have an eye-comfort profile inside the theme engine:

- `src/dreamcoder_theme/settings.py:theme_mode()` accepts only `light` and `dark`; `src/dreamcoder_theme/sync.py:main()` selects one base palette and sends it directly to renderers.
- `src/dreamcoder_theme/sync.py:sync_active_targets()` and `sync_repo_snippets()` cover the live and repository outputs, but there is no shared pre-render transform for a Night/Dim profile.
- `src/dreamcoder_theme/settings_store.py:SETTINGS_SCHEMA` has no eye-comfort state. The `dreamcoder` wrapper exposes `light`, `dark`, and `auto`, but no `night` command.
- `src/dreamcoder_theme/writers.py` has mode-aware selectors such as `update_ghostty_theme()`, `update_zellij_config()`, `update_warp_settings()`, and generic variant writers, but they know only the existing Light/Dark naming and settings behavior.
- WCAG calculations are importable from `src/dreamcoder_theme/_math.py`, while the SAPC/APCA implementation is copied independently into `scripts/verify-theme-health.py`, `scripts/generate-theme-preview.py`, and `tests/test_dreamcoder_global_design_system.py`. The package has no canonical `apca_lc()`.
- `scripts/verify-theme-health.py` mixes blocking calls through `check_apca_require()` with advisory calls through `check_apca_or_warn()`. `docs/DREAMCODER_DESIGN_SYSTEM.md` still describes APCA as public-beta and non-binding, including known advisory exceptions.
- The existing Hyprland 4000K keybindings are an external display filter, not a token/rendering profile, and do not provide target parity or package-level contrast validation.

This split allows APCA behavior and policy to drift, leaves some below-floor results as warnings, and gives users no deterministic all-target dim mode.

## Scope

### 1. Canonical WCAG 2.2 and APCA contrast core

- Extend `src/dreamcoder_theme/_math.py` with the canonical package implementation of APCA luminance and polarity-aware `apca_lc(foreground, background)`, preserving the currently cross-validated SAPC/APCA 0.0.98G-4g behavior.
- Keep `rel_luminance()`, `contrast()`, `guard()`, and `surface_guard()` as the WCAG path, updating policy language from WCAG 2.1 to WCAG 2.2 without weakening the 4.5:1 text floor or the 7.0:1 preferred main-text target.
- Remove the three independent APCA implementations from:
  - `scripts/verify-theme-health.py`;
  - `scripts/generate-theme-preview.py`;
  - `tests/test_dreamcoder_global_design_system.py`.
- Make those consumers import the package implementation. Keep `tests/test_apca_implementation.py` as cross-validation evidence against known vectors rather than as a fourth production formula.
- Update `src/dreamcoder_theme/palette.py:validate_palette()` so both WCAG and APCA failures are returned as validation errors before a palette reaches a renderer or writer.

The exact blocking APCA floors remain owned by `DreamcoderThemes/dreamcoder/tokens.json`:

| Content or affordance | Light / Cocoa-Lúcuma floor | Dark and Night / Anthracite floor |
| --- | ---: | ---: |
| Body text | Lc 75 | Lc 50 |
| Quiet text | Lc 44 | Lc 44 |
| UI affordances | Lc 60 | Lc 28 |
| On-accent text | Lc 60 | Lc 60 |
| Heading text | Lc 60 | Lc 45 |

These correspond to `minimum_apca_body`, `minimum_apca_body_dark`, `minimum_apca_quiet`, `minimum_apca_ui`, `minimum_apca_ui_dark`, `minimum_apca_on_accent`, `minimum_apca_heading_light`, and `minimum_apca_heading_dark`. Thresholds must be read from the canonical guardrails rather than duplicated as policy literals. Existing terminal ANSI, cursor, and selection WCAG floors remain independently blocking.

### 2. Deterministic Night/Dim rendering profile

- Add one package-level palette transformation in `src/dreamcoder_theme/palette.py` that derives Night/Dim from the selected Anthracite Steel dark palette after `adaptive_palette()` and before any renderer runs.
- Reduce brightness and saturation through explicit, bounded profile parameters represented in the canonical token contract or its schema; do not hand-tune colors inside individual renderers.
- Preserve token keys, semantic relationships, pure-black/white avoidance, alpha syntax, and renderer input shape. The transform must be deterministic for identical canonical tokens, wallpaper/adaptive input, and profile settings.
- Run the derived palette through `validate_palette()` after transformation. If dimming causes any WCAG or APCA pair to miss its floor, generation stops before writes; the transform may make a narrowly bounded corrective adjustment, but it may not weaken a threshold or silently fall back to the standard dark palette.
- Permit only minimal canonical token corrections required to make the newly blocking policy internally consistent. Broad recoloring of Anthracite Steel, Cocoa/Lúcuma, or Dusk is not authorized.

Night/Dim is orthogonal implementation state but has one unambiguous product base in this slice: activating it selects the dark Anthracite Steel base and applies the Night/Dim transform. Selecting `dreamcoder light` or `dreamcoder dark` returns to the standard profile. Dusk remains design-system-only and is not promoted to runtime.

### 3. All-active-target generation and write flow

The scoped target set is **all 32 consumer targets currently emitted by the active sync pipeline**, not only terminals and not every audited record in `targets.json`. For implementation, the authoritative inventory is the union of consumer outputs owned by `src/dreamcoder_theme/sync.py:sync_active_targets()` and `sync_repo_snippets()`, including terminal, AI CLI, prompt/shell, editor/TUI, desktop, browser, notes, notification, audio, and Herdr repository variants already in that pipeline. Selector-only, excluded, maintenance, scheduler, and unrelated-application records in the 37-ID manifest are not color-render targets and do not inflate or shrink this scope.

- Change `src/dreamcoder_theme/sync.py:main()` to resolve the base mode and rendering profile, call `adaptive_palette()`, apply the Night/Dim transform, validate the final palette, and only then call `sync_active_targets()` and `sync_repo_snippets()`.
- Extend the existing variant registry and explicit repository-snippet branches so each active consumer has a deterministic Night artifact or Night-selected active output where the target format supports named variants. No target may silently receive standard dark while the command reports Night.
- Continue passing the same `dict[str, str]` palette shape to the existing `renderers_*.py` functions. Renderer interface ports or protocol redesign are explicitly deferred; leaf renderer changes are allowed only for Night naming/selection or a target format that cannot otherwise consume the transformed palette.
- Extend `src/dreamcoder_theme/writers.py:write_variant_files()` and the mode-aware selectors `update_ghostty_theme()`, `update_zellij_config()`, and `update_warp_settings()` only as required to write/select Night output atomically and report whether it changed.
- Preserve `write_if_changed()` semantics. Validation must finish before the first write so a failed APCA/WCAG gate cannot leave a partially applied cross-target profile.
- Update `DreamcoderThemes/dreamcoder/targets.json` and schema only where required to represent Night render coverage for the existing active color targets. `dusk-runtime` remains excluded.

### 4. Persistent settings and Dreamcoder CLI activation

- Add a typed setting such as `theme.render_profile` with the closed values `standard` and `night` to `src/dreamcoder_theme/settings_store.py:SETTINGS_SCHEMA`; preserve unknown settings for forward compatibility as today.
- Add a profile resolver in `src/dreamcoder_theme/settings.py` so sync can read the persisted setting, with an explicit environment override for isolated generation and tests. `theme_mode()` remains responsible for the Light/Dark base and must not reinterpret Night as Dusk.
- Extend `src/dreamcoder_theme/cli_parser.py`, `cli_handlers.py`, and `control.py` with the activation path used by the shell wrapper. The user-facing surface is `dreamcoder night`, added to `scripts/dreamcoder`; it persists the Night profile, selects the dark base, runs the validated sync, and returns non-zero without changing active outputs when validation fails.
- Keep `dreamcoder light` and `dreamcoder dark` backward compatible while making each explicitly persist `theme.render_profile=standard` before applying its base mode. `dreamcoder settings get/set theme.render_profile` remains available through the existing generic settings interface for inspection and automation.
- Do not add automatic time-based activation. `scripts/theme-auto.sh` keeps its current Light/Dark schedule in this slice.

### 5. Blocking health verification, tests, and documentation

- Refactor `scripts/verify-theme-health.py` to import canonical `contrast()` and `apca_lc()` and remove `check_apca_or_warn()` behavior for declared guardrail pairs. Every below-floor pair must terminate the command non-zero with mode/profile, token or state pair, measured WCAG/APCA value, and required threshold.
- Validate standard Light, standard Dark, design-system Dusk, and derived Night deterministically. Night must be checked before any generated artifact is accepted, and all 32 active consumers must have declared generation/selection coverage.
- Refactor `scripts/generate-theme-preview.py` to use the same canonical math and include Night measurements without creating screenshot baselines.
- Replace advisory assertions and comments in `tests/test_dreamcoder_global_design_system.py`; add focused package tests for APCA vectors, threshold boundaries, polarity, Night determinism, transform bounds, failed-transform no-write behavior, setting validation, CLI activation, and all-target coverage.
- Update `docs/DREAMCODER_DESIGN_SYSTEM.md` and generated preview policy so WCAG 2.2 and APCA are documented as independent blocking gates. Previously documented APCA exceptions must be corrected or explicitly removed; they cannot remain accepted warnings.
- Keep local and CI behavior aligned around `python scripts/verify-theme-health.py` and the existing pytest suite.

### 6. Visual-health rationale and evidence boundaries

This change is a comfort-oriented rendering feature, not a medical treatment claim:

- APCA models polarity and perceptual lightness behavior that a ratio-only WCAG check can miss, which is especially relevant to low-luminance dark interfaces. It supplements rather than replaces the WCAG 2.2 legal floor.
- AAO/AOA digital-eye-strain guidance reports substantially reduced blink behavior during screen use—commonly summarized as roughly halving blink rate—and emphasizes glare, viewing conditions, breaks, and appropriate display brightness. A lower-luminance, lower-chroma Night profile addresses only the display-intensity part of that context.
- The WHO-ITU safe-listening/viewing-oriented guidance supports managing display luminance and viewing conditions as part of safer device use; it does not justify weakening readable contrast.
- Cochrane evidence does not establish meaningful short-term eye-strain benefit from blue-light-filtering lenses. Accordingly, this proposal makes no blue-light-treatment claim and does not add automatic warmth filtering. Night/Dim is a validated luminance/chroma profile, while the existing Hyprland 4000K filter remains separate.

## Affected Areas

Expected implementation areas are:

- `DreamcoderThemes/dreamcoder/tokens.json`, `tokens.schema.json`, `targets.json`, and `targets.schema.json`;
- generated `src/dreamcoder_theme/palette_tokens.py`;
- `src/dreamcoder_theme/_math.py`, `palette.py`, `settings.py`, `settings_store.py`, `sync.py`, and `writers.py`;
- `src/dreamcoder_theme/cli_parser.py`, `cli_handlers.py`, and `control.py`;
- `scripts/dreamcoder`, `scripts/apply-theme-mode.sh`, `scripts/verify-theme-health.py`, and `scripts/generate-theme-preview.py`;
- existing `renderers_*.py` modules only where target-specific Night naming or selection cannot be handled by orchestration/writers;
- focused tests, including `tests/test_apca_implementation.py`, `tests/test_dreamcoder_global_design_system.py`, palette/sync/settings/CLI tests, and target-coverage tests;
- `docs/DREAMCODER_DESIGN_SYSTEM.md` and generated theme-preview documentation;
- checked-in generated Night artifacts for the active target inventory where repository variants are part of the existing contract.

Exact generated paths and selector names must be enumerated in the specification/design from the existing sync inventory before implementation. This proposal does not authorize unrelated application settings or renderer architecture work.

## Non-Goals

- Automatic Night/Dusk/warmth activation at sunset or any change to `theme-auto.sh` scheduling policy.
- 20-20-20 reminders, break timers, blink prompts, or wellness notifications.
- Blue-light filtering, color-temperature control, or replacement of the existing Hyprland 4000K keybindings.
- Broad redesign of Anthracite Steel, Cocoa/Lúcuma, Dusk, semantic token names, or Dreamcoder brand identity.
- Porting renderers to a new interface, protocol, class hierarchy, or plugin architecture; that is a separate later SDD.
- Screenshot baselines or visual-regression infrastructure; that is a separate later SDD.
- Promoting Dusk to a runtime mode.
- Adding new application targets beyond the 32 active sync consumers.
- Medical claims that Night/Dim prevents disease, cures eye strain, improves sleep, or reproduces a hardware/display-level luminance measurement.
- Architecture-wide cleanup or governance/release-process redesign. Those are chained follow-ups, not prerequisites for this slice.

## Constraints and Invariants

- `DreamcoderThemes/dreamcoder/tokens.json` remains the canonical token and guardrail source; `palette_tokens.py` remains generated fallback data.
- WCAG 2.2 4.5:1 remains the minimum semantic-text floor, with existing stricter 7.0:1 main-text and terminal selection rules preserved.
- APCA is independently blocking at the exact canonical Lc floors; one metric cannot compensate for failure of the other.
- The final transformed Night palette must be validated before any writer runs.
- All 32 active target consumers receive Night output or the activation fails. Silent omission, standard-dark substitution, and partial success are forbidden.
- Night derives from dark Anthracite Steel; Light remains Cocoa/Lúcuma, and Dusk remains runtime-excluded.
- Existing renderer function input shape remains unchanged in this slice.
- Pure black/white avoidance, token parity, deterministic generation, and generated-source provenance remain enforced.
- Runtime settings changes and generated/active output updates must be recoverable without hand-editing generated files.
- No source-code changes are part of this proposal phase.

## Success Criteria

1. `src/dreamcoder_theme/_math.py` is the sole APCA implementation, and scripts/tests import it; no copied SAPC formula remains in the three current duplicate locations.
2. The package exposes cross-validated APCA results for known vectors and preserves WCAG 2.2 contrast behavior.
3. Every declared body, quiet, UI, on-accent, and heading pair blocks below its canonical mode-aware Lc floor, while WCAG requirements remain independently blocking.
4. `dreamcoder night` persists Night state, derives from dark Anthracite Steel, validates before writing, and applies coherently to all 32 active consumers.
5. `dreamcoder light` and `dreamcoder dark` remain backward compatible and explicitly leave Night for the standard rendering profile.
6. Identical inputs produce byte-identical Night palettes and generated artifacts; a threshold failure returns non-zero and causes no partial writes.
7. `scripts/verify-theme-health.py` checks Light, Dark, Dusk, Night, and active-target coverage and reports actionable mode/profile, pair, measured value, and threshold diagnostics.
8. `scripts/generate-theme-preview.py`, package validation, tests, and health verification produce consistent WCAG/APCA decisions from the same math and guardrails.
9. Existing Dreamcoder visual identity remains recognizable; changes outside derived Night output are limited to documented corrections needed to satisfy the newly blocking APCA policy.
10. No automatic sunset activation, reminder system, palette redesign, renderer-interface port, or visual-regression baseline is required for completion.

## Risks and Mitigations

- **Night dimming can destroy contrast:** Lower brightness or saturation may push text, diagnostics, or focus states below a floor. Mitigate by transforming centrally, validating the final palette before writes, bounding corrective adjustments, and failing closed rather than weakening policy.
- **The new blocking policy exposes existing advisory debt:** Current documentation records below-target APCA cases, so enabling all floors may initially fail on standard tokens. Mitigate with an explicit failing-pair inventory and only narrow, reviewed token corrections that preserve Anthracite Steel and Cocoa/Lúcuma identity.
- **Partial cross-target activation:** Thirty-two outputs and target-specific selectors increase failure surface. Mitigate with pre-render/pre-write validation, deterministic generation, atomic per-file replacement, an all-target coverage matrix, and rollback to the last standard profile.
- **Base mode/profile ambiguity:** Treating Night as a third palette could accidentally enable Dusk or fork renderer semantics. Mitigate by defining Night as an orthogonal profile with dark as its sole base and by keeping the renderer palette interface stable.
- **Settings and environment drift:** `DREAMCODER_THEME_MODE`, persisted settings, and scripts could disagree. Mitigate with one documented precedence rule, structured CLI output, settings validation, and tests for command transitions.
- **APCA algorithm drift:** Consolidation can change measurements if consumers import different code or thresholds. Mitigate with one package implementation, known-vector cross-validation, polarity/boundary tests, and guardrails loaded from tokens.
- **Overstated health claims:** Eye-comfort language can imply medical efficacy not supported by evidence. Mitigate by describing Night as a user-controlled display profile, retaining WCAG readability, and explicitly excluding treatment/sleep claims and blue-light filtering.
- **Chained-scope expansion:** All-target support can become renderer modernization or governance redesign. Mitigate by holding renderer interfaces constant and recording architecture and governance as later SDDs.

## Rollback

Implementation must preserve a complete return path to the standard Light/Dark system:

1. Before activation, record the prior base mode, `theme.render_profile`, and the set of active/generated files that the Night transaction will replace.
2. If Night generation, selection, reload, or post-write validation fails, restore the prior setting and regenerate all affected outputs from canonical tokens using the standard profile; do not hand-edit generated files or leave a mixed profile active.
3. Provide an operator path through `dreamcoder dark` or `dreamcoder light` that disables Night and regenerates the prior standard identity across the same target inventory.
4. If the Night feature must be withdrawn, revert its CLI/settings/transform/selector changes and remove only Night-owned generated artifacts, while retaining the canonical APCA implementation and WCAG/APCA diagnostics when they are healthy.
5. If newly blocking APCA enforcement causes an unanticipated release outage, any temporary downgrade must be explicit, time-bounded, and tracked as a blocker. WCAG 2.2 floors must never be disabled, and APCA exceptions must not be silently converted back into permanent warnings.
6. Rollback verification must run theme health and focused target-selection checks against the restored standard profile before reporting success.

## Chained Follow-Ups

This is SDD 1 of a chained series. Later, separately approved changes may:

- define a cleaner renderer architecture and port interfaces without coupling that migration to Night delivery;
- add visual-regression baselines after the token/contrast contract is stable;
- formalize contribution, threshold-change, exception, release, and evidence governance;
- consider automatic scheduling only after Night behavior and rollback are proven in real use.

None of those follow-ups expands this proposal's implementation authority.

## Proposal Question Round

The prior questionnaire resolved the product decisions needed for this proposal: WCAG 2.2 plus blocking APCA, a brightness/saturation-reduced Night/Dim profile, one canonical APCA implementation, and all 32 active targets. The resulting assumptions are made explicit for review:

- Night/Dim derives from dark Anthracite Steel rather than becoming a fourth hand-authored brand palette.
- “All 32 active targets” means the current color consumers emitted by `sync_active_targets()` and `sync_repo_snippets()`, not selector-only or excluded records in the broader 37-ID manifest.
- `dreamcoder night` is manual and persistent; selecting Light or Dark exits Night.
- Existing below-floor advisory cases become implementation blockers requiring narrow correction, not threshold waivers.
- Automatic sunset activation, reminders, palette redesign, renderer-interface ports, and visual baselines remain future work.
