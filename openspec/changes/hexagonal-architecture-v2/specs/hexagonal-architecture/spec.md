# Hexagonal Architecture Specification

## Purpose

Establish the second architecture slice of the Dreamcoder chained SDD series: one formal, versioned Python renderer port with declarative, immutable registrations for every active sync consumer; one typed sync registry from which paths, variants, coverage, render planning, writes, and summaries are derived; `DreamcoderThemes/dreamcoder/targets.json` as the only hand-authored installer inventory consumed identically by Python, Go, and shell; naming normalization as metadata migration with fail-closed preflight; and contract validation across all three languages — all while preserving existing theme output, Night behavior, WCAG/APCA gates, `prepare()`'s fail-closed validation-first boundary, and without shell god-script refactoring, visual baselines, palette redesign, motion completion, new renderer/installer targets, or resuming the archived July `hexagonal-architecture-refactor`.

## Requirements

### Requirement: Formal renderer port

The system MUST provide a formal Python renderer port whose required operation is semantically `render(palette: dict[str, str]) -> str`. A `Mapping[str, str]` MAY be accepted internally for immutability and type safety, but existing callers and leaf renderers MUST remain compatible with the established `dict[str, str] -> str` contract. The primary port MUST be a typed `Protocol` so existing function-based renderers conform without a mandatory class hierarchy. Non-uniform functions — including transparent OpenCode rendering, named Zellij themes, the Nvim dispatcher, and version-bound Herdr output — MUST be exposed through small adapters that bind target-specific context while presenting the same one-palette/one-string port. An ABC base MAY be provided for stateful adapters, but it MUST NOT create a second renderer contract.

#### Scenario: Function renderer conforms to the port

- GIVEN an existing leaf renderer that accepts a `dict[str, str]` palette and returns a string
- WHEN its conformance against the formal port is checked
- THEN it satisfies the port without a class wrapper, and its existing callers remain compatible

#### Scenario: Special consumer renders through a single-port adapter

- GIVEN a non-uniform consumer such as transparent OpenCode or version-bound Herdr
- WHEN its adapter renders
- THEN the adapter accepts exactly one palette mapping, returns a `str`, and binds its target-specific context internally

#### Scenario: No second renderer contract

- GIVEN an ABC base provided for stateful adapters
- WHEN any consumer inspects the renderer contract
- THEN exactly one renderer contract exists, and the ABC base does not define a distinct render signature

### Requirement: Immutable declarative renderer registrations

Each active consumer MUST be declared by exactly one immutable registration placed adjacent to its leaf renderer module. Each registration MUST declare at least: a unique active consumer ID; the renderer adapter implementing the formal port; a renderer contract version; the closed set of supported render modes (`dark`, `light`, and `night` for the current active inventory); output/selection metadata needed by sync, including whether the consumer has active output, repository variants, or both; and a human-readable summary label. Registrations MUST assemble deterministically into one registry and MUST NOT depend on unordered import side effects. Adding a normal renderer target MUST require one renderer declaration, not edits to multiple orchestration tables.

#### Scenario: One declaration adds a normal target

- GIVEN a new normal renderer target
- WHEN it is added to the system
- THEN a single adjacent declarative registration is the only required edit, and the registry, paths, variants, coverage, writes, and summary derive from it without edits to `ThemePaths`, `sync_active_targets()`, `print_summary()`, `VARIANT_REGISTRY`, or coverage declarations

#### Scenario: Deterministic assembly independent of import order

- GIVEN registrations spread across multiple leaf renderer modules
- WHEN the registry is assembled under different import orders
- THEN the resulting registration order is identical in every run and independent of unordered import side effects

#### Scenario: Closed mode set is declared and renderable

- GIVEN a registration declaring its supported modes
- WHEN the registration is validated
- THEN its mode set is a closed subset of {`dark`, `light`, `night`}, every declared mode is renderable by its adapter, and no undeclared mode is served

### Requirement: Renderer registry validation and purity

The registry MUST be validated before any rendering or writing. Validation MUST reject duplicate consumer IDs, unsupported contract versions, missing modes, invalid or duplicate output ownership, a renderer that does not satisfy the port, and non-string renderer results. Registry discovery and conformance checks MUST NOT write files, run selectors, or invoke installer or subprocess behavior.

#### Scenario: Duplicate consumer ID is rejected

- GIVEN two registrations declaring the same consumer ID
- WHEN registry validation runs
- THEN validation fails before any render or write, and the diagnostic names the duplicated ID

