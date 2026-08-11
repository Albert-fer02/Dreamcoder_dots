# Proposal: Hexagonal Architecture V2

## Intent

Create the second architecture slice in the Dreamcoder chained SDD series by replacing the Python theme engine's ad hoc renderer orchestration and the repository's three independent installer inventories with explicit, validated contracts.

The product outcome is safer extension and maintenance:

- a renderer target is added once through a declarative registration instead of by coordinating edits across `ThemePaths`, `sync_active_targets()`, `print_summary()`, `VARIANT_REGISTRY`, and coverage declarations;
- every one of the 32 active sync consumers implements the same formal `dict[str, str] -> str` rendering port and declares its contract version and supported modes;
- paths, variants, coverage, and summary reporting are generated from one sync registry;
- `DreamcoderThemes/dreamcoder/targets.json` is the single source of truth for installable components, exact GNU Stow module names, destinations, and ownership policy across the Go installer, shell maintenance flow, and Python install plan;
- canonical module names match repository directories, including `DreamcoderBat` and `DreamcoderAntigravity`, while kebab-case remains limited to stable manifest IDs and user-facing aliases where appropriate.

This is a new change. The archived `hexagonal-architecture-refactor` documented the original July audit, but its shell-library work has already landed and its broad shell/Python rewrite plan is stale. This proposal uses that audit only as evidence for the remaining Python renderer and installer gaps; it does not resume or duplicate the earlier shell scope.

## Current-State Gap

SDD 1 established a validation-first `prepare()` boundary, an immutable `PreparedSync`, profile-aware writers, dual WCAG/APCA validation, and an explicit `COVERAGE` tuple for 32 active consumers. Those improvements expose the next architectural bottlenecks:

- `src/dreamcoder_theme/renderers.py` is a flat import/export hub for roughly 30 leaf functions. Most renderers accept `dict[str, str]` and return `str`, but the contract is only conventional; special arguments and non-uniform consumers are coordinated manually in `sync.py`.
- `src/dreamcoder_theme/sync.py` still encodes the same target in several structures and branches: `sync_active_targets()`, `VARIANT_REGISTRY`, the 32-row `COVERAGE` declaration, `render_coverage_plan()`, explicit repository writes, and `print_summary()`. A target can be rendered, written, summarized, or coverage-counted inconsistently.
- `src/dreamcoder_theme/settings.py:ThemePaths` contains a long positional path model with repository, XDG, environment, active, selector, and temporary defaults mixed together. Some defaults are not evidence of a live consumer, so path existence and target support can drift.
- `DreamcoderThemes/dreamcoder/targets.json` has a validated 37-ID rollout manifest, but its `render.renderer` values and generated repository paths are not the active 32-consumer registry used by `sync.py`.
- Installer metadata is independently authored in at least three places: Go's `installer/internal/dotfiles/paths.go` (`ModuleMap` and `KnownComponents()`), shell arrays in `scripts/dreamcoder-lib.sh` consumed by `dreamcoder-maintenance.sh`, and Python's `src/dreamcoder_theme/installer.py` (`managed_targets()` and `installer_plan()`). Their inventories, paths, and naming rules differ.
- The manifest currently uses names such as `Dreamcoder-bat` and `Dreamcoder-antigravity`, while Go and repository directories use `DreamcoderBat` and `DreamcoderAntigravity`. Blindly transforming kebab IDs into module names cannot represent shared modules such as `DreamcoderShell` or aliases such as Fish, Zsh, and Bash.

The result is change amplification, false confidence from partial coverage, and installer behavior that depends on which entry point a user chooses.

## Scope

### 1. Formal renderer port and declarative renderer registry

