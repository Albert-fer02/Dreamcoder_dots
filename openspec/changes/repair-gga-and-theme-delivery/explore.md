# Exploration: Global Gentle AI Remediation and Theme Delivery

## Status and scope

This exploration expands the change to the **entire global Gentle AI installation**, while preserving a strict separation from Dreamcoder Phase 1 delivery. It is documentation-led: no runtime configuration, binary, hook, project code, or unrelated artifact was modified.

The two ownership domains are:

- **Global Gentle AI installation:** managed by the Gentle AI installer/upgrade/sync lifecycle and its documented agent-specific repair routes.
- **Dreamcoder repository:** owns only the exact nine Phase 1 paths listed below; its dirty workspace and native review authority lock remain parent/maintainer concerns.

## Verified official lifecycle facts

The following facts are accepted from official Gentle AI commit `9c7bac8129e7936f414b25830ef591e173ed48ed` and must govern proposal/design work:

- `gentle-ai upgrade` refreshes managed binaries, including GGA.
- `gentle-ai sync` refreshes managed assets but **does not refresh binaries**.
- Pi is package-managed; the official stack/repair route is `gentle-ai install --agent pi`.

Current observed version/health facts:

- Gentle AI: `2.1.6`, latest reported.
- Engram: `1.19.0`, latest reported.
- GGA: latest `2.10.1`; installed version cannot be read because the installed v2.10.0 shell script is syntactically invalid.
- Doctor reports 11 agents installed and one duplicate OpenCode PATH warning.

These facts make `sync` insufficient for the GGA defect and prohibit treating a successful asset sync as binary repair. They also require Pi to be repaired through its package-managed install route rather than by copying files manually.

## Global installation inventory

The remediation must first produce a read-only inventory of the complete managed installation, including:

1. **Management identity:** Gentle AI version, executable path, installation root, package/installer provenance, update channel, and official commit/documentation version used as authority.
2. **Managed binaries:** every installed executable and version probe result, explicitly recording probe failure versus “not installed.” GGA must be syntax-checked before invoking `--version`; its current installed entrypoint is `/home/dreamcoder08/.local/bin/gga`, declares v2.10.0, and contains malformed Bash near the library-resolution guard.
3. **Managed assets:** paths and checksums for agent assets, templates, skills, configuration fragments, and generated metadata. `gentle-ai sync` belongs here and must not be presented as a binary refresh.
4. **Agents:** all 11 doctor-reported agents, their executable/package path, version, ownership (managed, package-managed, user-owned, or unknown), health result, and official repair command.
5. **Engram:** installed version/path and whether its managed state is current; current report is v1.19.0/latest.
6. **Pi:** package-managed status, package manager/source, installed package identity, and repair readiness for `gentle-ai install --agent pi`.
7. **OpenCode:** every PATH candidate and duplicate warning, with canonical owner and precedence. The duplicate warning is a discovery/ownership issue and must not be “fixed” by deleting a path during audit.
8. **GGA libraries:** `/home/dreamcoder08/.local/share/gga/lib` and the installed entrypoint’s required libraries (`providers.sh`, `cache.sh`, `pr_mode.sh`), with hashes and provenance. The repository checkout at `/home/dreamcoder08/Documents/PROYECTOS/gentleman-guardian-angel/bin/gga` is v2.6.1 and is evidence only, not a safe replacement for v2.10.1.
9. **Hooks and consumers:** identify references such as `.git/hooks/pre-commit.legacy`, but do not modify or reinstall hooks as part of global inventory.

The inventory must distinguish facts observed by commands from facts inferred from documentation, and must retain command output, exit status, timestamp, and environment relevant to reproducibility without exposing credentials.

## Official-conformance criteria

A conforming remediation must:

- Use `gentle-ai upgrade` for managed binary refresh, including GGA.
- Use `gentle-ai sync` only for managed asset refresh; never claim it repairs binaries.
- Use `gentle-ai install --agent pi` for the official Pi package-managed repair path.
- Preserve installer ownership and avoid manually copying binaries or mixing versions from unrelated checkouts.
- Confirm post-operation versions, syntax, paths, hashes/provenance, and doctor health.
- Treat an unavailable version probe as a failure requiring diagnosis, not as evidence of currency.
- Record the exact official documentation/commit authority and any deviation with maintainer approval.
- Keep OpenCode duplicate-path handling non-destructive until canonical ownership is proven.

## Safe ordered remediation plan

The order is intentionally conservative and reversible:

### Stage 0 — Freeze and audit

Run only read-only checks. Capture global inventory, `gentle-ai doctor`, version probes, PATH resolution, file ownership, hashes, package metadata, and current repository status. Snapshot/hash any managed target that may be replaced. Do not run repair commands yet.

### Stage 1 — Refresh managed binaries

Run the documented `gentle-ai upgrade`. This is the authoritative route for Gentle AI-managed binaries and GGA. Re-inventory all binaries, syntax-check GGA, and verify GGA version/help and required library resolution. If upgrade cannot complete, stop; do not substitute the v2.6.1 checkout.

### Stage 2 — Refresh managed assets

Run `gentle-ai sync` only after the binary lifecycle is healthy, or independently if the audit proves assets are stale. Record that this stage cannot repair binaries. Compare asset manifests/hashes before and after.

### Stage 3 — Repair Pi through package management

If Pi is unhealthy or missing, use exactly `gentle-ai install --agent pi`. Re-run package/version/health checks and record package ownership. Do not manually copy Pi files or classify a generic sync as Pi repair.