#### Scenario: Non-string renderer result is rejected

- GIVEN a renderer that returns a non-string result for a declared mode
- WHEN the conformance check renders that mode with a valid representative palette
- THEN validation fails, naming the consumer and mode

#### Scenario: Discovery and conformance are side-effect-free

- GIVEN registry discovery and conformance checks for a consumer that is not intended to be selected
- WHEN discovery and conformance run
- THEN no file is written, no selector runs, and no installer or subprocess behavior is invoked

### Requirement: Exact 32-consumer registry migration and CI bijection

All 32 consumers currently named by `sync.py:COVERAGE` MUST migrate to typed registrations, including adapter-backed special cases. The exact scope MUST be the SDD 1 active sync consumer inventory — `kitty`, `kitty_ui`, `ghostty`, `warp`, `starship`, `codex_app`, `codex_theme`, `bat_theme`, `pi_theme`, `antigravity`, `tmux`, `zsh_syntax`, `ls_colors`, `bat`, `delta`, `fzf`, `btop`, `dunst`, `firefox`, `obsidian`, `cava`, `opencode`, `zellij`, `nvim`, `hyprland`, `hypr_colors_lua`, `hypr_colors_conf`, `waybar`, `waybar_matugen`, `rofi`, `rofi_matugen`, `herdr` — not every record of the 37-ID rollout manifest. Selector-only, excluded, scheduler, maintenance, and unrelated-application records MUST NOT be registered as renderers. CI MUST instantiate every registration, render every declared mode with a valid representative palette, assert string output, and prove an exact, duplicate-free bijection between the expected 32 consumer IDs and the renderer registry; six-target or sample-only contract coverage MUST NOT be accepted as sufficient.

#### Scenario: Exact bijection is proven in CI

- GIVEN the expected set of 32 active consumer IDs
- WHEN the CI conformance test instantiates every registration and renders every declared mode with a valid representative palette
- THEN the registered ID set equals the expected set exactly with no additions, omissions, or duplicates, and every rendered output is asserted to be a string

#### Scenario: Special consumers are registered through adapters

- GIVEN the special consumers `opencode`, `zellij`, `nvim`, and `herdr`
- WHEN the registry is enumerated
- THEN each has exactly one typed registration backed by an adapter and appears in the 32-ID bijection

#### Scenario: Non-renderer rollout records are excluded

- GIVEN a selector-only, excluded, scheduler, maintenance, or unrelated-application rollout record from the 37-ID manifest
- WHEN the renderer registry is built
- THEN the record is absent from the registry, and the bijection still passes with exactly the 32 consumer IDs

### Requirement: Single declarative sync registry

The system MUST replace the duplicated target encoding across `ThemePaths`, `sync_active_targets()`, `render_coverage_plan()`, `COVERAGE`, `VARIANT_REGISTRY`, explicit repository branches, and `print_summary()` with one typed sync registry built around the renderer registrations. Each sync entry MUST declaratively own: active-path resolution, including existing environment overrides and XDG/home/repository bases; repository output templates for each supported mode where variants exist; writer and selector strategy as explicit adapters rather than target-name conditionals; active versus repository-only behavior; coverage classification and selection strategy; and summary label and reportable destination. The in-memory render plan, `PreparedSync.coverage`, active writes, repository-variant writes, and summary rows MUST be derived from that registry, and validation MUST complete before the first writer or selector runs, preserving SDD 1's fail-closed preparation boundary.

#### Scenario: One registration drives the whole derived plan

- GIVEN a single registration for one consumer
- WHEN the sync registry builds the render plan
- THEN the render plan, coverage row, active write, repository-variant writes, and summary row for that consumer all derive from that one entry, with no target-specific edits elsewhere

#### Scenario: Fail-closed preparation is preserved

- GIVEN a registry that fails validation
- WHEN `prepare()` runs
- THEN no writer or selector runs, no file is written, and no settings mutation occurs

#### Scenario: Derived output is deterministic

- GIVEN the same registry and palette inputs
- WHEN the render plan, coverage, and summary are derived twice
- THEN both derivations are identical and in deterministic order

### Requirement: Adapter-bound specialized behavior and expected consumer-ID set