- Introduce a formal Python renderer port whose required operation is semantically `render(palette: dict[str, str]) -> str`. `Mapping[str, str]` may be accepted internally for immutability/type safety, but existing callers and leaf renderers must remain compatible with the established `dict[str, str] -> str` contract.
- Use a typed `Protocol` as the primary port so existing function-based renderers can migrate without a mandatory class hierarchy. Non-uniform functions such as transparent OpenCode rendering, named Zellij themes, the Nvim dispatcher, and version-bound Herdr output must be exposed through small adapters that bind target-specific context while presenting the same one-palette/one-string port. An ABC base may be provided for stateful adapters, but it must not create a second renderer contract.
- Define immutable renderer registrations. Each registration must declare at least:
  - a unique active consumer ID;
  - the renderer adapter implementing the formal port;
  - a renderer contract version;
  - the closed set of supported render modes (`dark`, `light`, and `night` for the current active inventory);
  - output/selection metadata needed by sync, including whether the consumer has active output, repository variants, or both;
  - a human-readable summary label.
- Keep registrations adjacent to their leaf renderer modules and assemble them deterministically into one registry. Registration must not depend on unordered import side effects. Adding a normal target must require one renderer declaration, not edits to multiple orchestration tables.
- Validate the registry before rendering or writing. Validation must reject duplicate consumer IDs, unsupported contract versions, missing modes, invalid or duplicate output ownership, a renderer that does not satisfy the port, and non-string renderer results.
- Preserve renderer purity: registry discovery and conformance checks must not write files, run selectors, or invoke installer/subprocess behavior.
- Migrate all 32 consumers currently named by `sync.py:COVERAGE`, including adapter-backed special cases. The exact scope is the active sync consumer inventory established by SDD 1, not every record in the 37-ID rollout manifest. Selector-only, excluded, scheduler, maintenance, and unrelated-application records are not renderers.
- Add CI conformance tests that instantiate every registration, render every declared mode with a valid representative palette, assert string output, and prove an exact bijection between the expected 32 consumer IDs and the renderer registry. Six-target or sample-only contract coverage is not sufficient.

### 2. One declarative sync registry for paths, variants, coverage, and summaries

- Replace the target-specific duplication across `ThemePaths`, `sync_active_targets()`, `render_coverage_plan()`, `COVERAGE`, `VARIANT_REGISTRY`, explicit repository branches, and `print_summary()` with one typed sync registry built around the renderer registrations.
- Each sync entry must declaratively own:
  - active-path resolution, including existing environment overrides and XDG/home/repository bases;
  - repository output templates for each supported mode where variants exist;
  - writer and selector strategy, represented as explicit adapters rather than target-name conditionals;
  - active versus repository-only behavior;
  - coverage classification and selection strategy;
  - summary label and reportable destination.
- Derive the in-memory render plan, `PreparedSync.coverage`, active writes, repository-variant writes, and summary rows from that registry. Validation must complete before the first writer or selector runs, preserving SDD 1's fail-closed preparation boundary.
- Preserve specialized behavior where formats genuinely differ—such as profile-aware Ghostty/Warp/Zellij selectors, OpenCode transparency, Herdr's version-bound repository variants, and active-only Matugen bridges—but bind that behavior through declared adapters in the registry instead of separate coverage bookkeeping.
- Replace the hard-coded “32” implementation assumption with an explicit expected consumer-ID set checked against the registry. The current accepted set has 32 entries; CI must fail on accidental addition, omission, or duplication until the inventory change is intentionally reviewed.
- Reduce `ThemePaths` to a compatibility facade generated from registry path resolvers or remove it after callers migrate. Every retained default must correspond to a registered consumer and a real write/selection path. Temporary Herdr paths and other special state paths must be owned by their adapter rather than presented as generic theme-target defaults.
- Preserve `write_if_changed()` behavior, atomic/profile-aware writer semantics, deterministic ordering, and validation-before-write. This change reorganizes ownership; it does not authorize output-format or visual changes.

### 3. `targets.json` as the installer single source of truth

- Extend `DreamcoderThemes/dreamcoder/targets.json` and `targets.schema.json` with a canonical installer catalog sufficient to derive all current installer behavior. The catalog must represent:
  - stable component identity and display metadata used by the Go CLI/TUI;
  - the exact case-sensitive GNU Stow module directory, without deriving it from a target ID;
  - zero or more component aliases where several selections share one module, such as Fish/Zsh/Bash to `DreamcoderShell`;
  - destination path templates and their base (`HOME`, XDG config, XDG data, or another explicitly supported root);
  - ownership and conflict policy currently represented by `allowed_ownership` and Python classification;
  - category/default-selection/installability metadata needed by `KnownComponents()`.
