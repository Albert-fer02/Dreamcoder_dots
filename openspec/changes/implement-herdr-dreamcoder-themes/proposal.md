# Proposal: Implement and Safely Activate Herdr Dreamcoder Themes

## Intent

Add complete Dreamcoder Light and Dreamcoder Dark configurations for Herdr and support a narrowly bounded, managed local activation on the exact verified runtime version, `herdr 0.7.3`.

Each managed configuration combines Dreamcoder-owned theme values with the canonical non-theme `[ui]` and `[keys]` values from upstream Gentleman.Dots. Activation must preserve the existing active configuration in a backup, update only the resolved Herdr configuration target atomically, attempt Herdr's documented configuration reload when applicable, and restore the backup if writing or reloading fails.

This proposal does not establish a general migration, adoption, repair, or runtime-management framework. It authorizes only the evidenced Herdr 0.7.3 path and the two explicit Dreamcoder variants.

## Current-State Gap

The repository already contains Light and Dark Herdr variants and a renderer restricted to those modes, but the checked-in variants omit the canonical upstream `[ui]` and `[keys]` sections. The active local Herdr configuration contains a custom Dreamcoder Light theme but likewise lacks those canonical sections.

The current workflow also lacks a bounded way to activate a complete Dreamcoder Herdr configuration while preserving user-owned state and recovering from a failed write or documented reload.

Authoritative evidence for this proposal is:

- Installed runtime: `herdr --version` returns exactly `herdr 0.7.3`.
- Herdr help documents `HERDR_CONFIG_PATH` and `herdr server reload-config`.
- The observed default runtime configuration is under the XDG configuration location for Herdr; implementation must derive it from environment variables and must not hardcode a specific user's home path.
- Canonical upstream configuration: `/tmp/pi-github-repos/Gentleman-Programming/Gentleman.Dots/herdr/config.toml`.
- Existing repository variants:
  - `DreamcoderHerdr/.config/herdr/dreamcoder/0.7.3/config.dark.toml`
  - `DreamcoderHerdr/.config/herdr/dreamcoder/0.7.3/config.light.toml`
- Existing Light/Dark renderer: `src/dreamcoder_theme/renderers_herdr.py`.

This evidence proves the supported version, active configuration path contract, documented reload command, and canonical static values. It does not justify broader version support, process discovery, scheduling, automatic mode selection, or unrelated target management.

## Product Outcome

A user running exactly Herdr 0.7.3 can explicitly activate either:

- Dreamcoder Dark
- Dreamcoder Light

The resulting active configuration contains:

1. Dreamcoder-owned `[theme]` and `[theme.custom]` values from the existing Herdr renderer contract.
2. Canonical upstream `[ui]` and `[keys]` values, independent of Dreamcoder palette changes.

Activation is safe and explainable:

1. Resolve the active Herdr configuration from `HERDR_CONFIG_PATH` when explicitly provided; otherwise derive the standard Herdr path from `XDG_CONFIG_HOME`, with the XDG default based on `HOME` when the variable is unset.
2. Refuse managed activation unless `herdr --version` is exactly `herdr 0.7.3`.
3. Back up the existing active configuration before changing it.
4. Atomically replace or managed-update only that resolved configuration with the selected complete Light or Dark configuration.
5. Attempt `herdr server reload-config` only after a successful active-config update and only where reload is applicable to the invocation/runtime context.
6. Report an actionable failure and restore the backup if the write or attempted reload fails.

## Scope

### In scope

- Complete the static Dreamcoder Dark and Dreamcoder Light Herdr configurations.
- Preserve the renderer's existing Light/Dark-only mode boundary.
- Treat `[theme]` and `[theme.custom]` as the only palette-driven Dreamcoder sections.
- Include `[ui]` with the canonical upstream value:
  - `accent = "#6FA0AF"`
- Include `[keys]` with the canonical upstream values:
  - `prefix = "ctrl+a"`
  - `previous_agent = "prefix+alt+k"`
  - `next_agent = "prefix+alt+j"`
  - `focus_agent = "prefix+ctrl+1..9"`
- Ensure generated and checked-in Light and Dark variants preserve those `[ui]` and `[keys]` values exactly.
- Add an explicit managed activation operation for exactly `herdr 0.7.3`.
- Resolve the active configuration through the documented `HERDR_CONFIG_PATH` override or the XDG-derived Herdr configuration path; never hardcode a username or absolute home path.
- Back up an existing active configuration before any replacement or managed update.
- Use a same-target atomic update so a partial configuration is never exposed as the final active file.
- Preserve user-owned active configuration data in the backup rather than silently discarding it.
- Attempt the documented `herdr server reload-config` command only after a successful update and when reload applies.
- On a failed write or attempted reload, restore the backup and return an actionable error identifying the failed stage and recovery result.
- Add or adjust focused verification for static output, exact-version gating, path resolution, backup, atomic update, reload handling, and rollback.
- Fail closed when version, path, source variant, backup, write, reload, or restoration preconditions cannot be established safely.