Specialized behavior where formats genuinely differ — such as profile-aware Ghostty/Warp/Zellij selectors, OpenCode transparency, Herdr's version-bound repository variants, and active-only Matugen bridges — MUST be preserved and MUST be bound through declared adapters in the registry instead of separate coverage bookkeeping. The hard-coded "32" implementation assumption MUST be replaced with an explicit expected consumer-ID set checked against the registry; CI MUST fail on accidental addition, omission, or duplication until the inventory change is intentionally reviewed.

#### Scenario: Specialized behavior is preserved through declared adapters

- GIVEN a consumer with genuinely different behavior, such as Herdr version-bound repository variants or an active-only Matugen bridge
- WHEN sync derives writes and selections from the registry
- THEN the specialized behavior is produced through the consumer's declared adapter, and no separate coverage bookkeeping encodes it

#### Scenario: Expected consumer-ID set gates CI

- GIVEN the explicit expected 32-ID set
- WHEN the registry is compared against it in CI
- THEN any accidental addition, omission, or duplication of a consumer ID fails CI with a diagnostic naming the discrepancy

#### Scenario: Intentional inventory change is reviewed and passes

- GIVEN an intentionally reviewed change to the expected consumer-ID set
- WHEN the expected set is updated and the registry matches it
- THEN the bijection passes and the reviewed change is recorded

### Requirement: ThemePaths facade and preserved write semantics

`ThemePaths` MUST be reduced to a compatibility facade generated from registry path resolvers, or removed after callers migrate; every retained default MUST correspond to a registered consumer and a real write or selection path. Temporary Herdr paths and other special state paths MUST be owned by their adapter rather than presented as generic theme-target defaults. The system MUST preserve `write_if_changed()` behavior, atomic and profile-aware writer semantics, deterministic ordering, and validation-before-write; this change MUST NOT authorize output-format or visual changes.

#### Scenario: No unowned or dead target defaults remain

- GIVEN the post-migration `ThemePaths` facade or its replacement
- WHEN every retained default is traced to its consumer
- THEN each default corresponds to a registered consumer and a real write or selection path, and no generic default exists without a live consumer

#### Scenario: Adapter-owned special state paths

- GIVEN a temporary or special state path such as a Herdr version-bound path
- WHEN path resolution runs
- THEN the path is resolved by the owning adapter, and it is not surfaced as a generic theme-target default

#### Scenario: Writer and format behavior is unchanged

- GIVEN an unchanged consumer output
- WHEN the registry-driven writer runs
- THEN `write_if_changed()`, atomic and profile-aware writer semantics, deterministic ordering, and validation-before-write behave exactly as before, and the produced bytes and formats are unchanged

### Requirement: targets.json canonical installer catalog

The system MUST extend `DreamcoderThemes/dreamcoder/targets.json` and `targets.schema.json` with a canonical installer catalog sufficient to derive all current installer behavior. The catalog MUST represent: stable component identity and display metadata used by the Go CLI/TUI; the exact case-sensitive GNU Stow module directory, without deriving it from a target ID; zero or more component aliases where several selections share one module, such as Fish/Zsh/Bash to `DreamcoderShell`; destination path templates and their base (`HOME`, XDG config, XDG data, or another explicitly supported root); ownership and conflict policy currently represented by `allowed_ownership` and Python classification; and category, default-selection, and installability metadata needed by `KnownComponents()`. Ambiguous or missing catalog entries MUST fail closed rather than be inferred from casing.

#### Scenario: Shared-module aliases resolve to one exact module

- GIVEN catalog entries for Fish, Zsh, and Bash sharing one module
- WHEN installer resolution runs
- THEN all three resolve to the exact module `DreamcoderShell`, and Stow is invoked once for the deduplicated module

#### Scenario: Exact module casing comes from the catalog

- GIVEN catalog entries for `DreamcoderBat` and `DreamcoderAntigravity`
- WHEN module resolution runs
- THEN the emitted module names match repository directory casing exactly and are read from the catalog, never derived from target IDs by convention

#### Scenario: Ambiguous catalog entries fail closed

- GIVEN a catalog entry missing its module, destination base, or ownership value
- WHEN schema and loader validation runs
- THEN validation fails before any backup, Stow, or filesystem mutation

### Requirement: Manifest relationship clarity among rollout, renderer, and installer inventories

`targets.json` MUST express explicitly that the 37-ID rollout inventory, the 32 active renderer consumers, and the installable component catalog are related but not one-to-one. A selector-only or excluded rollout record MUST NOT be treated as automatically installable; one installer component MAY own several destinations; and several UI component aliases MAY resolve to one Stow module. The manifest MUST express these relationships instead of relying on naming conventions.