- Clarify the target ambiguity explicitly: the 37-ID rollout inventory, the 32 active renderer consumers, and the installable component catalog are related but not one-to-one. A selector-only or excluded rollout record is not automatically installable; one installer component may own several destinations; several UI component aliases may resolve to one Stow module. The manifest must express these relationships instead of relying on naming conventions.
- Make exact PascalCase repository directory names canonical, including `DreamcoderBat` and `DreamcoderAntigravity`. Kebab-case values such as `Dreamcoder-bat` may be accepted only as documented migration aliases; they must never be emitted as the Stow module passed to GNU Stow.
- Replace hand-authored Go `ModuleMap` and `KnownComponents()` data with a validated derivation from `targets.json`. A generated or embedded Go artifact is acceptable for a standalone binary only when CI proves it is reproducible and current; developers must never maintain an independent Go inventory.
- Replace `DREAMCODER_MODULES` and `DREAMCODER_TARGETS` hand-authored shell arrays with output from a validated manifest reader or reproducibly generated shell data. Shell must consume safely quoted array data and continue to call GNU Stow with exact canonical module names.
- Make `src/dreamcoder_theme/installer.py:managed_targets()` and `installer_plan()` load the same manifest catalog for modules, destinations, ownership checks, backup planning, and emitted Stow commands.
- Add cross-language parity checks proving that Python, Go, and shell resolve the same selected components to the same ordered, deduplicated canonical modules and destination ownership policies.

### 4. Existing-install migration and compatibility

- Treat naming normalization as a metadata migration, not a destructive directory migration. Existing repository-managed symlinks that already resolve inside the repository must remain managed even if they were selected through a legacy kebab alias.
- Before restowing, produce a manifest-derived preflight plan that classifies each destination as missing, repository-managed, legacy-managed, or conflict. Existing non-repository files/directories remain conflicts and must follow the current backup-before-mutation behavior.
- Resolve recognized legacy names to canonical PascalCase modules, restow canonical modules idempotently, and report stale aliases or links. Do not delete an existing path merely because its label changed.
- Keep existing Go component names and supported CLI selections compatible through explicit aliases. Unknown components or manifest/schema errors must fail before backup, Stow, or filesystem mutation.
- Record enough preflight evidence to restore the prior symlink/module selection if migration or restow fails. Migration tests must cover at least canonical installs, legacy alias input, shared-module deduplication, managed symlinks, external symlink conflicts, ordinary-file conflicts, and missing destinations.

### 5. Contract validation, tests, and documentation

- Extend package tests for renderer-port structural conformance, registry schema/version validation, mode support, deterministic order, duplicate ownership, output type, and exact 32-consumer coverage.
- Add sync tests proving one registration drives render planning, variant paths, active writes, coverage, and summary without target-specific edits elsewhere.
- Extend `targets.json` schema/loader tests for installer catalog relationships, exact module casing, path-template validation, aliases, shared modules, and ownership values.
- Add Go tests for manifest-derived component/module resolution and Python/shell tests for identical install plans. CI must fail when a generated/embedded derivative differs from `targets.json`.
- Document the contribution workflow for adding a renderer consumer and an installer component, including when they are intentionally different inventories.
- Keep the existing full Python, Go, shell, schema, and theme-health gates. This architecture change must not weaken the SDD 1 WCAG/APCA or validation-first guarantees.

## Affected Areas

Expected implementation areas are:

- `src/dreamcoder_theme/renderers.py`, the existing `renderers_*.py` leaf modules, and new renderer-port/registry modules;
- `src/dreamcoder_theme/sync.py`, `settings.py`, `targets.py`, `installer.py`, and focused writer/adapter modules;
- `DreamcoderThemes/dreamcoder/targets.json` and `targets.schema.json`;
- `installer/internal/dotfiles/paths.go` and Go callers/tests that consume `ModuleMap` or `KnownComponents()`;
- `scripts/dreamcoder-lib.sh`, `scripts/dreamcoder-maintenance.sh`, and a shared manifest-reading or generated-data path used by shell;
- renderer, sync, target-manifest, installer-plan, migration, shell, and Go parity tests;
- contributor and installer documentation.

The specification and design must enumerate the exact 32 current consumer IDs, the canonical installer component/module catalog, the allowed ownership states, and every legacy alias before implementation. Ambiguous or missing catalog entries must fail closed rather than be inferred from casing.

## Non-Goals

- Refactoring shell god-scripts, replacing `doctor.sh`, or redesigning shell libraries. The shared `lib/` foundation already exists and broader shell decomposition is a separate concern.
- Visual-regression screenshots or baseline governance; those belong to SDD 3.
- Redesigning Dreamcoder palettes, tokens, contrast thresholds, Night derivation, or target output formats.
- Completing motion presets, automatic scheduling, Dusk runtime support, or other product features unless a directly coupled selector contract cannot otherwise be preserved.
- Replacing existing writers, selectors, or reload behavior when an adapter can expose them through the new registry.
- Adding new renderer consumers or installer modules beyond the currently approved inventories.
- Renaming top-level repository module directories solely for stylistic consistency.
- Resuming the archived July `hexagonal-architecture-refactor` or duplicating its completed shell-library scope.

## Constraints and Invariants

- Renderers continue to consume a palette mapping compatible with `dict[str, str]` and return text; palette and generated visual behavior must remain unchanged.
- The 32-consumer scope is the SDD 1 active sync coverage inventory, not the entire 37-ID rollout manifest.
- All renderer registrations declare a supported contract version and modes, and all registrations are validated before writes.
- `prepare()` remains side-effect-free and validation-first; no writer, selector, Stow operation, backup, or settings mutation runs after a failed contract or manifest gate.
- `targets.json` is the only hand-authored installer inventory. Go or shell derivatives must be reproducible, validated, and drift-checked.
- Canonical Stow module values are exact, case-sensitive repository directory names. IDs and aliases are not transformed into paths by convention.
- Existing conflict classification and backup-before-mutation behavior must be preserved or strengthened.
- Deterministic registry order and deduplication are required so summaries, plans, tests, and rollback evidence remain stable.
- No source-code changes are part of this proposal phase.

## Success Criteria

1. A formal renderer port accepts a Dreamcoder palette and returns `str`, and every active renderer consumer is represented by one valid typed registration.
2. CI proves an exact, duplicate-free bijection between the expected 32 active consumer IDs and conforming renderer registrations across every declared mode and contract version.
3. Adding a normal renderer target requires one adjacent declarative registration; paths, variants, render planning, coverage, writes, and summary are derived without editing four separate sync structures.
4. `PreparedSync` remains validation-first and side-effect-free, and renderer/registry failures produce no partial writes or selector changes.
5. `ThemePaths` no longer carries unowned/dead target defaults; every generic target path is registry-owned, while adapter-specific state remains adapter-owned.
6. `targets.json` contains the complete canonical installer component, exact module, destination, alias, and ownership data needed by Python, Go, and shell.
7. Go no longer has an independently maintained `ModuleMap`/`KnownComponents()` inventory, and shell no longer has independently maintained module/target arrays.
8. Python, Go, and shell parity tests resolve the same selections to the same ordered, deduplicated modules and ownership-aware destinations.
9. `DreamcoderBat` and `DreamcoderAntigravity` are emitted with exact repository casing; legacy kebab aliases are recognized only for migration and are never passed to Stow.
10. Existing managed installations migrate idempotently without destructive directory renames, while real conflicts are backed up and reported before mutation.
11. Existing theme output, Night behavior, WCAG/APCA gates, installer component selections, and supported CLI aliases remain backward compatible.
12. Shell god-script refactoring, visual baselines, palette redesign, motion completion, and unrelated target expansion are not required for completion.

