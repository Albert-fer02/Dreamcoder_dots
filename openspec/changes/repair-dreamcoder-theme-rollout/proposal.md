# Proposal: Complete the Dreamcoder Light/Dark Rollout Across ML4W and Gentleman Dots

## Decision

Use `repair-dreamcoder-theme-rollout` as the master change for making Dreamcoder Light and Dark render, install, apply, switch, verify, and roll back consistently across the declared ML4W and Gentleman Dots target set.

The rollout is fail-closed for every target classified as required. An optional integration may be skipped only when it is unavailable and the result names the target, reason, consequence, and corrective action. Herdr is not a promised rollout target until its installed-version schema, validation, ownership, and reload contract are verified. `dusk` remains a token/design-system mode and is not eligible for runtime activation.

This proposal supersedes the earlier narrow Ghostty-only proposal as the planning authority for this change. The completed Ghostty parser remediation remains valid evidence and an isolated reviewed slice; it does not establish end-to-end rollout success.

Dreamcoder Dark also adopts **The Nytherx** as its canonical art direction. This is a bounded Dark-only palette-calibration requirement: OLED void backgrounds in black or near-black; graphite and titanium structural layers; star blue-white and cold silver for active systems and readable foregrounds; restrained gravitational violet for depth; and minimal copper or amber for warm focal meaning. The intended 80/15/5 composition is qualitative guidance—approximately 80% void/structural neutrals, 15% cold active/readability roles, and 5% violet plus warm focal accents—not a mechanically verifiable pixel ratio. Concrete token values and role pairings must be chosen only from verified WCAG/APCA matrices; this proposal invents no hex values. Dreamcoder Light remains unchanged.

## Intent

Deliver one explainable product contract for Dreamcoder Light/Dark instead of a collection of partially overlapping generators, hooks, installers, manual color copies, and application-specific exceptions.

A user should be able to install or repair Dreamcoder on a supported Gentleman Dots and ML4W environment, select Light or Dark explicitly or through scheduling, and receive a truthful result: all required targets converged, or the operation failed with actionable diagnostics and a safe rollback. Repeating the same operation must not churn files or selectors.

## Problem and Current-State Gap

The repository already has a broad token-driven Python theme engine, generated snippets, ML4W hooks, Stow modules, mode scripts, and health checks, but their coverage and ownership do not form one enforced contract.

Current gaps include:

- generated target coverage is broader than the health-check inventory;
- installer modules, apply-time targets, and renderer targets are not governed by one required-target manifest;
- manual Tmux palette values can drift from canonical tokens;
- mode application can partially succeed while an integration or reload failure is hidden;
- safe behavior for missing, external, conflicting, or partially installed targets is inconsistent;
- repository Light/Dark variants can be confused with wallpaper-adaptive runtime output;
- Herdr is invoked by runtime scripts even though the repository does not yet prove its version-bound schema, managed ownership, or reliable reload behavior; and
- the pre-existing dirty worktree can contaminate evidence unless explicitly excluded.

The result is operational ambiguity: users cannot reliably tell whether a successful command means the complete declared theme contract was applied.

## Users and Supported Scenarios

### Primary users

- A new user installing Dreamcoder as an overlay on Gentleman Dots and ML4W.
- An existing user repairing or updating a partially configured installation.
- A user explicitly switching between Dreamcoder Light and Dreamcoder Dark.
- A user relying on scheduled automatic Light/Dark selection.
- A maintainer adding or changing a renderer, target, hook, or palette role.

### Supported scenarios

- Fresh installation where managed destinations are absent.
- Repair or reinstall of repository-managed files and symlinks.
- Existing external symlinks or regular files that must not be silently adopted or overwritten.
- A required target that is missing, invalid, unwritable, or cannot reload.
- An optional integration that is not installed or unavailable.
- Repeated generation and repeated application of the already-selected mode.
- Partial activation failure after one or more targets have changed.

## Product Outcome

After this change:

