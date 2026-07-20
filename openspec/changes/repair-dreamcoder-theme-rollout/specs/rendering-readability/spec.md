# Rendering and Readability Specification

## Purpose

Require deterministic canonical Light/Dark output, token parity, and blocking WCAG/APCA diagnostics without expanding runtime modes.

## Requirements

### Requirement: Light and Dark rendering is deterministic and token-derived

Every manifest-declared renderable target MUST produce Light and Dark output from canonical tokens. Repository variants MUST use non-adaptive palettes, stable ordering, LF endings, one trailing newline, and only supported fields. Target-specific color literals MUST be absent or parity-checked against canonical roles.

#### Scenario: Repeated generation is unchanged

- GIVEN unchanged canonical tokens and manifest inputs
- WHEN repository generation runs twice
- THEN both outputs MUST be byte-identical and the second run MUST report no content changes

#### Scenario: Adaptive runtime generation runs

- GIVEN wallpaper-adaptive runtime generation is requested
- WHEN active output is produced
- THEN tracked Light/Dark repository variants MUST remain unchanged

### Requirement: Canonical token and mode parity is enforced

`tokens.json` MUST validate against its schema, and generated static tokens MUST exactly match it. Required roles MUST exist for Light, Dark, and `dusk`; parity validation MUST NOT make `dusk` runtime-activatable.

#### Scenario: Generated token drift exists

- GIVEN `palette_tokens.py` differs from canonical token values
- WHEN health validation runs
- THEN validation MUST fail and identify the source token and generated artifact

#### Scenario: Dusk is requested at runtime

- GIVEN a runtime selector, scheduler, or apply entrypoint receives `dusk`
- WHEN mode validation runs
- THEN it MUST reject the request without mutating active state

### Requirement: Readability diagnostics block unsafe output

Text-bearing state combinations MUST meet WCAG 2 contrast of at least 4.5:1 and applicable APCA body thresholds (75, or the explicitly applicable dark-background threshold of 50). WCAG failures MUST remain blocking; APCA advisories MUST NOT waive them. Diagnostics MUST identify mode, role/state, target where material, metric, measured value, threshold, and source token.

#### Scenario: State matrix contains a contrast failure

- GIVEN a text, muted, selection, focus, material border, or semantic status pairing is below its applicable threshold
- WHEN health validation runs
- THEN validation MUST fail with the complete diagnostic context

### Requirement: Dark rendering follows the bounded Nytherx role contract

Dark tokens and renderers MUST map semantic roles to the bounded Nytherx direction: void backgrounds; graphite/titanium structural layers; star blue-white and cold silver active systems and readable foregrounds; restrained gravitational violet for depth; and minimal copper/amber for warm focal meaning. The 80/15/5 balance MUST remain qualitative guidance only. Every concrete Dark value and role pairing MUST be selected from verified WCAG/APCA evidence; Light tokens, mappings, and tracked outputs MUST remain unchanged.

#### Scenario: Dark role evidence is reviewed

- GIVEN a Dark token candidate or text/status/focus/selection pairing is proposed
- WHEN the canonical readability evidence is generated
- THEN it MUST identify the semantic role, source token, WCAG result, APCA result, and applicable threshold
- AND it MUST reject values that lack verified evidence or introduce an independent target literal

#### Scenario: Light preservation is checked

- GIVEN the Dark palette or renderer mapping changes
- WHEN parity validation runs against the pre-calibration Light baseline
- THEN the canonical Light token object, semantic mapping, and tracked Light outputs MUST be byte-identical