## Risks and Mitigations

- **Registry migration can omit a special consumer:** The current sync flow has explicit exceptions for OpenCode, Zellij, Nvim, Matugen bridges, and Herdr. Mitigate with an exact 32-ID bijection, characterization tests of current bytes/paths, and adapters that preserve special behavior rather than forcing false uniformity.
- **A generic registry can become an untyped configuration blob:** Moving conditionals into arbitrary callbacks would hide rather than solve coupling. Mitigate with immutable typed entries, closed strategy types, versioned renderer contracts, schema validation, and narrowly scoped adapters.
- **Path centralization can change live destinations:** XDG, home, environment overrides, repository outputs, and temporary state have different lifecycles. Mitigate by characterizing existing path resolution, declaring path bases explicitly, and comparing old/new plans before enabling writes.
- **Manifest unification can break the standalone Go installer:** Runtime access to repository JSON may not exist in a distributed binary. Mitigate with validated embedding or reproducible generation and a CI freshness check, while keeping JSON as the only authored source.
- **Module-name normalization can disturb existing installs:** Legacy labels, shared modules, and symlinks may not map one-to-one. Mitigate with explicit aliases, destination-based ownership detection, dry-run/preflight evidence, idempotent canonical restow, and no automatic directory deletion.
- **Cross-language parsers can disagree:** Python, Go, and shell may normalize ordering, variables, or aliases differently. Mitigate with shared fixtures and parity tests against canonical expected plans; shell should consume a validated helper rather than implement an independent JSON parser.
- **Scope can expand into the stale architecture refactor:** Renderer ports may invite broad domain/application rewrites, and shell consumption may invite god-script cleanup. Mitigate by limiting this slice to renderer/sync registration and installer metadata derivation.

## Rollback Plan

1. Before enabling registry-driven writes, capture the current 32-consumer render plan, resolved paths, generated bytes, selector decisions, and summary output as characterization evidence.
2. Keep the current orchestration path available behind a short-lived migration switch until registry parity is proven for all 32 consumers. If registry validation or output parity fails, disable the new path and run the established SDD 1 sync flow; do not maintain both paths as permanent sources.
3. Before installer migration, record the manifest-derived preflight plan, current managed symlink targets, selected component aliases, canonical modules, conflicts, and backup ID.
4. If canonical restow fails, restore the prior managed links and selections from that evidence and the existing backup mechanism. Never remove user-owned conflicts or hand-edit generated theme files during rollback.
5. If the unified installer catalog must be reverted, restore the last known-good manifest and regenerate/re-embed its Go and shell derivatives. Do not reintroduce hand-authored divergent inventories as a rollback shortcut.
6. Preserve explicit legacy aliases for at least the migration window. Alias removal requires separate evidence that no supported install/repair path still emits or accepts them.
7. Rollback verification must run renderer-registry validation, exact coverage checks, theme health, Python tests, Go tests, shell tests, and installer dry-run parity before reporting the prior behavior restored.

## Chained Follow-Ups

This is SDD 2 of the chained series. Separately approved follow-ups may:

- add visual-regression baselines and target screenshots in SDD 3 after renderer identities and output ownership are stable;
- formalize broader contribution, compatibility, release, and exception governance;
- revisit deeper application/domain boundaries or shell command decomposition with fresh scope and evidence;
- add new renderer or installer targets through the contracts established here.

None of those follow-ups expands this proposal's implementation authority.

## Proposal Question Round

The prior questionnaire resolved the product decisions required for this proposal. The resulting assumptions are recorded for review:

- this is a new SDD and does not resume the stale July architecture change;
- the renderer boundary is formal and versioned, with declarative registration and CI conformance for all 32 active consumers;
- one sync registry drives paths, modes/variants, coverage, write planning, and summary reporting;
- `targets.json` is the only authored installer inventory, while Go and shell may use validated reproducible derivatives;
- module names use exact repository casing, with kebab forms retained only as explicit migration aliases;
- shell god-script refactoring, visual baselines, palette redesign, and unrelated motion work remain outside this slice.
