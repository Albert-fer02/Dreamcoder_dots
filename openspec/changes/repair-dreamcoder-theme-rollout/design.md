# Technical Design: Canonical Dreamcoder Light/Dark Rollout

## Decision Summary

Implement the rollout around one tracked, schema-validated target manifest. The manifest is the only coverage inventory consumed by repository generation, install/repair planning, mode application, health checks, and tests. Canonical tokens remain the only color authority; repository Light/Dark variants are deterministic and are generated separately from adaptive active output.

Calibrate Dark to the bounded Nytherx semantic families only through a verified WCAG/APCA decision matrix and canonical role map. Prevent target-local color decisions, treat 80/15/5 as non-mechanical composition guidance, and gate publication on a byte-identical Light token/mapping/output baseline.

Mode application becomes a transaction coordinator. It validates all candidates before activation, snapshots only proven managed state, applies selectors in dependency-safe order, records structured per-target outcomes, and rolls back affected rollback-capable targets when a required or mutated-present-optional target fails.

Herdr remains gated for production on 0.7.3. The additive [Herdr runtime diagnosis](./herdr-runtime-diagnosis.md) records a single time-bounded observation: `dreamcoder` resolves through `scripts/dreamcoder.sh` to `apply-theme-mode.sh` and `herdr-theme-switch.sh`; the diagnosed Dark selector was `config.toml -> config.dark.toml`; and the two external variant filenames contained the opposite canonical mode anchors. It also records that `renderers_herdr.py` deliberately keeps rendering unavailable and that `herdr server reload-config 2>/dev/null || true` discards reload errors. This evidence does not prove an isolated validator, complete schema, parsed-path identity under `HERDR_CONFIG_PATH`, reload semantics, production activation, or observable UI state. Therefore the safe temporary behavior is to stop changing the Herdr selector, never reload it, report `unsupported-contract` with the detected semantic variant mismatch, and leave all external files untouched. Repository-owned Light/Dark variants remain blocked unless a later, separately approved version-bound profile and harness prove supported schema/candidate validation, rendering identity, semantic anchors, WCAG/APCA role states, selector/content parity, and the exact limits of reload/UI observability.

This document supersedes the earlier Ghostty-only design as future rollout planning authority. It preserves that design and the completed Ghostty remediation as historical, version-bound evidence. It also coordinates, without rewriting, `harden-theme-design-system`, `implement-herdr-dreamcoder-themes`, and `repair-gga-and-theme-delivery`.

## Architectural Boundaries

```text
DreamcoderThemes/dreamcoder/tokens.json
  -> tokens.schema.json
  -> generated palette_tokens.py parity
  -> canonical static palettes (dark, light; dusk validation-only)
  -> Dark Nytherx role map + WCAG/APCA decisions + immutable Light baseline
  -> target manifest + manifest schema
       -> deterministic repository generation
       -> ownership-aware install/repair plan
       -> transactional explicit/scheduled apply
       -> manifest-driven health and test inventories
  -> structured target outcomes
  -> aggregate result + rollback report
```

The implementation preserves these ownership rules:

- Dreamcoder owns palette values, generated color overlays, their selectors, and rollout diagnostics.
- ML4W/Gentleman owns layout, behavior, launch structure, wallpaper and Matugen lifecycle. Dreamcoder overlays load after their defaults.
- External application configuration is user-owned unless path containment, symlink identity, and recorded digest prove Dreamcoder ownership.
- Generic Python synchronization may generate repository artifacts and declared active files, but it may not adopt arbitrary external files or perform runtime reload transactions.
- Only `light` and `dark` cross a runtime boundary. `dusk` participates in schema, role parity, and readability checks only.

## Components and File Responsibilities

| Component                    | Responsibility                                                                                                                                                                 | Expected files                                                                                                                       |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| Manifest model               | Parse, schema-validate, and expose the authoritative target inventory and typed policy                                                                                         | `DreamcoderThemes/dreamcoder/targets.json`, `DreamcoderThemes/dreamcoder/targets.schema.json`, new `src/dreamcoder_theme/targets.py` |
| Canonical token pipeline     | Validate token schema, regenerate exact static constants, expose canonical non-adaptive modes                                                                                  | existing `tokens.json`, `tokens.schema.json`, `palette_tokens.py`, `palette.py`, `generate-palette-tokens.py`                        |
| Repository generator         | Iterate manifest render contracts, call pure renderers, normalize bytes, and write only changed tracked variants                                                               | `renderers.py`, leaf renderers, `sync.py`, `writers.py`                                                                              |
| Readability verifier         | Evaluate role/state pairs, Nytherx family mapping, token provenance, WCAG/APCA decisions, literal parity, Light preservation, and deterministic output                         | `design_system.py`, design contract/evidence fixtures, `verify-theme-health.py`, focused tests                                       |
| Ownership planner            | Classify each destination before mutation and produce an install/repair plan without adopting external state                                                                   | `installer.py`, backup primitives, `dreamcoder-lib.sh`, `dreamcoder-maintenance.sh`                                                  |
| Apply coordinator            | Own mode validation, preflight, snapshots, ordered activation, aggregate outcomes, and bounded rollback                                                                        | new focused Python service or module plus `apply-theme-mode.sh` as adapter                                                           |
| Scheduler                    | Select Light/Dark only and invoke the same apply coordinator                                                                                                                   | `theme-auto.sh`                                                                                                                      |
| Target adapters              | Validate, select, and reload one consumer according to its manifest contract; return a structured result                                                                       | focused Python adapters and thin shell helpers where unavoidable                                                                     |
| Herdr compatibility boundary | Bind exact-version profiles/evidence, detect capabilities, run only supported visual/readability checks, model non-observability, and prohibit live mutation while unsupported | `herdr_contract.py`, profile/evidence fixtures, `renderers_herdr.py`, future activation module, `herdr-theme-switch.sh`              |
| Health/reporting             | Compare all consumer inventories to the manifest and summarize required, optional, skipped, failed, and rollback states                                                        | `verify-theme-health.py`, doctor/control reporting, tests                                                                            |