1. Dreamcoder Light and Dark are generated deterministically from canonical tokens for every declared renderable target.
2. Installation and repair classify ownership before mutation and provision all required managed artifacts safely.
3. Explicit and scheduled switching use the same application boundary and converge to the same final state.
4. Every required target either validates and activates successfully or causes a fail-closed result with rollback where mutation occurred.
5. Optional unavailable integrations are skipped only with actionable reporting; optional integrations that are present and selected for activation must not have validation or reload failures hidden.
6. Health output reports what was required, applied, skipped, failed, and rolled back.
7. A second generate or apply run produces no content, selector, or reload churn unless runtime state actually differs.
8. ML4W continues to own layout, behavior, wallpaper lifecycle, Matugen lifecycle, and launch structure; Dreamcoder owns the color-bearing overlay imported after those defaults.

## Canonical Ownership and Required Target Manifest

### Source-of-truth hierarchy

| Concern                                | Owner                                                     | Rule                                                                                       |
| -------------------------------------- | --------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| Palette values and guardrails          | `DreamcoderThemes/dreamcoder/tokens.json`                 | The only authority for color decisions.                                                    |
| Token shape and mode validity          | `DreamcoderThemes/dreamcoder/tokens.schema.json`          | Reject invalid or incomplete token contracts.                                              |
| Generated static token constants       | `src/dreamcoder_theme/palette_tokens.py`                  | Must be generated from and exactly match canonical tokens.                                 |
| Runtime loading and readability guards | `src/dreamcoder_theme/palette.py`                         | Enforces WCAG/APCA policy without weakening canonical values silently.                     |
| Target serialization                   | `src/dreamcoder_theme/renderers.py` and leaf renderers    | Pure, deterministic output; no independent palette literals.                               |
| Generation orchestration               | `src/dreamcoder_theme/sync.py`                            | Produces active outputs and tracked Light/Dark variants according to the manifest.         |
| Safe file mutation                     | `src/dreamcoder_theme/writers.py`                         | Owns write-if-changed and target-specific safe updates.                                    |
| Install/repair ownership               | maintenance, Stow, and hook installers                    | Classify destinations and provision manifest-owned artifacts without destructive adoption. |
| Mode selection and activation          | `scripts/apply-theme-mode.sh` and `scripts/theme-auto.sh` | Apply only `light` or `dark`, aggregate truthful status, and coordinate rollback.          |
| Verification                           | `scripts/verify-theme-health.py` and focused tests        | Validate the same manifest used by generation, installation, and apply.                    |

### Manifest ownership contract

A single tracked Required Target Manifest is the authoritative inventory for rollout behavior. The theme-engine domain owns the manifest; generation, install/repair, apply/switch, health checks, and tests consume the same classifications rather than maintaining independent lists.

Each manifest entry must declare:

- stable target identifier and ownership domain;
- required or optional status, with an explicit product reason;
- Light and Dark render outputs or a documented selector-only contract;
- active destination and repository-generated artifact ownership;
- install/repair ownership classification behavior;
- validation mechanism;
- activation/reload mechanism and whether it is observable;
- rollback capability and failure semantics; and
- any version-bound compatibility constraint.

A target cannot be advertised as covered merely because a renderer exists. It is covered only when its complete manifest contract is implemented and verified.

### Initial target domains

The manifest must account for the audited inventory across:

- terminals and terminal-adjacent tools: Kitty, Ghostty, Warp, Tmux, Zellij, Starship, shell syntax highlighting, and `LS_COLORS`;
- editors, coding CLIs, and TUIs: Neovim, Bat, Codex TextMate, Delta, fzf, OpenCode theme/TUI settings, Pi, Codex CLI, and Antigravity;
- desktop and ML4W surfaces: Hyprland, Waybar, Rofi, Dunst, Btop, Firefox, Obsidian, Cava, and wallpaper/Matugen hook integration; and
- repository and operational artifacts: generated Dreamcoder Light/Dark snippets, prefixed Gentleman Dots modules, installer plans, Stow modules, hooks, doctor, and maintenance flows.

