# Herdr Theme Rollout Specification

## Purpose

Define an evidence-driven, repository-managed Dreamcoder Light/Dark rollout for Herdr without introducing configuration syntax that has not been verified against the affected runtime.

## Requirements

### Requirement: Runtime evidence gates Herdr configuration changes

The rollout MUST inspect and record the affected executable/application identity, installed version, active and mode-specific configuration paths, parsed validation result, and authoritative supported schema or help before adding or changing Herdr configuration fields.

#### Scenario: Herdr is confirmed as the affected consumer

- GIVEN the reported unknown-field failure is reproduced or attributed to the `herdr` runtime
- WHEN the executable identity, version, configuration files, and supported schema are recorded in sanitized form
- THEN repository configuration changes MAY proceed only against the recorded runtime contract

#### Scenario: Another consumer or unverifiable runtime is identified

- GIVEN inspection cannot confirm Herdr as the error-producing application or cannot establish an authoritative runtime contract
- WHEN rollout planning reaches configuration integration
- THEN no replacement Herdr syntax or speculative Herdr configuration MUST be added
- AND the repair MUST stop or be redirected to a separately scoped change

### Requirement: Managed configuration uses only confirmed runtime syntax

Any repository-controlled Herdr configuration MUST contain only fields and representations proven supported by the inspected affected runtime, and MUST derive palette values from canonical Dreamcoder tokens rather than an independent palette.

#### Scenario: Title fields are unsupported

- GIVEN inspection proves `window-title` and/or `tab-title` are invalid or unsupported
- WHEN managed Herdr variants are produced
- THEN those fields MUST NOT be emitted
- AND the limitation MUST be documented

#### Scenario: Supported title behavior is confirmed

- GIVEN authoritative runtime evidence identifies supported title configuration
- WHEN managed variants are produced
- THEN they MUST use exactly that confirmed representation
- AND the generated configuration MUST pass the runtime's validation mechanism

### Requirement: Light and Dark variants are complete and schema-valid

When Herdr is confirmed as an intended managed target, the repository MUST provide installable Dreamcoder Light and Dreamcoder Dark variants, both accepted by the confirmed runtime schema and independent of untracked pre-existing mode files.

#### Scenario: Both variants are generated from canonical tokens

- GIVEN a confirmed Herdr runtime contract and canonical Dreamcoder tokens
- WHEN theme synchronization runs
- THEN Light and Dark Herdr variants MUST be produced deterministically from the corresponding token mode
- AND both variants MUST preserve applicable WCAG/APCA palette guardrails

#### Scenario: One variant is invalid

- GIVEN either generated variant fails runtime validation
- WHEN installation or switching is attempted
- THEN that variant MUST NOT become active
- AND the result MUST identify the validation failure as actionable

### Requirement: Installation and repair provision managed files safely

Fresh installation and repair MUST provision all required Herdr managed files before activation, while preserving or backing up existing user-owned configuration according to established project conventions.

#### Scenario: Fresh install

- GIVEN Herdr is confirmed in scope and the executable is available
- WHEN a clean installation runs
- THEN both mode variants and required active-configuration support MUST exist before theme activation
- AND the executable MUST NOT be installed unless separately authorized by project policy

#### Scenario: Repair with existing external configuration

- GIVEN existing Herdr configuration files are present outside repository ownership
- WHEN repair or reinstall provisions managed files
- THEN existing user configuration MUST NOT be destructively overwritten
- AND the established backup or migration behavior MUST preserve a rollback path

### Requirement: Explicit and automatic mode selection converge

The active Herdr configuration MUST follow the existing `dark`/`light` mode contract, and explicit switching and automatic scheduling MUST reach the same validated final state.

#### Scenario: Explicit light-to-dark and dark-to-light switching

- GIVEN both validated variants are installed
- WHEN an explicit mode change is requested in either direction
- THEN the corresponding variant MUST become active
- AND the runtime MUST be reloaded or restarted using a confirmed supported mechanism

#### Scenario: Automatic scheduled selection

- GIVEN automatic mode selection chooses Light or Dark
- WHEN the theme fan-out completes
- THEN Herdr MUST receive the same corresponding active configuration and reload behavior as explicit switching

#### Scenario: Interactive Fish startup

- GIVEN installation has completed and an interactive Fish session starts Herdr
- WHEN Herdr reads its active configuration
- THEN it MUST use a valid managed or intentionally external configuration without depending on missing repository files

### Requirement: Runtime status reports partial failures truthfully

The rollout MUST distinguish successful reload, not running, not installed, invalid configuration, and reload failure, and MUST NOT report successful Herdr propagation when validation or reload fails.

#### Scenario: Herdr is absent

- GIVEN the Herdr executable is not installed or the application is not available
- WHEN installation or theme switching runs
- THEN other theme targets MUST continue according to existing behavior
- AND the result MUST clearly report Herdr as skipped or not installed

#### Scenario: Herdr validation fails

- GIVEN Herdr is installed but rejects the selected configuration
- WHEN switching or activation runs
- THEN the Herdr step MUST report an actionable validation failure
- AND it MUST NOT claim successful Herdr activation

#### Scenario: Herdr reload fails

- GIVEN the selected configuration is valid but the supported reload/restart operation fails
- WHEN switching completes
- THEN the result MUST report a Herdr reload failure
- AND it MUST preserve the distinction between successful unrelated target updates and failed Herdr propagation

### Requirement: Rollout regressions are validated across entrypoints

Automated coverage MUST validate the confirmed configuration format, both variants, installation ownership, backup or migration behavior, explicit mode propagation, automatic mode propagation, and failure statuses; runtime validation MUST cover both switching directions on the inspected application version.

#### Scenario: Existing Dreamcoder targets remain healthy

- GIVEN Herdr rollout changes are applied
- WHEN the standard theme tests and canonical theme health checks run
- THEN existing Light and Dark targets MUST continue to generate and apply successfully
- AND no new Herdr integration failure may be hidden by swallowed reload errors

#### Scenario: Rollback is exercised

- GIVEN a pre-change Herdr configuration was backed up
- WHEN the documented rollback procedure runs
- THEN the prior configuration and active selection MUST be restorable
- AND unaffected theme targets and interactive Fish startup MUST remain functional