`write_if_changed()` remains appropriate for deterministic repository artifacts. Live selectors require a same-directory temporary object plus atomic `os.replace()` and cannot use plain `ln -sf`.

## Required-Target Manifest

### Storage and schema

Use `DreamcoderThemes/dreamcoder/targets.json` with schema identifier `dreamcoder.theme-targets.v1`. JSON is chosen because Python consumers already use JSON and `jsonschema`, shell consumers can request a normalized plan from Python instead of parsing JSON themselves, and stable key ordering is straightforward.

Each target entry has this conceptual shape:

```json
{
  "id": "kitty",
  "classification": "required",
  "reason": "Core Gentleman terminal theme",
  "owner": "dreamcoder",
  "availability": { "kind": "always" },
  "render": {
    "renderer": "kitty",
    "modes": ["dark", "light"],
    "repository_outputs": { "dark": "...", "light": "..." },
    "adaptive_active_output": "..."
  },
  "install": {
    "module": "DreamcoderKitty",
    "destinations": ["$XDG_CONFIG_HOME/kitty"],
    "allowed_ownership": ["missing", "managed"]
  },
  "activation": {
    "selector": "...",
    "validate": { "kind": "anchor", "contract": "..." },
    "reload": { "kind": "signal", "observable": true },
    "rollback": "selector-and-reload"
  },
  "version": { "constraint": null }
}
```

Required fields are `id`, `classification`, `reason`, `owner`, `availability`, `render` or an explicit `selector_only` contract, `install`, `activation`, and `version`. Optional and excluded entries require a non-empty product reason. Excluded entries require `excluded_behavior` and must define how health reports the exclusion. Relative repository paths are rooted at `ROOT`; destination templates are expanded by Python using the existing HOME/XDG settings boundary.

The schema rejects duplicate IDs, unknown classification values, runtime mode `dusk`, missing Light/Dark pairs, an observable reload without a command/adapter contract, a rollback claim without restorable state, or a required target without validation. Cross-entry checks reject duplicate output ownership and selector collisions.

### Initial classifications

The following table accounts for every audited item. A row may represent several files only where they share one owner and one activation contract; the manifest records each concrete output and destination within that row.

| Target ID                        | Classification | Owned contract and reason                                                                                                   |
| -------------------------------- | -------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `kitty`                          | required       | Colors, UI include, variants, active selector/config; core Gentleman terminal surface                                       |
| `ghostty`                        | required       | Versioned theme variants and config selection; the 1.3.1-arch2 title repair remains separate evidence                       |
| `warp`                           | optional       | Variants/settings are supported only when Warp is installed; present failures are accountable                               |
| `tmux`                           | required       | Standalone generated theme; canonical token mapping replaces manual palette copies                                          |
| `tmux-kanagawa-bridge`           | optional       | External plugin bridge; absence is actionable skip, present mutation/reload failure is failure                              |
| `zellij`                         | optional       | External multiplexer selector; preserve non-theme KDL content                                                               |
| `starship`                       | required       | Shell module output and active configuration                                                                                |
| `shell-syntax`                   | required       | Generated syntax-highlighting snippet                                                                                       |
| `ls-colors`                      | required       | Generated shell environment snippet                                                                                         |
| `neovim`                         | required       | Dispatcher plus Light/Dark color files in the prefixed module                                                               |
| `bat`                            | required       | Generated TextMate variants and selected theme in the prefixed module                                                       |
| `codex-textmate`                 | optional       | Codex CLI consumer is external; generated variants remain deterministic when declared available                             |
| `delta`                          | required       | Generated Git include snippet                                                                                               |
| `fzf`                            | required       | Generated shell snippet                                                                                                     |
| `opencode-theme`                 | required       | Repository-owned `.opencode/themes/dreamcoder.json` and Light/Dark variants                                                 |
| `opencode-tui-selection`         | optional       | User TUI settings are external and may only be changed through classified ownership; unrelated app config is excluded       |
| `pi`                             | optional       | External CLI; generated variants/settings are accountable when installed                                                    |
| `codex-cli-settings`             | optional       | Theme selection only; unrelated Codex settings are excluded                                                                 |
| `antigravity`                    | optional       | External consumer with repository-generated variants                                                                        |
| `herdr`                          | excluded       | `gated: unsupported-contract` for 0.7.3 until schema, parsed path, candidate validation, reload, and observation are proven |
| `hyprland-colors`                | required       | Dreamcoder color overlays only; ML4W layout/behavior remains external ownership                                             |
| `waybar-colors`                  | required       | Active and Matugen-compatible color files loaded after ML4W defaults                                                        |
| `rofi-colors`                    | required       | Active and Matugen-compatible color files loaded after ML4W defaults                                                        |
| `dunst`                          | optional       | External daemon; generated variants and reload are accountable when installed                                               |
| `btop`                           | optional       | External TUI; generated variants/selector are accountable when installed                                                    |
| `firefox`                        | optional       | User-profile CSS cannot be silently installed or adopted                                                                    |
| `obsidian`                       | optional       | Vault/user CSS destination is external and requires explicit ownership                                                      |
| `cava`                           | optional       | External visualizer configuration                                                                                           |
| `wallpaper-matugen-hook`         | optional       | Dreamcoder consumes hook output but ML4W owns wallpaper/Matugen lifecycle                                                   |
| `generated-repository-contract`  | required       | Tokens, schemas, design-system contract, README, and all declared Light/Dark outputs                                        |
| `gentleman-module-plan`          | required       | Prefixed modules and Stow plan must agree with manifest-managed destinations                                                |
| `ml4w-hook-plan`                 | required       | Hook import ordering and color-only boundary                                                                                |
| `theme-scheduler`                | required       | Timer/service selects only Light/Dark and delegates to common apply boundary                                                |
| `doctor-maintenance`             | required       | Installer, repair, doctor, maintenance, and health inventories must derive from the manifest                                |
| `ml4w-structure`                 | excluded       | Layout, behavior, launchers, wallpaper lifecycle, and Matugen lifecycle remain ML4W-owned                                   |
| `dusk-runtime`                   | excluded       | Design-system-only mode; every runtime entrypoint rejects it before mutation                                                |
| `unrelated-application-settings` | excluded       | Non-theme OpenCode, Codex, Pi, browser, editor, and app settings are not rollout artifacts                                  |