The design phase must classify every audited entry as required, optional, or explicitly excluded before implementation. An unclassified audited entry blocks rollout completion.

## Business and Product Rules

1. **Required means fail closed.** Missing output, invalid rendering, ownership conflict, write failure, selector failure, validation failure, or activation/reload failure for a required target fails the aggregate operation. Mutation must stop or roll back according to the target transaction boundary.
2. **Optional does not mean silent.** An optional integration may be skipped only when unavailable. Reporting must identify the target, why it was skipped, what capability is absent, and the command or action needed to enable or diagnose it.
3. **Present optional targets remain accountable.** Once an optional target is detected, selected, and mutated, its invalid configuration or failed activation cannot be reported as success.
4. **Canonical tokens are the only color authority.** Target-specific color literals are prohibited unless they are generated from canonical roles or explicitly documented non-color syntax. Existing manual Tmux values must be generated or parity-checked.
5. **Repository variants are deterministic.** Tracked Light/Dark artifacts use canonical non-adaptive palettes. Wallpaper adaptation may affect active runtime output but must never rewrite tracked variants.
6. **Light and Dark are the only runtime modes.** `dusk` remains available for token parity, readability validation, and design-system analysis, but apply scripts, scheduling, selectors, and active target generation must reject runtime activation of `dusk`.
7. **ML4W remains structurally authoritative.** Dreamcoder imports color-bearing overlays after ML4W/Gentleman defaults and must not replace their layout, behavior, wallpaper, Matugen, or launcher ownership.
8. **Ownership precedes mutation.** Fresh, managed, external-symlink, external-file, missing-parent, and conflict states must be classified before install, repair, or apply changes a destination.
9. **No destructive adoption.** External files or symlinks are never silently overwritten or converted to repository ownership. A conflict must fail with recovery instructions unless an explicit migration contract applies.
10. **Switching is transactional at the product boundary.** Selector changes, generated writes, and observable reloads must either converge to the requested mode or produce a truthful partial-failure result and rollback affected state where supported.
11. **Pre-existing dirty worktree changes are excluded evidence.** They may inform discovery, but they are not authored scope, acceptance evidence, rollback material, or proof of this change. Every slice must bind evidence to its declared paths and baseline.
12. **Ghostty evidence is version-bound.** The completed title-field repair is accepted only for its recorded Ghostty version and narrow validation claim. Broader Ghostty rendering and activation still require manifest-level evidence.
13. **Herdr remains gated.** No Herdr support promise, generated config, installation ownership, active-file mutation, reload claim, or required-target classification is allowed until its installed-version schema, validation command, active paths, ownership states, and reload/restart contract are authoritatively verified.
14. **The Nytherx calibrates Dark only.** Dark semantic roles must express OLED void backgrounds, graphite/titanium structure, star blue-white and cold silver active/readability systems, restrained gravitational violet depth, and minimal copper/amber focal meaning. The 80/15/5 balance is qualitative composition guidance, not a pixel-counting acceptance gate. Every concrete token choice must come from a verified WCAG/APCA role matrix, and no target may introduce an independent Nytherx color literal. Light tokens, Light role mappings, and Light rendered output remain unchanged.

## Scope

### In scope

- Establish and enforce the single required/optional target manifest across generation, install/repair, apply/switch, and health verification.
- Ensure deterministic canonical Dreamcoder Light/Dark rendering for every declared renderable target.
- Enforce canonical token-to-generated-token parity and eliminate or guard manual color duplication.
- Calibrate the canonical Dreamcoder Dark semantic palette to The Nytherx art direction, including an explicit restrained violet depth role, using only token candidates and role pairings that pass the verified WCAG/APCA matrices.
- Preserve Dreamcoder Light token values, semantic mappings, and generated output byte-for-byte throughout the Dark calibration slice.
- Validate readability roles and state combinations with WCAG and APCA evidence.
- Reconcile ML4W/Gentleman overlay ordering, mode selector ordering, hook behavior, and active reload reporting.
- Make fresh install and repair ownership-aware, conflict-safe, and complete for required targets.
- Make explicit and scheduled Light/Dark selection converge through the same application contract.
- Add idempotency and rollback evidence for generation, installation, and activation boundaries.
- Preserve the completed Ghostty parser remediation as an isolated, version-bound slice and add broader Ghostty coverage only through the manifest contract.
- Produce concise operator diagnostics and recovery guidance.
- Classify Herdr as gated/unavailable until its runtime contract is proven; if later proven within this master change, implement it only in dedicated slices.

