# Rollout Contract Specification

## Purpose

Define the authoritative, fail-closed contract for Dreamcoder Light/Dark coverage across rendering, installation, activation, and verification. `dusk` is design-system-only and MUST NOT be activated at runtime.

## Requirements

### Requirement: The required-target manifest owns rollout classification

The system MUST maintain one tracked manifest consumed by generation, installation/repair, switching, health checks, and tests. Every audited target MUST have exactly one classification: `required`, `optional` with a reason, or `excluded` with a reason. Each entry MUST identify ownership, Light/Dark output or selector contract, destination, validation, reload observability, rollback capability, and version constraints.

#### Scenario: An audited target is unclassified

- GIVEN an audited renderer, artifact, hook, installer target, or consumer is absent from the manifest
- WHEN rollout health validation runs
- THEN validation MUST fail and identify the unclassified entry and owning domain

#### Scenario: Inventories disagree

- GIVEN generation, installation, activation, or health code maintains coverage not represented by the manifest
- WHEN parity validation runs
- THEN validation MUST fail with both inventories and the required reconciliation action

### Requirement: Required and optional outcomes are truthful

A required target MUST fail the aggregate operation when its output, ownership, write, selector, validation, or observable activation contract fails. An unavailable optional target MAY be skipped only with target, reason, consequence, and corrective action. A present optional target that is selected and mutated MUST report validation or activation failure, not a successful skip.

#### Scenario: Required target cannot activate

- GIVEN a required target was rendered and installed
- WHEN validation or reload fails
- THEN the aggregate result MUST be non-success, name the target and phase, and invoke the bounded rollback contract where supported

#### Scenario: Optional integration is absent

- GIVEN an optional integration is unavailable
- WHEN rollout runs
- THEN it MUST remain unchanged and report an actionable skip containing the four required diagnostic fields

### Requirement: ML4W and Gentleman ownership boundaries are preserved

ML4W MUST remain authoritative for layout, behavior, wallpaper, Matugen lifecycle, and launch structure. Dreamcoder MUST own only declared color-bearing overlays and MUST import them after ML4W/Gentleman defaults.

#### Scenario: Overlay ordering is inspected

- GIVEN an ML4W/Gentleman default and a Dreamcoder color overlay exist
- WHEN the active configuration is evaluated
- THEN the Dreamcoder overlay MUST be loaded after the default without replacing unrelated structure or behavior
