# Native Dreamcoder Herdr Light/Dark Integration Design

Herdr will become a first-class Dreamcoder theme target driven exclusively by Dreamcoder tokens. The implementation must not borrow Gentleman styling or assume Herdr configuration semantics. It will first prove the Herdr 0.7.3 contract, then generate deterministic Dreamcoder Light and Dark variants, install them without taking ownership of user files, and switch modes only when the result can be observed and reported truthfully.

## Decision Summary

| Topic | Decision |
| --- | --- |
| Theme authority | `themes/dreamcoder/tokens.json` is the only color authority. |
| Target status | Herdr is a native Dreamcoder target, not a static copied configuration. |
| Supported modes | Light and Dark only. The integration does not introduce a Herdr Dusk mode. |
| Compatibility boundary | Herdr 0.7.3 behavior must be demonstrated before behavior-changing code is written. |
| Generated output | The renderer produces deterministic Light and Dark variants in the `DreamcoderHerdr/.config/herdr` module. |
| Switching safety | Validate before changing selection; make the selector change atomically; reload only when its result is observable; roll back on a failed transaction. |
| User-file safety | The installer changes only files it owns, records ownership, and backs up eligible pre-existing files before migration. |
| Status contract | A mode switch succeeds only when every required step succeeds. Errors from validation, selection, reload, or rollback are visible to the caller. |

## Scope

The later implementation will add a Herdr compatibility profile, token renderer, target exports, managed configuration module, installation or migration path, and safe switching integration. It will connect the target to the existing Dreamcoder theme workflow after the target contract is verified.

The design recognizes these current integration anchors:

- `themes/dreamcoder/tokens.json` is the token input for Dreamcoder renderers.
- `src/dreamcoder_theme/renderers.py` is the renderer export hub.
- `src/dreamcoder_theme/sync.py` and `src/dreamcoder_theme/settings.py` are the existing orchestration and path-definition seams for generated targets.
- Fish starts Herdr from `DreamcoderShell/.config/fish/config.fish`; the runtime integration must preserve that startup responsibility.
- `scripts/herdr-theme-switch.sh` currently expects external `config.dark.toml` and `config.light.toml` files and hides reload errors.
- `scripts/apply-theme-mode.sh` can report a successful theme application when the Herdr operation did not succeed.

## Non-Goals

- Changing Herdr, Fish, or theme files in this design phase.
- Copying, adapting, or treating Gentleman's static Herdr configuration as a compatible implementation.
- Supporting unverified Herdr versions or claiming compatibility with versions other than 0.7.3.
- Adding adaptive wallpaper-derived Herdr colors in the first integration.
- Introducing a Dusk selector, automatic time scheduling, or a background service.
- Replacing the existing Fish startup policy or silently killing and restarting Herdr.
- Overwriting an unmanaged user Herdr configuration.
- Reporting success merely because a script started or a selector file was written.

## Contract Discovery Is the First Deliverable

Herdr 0.7.3 is installed, but the following facts are unverified and must not be encoded from examples, memories, or a static Gentleman file:

- TOML structure and required sections.
- Valid color fields, their accepted syntax, and their mapping to Herdr UI elements.
- Validation command, exit behavior, and diagnostic output.
- Default configuration path, XDG behavior, environment-variable overrides, and include or selector behavior.
- Startup behavior when the configuration is absent, invalid, or changed.
- Reload semantics, including whether reload exists, which invocation triggers it, and how success or failure is signaled.

### Required Compatibility Evidence

Before implementation changes behavior, a reproducible 0.7.3 compatibility investigation must produce evidence for every item below.

| Evidence | Required result | Implementation consequence |
| --- | --- | --- |
| Installed version | The executable reports exactly `0.7.3`. | The profile is pinned to the inspected version. |
| Canonical sample | A minimal known-good configuration is accepted by Herdr. | Establishes the renderer's structural baseline. |
| Field matrix | Each intended color field is accepted, rejected, or ignored with captured evidence. | The renderer emits only accepted, effective fields. |
| Invalid-config behavior | An intentionally invalid file has a known non-zero or otherwise detectable failure signal. | Validation and rollback can distinguish rejection from acceptance. |
| Path resolution | The active configuration path is demonstrated under the real Fish launch environment. | The installer and selector modify the path Herdr actually reads. |
| Variant selection | The mechanism that chooses Light versus Dark is demonstrated. | The transaction updates the real selector, not a speculative file. |
| Runtime reload | The supported reload mechanism, or lack of one, is demonstrated with observable evidence. | Reload handling follows actual capabilities. |
| Live effect | A visible or queryable property changes after a valid mode switch. | The switcher can assert postcondition success. |

The compatibility profile is a version-tied record of this evidence for Herdr 0.7.3. It must contain the supported schema, field mapping, path rules, selector mechanism, validation invocation, reload capability, observable postcondition, and known unsupported behavior. A new Herdr release requires a new investigation and profile review; it must not inherit 0.7.3 support automatically.

