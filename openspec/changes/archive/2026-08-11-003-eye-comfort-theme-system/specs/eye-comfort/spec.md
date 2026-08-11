# Eye-Comfort Specification

## Purpose

Define the Night/Dim eye-comfort rendering profile for Dreamcoder OS: one canonical APCA contrast implementation, independent blocking WCAG 2.2 + APCA gates, a deterministic brightness/saturation-reduced derivation of the dark Anthracite Steel palette, persistent `theme.render_profile` settings with `dreamcoder night` CLI activation, all-32-active-target coverage, and fail-closed validation before any write — without medical claims, automatic scheduling, palette redesign, or renderer-interface changes.

## Requirements

### Requirement: Canonical APCA contrast implementation

The system MUST provide a single canonical package implementation of APCA luminance and polarity-aware `apca_lc(foreground, background)` in `src/dreamcoder_theme/_math.py`, preserving the currently cross-validated SAPC/APCA 0.0.98G-4g behavior. The three locations that currently copy an independent SAPC/APCA implementation — `scripts/verify-theme-health.py`, `scripts/generate-theme-preview.py`, and `tests/test_dreamcoder_global_design_system.py` — MUST import `apca_lc()` (and `contrast()` for the WCAG path) from the package and MUST NOT contain a copied production formula. `tests/test_apca_implementation.py` MUST remain cross-validation evidence against known vectors and MUST NOT become a fourth production implementation. `validate_palette()` in `src/dreamcoder_theme/palette.py` MUST return both WCAG and APCA validation errors so a palette failing either metric never reaches a renderer or writer.

#### Scenario: Single source of truth for APCA

- GIVEN `_math.py` exposes the canonical `apca_lc()` implementation
- WHEN any consumer (health script, preview generator, or test) computes APCA contrast
- THEN it imports the package function and yields results consistent with the cross-validated 0.0.98G-4g known vectors

#### Scenario: A duplicated SAPC formula is detected

- GIVEN a consumer file still contains a copied SAPC/APCA formula instead of importing from the package
- WHEN health validation or the focused test suite runs
- THEN validation MUST fail, naming the consumer and the duplicated formula location

#### Scenario: validate_palette reports both metrics

- GIVEN a palette where a pair passes WCAG but fails APCA, or passes APCA but fails WCAG
- WHEN `validate_palette()` runs
- THEN it MUST return an error for the failing metric and MUST NOT clear or waive the other metric's failure

### Requirement: Independent blocking WCAG and APCA dual gate

All enforced text and affordance pairs MUST satisfy BOTH the WCAG 2.2 minimum contrast floor and the mode-aware APCA Lc floors. WCAG MUST remain the legal accessibility floor, including at least 4.5:1 for semantic text and the preserved 7.0:1 preferred main-text and terminal selection rules. APCA MUST be independently blocking: passing WCAG MUST NOT waive an APCA failure, and passing APCA MUST NOT waive a WCAG failure. The blocking APCA floors MUST be read from the canonical guardrails in `DreamcoderThemes/dreamcoder/tokens.json` — `minimum_apca_body` (Lc 75), `minimum_apca_body_dark` (Lc 50), `minimum_apca_quiet` (Lc 44), `minimum_apca_ui` (Lc 60), `minimum_apca_ui_dark` (Lc 28), `minimum_apca_on_accent` (Lc 60), `minimum_apca_heading_light` (Lc 60), and `minimum_apca_heading_dark` (Lc 45) — and MUST NOT be duplicated as policy literals. Existing terminal ANSI, cursor, and selection WCAG floors MUST remain independently blocking.

#### Scenario: WCAG pass with APCA fail is blocking

- GIVEN a body-text pair that measures 5.0:1 WCAG but Lc 48 against the dark-background floor of 50
- WHEN validation runs
- THEN the gate MUST fail on APCA with the pair, measured Lc, and required threshold, and the WCAG pass MUST NOT excuse it

#### Scenario: APCA pass with WCAG fail is blocking

- GIVEN a pair that measures Lc 80 but 4.2:1 WCAG
- WHEN validation runs
- THEN the gate MUST fail on WCAG, and the APCA pass MUST NOT excuse it