### Out of scope

- Runtime activation of `dusk`.
- Visual-identity or palette redesign beyond the bounded Dreamcoder Dark Nytherx calibration; Dreamcoder Light is explicitly unchanged.
- Implementing the user's character, ship, city, or architectural references as repository assets, UI features, target syntax, or runtime behavior; they are external brand rationale only.
- Treating the qualitative 80/15/5 composition guidance as a mechanically measured pixel ratio.
- Replacing ML4W layout, behavior, wallpaper lifecycle, Matugen lifecycle, or launch structure.
- Installing third-party applications or upgrading/downgrading their versions.
- Inventing unsupported configuration syntax or reload behavior.
- Silently adopting or deleting user-owned configuration.
- Treating application settings unrelated to theme presentation as theme artifacts.
- Folding global Gentle AI remediation into this rollout.
- Claiming Herdr support before its version-bound contract is verified.
- Treating pre-existing dirty-worktree changes as implementation scope.

## Affected Areas

- Canonical Dark tokens, semantic-role mapping, schema, generated token constants, and WCAG/APCA contrast validation for The Nytherx calibration; canonical Light artifacts remain preservation-only.
- Theme renderer registry, leaf renderers, synchronization, settings, and writers.
- Generated Dreamcoder Light/Dark repository snippets and prefixed Gentleman Dots modules.
- ML4W color overlay imports and Matugen-compatible Hyprland, Waybar, and Rofi outputs.
- Install, repair, Stow, hook, doctor, and maintenance flows.
- Explicit and scheduled mode application, selector ordering, reload helpers, and aggregate status.
- Theme-health checks, focused tests, fixtures, and operator documentation.
- Ghostty as a version-bound target with its previous narrow parser repair preserved.
- Herdr only as a gated manifest entry until its contract is verified.

## Measurable Acceptance Criteria

### Manifest and scope

1. Every audited target has exactly one manifest classification: required, optional with reason, or explicitly excluded with reason.
2. Generation, install/repair, apply/switch, health checks, and tests derive their coverage from the same manifest or pass an automated parity check proving no independent inventory drift.
3. Acceptance evidence lists only slice-owned paths and explicitly excludes the pre-existing dirty-worktree baseline.
4. No required target is silently skipped; no unclassified audited target remains at completion.

### Rendering

1. Every declared renderable target produces both Light and Dark output from canonical tokens.
2. Two consecutive repository-generation runs produce byte-identical outputs with stable ordering, LF endings, one trailing newline, and no unsupported fields.
3. Tracked Light/Dark outputs remain unchanged when only wallpaper-adaptive runtime generation is exercised.
4. Runtime or parser validation succeeds for every target that exposes a version-appropriate validator.

### Installation and repair

1. Automated or reproducible fixtures cover fresh destination, repository-managed target, missing target, external symlink, external regular file, and ownership conflict.
2. Required artifacts exist and validate before activation; an ownership conflict causes a fail-closed result without destructive adoption.
3. Repair restores missing or stale repository-managed artifacts but leaves unrelated user-owned content unchanged.
4. An unavailable optional integration is reported with target, reason, impact, and corrective action.

### Apply and switching

1. Explicit Light-to-Dark and Dark-to-Light operations converge every required active selector and observable consumer to the requested mode.
2. Scheduled selection invokes the same application boundary and reaches the same final state as explicit selection.
3. Selector ordering prevents stale active links from causing a mode-specific repository artifact to be overwritten.
4. A required validation, write, selector, or reload failure produces a non-success aggregate result naming the failed target and phase.
5. Optional-target validation or reload failure after mutation is not reported as a successful optional skip.