#### Scenario: Selector-only rollout record is not automatically installable

- GIVEN a rollout record whose category is selector-only or excluded
- WHEN the installer catalog is derived from the manifest
- THEN the record is not emitted as an installable component unless the catalog explicitly declares it installable

#### Scenario: One installer component owns several destinations

- GIVEN an installer component declared with multiple destinations
- WHEN the install plan is derived
- THEN every declared destination is included under that component with its declared base and path template

#### Scenario: Multiple aliases deduplicate to one module

- GIVEN several component aliases resolving to one Stow module
- WHEN the install plan is derived
- THEN the shared module appears exactly once in the ordered, deduplicated module list

### Requirement: Canonical module casing and migration aliases

Exact PascalCase repository directory names MUST be canonical, including `DreamcoderBat` and `DreamcoderAntigravity`. Kebab-case values such as `Dreamcoder-bat` MUST be accepted only as documented migration aliases and MUST NEVER be emitted as the Stow module passed to GNU Stow.

#### Scenario: Legacy alias emits canonical module casing

- GIVEN a component selected through its legacy kebab alias `Dreamcoder-bat`
- WHEN the Stow command is built
- THEN the emitted module is `DreamcoderBat` and never `Dreamcoder-bat`

#### Scenario: Undocumented kebab value is rejected, not transformed

- GIVEN a kebab-case value that is not listed as a documented migration alias
- WHEN installer validation runs
- THEN the value is rejected as unknown rather than transformed into a module name by casing convention

### Requirement: Derived Go, shell, and Python installer inventories with parity

Hand-authored Go `ModuleMap` and `KnownComponents()` data MUST be replaced with a validated derivation from `targets.json`; a generated or embedded Go artifact is acceptable for a standalone binary only when CI proves it is reproducible and current, and developers MUST NOT maintain an independent Go inventory. The hand-authored `DREAMCODER_MODULES` and `DREAMCODER_TARGETS` shell arrays MUST be replaced with output from a validated manifest reader or reproducibly generated shell data; shell MUST consume safely quoted array data and continue to call GNU Stow with exact canonical module names. `src/dreamcoder_theme/installer.py:managed_targets()` and `installer_plan()` MUST load the same manifest catalog for modules, destinations, ownership checks, backup planning, and emitted Stow commands. Cross-language parity checks MUST prove that Python, Go, and shell resolve the same selected components to the same ordered, deduplicated canonical modules and destination ownership policies.

#### Scenario: Go inventory derives from the manifest and is drift-checked

- GIVEN `targets.json` as the only hand-authored installer inventory
- WHEN Go builds or its tests run
- THEN `ModuleMap` and `KnownComponents()` derive from the manifest, and CI proves the generated or embedded derivative is reproducible and current with `targets.json`

#### Scenario: Shell consumes validated quoted data with canonical module names

- GIVEN the shell installer flow
- WHEN `dreamcoder-maintenance.sh` or a dependent flow runs
- THEN shell loads safely quoted module and target data from the validated manifest reader or generated output, does not implement an independent JSON parser, and calls GNU Stow with exact canonical module names

#### Scenario: Cross-language install plans are identical

- GIVEN the same selected components and ownership policy in `targets.json`
- WHEN Python, Go, and shell each resolve an install plan
- THEN all three produce the same ordered, deduplicated canonical modules and the same destination ownership policies

### Requirement: Migration preflight and metadata normalization

Naming normalization MUST be treated as metadata migration, not destructive directory migration; existing repository-managed symlinks that already resolve inside the repository MUST remain managed even when they were selected through a legacy kebab alias. Before restowing, the system MUST produce a manifest-derived preflight plan that classifies each destination as missing, repository-managed, legacy-managed, or conflict; existing non-repository files and directories MUST remain conflicts and MUST follow the current backup-before-mutation behavior. The migration MUST resolve recognized legacy names to canonical PascalCase modules, restow canonical modules idempotently, and report stale aliases or links; it MUST NOT delete an existing path merely because its label changed. Existing Go component names and supported CLI selections MUST remain compatible through explicit aliases; unknown components or manifest/schema errors MUST fail before backup, Stow, or filesystem mutation. The migration MUST record enough preflight evidence to restore the prior symlink/module selection if migration or restow fails.

#### Scenario: Legacy-managed destination restows idempotently without deletion