Manifest parity tests compare this declared inventory with renderer exports, repository output plans, installer modules/destinations, activation adapters, health checks, and the audit fixture. Any extra or missing item fails with the owning inventory and reconciliation action.

## Interfaces and Data Model

### Normalized target plan

Shell entrypoints call a Python command that emits a normalized plan; they do not maintain target arrays. The internal API is equivalent to:

```python
load_target_manifest(path: Path) -> TargetManifest
build_generation_plan(manifest, variants) -> tuple[GenerationStep, ...]
build_install_plan(manifest, environment) -> tuple[InstallStep, ...]
build_activation_plan(manifest, mode, environment) -> tuple[ActivationStep, ...]
validate_inventory_parity(manifest, discovered) -> tuple[Finding, ...]
```

Plans are immutable and deterministically ordered by manifest order plus explicit dependencies. Each step records target ID, classification, concrete paths, preconditions, validation, reload observability, and rollback contract.

### Ownership states

Use one enum across installer and activation:

- `missing`
- `managed`
- `managed-stale`
- `partial-managed`
- `external-symlink`
- `external-file`
- `external-directory`
- `missing-parent`
- `conflict`

Managed status requires repository path containment or state-recorded path plus digest. Markers alone are insufficient. Broken symlinks are inspected without following them blindly. Only `missing`, `managed`, and repairable `managed-stale` may mutate automatically. `partial-managed` requires complete state evidence; otherwise it becomes `conflict`.

### Target outcome

Every adapter returns a serializable `TargetOutcome`:

```json
{
  "schema": "dreamcoder.theme-target-outcome.v1",
  "target": "kitty",
  "classification": "required",
  "phase": "reload",
  "status": "failed",
  "changed": true,
  "validation": "passed",
  "reload": "failed",
  "rollback": "succeeded",
  "reason": "reload command returned non-zero",
  "consequence": "running Kitty instances retained the previous mode",
  "corrective_action": "inspect the reported command error and retry",
  "residual_paths": []
}
```

Statuses are `applied`, `unchanged`, `skipped-not-installed`, `unsupported-contract`, `conflict`, `validation-failed`, `activation-failed`, `rolled-back`, and `rollback-failed`. Optional absence is zero only when all four diagnostic fields are present. Any present optional target that was selected or mutated and then fails contributes to non-success.

The aggregate result uses `dreamcoder.theme-apply.v1`, includes requested mode, baseline ID, ordered outcomes, required/optional counts, rollback summary, and residual inconsistent targets. Human output is rendered from this object; adapters never print unconditional success.

## Deterministic Generation and Token Verification

Generation has two explicit modes:

1. `repository`: load canonical non-adaptive `dark` and `light`; render every manifest render contract; validate all candidates; then publish changed files.
2. `active`: load the selected canonical mode and optionally apply wallpaper adaptation only to declared active-runtime outputs. It cannot write a path owned by a repository variant.

A path ownership index built from the manifest rejects overlap between repository outputs, adaptive outputs, selectors, and external destinations. This prevents a stale active symlink from redirecting repository generation into the opposite variant. Repository generation writes to resolved repository paths without following active-home selectors.

Renderer requirements:

- pure input-to-string behavior;
- stable manifest/field ordering;
- UTF-8, LF endings, exactly one trailing newline;
- no timestamp, environment, wallpaper, filesystem, or locale dependency;
- Light and Dark structural parity where the target format permits it;
- only supported fields;
- every emitted color carries a testable canonical token mapping.

Token and readability verification proceeds in this order:

1. Validate `tokens.json` against `tokens.schema.json`.
2. Render `palette_tokens.py` in memory and compare exact bytes with the tracked file.
3. Require role parity for Dark, Light, and `dusk`; separately assert all runtime parsers reject `dusk` without writes.
4. Evaluate the design-system state matrix for body/heading text, muted/comment text, selection, focus, material borders, and semantic error/warning/success/info pairs.
5. Block WCAG text contrast below 4.5:1 and apply stricter existing policies such as 7:1 main text.
6. Evaluate APCA independently using the declared Light threshold and dark-background threshold; APCA cannot waive WCAG failure.
7. Render all manifest variants and report mode, state/role, target when material, measured value, threshold, and canonical source token.
8. Extract target color literals and compare them with renderer-declared token mappings. Non-color literals must be allow-listed with a reason.
9. Run generation twice in an isolated copy and compare exact bytes; run adaptive active generation and assert tracked variants remain unchanged.