#### Scenario: Thresholds come from canonical guardrails

- GIVEN `tokens.json` defines the mode-aware APCA floors
- WHEN validation computes a below-floor verdict
- THEN the threshold in the diagnostic MUST equal the value read from the canonical guardrails, not a hardcoded literal in code

#### Scenario: Class floors apply per content and mode

- GIVEN heading (Lc 60 light / Lc 45 dark), quiet (Lc 44), UI (Lc 60 light / Lc 28 dark), and on-accent (Lc 60) pairs across Light, Dark, and Night
- WHEN health validation runs
- THEN each pair MUST be measured against its declared class and mode floor, and any below-floor pair MUST block

### Requirement: Deterministic Night/Dim palette transformation

The system MUST derive the Night/Dim palette in `src/dreamcoder_theme/palette.py` by applying a brightness- and saturation-reduced transform to the dark Anthracite Steel palette, after `adaptive_palette()` and before any renderer runs. The transform MUST use explicit, bounded profile parameters represented in the canonical token contract or its schema, and MUST NOT hand-tune colors inside individual renderers. The transform MUST preserve token keys, semantic relationships, pure-black/white avoidance, alpha syntax, and the `dict[str, str]` renderer input shape. For identical canonical tokens, wallpaper/adaptive input, and profile settings, the transform MUST produce byte-identical output.

#### Scenario: Night derives from dark Anthracite Steel

- GIVEN the standard dark Anthracite Steel palette
- WHEN the Night/Dim transform is applied after `adaptive_palette()` and before any renderer runs
- THEN every output token is a brightness/saturation-reduced derivation of the corresponding dark token with the same semantic role, and no individual renderer adjusts colors

#### Scenario: Identical inputs produce identical output

- GIVEN identical canonical tokens, adaptive input, and profile settings
- WHEN the Night transform runs twice
- THEN both runs MUST produce byte-identical palettes

#### Scenario: Keys, alpha syntax, and input shape are preserved

- GIVEN a transformed Night palette
- WHEN it is passed to renderers
- THEN it contains exactly the same token keys and alpha syntax as the standard palette and consumes the same `dict[str, str]` input shape

### Requirement: Pre-write validation and fail-closed write behavior

The final palette — including the transformed Night palette — MUST be validated by `validate_palette()` before the first writer runs, and validation MUST finish before `sync_active_targets()` and `sync_repo_snippets()` perform any write. If dimming causes any WCAG or APCA pair to miss its floor, generation MUST stop before writes, the command MUST exit non-zero, and no partial cross-target profile MAY be left applied. The transform MAY make a narrowly bounded corrective adjustment to restore a floor, but MUST NOT weaken a threshold and MUST NOT silently fall back to the standard dark palette. `write_if_changed()` semantics MUST be preserved.

#### Scenario: A failed gate blocks all writes

- GIVEN a Night palette whose transformed output misses one APCA floor
- WHEN the validated sync runs
- THEN no target or active output is written or selected, the command exits non-zero, and the prior standard profile remains active

#### Scenario: Bounded corrective adjustment restores a floor

- GIVEN dimming pushes one pair below its declared floor
- WHEN the transform applies a narrowly bounded corrective adjustment
- THEN the adjustment restores the floor without weakening any threshold, and the final palette passes validation before any write

#### Scenario: No silent standard-dark fallback

- GIVEN the transform cannot meet a floor after bounded correction
- WHEN the Night sync runs
- THEN it MUST fail closed with a diagnostic and MUST NOT emit standard dark output while reporting Night

### Requirement: All-active-target Night coverage

Night MUST apply to every consumer output in the union of `sync_active_targets()` and `sync_repo_snippets()` — the 32 active color consumers — and MUST NOT silently substitute standard dark for any of them. Each active consumer MUST have a deterministic Night artifact or a Night-selected active output where the target format supports named variants. Silent omission, standard-dark substitution, and partial success MUST be forbidden: no target MAY receive standard dark while the command reports Night. `targets.json` and its schema MUST be updated only as required to represent Night render coverage for the existing active color targets; `dusk-runtime` MUST remain excluded, and no new application targets beyond the 32 active consumers MAY be added.

