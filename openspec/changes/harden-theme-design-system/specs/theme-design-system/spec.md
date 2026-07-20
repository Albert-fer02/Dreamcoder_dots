# Theme Design System Specification

## Purpose

Define an auditable, terminal-first contract for Dreamcoder theme tokens, mode parity, state/contrast validation, generated artifacts, and CI enforcement without requiring broad palette redesign or all-target screenshot baselines.

## Requirements

### Requirement: Canonical layered token contract

The system MUST treat `themes/dreamcoder/tokens.json` as the canonical source and MUST expose a traceable layered contract consisting of palette primitives, semantic roles, and terminal/component state roles. Every enforced role MUST identify its canonical source, supported modes, and derivation or mapping rule. Generated or static representations MUST NOT be independently authoritative.

#### Scenario: A role is traceable to canonical input

- GIVEN an enforced terminal role such as `text`, `accent`, `focus`, or `error`
- WHEN the role is inspected in the contract or health report
- THEN its canonical token path, mode coverage, and target/component mapping are identifiable

#### Scenario: Static token drift is detected

- GIVEN a generated/static representation differs from the output derived from `tokens.json`
- WHEN health validation runs
- THEN validation MUST fail and identify the canonical source and divergent generated artifact

### Requirement: Explicit three-mode parity

The terminal-first contract MUST include `dark`, `light`, and `dusk`. Each enforced target MUST provide every required role and state for all three modes, or MUST declare an explicit, reviewable semantic mapping when its format cannot represent the role directly. Missing modes, silent fallback, and undocumented omission MUST fail validation. Parity MUST require equivalent supported roles and states, not identical color values.

#### Scenario: Complete mode coverage passes

- GIVEN all required terminal-first targets expose the required roles and states for `dark`, `light`, and `dusk`
- WHEN deterministic health validation runs
- THEN the parity check MUST pass regardless of intentional, documented mode-specific color differences

#### Scenario: Dusk or a required mapping is absent

- GIVEN a target has no `dusk` output or omits a required role without a declared mapping
- WHEN health validation runs
- THEN validation MUST fail with the mode, target, role/state, and corrective ownership identified

### Requirement: Reviewable state and contrast matrix

The system MUST maintain a reviewable matrix for the terminal-first core covering, at minimum, normal text, muted text, selected text, focus, perceptually significant borders, and semantic status states. Each matrix row MUST identify its foreground, background, mode scope, target scope, metric, threshold, and blocking severity.

#### Scenario: Matrix coverage is validated

- GIVEN the required matrix is evaluated against all three modes
- WHEN a required foreground/background or state pairing is missing
- THEN validation MUST fail and report the missing matrix row and affected target or artifact

### Requirement: WCAG and APCA policy enforcement

Text contrast MUST meet WCAG 4.5:1 minimum. Main text SHOULD meet 7.0:1 where the existing policy applies. Body text MUST meet the canonical APCA threshold of 75, or 50 for the mode-aware dark-background policy where explicitly applicable. Validation MUST preserve pure black/white avoidance where feasible and MUST NOT weaken an existing threshold solely to pass current output. The matrix MUST designate which metric governs each row.

#### Scenario: Contrast violation blocks validation

- GIVEN a matrix row measures below its applicable WCAG or APCA threshold
- WHEN health validation runs
- THEN validation MUST fail and report mode, token/state pair, measured value, required threshold, metric, and affected target/artifact

### Requirement: Deterministic health validation and blocking CI

Theme-health validation MUST be deterministic, reproducible locally, independent of active machine theme state, and scoped to the declared terminal-first contract. It MUST block CI when mode parity, matrix/contrast policy, canonical/generated synchronization, or generated-artifact integrity fails. Local and CI invocations MUST apply the same checks and classification rules.

#### Scenario: Healthy canonical outputs pass consistently

- GIVEN unchanged canonical inputs and valid generated outputs
- WHEN validation runs locally and in CI with isolated deterministic state
- THEN both runs MUST produce a passing result with equivalent findings

#### Scenario: Contract failure blocks CI

- GIVEN any required contract check fails
- WHEN the CI theme-health job runs
- THEN the job MUST fail with actionable diagnostics and MUST NOT downgrade the defect to a warning or silently allowlist it

### Requirement: Generated artifact ownership and synchronization

Every generated theme artifact in scope MUST have explicit ownership, generation path, provenance, mode coverage, and validation scope. The canonical workflow MUST be able to regenerate it deterministically. Unexpected, stale, malformed, or incorrectly scoped artifacts MUST receive an actionable classification rather than being ignored.

#### Scenario: Regeneration restores a stale artifact

- GIVEN an in-scope artifact is stale or manually diverges
- WHEN the supported generation workflow runs from canonical tokens
- THEN it MUST deterministically restore the expected artifact, and health validation MUST pass afterward

#### Scenario: Unowned artifact is discovered

- GIVEN validation discovers a generated-looking artifact without declared ownership or provenance
- WHEN health validation runs
- THEN validation MUST fail and identify the artifact, expected lifecycle decision, and required owner/action

### Requirement: OpenCode artifact lifecycle is enforced

The OpenCode generated artifact MUST have one explicit lifecycle classification—checked-in, ephemeral, or workflow-specific—with its owner, generation source, mode coverage, and validation scope documented. The implementation MUST resolve the existing failure at that source contract and MUST NOT use a global validator weakening or unexplained permanent exception. Valid artifacts MUST pass, while equivalent drift or corruption MUST fail.

#### Scenario: Valid OpenCode output passes

- GIVEN an OpenCode artifact produced through its documented generation path and lifecycle
- WHEN health validation runs
- THEN the artifact MUST be accepted for every required mode and target scope

#### Scenario: OpenCode corruption or drift fails

- GIVEN the OpenCode artifact is malformed, stale, mode-incomplete, or inconsistent with canonical generation
- WHEN health validation runs
- THEN validation MUST fail with a specific ownership/provenance or integrity diagnostic

### Requirement: Focused regression coverage protects the contract

Automated tests MUST cover valid and invalid representative cases for layered synchronization, dark/light/dusk parity, contrast/state policy, deterministic health classification, and OpenCode artifact ownership and integrity. The change MUST NOT require screenshot baselines for every supported target.

#### Scenario: Representative negative cases remain blocking

- GIVEN tests introduce a stale generated source, missing dusk role, contrast-breaking state, or corrupted OpenCode artifact
- WHEN focused health tests run
- THEN the corresponding check MUST fail deterministically with the required diagnostic context

#### Scenario: Screenshot infrastructure is not required

- GIVEN the terminal-first contract and focused regression suite are complete
- WHEN acceptance is evaluated
- THEN completion MUST NOT depend on all-target screenshot baselines or visual snapshots