Manual Tmux/Kanagawa values move behind a generated environment/command plan or an exact parity assertion sourced from canonical tokens. Shell scripts no longer contain independent color decisions.

## Bounded Dark Nytherx Calibration

The Nytherx change is a Dark-only semantic calibration, not a renderer redesign. It introduces no accepted hex value in design: implementation may change a Dark token only after the candidate and every role/state pairing that consumes it have a verified matrix row. The current Dark palette is input evidence, not an automatically approved Nytherx result.

### Semantic role contract

A machine-readable Dark role map sits beside the design-system contract and binds canonical tokens to permitted families and purposes:

| Nytherx family       | Permitted semantic purpose                             | Representative canonical roles                                                     | Constraint                                                                                     |
| -------------------- | ------------------------------------------------------ | ---------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| void                 | OLED canvas and deepest backgrounds                    | `bg`, `prompt_bg`, overlay/scrim bases                                             | black or near-black; never assumed readable without a matrix pair                              |
| graphite/titanium    | layered structure and material boundaries              | `bg_soft`, `surface0..3`, `border*`, hover/pressed                                 | establishes hierarchy without becoming primary text or warm emphasis                           |
| star blue-white      | primary readable foreground and highest active clarity | `text`, `text_heading`, `prompt_text`, `on_surface`                                | text thresholds apply against every declared background/state                                  |
| cold silver          | secondary readable foreground and cool active systems  | `muted`, `comment`, `subtle`, `focus`, `accent`, `link`, diagnostics               | quiet roles retain their stricter applicable role policy; disabled remains explicitly non-body |
| gravitational violet | restrained depth and secondary dimensional emphasis    | approved depth role(s), potentially backed by `lavender`/`mauve` after calibration | cannot replace body text, broad surfaces, or semantic status meaning merely for visual effect  |
| copper/amber         | minimal warm focal and warning meaning                 | `warning` and explicitly approved focal role(s)                                    | no broad structural fill and no target-local accent expansion                                  |

Existing token names do not prove family membership. The mapping records `family`, `purpose`, `source_token`, and permitted consumer roles; candidates that do not fit are rejected or require a separately specified canonical role. The 80/15/5 direction guides composition review only: predominantly void/structure, a smaller cold active/readability layer, and sparse violet/warm emphasis. No pixel counting, token-count ratio, renderer quota, or screenshot-area calculation is an acceptance gate.

### Verified WCAG/APCA decision matrix

Calibration uses a candidate matrix with one row per role/state/background combination. A row contains mode (`dark` only), semantic family, foreground token, background token, state, material target when relevant, candidate value provenance, WCAG ratio and threshold, APCA absolute contrast and threshold, and decision (`accepted` or `rejected`) with reason. Required coverage includes body, heading, muted/comment, selection, focus, link/hover, material borders, prompt roles, terminal cursor/ANSI where applicable, and error/warning/success/info with their `on_*` foregrounds.

The decision procedure is fail-closed:

1. Resolve both values from the canonical candidate token object; no visual estimate or copied target value is admissible.
2. Apply the existing role-specific WCAG threshold (at least 4.5:1, 7:1 where the current main-text or selection policy requires it).
3. Apply the applicable Dark APCA threshold independently (`body`, `heading`, `quiet`, `ui`, or `on_accent`).
4. Reject on any blocking WCAG failure. Record APCA independently; it never waives WCAG.
5. Accept a token only when every required downstream row passes and diagnostics name role, state, metric, measured value, threshold, and source token.

### Literal and Light-preservation boundaries

Renderer contracts expose emitted color fields and their canonical role. Literal scanning compares normalized emitted colors with the resolved Dark token set and declared mapping. A color literal passes only when it is the exact serialization of its declared canonical token; non-color syntax requires a narrow allow-list reason. Unknown, duplicated, or independent Nytherx literals fail health validation, including shell/Tmux copies.

Before calibration, capture a content-addressed Light baseline containing the complete canonical Light JSON object, Light semantic-role map, generated `palette_tokens.py` Light representation, and every tracked Light output in manifest order. The calibration publisher rejects any candidate unless all baseline bytes and path identities remain identical. Shared renderer or schema edits are permitted only when this byte comparison proves zero Light drift; adaptive generation is run separately and must not touch the baseline paths.

## Install and Repair Flow

```text
manifest
  -> expand paths in isolated environment
  -> classify every destination without mutation
  -> reject required conflicts
  -> report optional absence/conflict truthfully
  -> render and validate all required artifacts
  -> create path-bound backup manifest for proven managed mutations
  -> provision missing/managed artifacts in dependency order
  -> reclassify and validate
  -> activate through the common apply boundary
```

Installation does not automatically move arbitrary conflicts. The current maintenance helper's generic `backup_path` behavior must be narrowed: automatic backup/move is permitted only for a separately approved explicit migration contract. Otherwise external symlinks, regular files, and directories remain byte-for-byte unchanged and receive migration-required guidance.

Stow module names and destination arrays are generated from the normalized manifest plan. Repair restores missing or stale repository-managed artifacts only. It does not clean unrelated directories, delete alternate themes, or rewrite user application settings merely because parsing failed.

Dreamcoder overlays are inserted after ML4W/Gentleman defaults through idempotent managed include anchors. Validation checks exactly one managed include and correct ordering while preserving all non-color structure.

## Transactional Switching

### Control flow

Both `dreamcoder light|dark` and `theme-auto.sh` invoke one application coordinator:

```text
request mode
  -> reject non-Light/Dark before writes
  -> load/validate manifest and inventory parity
  -> acquire global apply lock
  -> classify target state
  -> build deterministic plan
  -> render/validate all candidates
  -> snapshot proven managed content/selectors
  -> apply reversible selectors before generators that follow selectors
  -> write active generated files
  -> invoke target validation/reload adapters
  -> success: persist state and aggregate report
  -> failure: finish only non-mutating diagnostics, rollback changed targets in reverse order,
              revalidate prior state, report initiating and rollback outcomes separately
```

Selectors for Waybar, Rofi, Hyprland, Kitty, Pi, Warp, Btop, and other selector-backed targets are committed before any active writer can follow them. However, repository variants are always generated by repository path and never through active selectors.

The coordinator snapshots only manifest-declared, proven managed paths. It records symlink identity and relative target, regular-file digest/content backup, permissions where owned, and prior mode. External paths are excluded from both mutation and rollback.

### Idempotency

A target is `unchanged` only when candidate validation passes, selector/content digest matches the requested mode, and any observable runtime state is already consistent. `unchanged` performs no write and no reload. If runtime state cannot be queried, the manifest declares the limitation: selector equality proves filesystem convergence, but the report says `reload-observation-unavailable` rather than claiming the UI is already converged.

### Failure semantics

- Preflight, ownership, rendering, or candidate-validation failure: no activation mutation.
- Required write/selector/reload failure: aggregate non-success; rollback all changed rollback-capable targets in reverse dependency order.
- Optional unavailable: no mutation; actionable skip may remain aggregate success.
- Optional present and mutated, then failed: aggregate non-success and rollback that target.
- Rollback succeeds and prior state revalidates: `rolled-back`.
- Any restoration or revalidation is unproven: `rollback-failed`, with residual paths and recovery command.
- Suppressed stderr, `|| true`, and unconditional success messages are prohibited for validators and reloads. Benign absence checks must be explicit outcome branches, not swallowed commands.
- Independent targets may complete validation/reporting after a failure, but no new mutating step begins once fail-closed state is entered.

## Herdr Visual and Readability Gate

### Evidence interpretation

The [Herdr runtime diagnosis](./herdr-runtime-diagnosis.md) is a time-bounded, read-only observation for `herdr 0.7.3`: it records the repository dispatch chain, one observed selector, opposite canonical anchors in the two externally owned mode filenames, the fail-closed renderer, and a reload command whose diagnostics and status are swallowed. The earlier [`runtime-inspection.md`](./runtime-inspection.md) records a different observed selector and remains inconclusive about parsed-path identity and parser attribution.

Both records are diagnosis inputs, not production proof. User-reported illegibility and the observed swapped variants justify anti-swap and readability checks, but they do not prove a Herdr color schema, field semantics, parsed path under `HERDR_CONFIG_PATH`, ownership, candidate validator, rendering behavior, reload semantics, or UI convergence. No runtime schema or success claim may be inferred from filenames, a symlink operation, process presence, visual inspection, or forced-zero reload status.

### Version-bound profile and evidence model

Herdr support is controlled by an immutable compatibility profile selected by detected executable identity, exact version, and—where available—binary digest/platform constraint. A profile declares:

- profile schema/version and evidence capture IDs;
- supported config fields and authoritative provenance for each field;
- default and override path semantics that have actually been proven;
- candidate-validation capability and its non-mutating invocation;
- rendering-evidence capability and the supported way to obtain it;
- canonical semantic anchors and Herdr field-to-role mappings;
- required WCAG/APCA role/state rows;
- selector/content identity rules;
- reload command, exit semantics, and observability class;
- runtime/UI query capability, if any;
- ownership, migration, activation, and rollback permissions; and
- explicit unsupported or unknown capabilities.

Evidence records are content-addressed, sanitized, timestamped, and linked to exactly one profile identity. Profile matching fails closed on absent executable, version/digest mismatch, ambiguous provenance, stale evidence, or an unknown required capability. A profile cannot mark a capability supported merely because a command exists in help output.

Capability detection is read-only and returns `supported`, `unsupported`, or `unknown` for `schema`, `candidate_validation`, `render_evidence`, `parsed_path`, `selector`, `reload`, and `ui_observation`. Only a profile-declared supported capability may run. Generic TOML parsing proves syntax only; it is not relabeled as Herdr schema validation. Process detection proves neither parsed path nor UI state. Unknown is never coerced to supported.

### Candidate harness

`herdr_content(profile, mode, canonical_palette)` remains pure and accepts only `dark` or `light`. It emits stable, versioned repository candidates only after the profile allow-lists every field and provides a supported candidate-validation contract. No external or active path is a renderer output.

The harness evaluates a candidate in this order:

1. Match the detected executable to one complete profile and verify all referenced evidence.
2. Render in memory; check deterministic bytes, TOML syntax, allowed/forbidden fields, and equal Light/Dark key structure.
3. Resolve each profile field through its declared canonical semantic token. Compare semantic token anchors, not arbitrary literals or whole external files. Dark anchors must match Dark roles and reject the Light fingerprint; Light has the inverse requirement.
4. Evaluate the profile's WCAG/APCA matrix for every text, status, focus, selection, muted/comment, link, and material UI state it can render. Each row records field, semantic role, foreground/background tokens, state, WCAG/APCA measured values, applicable thresholds, and decision. WCAG remains blocking; APCA is independent and cannot waive it.
5. Use only profile-supported schema/candidate validators and rendering evidence. If the installed version exposes no supported renderer or screenshot/query contract, do not invent one; mark rendered identity proof missing.
6. Prove selector/content parity before activation: requested mode, selector basename/identity, candidate semantic fingerprint, and parsed-path evidence must agree. Filename equality alone is insufficient.
7. Classify reload and UI evidence separately. A successful reload exit may be claimed only when exit semantics are proven; UI convergence may be claimed only from a supported state query or rendering observation tied to the same profile and candidate.