### Stage 4 — Reconcile agent health and PATH warnings

Re-run doctor and the complete 11-agent inventory. Investigate the duplicate OpenCode PATH warning by identifying owners and precedence. No deletion, unlinking, PATH rewrite, or hook change is permitted without a separate approved work unit and evidence of ownership.

### Stage 5 — Global acceptance

Require all managed binaries to have valid probes, GGA to pass syntax and non-destructive invocation checks, Pi to be package-managed and healthy, assets to match their managed manifest, and doctor to show no unexplained agent failure. The duplicate OpenCode warning may remain an explicitly documented follow-up if it is non-blocking and ownership is unresolved.

## Evidence, rollback, and failure boundaries

Each stage is independently receipted:

- **Audit boundary:** read-only; rollback is none. Restore no files.
- **Binary boundary:** only files proven managed by `gentle-ai upgrade`; rollback uses captured package/version provenance or the official downgrade/reinstall route, never an ad hoc copy.
- **Asset boundary:** only files owned by `gentle-ai sync`; rollback uses the pre-sync manifest or official asset restore route.
- **Pi boundary:** only the package-managed Pi installation; rollback uses the package manager/official install route.
- **OpenCode boundary:** no mutation during this change unless a later proposal explicitly scopes it; rollback is therefore not applicable to the audit.
- **GGA consumer boundary:** repository hooks remain unchanged; a GGA executable repair must be independently reversible from hook behavior.

For every mutating stage record: exact command, target paths, pre/post hashes, versions, exit status, doctor output, and restoration command. Stop on partial failure, ownership ambiguity, unexpected path changes, or new agent failures. Never “repair forward” over an unexamined partial result.

## Non-destructive audit requirements

The audit must not:

- source or execute the syntactically invalid GGA script beyond safe syntax diagnostics;
- edit global config, PATH files, shell startup files, package databases, hooks, or agent files;
- delete duplicate OpenCode entries;
- stage, reset, clean, stash, or otherwise alter the Dreamcoder repository;
- expose tokens, credentials, provider configuration secrets, or unrelated user data.

Use isolated temporary directories only for probes that need a writable workspace. Any environment overrides must be recorded and removed after the probe.

## Dreamcoder Phase 1 delivery boundary

Phase 1 remains exactly these nine repository paths:

- `.github/workflows/theme-validation.yml`
- `DreamcoderThemes/dreamcoder/tokens.json`
- `DreamcoderThemes/dreamcoder/tokens.schema.json`
- `docs/DREAMCODER_DESIGN_SYSTEM.md`
- `scripts/apply-theme-mode.sh`
- `scripts/verify-theme-health.py`
- `src/dreamcoder_theme/palette_tokens.py`
- `tests/test_token_parity.py`
- `tests/test_theme_health.py`

Health checks currently pass, but evidence must still be scoped to this manifest, with commands, environment, token/schema/parity results, and generated/static synchronization recorded. Do not infer scope from the 93 dirty paths. Do not include global Gentle AI files, hooks, native review artifacts, or unrelated generated/deleted paths in the Phase 1 delivery.

## Existing dirty workspace and review-lock ownership

The Dreamcoder workspace is reported dirty across 93 paths. Existing modifications, deletions, and generated files belong to their pre-existing owners. The SDD executor and global remediation owner must not clean, reset, stage, or reinterpret them.

Ordinary native review is blocked because unrelated correction-required review lineages hold the authority lock. This is owned by the parent/orchestrator or repository maintainer and must be handled through the native authority process. No agent may edit, reconcile, invalidate, bypass, or delete those lineages as part of global remediation or Phase 1 preparation. A later gate may validate only the exact intended Phase 1 content-bound receipt.

## Work units and rollback story

1. **Global audit:** read-only inventory and baseline receipt.
2. **Managed binary refresh:** `gentle-ai upgrade`, including GGA; independently reversible.
3. **Managed asset refresh:** `gentle-ai sync`; separate because it does not refresh binaries.
4. **Pi package repair:** `gentle-ai install --agent pi`; separate ownership and rollback.
5. **OpenCode warning investigation:** audit-only follow-up unless separately approved.
6. **Dreamcoder Phase 1 delivery:** exactly nine paths, with health/parity evidence.
7. **Native review/gate handling:** parent-owned, after implementation; never mixed into global installation repair.

Each work unit must contain focused verification, runtime or explicit N/A evidence, exact rollback boundary, and no unrelated path changes.

## Risks

- **Critical:** binary/asset lifecycle confusion could leave GGA broken while reporting a successful sync.
- **Critical:** manually replacing managed agents or Pi could destroy package ownership and future upgradeability.
- **High:** global remediation could accidentally modify hooks, shell startup, PATH precedence, or user configuration.
- **High:** changing unrelated native review lineages could corrupt authority and provenance.
- **High:** the 93-path dirty workspace can contaminate Phase 1 evidence and receipts.
- **Medium:** duplicate OpenCode PATH entries may have different owners; deletion without provenance is unsafe.
- **Medium:** health success alone does not prove token/generated parity or clean delivery scope.

## Next recommendation

Proceed to proposal planning. The proposal should define the read-only inventory schema, official command sequence, stop conditions, per-stage receipts and rollback, the nine-path Phase 1 evidence manifest, and explicit escalation to the parent for the existing review lock. Implementation must not begin from exploration alone.