If discovery finds that Herdr cannot validate configuration, cannot select variants safely, or cannot provide an observable activation outcome, the implementation must stop at generation and installation design. A verified restart-required path remains acceptable when a later restart can provide that observation. The implementation must not simulate confidence with hidden errors, process signals of unknown meaning, or an unconditional success exit code.

## Generated Configuration Design

### Token Mapping

The future `renderers_herdr.py` will consume `themes/dreamcoder/tokens.json` through the existing Dreamcoder palette path. It will map only verified Herdr color fields to Dreamcoder tokens. The compatibility profile, not a copied static file, determines which fields exist and how values are serialized.

The initial mapping must prefer semantic token roles over arbitrary palette selection:

| Herdr role after verification | Dreamcoder token source |
| --- | --- |
| Main background | `bg` |
| Secondary surface | `bg_soft` or a verified `surface*` role |
| Primary text | `text` |
| Muted text | `muted` or `subtle` |
| Focus or active state | `focus` or `accent` |
| Selection | `selection` |
| Error, warning, success, information | Corresponding semantic token |

The exact left-hand field names and any required transformations remain defined only by the compatibility profile. Each generated variant must preserve the token engine's contrast guardrails: WCAG text minimum 4.5:1, preferred main-text contrast 7.0:1, and the applicable APCA body minimum for its mode.

### Module and Variants

`DreamcoderHerdr/.config/herdr` will be the repository-managed module for this target. After compatibility proof, it will contain deterministic generated Light and Dark variants plus only the module metadata needed to establish ownership and select an active variant.

Deterministic means that equal token input, compatibility-profile version, renderer version, and mode produce byte-identical output. Generated files must not contain timestamps, machine-specific absolute paths, random identifiers, or environment-dependent color values.

The renderer is exported through `src/dreamcoder_theme/renderers.py`; path and sync integration are added through the existing theme-engine seams only after the generated artifacts and their runtime consumption are proven. The renderer must not emit an implicit fallback palette or Gentleman colors when a required Dreamcoder token is unavailable.

## Ownership and Migration Semantics

The installer treats an existing Herdr setup as user-owned unless an ownership marker and recorded managed-file manifest both identify it as Dreamcoder-managed. A matching directory name alone is never evidence of ownership.

| Existing state | Installer behavior |
| --- | --- |
| No active Herdr configuration | Install the managed module and configure the verified active path. |
| Managed configuration with matching manifest | Update only the recorded managed files. |
| Managed configuration with missing, altered, or inconsistent manifest | Stop and report a repair conflict; do not overwrite. |
| Unmanaged user configuration | Stop by default and report the conflict. Migration requires an explicit user action. |
| Explicit unmanaged migration | Create a recoverable backup before any change, then install only the verified integration boundary. |

Backups must be created only for files the migration will alter, placed outside the new managed module, and recorded with their original path and content identity. A failed migration restores every altered file from that transaction's backup. Existing files outside the integration boundary are neither moved nor deleted.

The implementation must preserve the Fish startup relationship in `DreamcoderShell/.config/fish/config.fish`. It may update that launch configuration only after discovery proves the required launch arguments and active-path behavior, and only with the same ownership and backup rules. It must not add a second Herdr process or assume an arbitrary process name is safe to terminate.

## Mode-Switch Transaction

The current external-file assumption in `scripts/herdr-theme-switch.sh` is replaced only after the verified selector mechanism is known. The new flow operates on generated, managed variants and has one transaction boundary.

1. Resolve the requested mode to `light` or `dark`; reject every other value before touching files.
2. Load the 0.7.3 compatibility profile and verify that it covers the installed Herdr version.
3. Confirm that the requested generated variant exists, belongs to the managed manifest, and passes the verified Herdr validation command.
4. Capture the prior selector state and all data needed to restore it.
5. Update the verified selector atomically. The atomic operation must replace one complete selector state, never expose a partial file, and preserve the prior selector until replacement succeeds.
6. Perform the profile-defined reload only when its invocation and outcome are observable. If Herdr requires restart rather than reload, the result must be explicitly reported as restart-required rather than falsely reported as live-applied.
7. Verify the profile-defined postcondition: Herdr is using the requested variant or an equivalent observable color property confirms it.
8. Return success only after the postcondition succeeds.

If any step after selector capture fails, the transaction restores the prior selector atomically. When a reload attempt may have partially applied a configuration, rollback must invoke the same verified observable activation path for the restored selector. The command result must distinguish:

- `applied`: requested mode is observably active.
- `rolled_back`: requested mode was not applied and the prior mode is observably restored.
- `restart_required`: the selector is valid but Herdr does not support a verified live reload.
- `failed`: neither the requested state nor a confirmed rollback state is active.

`scripts/apply-theme-mode.sh` must consume this result rather than infer success from a child process exit that was masked or ignored. Its final status is successful only for `applied`; `restart_required`, `rolled_back`, and `failed` are non-success outcomes with actionable diagnostics. It must preserve the failure status from the Herdr switcher and identify the failed phase: validation, selector update, reload, postcondition, or rollback.