A matrix or anchor failure is a candidate failure. A required capability that is unsupported or unknown is a gate failure. `reload-observation-unavailable` and `ui-observation-unavailable` are explicit evidence states, never success aliases. If the specification's success prerequisites cannot all be proven for that profile, the overall outcome is `unsupported-contract`, not a partial activation.

### Mutation boundary and safe outcome

While proof is incomplete, Herdr remains `excluded`/gated and no live external mutation is permitted:

- `renderers_herdr.py` continues to raise; generic sync produces no Herdr variant or active file.
- `update_herdr_config()` remains a no-op compatibility boundary until callers are removed.
- The Herdr switch adapter performs only read-only capability/profile checks and sanitized semantic-anchor comparison, then returns `skipped-not-installed` or non-success `unsupported-contract` with missing-proof diagnostics.
- The currently observed swapped variants and reported illegibility are reported as diagnosis findings only. The adapter does not flip selectors, rename or rewrite files, copy token values, invoke reload, or claim which config a process consumed.
- `apply-theme-mode.sh` may continue unrelated targets because Herdr is excluded, but it must not report Herdr as switched, rendered, readable, reloaded, or converged.
- External `config.toml`, `config.dark.toml`, and `config.light.toml` remain byte-identical. No migration, backup-as-adoption, global `HERDR_CONFIG_PATH`, Fish startup change, or external reload occurs.

If a later profile passes the complete harness, repository variants live below a versioned managed root, installation classifies ownership before provisioning, and activation is a separate slice. It validates the managed candidate, atomically changes only a proven managed selector, exposes reload diagnostics, and rolls back on failure. Non-observable reload or UI state remains explicitly modeled; it cannot satisfy a success requirement that demands observation.

## Ghostty Boundary

The completed Ghostty 1.3.1-arch2 title remediation is preserved. `window-title` and `tab-title` remain absent; documented `title` remains only if intentionally retained by that historical slice. The manifest adds broader rendering/install/selection claims only after independent validation of the relevant parsed graph. A different Ghostty version yields a version-gated finding, not generalized compatibility.

Rollback must never restore either unsupported title field. No theme-rollout test may cite the narrow parser repair as proof of Light/Dark rendering, switching, reload, or include-graph coverage.

## Test Strategy

Testing follows RED, GREEN, TRIANGULATE, REFACTOR within every implementation slice.

### RED

Add failing focused tests before production changes:

- manifest schema, audit completeness, duplicate ownership, and consumer-inventory parity;
- deterministic Light/Dark output, exact token provenance, stable newline/order, no adaptive contamination;
- three-mode token/role parity and runtime `dusk` rejection without mutation;
- WCAG/APCA state-matrix diagnostics with complete context;
- Dark Nytherx family/role-map completeness, candidate decision rows, rejection on either blocking metric, renderer literal provenance, qualitative-only composition metadata, and a content-addressed byte-identical Light baseline;
- fresh, managed, stale, partial, external symlink/file/directory, missing-parent, and conflict ownership fixtures;
- explicit/scheduled equivalence, idempotent no-reload behavior, partial failure, reverse rollback, and rollback failure;
- ML4W overlay-after-default ordering without structural replacement;
- Herdr exact-version profile matching; three-state capability detection; unsupported validator/render/UI paths; semantic anchor and selector/content mismatch; complete WCAG/APCA role/state rows; explicit reload/UI non-observability; no external mutation; and non-success `unsupported-contract`;
- synthetic complete-profile tests for supported candidate validation, rendering evidence, observable reload, and bounded rollback without treating those fixtures as evidence for production 0.7.3;
- Ghostty historical/version boundary and forbidden-title regression;
- dirty-baseline path exclusions.

### GREEN

Implement only the minimum behavior needed for the slice's focused tests. Use isolated HOME/XDG trees, fake executables, and manifest fixtures. Production tests must never read or write the user's Herdr directory.

### TRIANGULATE

For each behavior, exercise at least two distinct cases and one failure path: both modes, explicit and scheduled callers, managed and external ownership, first and repeated run, reload success and failure, selector restoration and rollback failure. For Nytherx, pair accepted and rejected Dark candidates, verify every required matrix row, compare all Light baseline bytes before/after calibration, and compare repository generation before/after adaptive active generation. For Herdr, test absent, exact-version, changed-version, unsupported, unknown, and synthetic-supported capabilities; positive synthetic profiles remain fixtures while production 0.7.3 stays disabled.

Run focused tests first, then applicable project gates:

```bash
python -m pytest tests/ -v
python -m pytest tests/ --cov=dreamcoder_theme --cov-fail-under=40
python scripts/verify-theme-health.py
ruff check src tests
mypy src
shellcheck scripts/apply-theme-mode.sh scripts/theme-auto.sh scripts/herdr-theme-switch.sh scripts/dreamcoder-lib.sh scripts/dreamcoder-maintenance.sh
```

Runtime checks are version-bound and sanitized. Where no validator or state query exists, record the limitation; do not substitute process presence or visual assumption.

### REFACTOR

After behavior is green, remove duplicate inventories and shell color literals, centralize outcome rendering, reduce adapters to manifest-driven policy, and preserve exact behavior with tests. Refactoring may not broaden ownership, enable Herdr, activate `dusk`, or mix another slice's paths.

## Migration and Rollback

### Rollout migration