#### Scenario: All 32 active targets receive Night output

- GIVEN the Night profile is active
- WHEN the validated sync runs
- THEN every one of the 32 consumers in the union of `sync_active_targets()` and `sync_repo_snippets()` receives Night output or a Night-selected active variant, and the coverage report lists each target

#### Scenario: Standard-dark substitution is forbidden

- GIVEN a consumer whose format supports named variants
- WHEN Night sync runs
- THEN that consumer MUST NOT be written with or left selecting standard dark while the command reports Night, and any such substitution MUST fail the command non-zero

#### Scenario: Partial success fails closed

- GIVEN Night generation succeeds for 31 consumers but fails for one
- WHEN the sync completes
- THEN the command exits non-zero and identifies the failed target, and MUST NOT report a silently partial profile as success

### Requirement: Persistent render profile setting

The system MUST add a typed setting `theme.render_profile` to `SETTINGS_SCHEMA` in `src/dreamcoder_theme/settings_store.py` with the closed values `standard` and `night`, and MUST preserve unknown settings for forward compatibility. A profile resolver in `src/dreamcoder_theme/settings.py` MUST read the persisted setting for sync, with an explicit environment override for isolated generation and tests. `theme_mode()` MUST remain responsible for the Light/Dark base and MUST NOT reinterpret Night as Dusk.

#### Scenario: Persisted profile is resolved

- GIVEN `theme.render_profile=night` is persisted
- WHEN sync resolves the rendering profile
- THEN the resolver returns `night` absent an environment override, and sync uses the Night transform with the dark base

#### Scenario: Environment override wins without mutation

- GIVEN `theme.render_profile=night` is persisted
- WHEN an explicit environment override for the profile is set for an invocation
- THEN the resolver MUST return the override value for that invocation and MUST NOT mutate the persisted setting

#### Scenario: Invalid profile value is rejected

- GIVEN `theme.render_profile` is set to a value other than `standard` or `night`
- WHEN settings validation runs
- THEN the value MUST be rejected or defaulted to `standard`, and MUST NOT be interpreted as a runtime profile

### Requirement: Dreamcoder CLI activation and profile exit

`dreamcoder night` MUST persist the Night profile, select the dark Anthracite Steel base, run the validated sync, and return non-zero without changing active outputs when validation fails. `dreamcoder light` and `dreamcoder dark` MUST remain backward compatible and MUST each explicitly persist `theme.render_profile=standard` before applying their base mode, exiting Night and regenerating the standard identity across the same target inventory. `dreamcoder settings get/set theme.render_profile` MUST remain available through the existing generic settings interface. The system MUST NOT add automatic time-based activation; `scripts/theme-auto.sh` MUST keep its current Light/Dark schedule.

#### Scenario: Night activation succeeds

- GIVEN the standard profile is active
- WHEN the user runs `dreamcoder night`
- THEN the Night profile is persisted, the dark base is selected, the Night transform is validated, and all 32 active targets receive Night output

#### Scenario: Night with a failing gate changes nothing

- GIVEN a transformed Night palette that fails a floor
- WHEN the user runs `dreamcoder night`
- THEN the command exits non-zero, no active output is changed, and the prior standard setting remains in effect

#### Scenario: Light and Dark exit Night

- GIVEN `theme.render_profile=night` is active
- WHEN the user runs `dreamcoder light` or `dreamcoder dark`
- THEN `theme.render_profile=standard` is persisted before the base mode is applied, the standard identity is regenerated across the same target inventory, and subsequent sync uses the standard profile

#### Scenario: No automatic time-based activation

- GIVEN the Night profile is not persisted
- WHEN the theme scheduler runs at any time of day
- THEN it MUST NOT activate Night automatically and MUST keep the existing Light/Dark schedule

### Requirement: Blocking health verification