### Idempotency

1. A second generation run changes no bytes.
2. A second application of the active mode changes no managed content or selector and avoids unnecessary reloads where target observability permits.
3. `write_if_changed` or equivalent evidence reports unchanged outputs on the second run.

### Rollback

1. Fixtures exercise failure after at least one mutation and prove restoration of prior managed content and selectors for rollback-capable targets.
2. Rollback failure is reported distinctly from the initiating failure and identifies remaining inconsistent targets.
3. Rollback never restores unsupported Ghostty title keys or overwrites external user-owned configuration.

### Readability and token parity

1. `tokens.json` validates against its schema and generated `palette_tokens.py` matches canonical mode and role values exactly.
2. All required palette roles exist for Light, Dark, and design-system `dusk`; parity checks do not make `dusk` runtime-activatable.
3. Text-bearing state combinations meet WCAG 2 contrast of at least 4.5:1 unless a stricter existing role policy applies.
4. Existing mode-aware APCA body thresholds are checked independently; APCA advisories never waive a WCAG failure.
5. Readability diagnostics identify mode, role/state, target where material, measured value, required threshold, and source token.
6. Selection, focus, muted text, borders where material, and semantic error/warning/success/info states have explicit readable foreground/background checks.
7. No target-specific palette literal can drift undetected from canonical tokens.
8. A machine-readable Dark semantic-role mapping assigns every Nytherx family to its permitted purpose: void to backgrounds; graphite/titanium to structure; star blue-white/cold silver to active systems and readable foregrounds; restrained gravitational violet to depth; and copper/amber only to minimal warm focal meaning.
9. Every concrete Dark token candidate and every text-bearing or state-bearing foreground/background pairing is traceable to a verified WCAG/APCA matrix result; no acceptance evidence relies on an invented or visually assumed hex value.
10. Dark body, heading, muted/comment, selection, focus, link, border where material, and semantic status pairings satisfy the existing blocking WCAG thresholds and applicable APCA thresholds, with diagnostics naming role, state, metric, measured value, threshold, and source token.
11. Renderer and generated-artifact checks prove that Nytherx colors enter targets only through canonical semantic roles; any target-specific color literal fails unless it is an explicitly allow-listed non-color syntax value or exact canonical-token serialization.
12. The complete canonical Light token object, Light semantic-role mapping, and tracked Light render outputs are byte-identical to the pre-calibration baseline.
13. Review evidence describes 80/15/5 only as qualitative composition guidance and does not claim or require pixel-level ratio measurement.

### Product completion

1. Health output summarizes required successes, optional successes, actionable skips, failures, and rollback status.
2. The completed Ghostty parser repair remains independently verifiable without being used as proof for unrelated targets.
3. Herdr is reported as gated/unavailable unless all version-bound schema, ownership, validation, and reload criteria are proven and its dedicated slices pass.
4. Runtime activation accepts only `light` and `dark`; `dusk` is rejected without mutating active state.

## Reviewable Delivery Slices

Each implementation slice must target fewer than 400 authored changed lines. If a slice cannot remain below that bound without obscuring an atomic behavior, it must be split before apply rather than receiving a blanket exception.