1. Introduce the manifest and parity checks without changing activation.
2. Add the Nytherx Dark role map, candidate matrix evaluator, literal guard, and immutable Light baseline before changing any Dark token.
3. Calibrate Dark and regenerate Dark-only artifacts in a separately reviewed slice; publish only when all matrix rows pass and Light bytes are identical.
4. Migrate generation inventories to the manifest while comparing old/new output bytes.
5. Migrate installer planning to normalized manifest output; keep mutation disabled on ambiguous ownership.
6. Introduce the transaction coordinator behind a dry-run/report-only path.
7. Move explicit switching, then scheduling, to the coordinator.
8. Remove duplicate arrays/literals only after parity tests pass.
9. Keep Herdr disabled; implement the read-only profile/capability/evidence harness separately from any renderer or activation work.
10. Enable Herdr repository rendering, then installation, then activation only in later gated slices after the complete installed-version profile is approved.

### Operational rollback

Each transaction captures a path-bound baseline before mutation. On failure, restore changed managed selectors/content in reverse order and revalidate the prior mode where supported. Never restore into an external path, never restore unsupported Ghostty title keys, and never use pre-existing dirty-worktree content as rollback material.

A slice rollback reverts only slice-owned code/artifacts and leaves earlier reviewed slices intact. If a new manifest consumer must be disabled, preserve the manifest entry and mark its adapter unavailable rather than recreating an independent hidden inventory.

Herdr rollback while gated is trivial because no mutation occurs. After a future gate opens, its dedicated activation transaction restores the previous selector atomically and reports runtime restoration separately; lack of observable restoration is `rollback-failed`, not success.

## Implementation Sequence and Review Slices

Every slice is forecast below 400 authored changed lines. If RED tests plus implementation exceed the limit, split by the indicated seam before apply.

| Slice | Scope                                                                                                          |              Forecast | Dependency                                           |
| ----- | -------------------------------------------------------------------------------------------------------------- | --------------------: | ---------------------------------------------------- |
| 1A    | Manifest schema/model and complete audited classification fixture                                              |               250–350 | none                                                 |
| 1B    | Inventory parity adapters for renderer, install, activation, and health                                        |               250–350 | 1A                                                   |
| 1C    | Canonical token/generated parity and generic state-matrix diagnostics                                          |               250–360 | 1A; coordinates `harden-theme-design-system`         |
| 1D    | Nytherx Dark family/role map, candidate WCAG/APCA matrix, literal guard, and Light-baseline fixture            |               260–380 | 1C                                                   |
| 1E    | Dark-only Nytherx token calibration and Dark artifact regeneration                                             |               220–380 | accepted 1D evidence                                 |
| 2A    | Terminal/shell deterministic registry migration                                                                |               250–380 | 1A–1E                                                |
| 2B    | Editor/CLI deterministic registry migration                                                                    |               250–380 | 1A–1E                                                |
| 2C    | Desktop/ML4W deterministic registry migration and overlay-order tests                                          |               250–380 | 1A–1E                                                |
| 3A    | Shared ownership enum/classifier and isolated fixtures                                                         |               250–350 | 1A                                                   |
| 3B    | Installer/Stow plan consumption and conflict-safe repair                                                       |               250–380 | 3A                                                   |
| 3C    | ML4W/Gentleman hook ordering and managed include checks                                                        |               200–320 | 3A–3B                                                |
| 4A    | Structured outcomes, apply plan, and report-only coordinator                                                   |               250–380 | 1B, 3A                                               |
| 4B    | Atomic selector/content snapshots and idempotent apply                                                         |               300–390 | 4A                                                   |
| 4C    | Reload adapters, aggregate failure, and reverse rollback                                                       |               300–390 | 4B                                                   |
| 4D    | Explicit/scheduled convergence and Tmux literal removal/parity                                                 |               250–380 | 4C                                                   |
| 5A    | Preserve/version-bind Ghostty evidence and add manifest-only coverage                                          |               150–300 | 1B, 2A                                               |
| 6A    | Herdr read-only profile/evidence model, capability detection, and `unsupported-contract` outcome               |               240–360 | 1B, 4A                                               |
| 6B    | Herdr visual/readability harness: anchors, role/state matrix, selector/content parity, non-observability tests |               260–390 | 6A; installed-version evidence remains external gate |
| 6C    | Herdr pure renderer and versioned repository variants, only after complete gate approval                       |               240–380 | complete supported profile, 6B                       |
| 6D    | Herdr ownership/provisioning and explicit migration                                                            | 300–390 per sub-slice | 6C, 3B                                               |
| 6E    | Herdr atomic activation, supported reload evidence, and rollback                                               | 300–390 per sub-slice | 6D, 4C                                               |
| 6F    | Herdr scheduled convergence and Fish compatibility, only if profile evidence requires it                       |               220–350 | 6E                                                   |
| 7A    | End-to-end health summary, dirty-baseline evidence, operator recovery docs                                     |               250–380 | prior enabled slices                                 |

Slices 1D and 1E keep palette evidence/calibration independently reviewable. Slices 6A and 6B keep the non-mutating Herdr harness independent from renderer and activation work. Slices 6C–6F remain blocked while the installed-version contract is incomplete; none may be pulled into 6A/6B. If any forecast reaches 400 authored lines, split tests from adapters or split by capability before apply—never use a blanket exception.

## Requirement Traceability