## Failure Handling

| Failure | Required behavior |
| --- | --- |
| Unsupported installed version | Make no changes; report the supported profile version and detected version. |
| Missing or invalid generated variant | Make no selector change; report validation output. |
| Selector replacement failure | Retain the prior selector and return failure. |
| Reload invocation failure | Restore the prior selector, attempt verified rollback activation, and expose both errors if rollback fails. |
| Postcondition mismatch | Treat as failed activation, not success; roll back as above. |
| Unmanaged configuration | Make no changes; state the exact conflicting paths. |
| Backup creation failure | Abort before modifying the user configuration. |
| Manifest conflict | Make no changes; require an explicit repair or migration action. |

Errors must be written to standard error with the operation, mode, affected path, and phase. No `|| true`, redirected reload error, unconditional zero exit, or generic success message is permitted on a failed Herdr step.

## Acceptance Criteria

### Contract and Rendering

- [ ] A checked-in Herdr 0.7.3 compatibility profile cites reproducible evidence for schema, valid fields, validation, active path, variant selection, reload semantics, and postcondition observation.
- [ ] Every emitted Herdr field is accepted and effective according to the profile; no field originates from an unverified example or Gentleman static configuration.
- [ ] Light and Dark output comes from `themes/dreamcoder/tokens.json` through the Dreamcoder renderer path.
- [ ] Generated variants in `DreamcoderHerdr/.config/herdr` are byte-identical across repeated generation with unchanged input.
- [ ] Generated colors meet the Dreamcoder token contrast guardrails for their mode.
- [ ] The Herdr renderer is exported through `src/dreamcoder_theme/renderers.py` and integrated through the established theme-engine path model.

### Ownership and Installation

- [ ] A clean installation creates only declared Dreamcoder-managed files and a manifest sufficient to identify them later.
- [ ] A managed update modifies only manifest-owned files.
- [ ] An unmanaged configuration remains unchanged without explicit migration.
- [ ] Explicit migration makes a recoverable backup before the first user-file modification.
- [ ] A failed migration restores all files altered by that migration transaction.
- [ ] Fish continues to start Herdr from `DreamcoderShell/.config/fish/config.fish`, using only a discovery-proven launch configuration.

### Switching and Status

- [ ] Invalid mode input does not modify the selector or reload Herdr.
- [ ] Validation failure leaves the active selector unchanged.
- [ ] A valid switch updates the selector atomically and confirms the requested active state through the profile-defined postcondition.
- [ ] Reload errors are visible and cause a non-success result.
- [ ] Postcondition failure triggers rollback and reports whether rollback was confirmed.
- [ ] `scripts/apply-theme-mode.sh` reports success only when Herdr returns `applied`; it preserves non-success Herdr results and phase diagnostics.
- [ ] A no-live-reload Herdr contract reports `restart_required` without claiming the theme was live-applied.

## Verification Strategy

Verification is a later implementation gate, not an assumption satisfied by documentation. It must run against the installed Herdr 0.7.3 binary and a disposable configuration environment so it does not alter a user's active configuration.

| Layer | Verification | Expected evidence |
| --- | --- | --- |
| Compatibility | Exercise minimal valid and invalid configs, intended fields, active path resolution, selection, and reload or restart behavior. | Captured command output, exit statuses, and observable runtime results recorded in the 0.7.3 profile. |
| Token renderer | Render both modes from fixture tokens and compare against approved deterministic snapshots. | Stable fixture output and token-to-field assertions. |
| Color quality | Run the existing token health checks and validate rendered foreground/background pairings required by the profile. | Passing contrast results for Light and Dark. |
| Installer | Test clean install, managed update, unmanaged conflict, explicit migration, backup failure, and restore after injected failure. | File manifests and byte-for-byte restoration checks. |
| Switcher | Test invalid input, missing variant, validation failure, selector replacement failure, reload failure, postcondition failure, successful Light and Dark activation, and restart-required behavior. | Exit status, phase diagnostics, selector state, and observed active state for each case. |
| End-to-end | Start Herdr through the Fish integration in an isolated XDG environment, apply Light then Dark, and verify the active runtime state after each transaction. | No hidden errors; exact state transitions and truthful top-level status. |

The implementation is not complete until the end-to-end test proves both directions of switching and at least one rollback path. A passing generation test alone is insufficient because it cannot validate Herdr's configuration-path or runtime semantics.

## Review Checklist

- [ ] This document names no Herdr TOML field, default path, selector, or reload command as fact without requiring compatibility evidence.
- [ ] Dreamcoder tokens, not Gentleman configuration, are the color source.
- [ ] The design separates deterministic generation, ownership-aware installation, selector mutation, activation, and postcondition verification.
- [ ] Every failure after selector capture has a defined rollback and status outcome.
- [ ] `restart_required` is explicitly non-success and cannot be confused with live application.
- [ ] The acceptance criteria and verification matrix cover all stated design decisions.
- [ ] The proposed work is isolated from unrelated dirty or staged workspace changes.