1. **Contract and inventory foundation:** establish manifest ownership and classifications, token/generated parity, design-system state matrix, WCAG/APCA diagnostics, and dirty-worktree evidence boundaries.
2. **Dreamcoder Dark Nytherx calibration:** after the verified contrast matrices exist, map Dark semantic roles to the bounded Nytherx families, add the restrained violet depth role without target-local literals, regenerate Dark artifacts, and prove the complete Light contract is unchanged. External character, ship, city, and architectural references remain rationale only.
3. **Deterministic repository generation — terminal and shell:** normalize Light/Dark outputs for terminal, prompt, multiplexer, and shell targets without changing apply behavior.
4. **Deterministic repository generation — editor, CLI, and desktop:** normalize the remaining editor/CLI and ML4W-facing snippets while preserving special renderer boundaries.
5. **ML4W/Gentleman install and ownership:** align Stow/module planning, hooks, fresh-install and repair classification, conflict safety, and required-artifact provisioning.
6. **Apply and switching correctness:** fix selector ordering, remove or parity-guard manual Tmux colors, converge explicit/scheduled paths, make reload status truthful, and implement bounded rollback.
7. **Ghostty completion:** preserve the completed narrow title repair as its own historical/review unit, then add only the manifest-required Light/Dark rendering, validation, switching, and failure evidence not already proven.
8. **Herdr contract and renderer, gated:** proceed only after authoritative installed-version evidence; generate repository-owned variants and remove generic live-file mutation. If the gate remains closed, record actionable exclusion and do not promise support.
9. **Herdr installation and activation, gated:** only after Slice 8 succeeds; add ownership classification, migration, atomic selection, observable reload/restart, rollback, scheduling convergence, and Fish-startup compatibility.
10. **End-to-end health and operator evidence:** exercise required-target rendering, installation, both switch directions, idempotency, rollback, actionable optional skips, and concise recovery documentation.

The design and tasks phases may subdivide these slices further. They must not merge unrelated ownership domains merely to reduce phase count.

## Coordination With Overlapping SDDs

This master change coordinates prior work without deleting or rewriting its artifacts:

| Change                              | Coordination decision                                                                                                                                                                                                                                            |
| ----------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `repair-dreamcoder-theme-rollout`   | Becomes the parent planning and acceptance authority. Its earlier Ghostty proposal/design/tasks remain historical evidence for the completed narrow slice and must be marked superseded for future planning.                                                     |
| `harden-theme-design-system`        | Its token provenance, mode parity, state matrix, WCAG/APCA, and deterministic health work becomes prerequisite foundation input to Slice 1. Its artifacts remain intact and must link back to this master change rather than drive a separate competing rollout. |
| `implement-herdr-dreamcoder-themes` | Its runtime-contract, ownership, migration, activation, and rollback requirements remain valuable but gated. Its artifacts remain intact and become inputs to Slices 8–9 only after version-bound evidence succeeds.                                             |
| `repair-gga-and-theme-delivery`     | Remains a separate global Gentle AI remediation. Only its dirty-worktree isolation, bounded-slice, receipt, and rollback evidence discipline constrain this rollout; its unrelated implementation scope is not imported.                                         |

Supersession means newer specs, design, and tasks under this master change control future implementation. It does not erase evidence, completed work, review history, or rationale from overlapping changes. The next planning phases must add explicit cross-references and identify stale prior artifacts so no executor accidentally follows the old Ghostty-only task list as the complete rollout plan.

## Risks and Mitigations