| Specification requirement                          | Design coverage                                                                                                   |
| -------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| Rollout: manifest owns classification              | Tracked schema/model, complete classification table, normalized plans, inventory parity tests                     |
| Rollout: truthful required/optional outcomes       | `TargetOutcome`, aggregate rules, actionable optional skips, present-optional failure semantics                   |
| Rollout: preserve ML4W/Gentleman boundaries        | Ownership boundary, overlay ordering, excluded structural target, hook tests                                      |
| Rendering: deterministic token-derived Light/Dark  | Separate repository mode, pure renderers, byte normalization, repeated-run tests                                  |
| Rendering: canonical token/mode parity             | Schema then generated-byte parity, three-mode role checks, runtime dusk rejection                                 |
| Rendering: blocking readability diagnostics        | State matrix, WCAG blocking policy, independent APCA, complete provenance diagnostics                             |
| Rendering: bounded Dark Nytherx contract           | Machine-readable family/role map, verified candidate matrix, qualitative-only composition, literal prevention     |
| Rendering: Light remains unchanged                 | Content-addressed Light token/map/output baseline and byte-identical publication gate                             |
| Install: classify ownership before mutation        | Shared ownership enum, path/digest proof, conflict-safe install/repair flow                                       |
| Install: explicit and scheduled share one boundary | Scheduler delegates to the same transaction coordinator                                                           |
| Install: switching idempotency                     | Validated `unchanged` invariant; no write/reload when observable state agrees                                     |
| Install: bounded recoverable activation failure    | Snapshot, reverse rollback, prior-state validation, distinct rollback failure                                     |
| Install: aggregate health truth                    | Manifest-derived outcomes/counts; no swallowed validator or reload errors                                         |
| Herdr: version-gated support                       | Exact detected-version profile, evidence binding, three-state capabilities, fail-closed `unsupported-contract`    |
| Herdr: visual/readability harness                  | Supported validators/render evidence only, semantic anchors, WCAG/APCA role/state matrix, selector/content parity |
| Herdr: reload/UI non-observability                 | Separate evidence states; no convergence claim or mutation while required proof is absent                         |
| Herdr: proven slices remain safe                   | Future pure renderer, versioned variants, classified install, atomic validated activation and bounded rollback    |
| Ghostty: version-bound evidence                    | Recorded 1.3.1-arch2 boundary and different-version finding                                                       |
| Ghostty: unsupported title fields absent           | Explicit forbidden regression and rollback prohibition                                                            |
| Ghostty: broader rollout needs manifest evidence   | Separate manifest validation; historical repair cannot prove broader behavior                                     |
| Evidence: dirty worktree excluded                  | Path-bound baselines, slice-owned evidence, rollback excludes unrelated paths                                     |
| Evidence: overlapping artifacts preserved          | Explicit coordination and supersession rules; no deletion or silent rewrite                                       |

The older `herdr-rollout` specification is retained as gated supporting input. Its runtime evidence, safe provisioning, explicit/automatic convergence, truthful status, rollback, and regression requirements map to the Herdr target architecture and Slices 6A–6F; none opens the production gate by itself. The newer `herdr-gate` requirements control classification and proof: user reports and swapped-file diagnosis remain inputs, never substitutes for the version-bound harness.

## Explicit Non-Goals

- No correction, rename, replacement, or adoption of the currently swapped external Herdr files in this design phase or temporary gate slice.
- No Herdr production profile, generated production variant, selector mutation, reload success claim, or UI convergence claim without complete authoritative evidence.
- No runtime `dusk` generation, selection, scheduling, or activation.
- No palette redesign beyond the bounded Dark-only Nytherx semantic calibration; no independent target color literals and no Light change.
- No replacement of ML4W/Gentleman layout, behavior, launch, wallpaper, or Matugen ownership.
- No automatic migration, deletion, cleanup, or adoption of arbitrary user-owned configuration.
- No installation or version management of third-party applications.
- No broad Ghostty compatibility claim from the narrow parser remediation.
- No import of unrelated global Gentle AI repair scope.
- No use of pre-existing dirty-worktree changes as authored evidence or rollback state.

## Risks and Mitigations

| Risk                                                               | Mitigation                                                                                                                                         |
| ------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- | --- | ------------------------------------------------------------------- |
| Manifest becomes another stale list                                | Make all five consumers derive plans from it and fail inventory parity on independent entries.                                                     |
| Required classification makes absent apps unusable                 | Separate repository product artifacts from optional external consumers and encode availability explicitly.                                         |
| Nytherx becomes subjective or mechanically overfit                 | Bind families to semantic roles and verified matrix decisions; treat 80/15/5 as non-mechanical composition guidance only.                          |
| Dark calibration changes Light                                     | Gate publication on byte-identical canonical Light tokens, mappings, generated constants, and tracked outputs.                                     |
| Target-local Nytherx colors drift                                  | Extract emitted colors and require exact canonical-role serialization or a reasoned non-color allow-list entry.                                    |
| Adaptive writes contaminate tracked variants                       | Use a disjoint path ownership index and separate repository/active generation modes.                                                               |
| Partial application leaves mixed modes                             | Prevalidate, snapshot, order dependencies, stop new mutations on failure, reverse rollback, and report residual state.                             |
| External configuration is overwritten                              | Require path/digest ownership proof; conflicts are non-mutating and migration is explicit.                                                         |
| Reload failures remain hidden                                      | Preserve stderr and exit status, prohibit `                                                                                                        |     | true` for validators/reloads, and aggregate non-success truthfully. |
| Herdr diagnosis is mistaken for schema or runtime proof            | Keep reports and swapped anchors as diagnosis inputs; require exact-version profile evidence for every supported capability.                       |
| Herdr validators, rendering, reload, or UI behavior are overstated | Run only profile-supported checks, model unsupported/unknown/non-observable states explicitly, and return `unsupported-contract` without mutation. |
| Review scope becomes unsafe                                        | Keep Nytherx evidence separate from calibration and Herdr harness separate from rendering/activation; split before 400 authored lines.             |
| Historical artifacts cause executor drift                          | Use master traceability and explicit supersession while preserving old artifacts as evidence only.                                                 |