### Non-goals

- Supporting Herdr versions other than exactly 0.7.3.
- Adding a Herdr dusk variant or any mode other than Light and Dark.
- Automatically detecting or choosing Light or Dark mode.
- Adding a scheduler, background daemon, broad process detection, or lifecycle framework.
- Building a general migration, adoption, repair, reconciliation, or configuration-merging system.
- Preserving unknown active-config fields in the newly activated file beyond retaining the complete prior file in the backup.
- Changing Hyprland, Ghostty, or any other theme target.
- Changing canonical Dreamcoder palette tokens or token guardrails.
- Making `[ui]` palette-driven or allowing Dreamcoder to customize `[keys]`.
- Changing unrelated Herdr behavior beyond the canonical `[ui]` and `[keys]` baseline.
- Modifying token, Fish startup, shell integration, or unrelated application configuration.
- Inferring undocumented validation, server discovery, reload, or compatibility behavior.
- Modifying any active target other than the single resolved Herdr configuration file and its directly associated backup/temporary file used by the managed operation.

## Business and Product Rules

- **Explicit authorization:** managed local Herdr activation is authorized only within this proposal's safety boundary.
- **Exact version gate:** activation proceeds only when `herdr --version` equals `herdr 0.7.3`; all other outputs fail closed without changing the active configuration.
- **Two variants only:** the user must explicitly select Dreamcoder Light or Dreamcoder Dark.
- **Narrow ownership:** palette-driven Dreamcoder values are confined to `[theme]` and `[theme.custom]`.
- **Canonical non-theme behavior:** `[ui]` and `[keys]` must match the canonical upstream values exactly in both variants.
- **No palette leakage:** Dreamcoder palette changes must not alter `[ui]` or `[keys]`.
- **Environment-derived target:** use the documented explicit config override when present; otherwise derive the target from XDG configuration variables. A user-specific absolute path must never be embedded in implementation.
- **Backup before mutation:** an existing active file must be copied to a distinct backup successfully before replacement begins. Backup failure leaves the active file untouched.
- **Atomic active update:** the complete selected configuration must be prepared before atomically replacing the resolved active target.
- **Bounded reload:** use only the documented `herdr server reload-config` command, after a successful update, and only when applicable. Do not invent server detection or alternate signals.
- **Transactional recovery:** a failed write or attempted reload is a failed activation. Restore the prior active configuration from backup and report both the original failure and whether restoration succeeded.
- **No collateral changes:** do not modify unrelated targets, canonical tokens, shell startup, or other user-owned files.
- **Actionable errors:** failures must identify the stage, target resolution without exposing unnecessary sensitive data, unchanged/restored state, and the user's next safe action.

## Affected Areas

Expected implementation impact is limited to Herdr static generation and the narrow activation path:

- `src/dreamcoder_theme/renderers_herdr.py`, only as needed to compose canonical non-theme sections with existing Light/Dark theme output.
- `DreamcoderHerdr/.config/herdr/dreamcoder/0.7.3/config.dark.toml`.
- `DreamcoderHerdr/.config/herdr/dreamcoder/0.7.3/config.light.toml`.
- The smallest existing theme-engine writer or activation entry point capable of implementing exact-version validation, XDG-aware target resolution, backup, atomic replacement, documented reload, and rollback.
- Focused Herdr renderer, writer, activation, or generated-artifact tests.

This list identifies likely implementation areas; it does not authorize changes to other targets or broad framework work.

### Protected unaffected areas

- Hyprland configuration and renderers.
- `DreamcoderGhostty/` and Ghostty renderer, writer, repair, or rollout behavior.
- Canonical Dreamcoder palette tokens and WCAG/APCA guardrails.
- Other application renderers, generated artifacts, and mode behavior.
- Token management.
- Fish startup and shell integration.
- Schedulers, wallpaper-derived mode selection, and general process management.
- Other OpenSpec changes and their artifacts.
- Any user-owned target other than the resolved active Herdr configuration and the backup/temporary file required for its transaction.

## Edge Cases and Boundaries