- **Manifest scope becomes too broad:** declaring every discovered integration required could make normal installs unusable. Mitigation: classify by product promise and availability, require a reason for optional/excluded status, and preserve fail-closed behavior for what is declared required.
- **Silent partial success:** shell helpers may suppress validator or reload failures. Mitigation: structured per-target outcomes and non-success aggregate status for required failures or mutated optional failures.
- **Manual palette drift:** Tmux or other scripts may retain independent literals. Mitigation: generate values or enforce exact parity against canonical roles.
- **Nytherx direction becomes subjective or overbroad:** qualitative brand references could encourage arbitrary hues, target-specific styling, or implementation of non-code imagery. Mitigation: constrain the slice to Dark semantic roles, select concrete values only from verified WCAG/APCA matrices, treat 80/15/5 as qualitative guidance, and keep external narrative references as rationale only.
- **Dark calibration regresses Light:** shared renderers or token tooling could alter Light while changing Dark. Mitigation: bind the slice to a pre-calibration Light baseline and require byte-identical Light tokens, mappings, and generated outputs.
- **Unsafe ownership migration:** install/repair may overwrite external files. Mitigation: classify before mutation, fail on conflict, and require explicit migration plus rollback.
- **Adaptive output contaminates tracked variants:** wallpaper-derived colors could rewrite reviewable artifacts. Mitigation: separate canonical repository generation from adaptive active-runtime generation and test the boundary.
- **Activation leaves mixed modes:** failure after partial mutation can strand consumers. Mitigation: snapshot selectors/content needed for rollback, order reversible steps before reloads, and report residual inconsistency.
- **Reload observability differs by application:** some consumers may not expose a reliable reload result. Mitigation: encode the observable contract per manifest entry and require restart or explicit limitation rather than claiming success.
- **Herdr speculation:** an assumed schema or reload command could break startup. Mitigation: keep the gate closed until version-bound evidence exists; do not emit or activate Herdr configuration beforehand.
- **Dusk scope creep:** three-mode token parity could accidentally expand runtime scheduling. Mitigation: reject `dusk` at every runtime entrypoint and test non-mutation on rejection.
- **Dirty-worktree contamination:** unrelated existing edits could be reviewed or rolled back as part of this change. Mitigation: capture slice-specific baselines, bind evidence to declared paths, and never use unrelated dirty changes as authored scope.
- **Reviewer overload:** a cross-cutting rollout can exceed safe review size. Mitigation: enforce the proposed sub-400-line slices and separate ownership domains.

## Rollback Strategy

- Capture the prior managed content, selector state, and target outcome before each mutating slice or apply transaction.
- On generation or validation failure, do not publish or activate invalid output.
- On install ownership conflict, make no destination mutation and provide corrective instructions.
- On apply failure after mutation, restore prior managed files and selectors for affected rollback-capable targets, then revalidate the restored mode.
- Do not overwrite external user-owned configuration during rollback.
- Report rollback failure separately and list any remaining mixed-mode or invalid targets.
- Preserve valid version-bound fixes during rollback; specifically, never restore Ghostty's unsupported `window-title` or `tab-title` keys.
- Roll back each reviewable slice independently. Do not require reverting unrelated slices or pre-existing dirty-worktree content.

## Success Criteria

The master change is complete only when:

- all audited targets are explicitly classified;
- every required target passes its rendering, installation/repair, apply/switch, idempotency, readability, and rollback contract;
- optional unavailable targets produce actionable skips and no present-but-failed integration is hidden;
- Light and Dark converge through explicit and scheduled paths without tracked-artifact contamination or repeated-run churn;
- canonical token parity and WCAG/APCA policies pass with target-specific diagnostics;
- Dreamcoder Dark expresses the bounded Nytherx semantic-role contract using matrix-verified token decisions, with no uncontrolled target-specific literals and without converting the qualitative 80/15/5 guidance into a pixel-ratio claim;
- Dreamcoder Light tokens, semantic mappings, and tracked outputs remain byte-identical to their pre-calibration baseline;
- ML4W/Gentleman ownership boundaries remain intact;
- `dusk` remains outside runtime activation;
- Herdr is either still truthfully gated or has passed its version-bound dedicated slices; and
- evidence and rollback scope exclude all pre-existing dirty-worktree changes.

## Proposal Question Round Resolution

The user delegated the product decisions required for consolidation and authorized corrective planning. This proposal therefore adopts the following assumptions without an additional question round:

- completeness is defined by one declared target manifest, not by every application installed on a machine;
- required targets fail closed, while unavailable optional integrations may be skipped only with actionable reporting;
- safe ownership and truthful partial-failure reporting take precedence over best-effort activation;
- Light and Dark are the runtime product modes; `dusk` remains design-system-only;
- Herdr remains a gated future slice until its runtime contract is proven;
- The Nytherx is a bounded Dark-only art direction whose concrete tokens must come from verified WCAG/APCA matrices, while 80/15/5 remains qualitative composition guidance;
- Dreamcoder Light remains unchanged, and character, ship, city, and architectural references remain external brand rationale rather than repository implementation scope; and
- prior SDD artifacts are preserved as evidence and coordinated inputs, not deleted or treated as parallel implementation authorities.