`scripts/verify-theme-health.py` MUST import canonical `contrast()` and `apca_lc()` from the package and MUST remove the `check_apca_or_warn()` advisory path for declared guardrail pairs. Every below-floor pair MUST terminate the command non-zero and report mode/profile, token or state pair, measured WCAG/APCA value, and required threshold. The command MUST validate standard Light, standard Dark, design-system Dusk, and derived Night deterministically, and MUST check Night before any generated artifact is accepted. It MUST declare generation/selection coverage for all 32 active consumers, and any consumer without declared coverage MUST block. `scripts/generate-theme-preview.py` MUST use the same canonical math and include Night measurements without creating screenshot baselines.

#### Scenario: Below-floor pair blocks with actionable diagnostics

- GIVEN a quiet-text pair measuring below Lc 44 in Night
- WHEN `verify-theme-health.py` runs
- THEN the command exits non-zero and reports profile Night, the pair, the measured Lc value, and the required threshold

#### Scenario: All four profiles are validated

- GIVEN standard Light, standard Dark, design-system Dusk, and derived Night palettes
- WHEN health validation runs
- THEN each profile is measured deterministically, and any below-floor pair in any profile blocks the command

#### Scenario: Advisory warnings become blocking

- GIVEN a declared guardrail pair that previously produced a warning through `check_apca_or_warn()`
- WHEN health validation runs
- THEN the pair MUST block the command non-zero and MUST NOT be downgraded to an advisory warning

#### Scenario: All-target coverage is declared

- GIVEN the Night profile
- WHEN health validation runs
- THEN the report declares generation/selection coverage for all 32 active consumers, and any consumer without declared coverage blocks the command

### Requirement: Focused regression coverage for the eye-comfort contract

The automated test suite MUST cover APCA known vectors, threshold boundaries, polarity, Night determinism, transform bounds, failed-transform no-write behavior, `theme.render_profile` setting validation, CLI activation, and all-target coverage. Advisory assertions and comments in `tests/test_dreamcoder_global_design_system.py` MUST be replaced with blocking checks. `tests/test_apca_implementation.py` MUST cross-validate the package `apca_lc()` against known vectors. Local and CI behavior MUST align around `python scripts/verify-theme-health.py` and the existing pytest suite.

#### Scenario: Known vectors cross-validate the package implementation

- GIVEN the known APCA vectors and the package `apca_lc()`
- WHEN `tests/test_apca_implementation.py` runs
- THEN every vector matches within the established tolerance and the test exercises the package implementation, not a copied formula

#### Scenario: Boundary and polarity cases are covered

- GIVEN pairs at and just below each class floor, and both light-on-dark and dark-on-light polarity
- WHEN the focused tests run
- THEN at-floor pairs pass and below-floor pairs fail with the correct metric and polarity-aware measurement

#### Scenario: Failed transform performs no writes

- GIVEN a test that forces the Night transform below a floor
- WHEN the sync path runs under test
- THEN no writes occur and the failure is asserted

### Requirement: Evidence and claims boundaries

Night MUST be documented as a user-controlled display profile, not a medical treatment. The system MUST NOT make blue-light-treatment, disease-prevention, eye-strain-cure, or sleep-improvement claims, MUST NOT add automatic warmth/color-temperature filtering, and MUST NOT replace the existing Hyprland 4000K keybindings, which remain a separate external display filter. `docs/DREAMCODER_DESIGN_SYSTEM.md` and generated preview policy MUST document WCAG 2.2 and APCA as independent blocking gates, and previously documented APCA exceptions MUST be corrected or explicitly removed rather than remaining accepted warnings.

#### Scenario: Night is documented without treatment claims

- GIVEN the Night profile and its documentation
- WHEN the documentation and generated preview policy are inspected
- THEN Night is described as a validated luminance/chroma display profile with no medical-treatment, blue-light-filtering, or sleep claims, and no automatic warmth is introduced

#### Scenario: Advisory APCA exceptions are removed

- GIVEN documentation that previously recorded below-threshold APCA pairs as accepted warnings
- WHEN the documentation is reviewed
- THEN those exceptions are corrected or removed, and the documentation states that WCAG 2.2 and APCA are independent blocking gates