- GIVEN a managed installation whose symlink was selected through a legacy kebab alias and resolves inside the repository
- WHEN migration runs
- THEN the destination is classified as managed, resolved to the canonical PascalCase module, restowed idempotently, and the existing managed link is preserved without deletion

#### Scenario: Real conflict is backed up before mutation

- GIVEN a destination occupied by a non-repository file or directory
- WHEN migration runs
- THEN the destination is classified as conflict, backed up, and reported before any mutation, preserving the current backup-before-mutation behavior

#### Scenario: Unknown component or schema error fails before mutation

- GIVEN an unknown component name or a manifest/schema error
- WHEN migration runs
- THEN it fails before backup, Stow, or any filesystem mutation, and no partial migration state is left

#### Scenario: Preflight evidence supports rollback

- GIVEN a migration preflight plan
- WHEN migration proceeds
- THEN sufficient evidence — prior managed symlink targets, selected aliases, canonical modules, conflicts, and backup ID — is recorded to restore the prior selection if migration or restow fails

### Requirement: Migration test coverage

Migration tests MUST cover at least canonical installs, legacy alias input, shared-module deduplication, managed symlinks, external symlink conflicts, ordinary-file conflicts, and missing destinations.

#### Scenario: Canonical install migrates cleanly

- GIVEN an install that already uses canonical PascalCase module names
- WHEN migration tests run
- THEN every destination is classified as repository-managed and the restow is idempotent

#### Scenario: External symlink conflict is not treated as managed

- GIVEN a destination whose symlink resolves outside the repository
- WHEN migration tests run
- THEN the destination is classified as conflict and follows backup-before-mutation rather than being treated as managed

#### Scenario: Missing destination is classified and created

- GIVEN a destination that does not exist
- WHEN migration tests run
- THEN the destination is classified as missing and is created and restowed by the canonical install path

### Requirement: Port, registry, and sync test suite

Package tests MUST cover renderer-port structural conformance, registry schema and version validation, mode support, deterministic order, duplicate ownership, output type, and exact 32-consumer coverage. Sync tests MUST prove that one registration drives render planning, variant paths, active writes, coverage, and summary without target-specific edits elsewhere.

#### Scenario: Port and registry failure modes are asserted

- GIVEN the focused package test suite
- WHEN it runs
- THEN it exercises port structural conformance, schema and version validation, mode support, deterministic order, duplicate ownership, output type, and exact 32-consumer coverage, and each failure mode is asserted

#### Scenario: One registration drives the full sync derivation

- GIVEN a test registration for one consumer
- WHEN the sync registry derives the render plan, variant paths, active writes, coverage, and summary
- THEN every derived structure reflects only that registration, with no target-specific edits elsewhere, and the test asserts the derivation

### Requirement: Manifest schema, loader, parity, and drift tests

`targets.json` schema and loader tests MUST cover installer catalog relationships, exact module casing, path-template validation, aliases, shared modules, and ownership values. Go tests MUST cover manifest-derived component and module resolution, and Python and shell tests MUST cover identical install plans. CI MUST fail when a generated or embedded derivative differs from `targets.json`.

#### Scenario: Schema rejects non-canonical casing and invalid templates

- GIVEN a manifest entry with a non-canonical module value or an invalid destination path template
- WHEN schema and loader tests run
- THEN the entry is rejected with a diagnostic naming the field

#### Scenario: Derivative drift fails CI

- GIVEN a generated or embedded Go or shell derivative that differs from `targets.json`
- WHEN the CI freshness check runs
- THEN CI fails, naming the derivative and the drift from the manifest

### Requirement: Contributor documentation and preserved gates

The project MUST document the contribution workflow for adding a renderer consumer and an installer component, including when those inventories are intentionally different. The change MUST keep the existing full Python, Go, shell, schema, and theme-health gates and MUST NOT weaken the SDD 1 WCAG/APCA or validation-first guarantees.

#### Scenario: Renderer and installer contribution workflows are documented

- GIVEN the contributor documentation
- WHEN a contributor adds a renderer consumer or an installer component
- THEN the documentation describes the single declarative registration or the catalog edit required, and when the renderer and installer inventories intentionally differ

#### Scenario: Existing gates remain blocking

- GIVEN the architecture change applied
- WHEN the full Python, Go, shell, schema, and theme-health gates run
- THEN they behave exactly as before the change, including blocking WCAG/APCA validation and validation-first fail-closed behavior