- If `herdr` is unavailable, version output differs in any way from `herdr 0.7.3`, or the version cannot be verified, activation fails before backup or mutation.
- If the requested mode is not exactly Light or Dark, activation fails without touching the active configuration.
- If `HERDR_CONFIG_PATH` is explicitly set, it is the managed target; otherwise the path is derived from XDG configuration variables and the standard XDG fallback. Empty, invalid, or unsafe path resolution fails closed.
- If no active configuration exists, implementation may create the selected configuration atomically, but must not claim that user data was backed up. A failed activation must remove only the newly created target when safe and report the resulting state.
- If an active configuration exists, a successful distinct backup is mandatory before mutation. The backup remains available after success so the prior user-owned file is preserved.
- Both variants contain identical canonical `[ui]` and `[keys]` values even though theme colors differ.
- The upstream `[ui].accent` remains `#6FA0AF`; it is not replaced with a Dreamcoder accent token.
- Existing rejection of modes other than `light` and `dark` remains intact.
- Reload is never attempted before the active file is successfully replaced. If reload is not applicable, the operation reports that it updated the file without claiming a live reload.
- If an attempted reload fails, the prior file is restored atomically where possible. The operation must not report success merely because the write succeeded.
- If restoration itself fails, the error is escalated clearly with the backup location and must not trigger edits to any other file.
- Additional fields, sections, versions, paths, or runtime behaviors require separate evidence and scope; they must not be guessed or generalized.

## Risks and Mitigations

- **User configuration loss:** replacing the active file could discard local data. Mitigation: require a successful backup before mutation and retain that backup after success.
- **Partial or corrupt active file:** an interrupted write could leave invalid TOML. Mitigation: prepare the complete file and use same-target atomic replacement.
- **Unsupported runtime behavior:** a similar Herdr version may behave differently. Mitigation: require the exact verified version string and fail closed otherwise.
- **Wrong target path:** hardcoded paths could modify another user's or environment's file. Mitigation: honor the documented override and derive defaults from XDG variables.
- **Write succeeds but runtime remains stale:** the active server may not observe the change. Mitigation: attempt only the documented reload when applicable and treat an attempted reload failure as activation failure.
- **Rollback fails:** permissions or filesystem errors may prevent restoration. Mitigation: retain the backup, report its location and restoration status, and avoid collateral repair attempts.
- **Theme ownership expands into behavior settings:** palette-driven generation could alter `[ui]` or `[keys]`. Mitigation: encode and test those sections as exact canonical upstream values.
- **Light and Dark drift:** one variant could preserve upstream behavior while the other diverges. Mitigation: assert identical canonical non-theme sections in both outputs.
- **Scope grows into orchestration:** activation work could expand into scheduling, mode inference, process management, or cross-target updates. Mitigation: keep selection explicit and all effects confined to one resolved Herdr target transaction.

## Rollback

### Repository rollback

- Restore the prior Herdr Light and Dark repository variants.
- Revert focused renderer composition and activation support introduced by this change.
- Do not alter other targets, canonical tokens, shell integration, or unrelated OpenSpec artifacts.

### Runtime rollback

- Before replacing an existing active configuration, retain a complete backup at a distinct path associated with the transaction.
- If writing the replacement fails, leave the original untouched when atomic replacement has not occurred; if replacement occurred before the failure was detected, restore the backup atomically.
- If an attempted `herdr server reload-config` fails, restore the backup atomically and return a failure that states whether restoration succeeded.
- After restoration, a reload may be attempted only through the same documented command and only when needed to return the runtime to the restored configuration; failure must be reported, not hidden or followed by broader repair.
- Never roll back or modify another target as compensation.
- On successful activation, retain the backup so the user-owned prior state remains recoverable; cleanup policy beyond this transaction is outside scope.

## Success Criteria

1. Exactly two Herdr variants are produced: Dreamcoder Light and Dreamcoder Dark.
2. Dreamcoder palette-driven differences are confined to `[theme]` and `[theme.custom]`.
3. Both variants include `[ui]` with `accent = "#6FA0AF"` exactly.
4. Both variants include `[keys]` with `prefix`, `previous_agent`, `next_agent`, and `focus_agent` exactly matching upstream.
5. `[ui]` and `[keys]` are identical between Light and Dark and are not derived from Dreamcoder palette tokens.
6. Modes other than Light and Dark remain rejected.
7. Managed activation makes no change unless `herdr --version` returns exactly `herdr 0.7.3`.
8. The active target is resolved from `HERDR_CONFIG_PATH` or XDG variables without a hardcoded user path.
9. An existing active configuration is backed up successfully before mutation, and the backup is retained after success.
10. The selected complete configuration is installed through an atomic update limited to the resolved Herdr target.
11. `herdr server reload-config` is attempted only after a successful update and only when applicable; no undocumented reload or process behavior is introduced.
12. A failed write or attempted reload returns an actionable error and restores the previous active configuration from backup; restoration failure is surfaced explicitly.
13. Focused tests or artifact checks cover static canonical sections, version gating, mode rejection, path resolution, backup-before-write, atomic replacement, reload handling, and rollback.
14. No Hyprland, Ghostty, token, Fish, scheduler, auto-detection, unrelated user-owned target, or other OpenSpec artifact is changed.
15. No general migration, adoption, repair, or lifecycle framework is introduced.
