# Herdr Gate Specification

## Purpose

Keep Herdr support gated until the installed-version runtime contract is authoritative and version-bound.

## Requirements

### Requirement: Herdr support is version-gated

Herdr MUST remain `gated` or `unavailable` unless authoritative evidence proves the installed version's configuration schema, active paths, ownership states, candidate validation, and reload/restart semantics. Before that gate opens, Herdr MUST NOT be a required target, generated active configuration, installation promise, or reload claim.

#### Scenario: Contract evidence is incomplete

- GIVEN Herdr is absent, changed version, or lacks complete schema and reload evidence
- WHEN synchronization or activation runs
- THEN no Herdr active configuration may be generated or mutated, and the result MUST identify `skipped-not-installed` or `unsupported-contract`

### Requirement: Herdr success requires a version-bound visual and readability harness

Herdr MUST NOT be classified as required, activated, or reported successful until a harness bound to the installed Herdr version proves the canonical Dark semantic-role mapping, WCAG and APCA checks for text, status, focus, and selection states, rendered color identity, selector/content parity, and reload observability. The harness MUST use only validators, rendering evidence, and runtime/UI queries that are actually available for that version; where reload or UI convergence cannot be observed, the profile MUST explicitly document that non-observability and MUST NOT claim convergence.

#### Scenario: Herdr visual/readability proof is absent or incomplete

- GIVEN the installed version has no complete supported harness, or any required visual/readability, selector/content, or reload evidence is missing
- WHEN Herdr is considered for classification, activation, or health reporting
- THEN Herdr MUST remain `gated` or `unavailable`
- AND no Herdr selector, active file, external configuration, or reload command MAY be mutated
- AND the result MUST be non-success with `unsupported-contract` and actionable missing-proof diagnostics

#### Scenario: Herdr rendered output passes the bound harness

- GIVEN a version-bound harness is available and its supported checks pass
- WHEN a Herdr candidate is evaluated
- THEN the candidate MUST prove Dark role mapping, WCAG/APCA thresholds for text/status/focus/selection, rendered color identity, and selector/content parity before activation
- AND reload success MAY be reported only when the profile provides an observable result
- AND otherwise the result MUST state `reload-observation-unavailable` rather than claiming runtime or UI convergence

### Requirement: Proven Herdr slices remain safe

If and only if the gate opens, Herdr Light/Dark variants MUST be canonical-token-derived, schema-valid, ownership-classified, validated before activation, atomically selected, observable on reload, idempotent, and rollback-capable. Unknown fields and generic live-file mutation MUST remain prohibited.

#### Scenario: Verified profile is activated

- GIVEN a complete verified profile and managed Light/Dark variants
- WHEN a mode is selected
- THEN the candidate MUST validate before selection, the selector MUST change atomically, and reload failure MUST produce bounded rollback or `rollback-failed`
