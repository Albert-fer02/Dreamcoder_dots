# Design: Failure-Safe Global Remediation and Nine-Path Theme Delivery

## Decision summary

Execution is a sequence of sealed, independently reversible work units. No mutating stage may start until the preceding receipt is sealed, target ownership is proven, an owner-supported rollback is recorded, and all stage preconditions pass.

Two domains remain strictly separate:

| Domain              | Mutable targets                                                                     | Evidence scope                                               | Delivery scope     |
| ------------------- | ----------------------------------------------------------------------------------- | ------------------------------------------------------------ | ------------------ |
| Global installation | Only targets owned by the exact official lifecycle command authorized for the stage | External evidence directory, never the Dreamcoder repository | Never committed    |
| Dreamcoder Phase 1  | Exactly the nine approved paths                                                     | Isolated synthetic Git tree and content-bound receipt        | Exactly nine paths |

This design authorizes four known global mutation routes: preferred managed-binary refresh through `gentle-ai upgrade`; narrowly conditional GGA recovery through `gentle-ai install --component gga` only when both the sealed existing GGA syntax/probe is invalid and the sealed official `gentle-ai update`/upgrade-checker result reports GGA version unknown or cannot establish GGA health, with every remaining `GGA-R0` prerequisite passing; `gentle-ai sync`; and, conditionally, `gentle-ai install --agent pi`. An OpenCode mutation is not authorized until its owner, official resolution command, exact rollback, and separate approval are recorded. No other fallback, manual binary copy, ad hoc `PATH` edit, hook mutation, native-review mutation, repository cleanup, or repair-forward action is permitted.

No command in this document has been executed by the design phase.

## Official authority and provenance policy

### Pinned authorities

| Subject                 | Official source                                                                                                                                                                                                                                   | Immutable source identity                                              | Design use                                                                                                                              |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| Gentle AI lifecycle     | [Gentle AI official repository at authority commit](https://github.com/Gentleman-Programming/gentle-ai/commit/9c7bac8129e7936f414b25830ef591e173ed48ed)                                                                                           | `9c7bac8129e7936f414b25830ef591e173ed48ed`                             | Governs `upgrade`, `sync`, Pi installation, doctor, and managed ownership expectations                                                  |
| GGA upstream            | [Official GGA repository](https://github.com/Gentleman-Programming/gentleman-guardian-angel)                                                                                                                                                      | Must be resolved to a full 40-hex commit for `v2.10.1` before mutation | Provenance comparison only; it is not a replacement source                                                                              |
| GGA v2.10.1 release/tag | [Official v2.10.1 release](https://github.com/Gentleman-Programming/gentleman-guardian-angel/releases/tag/v2.10.1) and [README at v2.10.1](https://github.com/Gentleman-Programming/gentleman-guardian-angel/blob/v2.10.1/README.md#installation) | Resolve and record the tag's full commit before relying on it          | Documents upstream Homebrew-preferred and clone-plus-`install.sh` routes; neither is an authorized fallback for a Gentle-AI-managed GGA |

The supplied research states that the official GGA repository advertises v2.10.1. A full v2.10.1 source commit was not supplied to this phase, so this design deliberately does not invent one. Stage 0 must resolve it from the official remote and seal it as documentation-derived evidence:

```bash
git ls-remote --tags https://github.com/Gentleman-Programming/gentleman-guardian-angel.git \
  'refs/tags/v2.10.1' 'refs/tags/v2.10.1^{}'
```

For an annotated tag, the peeled `^{}` value is the source commit; for a lightweight tag, the direct value is the source commit. The accepted value must be exactly 40 lowercase hexadecimal characters. The executor must then use a commit-pinned URL of the form:

`https://github.com/Gentleman-Programming/gentleman-guardian-angel/blob/<FULL_COMMIT>/README.md`

Failure to resolve one unambiguous official commit is a provenance blocker. The local v2.6.1 checkout may be hashed and cited as contrary evidence, but must never supply an executable or library.

### Claim classification

Every claim carries one of these classes:

- `observed`: produced by a sealed command record in the current run.
- `official-expectation`: supported by a commit-pinned official URL and full source commit.
- `derived`: computed from identified observed records, with the derivation named.
- `unknown`: evidence is missing, conflicting, or unsafe to obtain.

An `official-expectation` never substitutes for an observed postcondition. An `unknown` required field blocks the owning stage.

## Immutable evidence model

### Storage and sealing

Evidence is written outside the repository and outside all managed installation roots, for example:

`${XDG_STATE_HOME:-$HOME/.local/state}/gentle-ai-remediation/<UTC_RUN_ID>/`

The directory is created with `umask 077`. It contains no credentials, provider configuration, shell startup content, or unrelated user data.

```text
<run>/
  run.json
  records/000001.json ...
  blobs/sha256/<digest>
  snapshots/<stage>/<target-id>.json
  receipts/<stage>.json
  manifests/phase1-nine-paths.json
  seal.json
```

Records are append-only. A correction creates a new record with `supersedes_record_id`; it never edits prior evidence. Each record includes `previous_record_sha256`, producing a hash chain. A stage receipt names every record and blob digest, its preconditions, postconditions, stop decision, and rollback evidence. `seal.json` contains the final manifest digest. After sealing, files are made non-writable; this is tamper evidence, not a claim of filesystem immutability. A changed digest invalidates the run.

### Record schema

```json
{
  "schema_version": "1.0",
  "run_id": "UTC timestamp plus random identifier",
  "record_id": "monotonic six-digit id",
  "previous_record_sha256": "sha256 or null",
  "domain": "global|phase1|native-review",
  "stage": "S0|S1|S2|S3|S4|S5|S6|S7",
  "work_unit": "stable work-unit name",
  "claim_class": "observed|official-expectation|derived|unknown",
  "started_at_utc": "RFC3339 with fractional seconds",
  "finished_at_utc": "RFC3339 with fractional seconds",
  "cwd_identity": { "logical": "sanitized", "physical_sha256": "digest" },
  "command": {
    "argv": ["tokens, not shell text"],
    "executable_realpath": "path",
    "executable_sha256": "digest"
  },
  "environment": {
    "allowlisted": {},
    "path_entries": [],
    "redacted_keys": [],
    "sha256": "digest"
  },
  "exit": { "code": 0, "signal": null, "timed_out": false },
  "stdout": { "blob_sha256": "digest", "redactions": [] },
  "stderr": { "blob_sha256": "digest", "redactions": [] },
  "targets_before": [],
  "targets_after": [],
  "ownership": [],
  "provenance": [{ "url": "commit-pinned official URL", "commit": "40 hex" }],
  "expectation": "machine-checkable statement",
  "result": "pass|fail|blocked|not-applicable",
  "stop_reason": null,
  "supersedes_record_id": null
}
```

A target snapshot contains logical path, canonical path, file type, symlink target, mode, size, owner/group IDs, SHA-256 for regular files, package identity when available, installer identity, and whether the path lies inside the proven ownership root. Directory snapshots are sorted path/hash manifests rather than archive copies. Captured output is redacted before persistence; both the redaction rules and redacted blob digest are recorded. Raw secret-bearing output is never retained.

### Environment sanitization

Commands use an explicit allowlist: `HOME` only when necessary, `PATH` as a captured ordered list, locale fixed to `LC_ALL=C`, and stage-specific temporary `TMPDIR`, `XDG_CACHE_HOME`, `XDG_CONFIG_HOME`, and `XDG_STATE_HOME`. Variables matching token, key, secret, credential, auth, provider, or session patterns are omitted. The executor must not run `env` or dump complete configuration.

## Isolated probe strategy

Each probe receives a private `0700` temporary directory outside the repository and managed roots. Non-destructive commands use a fixed timeout, stdin from `/dev/null`, and temporary XDG directories when doing so does not invalidate the probe. The real `HOME` is exposed only to discovery commands that require installed-user resolution; its content is never enumerated broadly.

Probe rules:

1. Resolve and hash the executable before invocation.
2. For a shell entrypoint, run `bash -n <path>` before any invocation. Do not source it.
3. Run only documented non-destructive forms such as version, help, doctor, or package metadata queries.
4. Capture before/after manifests for the probe directory and all declared targets.
5. If any undeclared target changes, mark the probe failed and stop the stage.
6. Preserve the probe directory as a sealed blob on failure. On success, preserve its manifest and remove it with a safe, scoped cleanup tool; never use an unbounded recursive deletion.
7. Network access is disabled for probes unless the command's official behavior requires it. Network-dependent lifecycle commands record requested hosts and observed transport result without capturing credentials.

The malformed installed GGA entrypoint is never sourced or invoked until `bash -n` passes. Library checks parse its declared library paths and hash the expected files; they do not source those libraries. Runtime `gga version` and `gga --help`/documented help are allowed only after syntax, path ownership, and library provenance pass.

## Stage machine

```text
S0 baseline
  -> S1 managed binary upgrade
  -> S2 managed asset sync
  -> S3 conditional Pi repair
  -> S4 OpenCode ownership resolution
  -> S5 all-agent reconciliation
  -> S6 isolated nine-path validation
  -> S7 native review/delivery gate
```

A stage can be `pending`, `running`, `passed`, `blocked`, `failed-partial`, `rollback-pending`, `rolled-back`, or `escalated`. Only `passed` permits the next stage. `failed-partial` can transition only to `rollback-pending` or `escalated`; it cannot transition directly to retry or the next stage.

## Stage S0 — Read-only baseline and provenance freeze

### Preconditions

- Evidence root is outside the repository and all managed roots.
- Official Gentle AI authority commit is exactly `9c7bac8129e7936f414b25830ef591e173ed48ed`.
- No target mutation command is queued.
- Repository status and native authority are observations only.

### Command plan

Commands are run separately and individually receipted; the shown shell forms describe arguments, not permission to combine unsafe pipelines.

```bash
command -v gentle-ai
type -a gentle-ai
gentle-ai version
gentle-ai --help
gentle-ai doctor
gentle-ai update                         # only after pinned authority proves this is the read-only upgrade checker; otherwise use the exact pinned checker argv
command -v engram
type -a engram
engram --version
command -v gga
type -a gga
bash -n "$(command -v gga)"            # no GGA invocation if this fails
command -v pi
type -a pi
command -v opencode
type -a opencode
```

For every resolved executable, run read-only canonicalization and identity probes (`readlink`, `stat`, `sha256sum`) as available. Enumerate all command candidates from the captured `PATH` without executing them. Query ownership through applicable read-only adapters:

- Homebrew: `brew list --versions`, `brew info --json=v2 <formula>`, `brew --prefix <formula>`.
- Debian: `dpkg-query -S <path>` and `dpkg-query -W <package>`.
- RPM: `rpm -qf <path>` and `rpm -qi <package>`.
- Arch: `pacman -Qo <path>` and `pacman -Qi <package>`.
- npm/pnpm/bun: read-only global root/list commands and package manifests, only when the executable resolves into that manager's root.
- Gentle AI installer: installed manifests/checksums exposed by the commit-pinned CLI or installation metadata; do not infer ownership solely from location.

Unsupported or conflicting adapters produce `unknown`, not a guess. Capture `git status --porcelain=v2 -z` for repository boundary evidence only; do not stage, reset, clean, stash, checkout, or update the index. Capture native review status only through the read-only native facade. Do not run review start/finalize/reconcile operations.

Resolve the official GGA v2.10.1 tag commit using the official remote command above. Record the installed GGA entrypoint and the expected managed library files (`providers.sh`, `cache.sh`, and `pr_mode.sh`) only after confirming those names from the installed entrypoint and official commit-pinned source.

### Global configuration and asset conformance matrix

S0 must build a complete matrix from the union of the official expected inventory and every installed item under each proven Gentle AI managed root. A category summary is not sufficient: the sealed evidence contains one row per regular file, directory contract, or symlink. Recursive enumeration does not follow symlinks, sorts by repository-relative byte path under `LC_ALL=C`, includes dotfiles, and rejects escaping paths, special devices, sockets, and ownership-root overlaps.

The official side is derived without executing repository code. In an isolated temporary probe, fetch only the pinned Gentle AI authority commit and verify the fetched object before reading it:

```bash
git init "$probe/gentle-ai-authority"
git -C "$probe/gentle-ai-authority" remote add origin \
  https://github.com/Gentleman-Programming/gentle-ai.git
git -C "$probe/gentle-ai-authority" fetch --depth 1 origin \
  9c7bac8129e7936f414b25830ef591e173ed48ed
git -C "$probe/gentle-ai-authority" rev-parse --verify FETCH_HEAD
git -C "$probe/gentle-ai-authority" checkout --detach \
  9c7bac8129e7936f414b25830ef591e173ed48ed
```

`rev-parse` must equal the full authority commit exactly. The executor then reads the commit's installer/sync manifests, templates, generators, checksum declarations, and configuration mappings. It records, for every expected item, a commit-pinned source locator of the form `https://github.com/Gentleman-Programming/gentle-ai/blob/9c7bac8129e7936f414b25830ef591e173ed48ed/<source-path>` plus source blob ID and SHA-256. If the authority source does not provide enough information to enumerate or render an item deterministically, that item is `unknown-expectation` and blocks S0; executor inference is prohibited.

| Matrix class               | Items that must be enumerated                                                                                                                                                | Commit-pinned expectation                                                                                                              | Deterministic comparison                                                                                                                                                                                                                                                    |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Managed asset payloads     | Agent-facing rules, prompts, support files, static resources, and any other sync-owned payload                                                                               | Exact source blob or manifest entry at the authority commit; destination mapping and owner must come from pinned installer/sync source | Destination path, type, owner boundary, mode, symlink target, size, and SHA-256 must match exactly unless a pinned transformation rule applies                                                                                                                              |
| Templates                  | Every global or per-agent template distributed by Gentle AI                                                                                                                  | Template blob, destination pattern, render inputs, and render implementation at the authority commit                                   | Render in the isolated probe using only recorded non-secret installation variables; compare rendered bytes, mode, and destination. Missing render input or undocumented normalization is blocking                                                                           |
| Skills                     | Skill directories, every `SKILL.md`, and all skill-owned supporting files installed or synchronized by Gentle AI                                                             | Skill source tree and destination mapping at the authority commit                                                                      | Sorted relative path set, file type, mode, symlink target, and SHA-256 set equality. Extra nested files are drift, not implicitly user-owned                                                                                                                                |
| Configuration fragments    | Only installer/sync-owned fragments, includes, defaults, and generated snippets; user-owned configuration is represented as an excluded ownership boundary, not read broadly | Fragment/template blob, insertion/destination contract, merge rule, and ownership marker from commit-pinned source                     | Exact bytes for static fragments; deterministic rendering for templated fragments; structured comparison only when the pinned implementation explicitly defines semantic ordering. Secret-bearing values are represented by presence/type or salted digest, never persisted |
| Generated metadata         | Registries, indexes, caches declared durable, agent descriptors, generated inventories, and version metadata owned by sync                                                   | Generator source, input set, output path, schema/version, and invocation contract at the authority commit                              | Generate only inside the isolated probe from sealed inputs. Compare exact bytes unless pinned code explicitly declares nondeterministic fields; allowed fields are removed by an item-specific recorded rule before canonical comparison                                    |
| Manifests                  | Install/sync ownership manifests, file lists, package maps, and lifecycle state used to define managed scope                                                                 | Manifest source/schema and generation rule at the authority commit                                                                     | Parse with the declared schema; require unique normalized paths, sorted-set equality with actual managed inventory, valid owner class, and no path escaping or overlap                                                                                                      |
| Checksums                  | Distributed checksum files and checksums embedded in manifests/metadata                                                                                                      | Checksum algorithm, expected digest, covered path, and source declaration at the authority commit                                      | Require supported algorithm, one unambiguous target, digest match, and complete coverage. A checksum cannot validate itself or an out-of-root target                                                                                                                        |
| Directory contracts        | Empty required directories and managed roots whose existence/mode is lifecycle-owned                                                                                         | Directory declaration or destination parent implied unambiguously by pinned source                                                     | Existence, directory type, owner boundary, and required mode; directory content is validated through the individual child rows                                                                                                                                              |
| Symlinks/launch references | Asset/config symlinks owned by sync; executable links remain in the binary matrix                                                                                            | Link declaration and destination mapping at the authority commit                                                                       | Link text and resolved target must both match, remain inside the declared owner boundary, and terminate at an independently conforming row                                                                                                                                  |

Each concrete matrix row uses this schema:

```json
{
  "item_id": "sha256(class + managed-root-id + normalized-relative-path)",
  "class": "asset|template|skill|config-fragment|generated-metadata|manifest|checksum|directory|symlink",
  "managed_root_id": "proven owner root",
  "relative_path": "normalized nonescaping path",
  "installed_identity": {
    "type": "file",
    "mode": "octal",
    "sha256": "digest",
    "owner": "owner-id"
  },
  "official_expectation": {
    "authority_commit": "9c7bac8129e7936f414b25830ef591e173ed48ed",
    "source_url": "commit-pinned official URL",
    "source_blob": "full Git object id",
    "destination_rule": "pinned source locator",
    "transform_rule": "none or pinned source locator",
    "expected_identity_sha256": "digest"
  },
  "comparison": "exact-bytes|rendered-bytes|declared-structured|path-set|link-target|directory-contract",
  "status": "exact-match|allowed-declared-variant|sync-required|missing|unexpected-extra|modified|ownership-conflict|unknown-expectation",
  "reason_records": ["record ids"]
}
```

Comparison rules are fixed:

1. Normalize paths lexically; reject absolute destinations, `..`, NUL, duplicate normalized names, case-collision on the target filesystem, and symlink escape.
2. Compare the set union `E ∪ I`, where `E` is every commit-pinned expected destination and `I` is every installed child under proven managed roots. This guarantees missing and unexpected installed items receive rows.
3. Static files and templates after official rendering are byte-exact. Do not normalize whitespace, line endings, comments, key order, timestamps, or permissions unless the exact pinned lifecycle implementation declares that transformation.
4. Structured comparison is allowed only when the pinned implementation defines the schema and semantic normalization. Record the parser version and canonicalization rule; parse failure blocks.
5. A variant is allowed only when a commit-pinned rule names the field/path and allowed values. Local convention, apparent harmlessness, or doctor success never creates an allowlist.
6. User-owned material is excluded only when ownership evidence proves a non-overlapping boundary before enumeration. An extra item inside a sync-owned root is `unexpected-extra`, not user-owned by assumption.
7. In S0, `sync-required` is permitted only for a fully explained `missing` or `modified` row whose expected destination, source, transform, owner, and rollback are all known and whose correction is explicitly attributable to `gentle-ai sync`. `unexpected-extra`, `ownership-conflict`, and `unknown-expectation` always block S0.
8. In S2, no drift status is permitted: every row must be `exact-match` or `allowed-declared-variant`. Any remaining missing, modified, extra, ownership conflict, unknown item, manifest mismatch, or uncovered checksum blocks S2 and all later stages.
9. Aggregate counts and a matrix digest are derived from concrete rows. Counts never replace row-level evidence.

### Postconditions

- Gentle AI, Engram, GGA, Pi, OpenCode candidates, managed binaries, hooks/consumers, and exactly 11 doctor-reported agents each have a stable inventory ID.
- Every managed asset, template, skill, configuration fragment, generated metadata item, manifest, checksum, directory contract, and symlink has one concrete conformance row mapped to the full authority commit and a commit-pinned official URL.
- The expected/installed union is complete; every installed item under a managed root is either matched to an official expectation or blocks S0 as unexplained drift/unknown ownership.
- Matrix statuses are limited to `exact-match`, commit-pinned `allowed-declared-variant`, or fully explained `sync-required`; `unexpected-extra`, `ownership-conflict`, `unknown-expectation`, ambiguous transformation, and incomplete checksum coverage block S0.
- Probe failure is distinct from absence.
- Every future mutation target has a pre-hash/package identity and owner, or its stage is blocked.
- Every mutating stage has an exact owner-supported restoration command sourced from pinned official documentation. If Gentle AI does not document a compatible downgrade/reinstall route for the observed installation channel, S1 is blocked before mutation.
- GGA v2.10.1 has one full official source commit or S1 is blocked.
- When the GGA syntax/probe is invalid, S0 also seals a separate official `gentle-ai update`/upgrade-checker record. Only checker status `gga-version-unknown` or `gga-health-unestablished` can satisfy the second `GGA-R0` eligibility operand; a missing, ambiguous, conflicting, mutating, or health-establishing checker result blocks recovery.
- Hook file identities and native authority identity are sealed as no-change sentinels.

## Stage S1 — Gentle-AI-managed binary refresh

### Authorization

The preferred managed-binary mutation is:

```bash
gentle-ai upgrade
```

When and only when S0 seals both (a) an invalid existing managed GGA syntax/probe because syntax, version invocation, or required-library resolution cannot safely complete and (b) an independent official `gentle-ai update`/upgrade-checker result that reports GGA version `unknown` or cannot establish GGA health, the separate `GGA-R0` gate may authorize this official component recovery command:

```bash
gentle-ai install --component gga
```

The branches are mutually exclusive within one sealed run. A valid existing GGA probe requires the preferred upgrade branch. An invalid probe by itself does not authorize recovery: without the matching sealed checker result, the run is blocked. Only the conjunction of invalid probe and checker-reported unknown version/unestablished health may enter the conditional component-recovery branch; after recovery it must seal evidence and restart at S0 before the preferred full upgrade can run. Both routes are governed by the [pinned Gentle AI authority commit](https://github.com/Gentleman-Programming/gentle-ai/commit/9c7bac8129e7936f414b25830ef591e173ed48ed). Upstream GGA Homebrew and clone-plus-`install.sh` routes remain unauthorized because baseline ownership is Gentle-AI-managed.

### Preconditions

- S0 passed and is sealed.
- The invoked `gentle-ai` realpath/hash matches S0.
- All expected mutation roots are known and contain no hooks, repository paths, shell startup files, or native review state.
- Exact official rollback/reinstall procedure for the detected channel is recorded and scope-checked.
- GGA's expected v2.10.1 commit is resolved.

### Conditional GGA recovery decision gate

Gate `GGA-R0` is eligible only when `invalid_probe AND checker_unknown_or_unhealthy` is true in the same sealed S0 run. A malformed or otherwise invalid existing GGA syntax/probe is necessary but not sufficient. The independent official `gentle-ai update`/upgrade-checker must also report that GGA's version is unknown or that it cannot establish GGA health. Staleness alone is insufficient when syntax, supported version probe, and required-library resolution are valid; that case uses preferred `gentle-ai upgrade`. A checker result that establishes a known version and health, disagrees with the invalid-probe record, is unavailable, is stale, is ambiguous, or cannot be proven read-only blocks `GGA-R0` for investigation; it does not resolve the conflict by choosing either observation. `GGA-R0` is narrowly scoped permission for the Gentle AI manager to reinstall only its owned GGA component through `gentle-ai install --component gga`. Direct Homebrew installation, clone-plus-`install.sh`, downloaded scripts, every other installer/component fallback, manual file/symlink copies, `PATH` edits, hook changes, and native review changes remain prohibited.

#### Dual-evidence eligibility records

Before the component dry-run, seal two separately executed records and one derived decision record:

```json
{
  "gga_r0_eligibility": {
    "probe_record_id": "record with bash syntax, supported version probe, and required-library resolution",
    "probe_status": "invalid",
    "probe_failure": "syntax|version-unavailable|library-resolution",
    "checker_record_id": "independent official checker record",
    "checker_argv": ["gentle-ai", "update"],
    "checker_contract_source": "commit-pinned URL proving read-only checker semantics and output parser",
    "checker_status": "gga-version-unknown|gga-health-unestablished",
    "same_run": true,
    "pre_mutation_sentinel_digest": "digest",
    "decision": "eligible|blocked"
  }
}
```

The checker record must identify executable realpath/hash, exact argv, pinned checker contract/parser, timestamp, sanitized environment, exit status, stdout/stderr digests, parsed GGA row, and before/after sentinel digests. Use `gentle-ai update` only if authority commit `9c7bac8129e7936f414b25830ef591e173ed48ed` proves that exact invocation is the non-mutating upgrade checker. If the pinned CLI names another checker argv, record and use that exact argv instead. If no official read-only checker can be established, do not run a possibly mutating `update`; seal `checker_status=unknown` and block `GGA-R0`.

Eligibility is deterministic: `eligible = (probe_status == invalid) AND (checker_status IN {gga-version-unknown, gga-health-unestablished}) AND same_run AND sentinels_unchanged`. Any missing record, unsupported failure category, checker success that establishes version/health, parse ambiguity, cross-run evidence, output disagreement, or sentinel change yields `decision=blocked`. The derived record names both immutable record IDs; neither observation may be inferred from the other or replaced by doctor output.

#### Dry-run requirement

Before mutation, the executor must prove from the pinned Gentle AI CLI help/source that the installed manager supports the exact non-mutating preview form:

```bash
gentle-ai install --component gga --dry-run
```

Run it once with the same resolved `gentle-ai` executable, captured `PATH`, installation channel, and non-secret environment that will be used for the real component recovery. Do not guess an equivalent flag, pipe output into a shell, add `sudo`, use `--force`, or substitute another installer. If the pinned authority does not document this exact dry-run form, if the installed manager does not support it, or if the preview itself mutates a sentinel, `GGA-R0` is `blocked` and no recovery command runs.

The dry-run record must have exit code 0 and expose a complete machine-readable plan, or output whose parser and extraction rules are pinned to authority commit `9c7bac8129e7936f414b25830ef591e173ed48ed`. Human interpretation of free-form output is not sufficient to establish target scope.

#### Acceptable installer ownership evidence

All of the following evidence is required:

1. The invoked `gentle-ai` realpath, SHA-256, version, installation root, channel, and package/installer receipt match S0.
2. A commit-pinned Gentle AI manifest or installer mapping identifies GGA as managed by that installation and maps the GGA entrypoint plus each required library to destinations under one proven managed root.
3. Filesystem/package ownership agrees with that mapping. Location under `$HOME/.local` alone is not ownership proof.
4. The dry-run identifies the official source artifact/version and full source commit for the replacement GGA, and that identity agrees with the sealed v2.10.1 provenance record.
5. No competing package manager claims the same targets. Conflicting Homebrew, OS-package, npm-family, user, or unknown ownership blocks the gate.
6. The unrelated v2.6.1 checkout is absent from the source, target, temporary, and library-resolution plan.

#### Exact target extraction

Parse the dry-run into a sorted `gga-recovery-targets.json` before mutation. Every planned create, replace, relink, chmod, rename, or remove operation is a separate row:

```json
{
  "operation": "replace|create|remove|relink|chmod|rename",
  "logical_path": "absolute normalized path",
  "canonical_path_before": "path or null",
  "canonical_path_after": "planned path or null",
  "owner_root_id": "sealed managed root",
  "component": "gga-entrypoint|gga-library",
  "source_artifact": "official artifact identity",
  "source_commit": "full 40-hex commit",
  "expected_post_sha256": "digest or null with pinned derivation",
  "expected_mode": "octal",
  "rollback_action_id": "preapproved owner-supported action"
}
```

The extracted target set is acceptable only when:

- every path is absolute after normalization, remains inside exactly one proven binary ownership root, and has no symlink or parent-directory escape;
- every existing target has canonical path, type, mode, owner/group IDs, symlink text, SHA-256, package identity, and installer identity;
- every new target has a commit-pinned destination rule and expected post-identity;
- every remove/rename/relink operation names both old and new identities and has an owner-supported inverse;
- all GGA entrypoint and required library targets are present, with no unexplained target;
- no non-GGA target is present; every non-GGA managed binary is a must-not-change sentinel;
- no asset/configuration matrix path, Pi package path, OpenCode owner path, repository path, hook, shell startup file, credential/provider path, or native authority path appears.

A dry-run that omits target paths, uses globs that cannot be expanded read-only, reports an unknown operation, lacks source identity, or disagrees with S0 is blocked. The target-set digest becomes an execution sentinel; the real command may not broaden it.

#### Snapshot, backup, and rollback gate

For every extracted existing target, capture the normal immutable target snapshot plus a byte-preserving, read-only backup in the sealed external evidence root. The backup includes file bytes, link text without dereferencing, mode, owner/group IDs, timestamps needed for comparison, package/installer metadata, and a SHA-256 manifest. The evidence backup must not include credentials or unrelated directories and must not be placed in a managed root or repository.

The backup is forensic and may be consumed for restoration only when the pinned official installer explicitly supports that backup format. It is never authorization to copy old binaries or libraries back manually.

Before mutation, each target row must map to an exact rollback action documented by the pinned owner, including command argv, version/artifact identity restored, affected paths, preconditions, expected post-state, and whether it can recover a partially completed component installation. The rollback action must preserve installer/package ownership and may not use ad hoc `cp`, `mv`, symlink creation, direct archive extraction, direct package-database edits, or source from the v2.6.1 checkout. If the installer supports only full managed-binary rollback, that complete rollback target set must be extracted and sentinel-checked with the same rules.

Missing target identity, incomplete backup, absent official rollback, rollback broader than the proven owner boundary, or rollback that cannot address the previewed failure modes makes `GGA-R0` blocked. A backup alone is not rollback support.

#### Pre/post sentinels

Seal these sentinels immediately before the dry-run, confirm they are unchanged immediately after the dry-run, and capture them again immediately before and after the real component recovery:

- ordered `PATH` value, all `type -a` candidate identities, and OpenCode precedence;
- complete hook path/type/mode/hash manifest without reading secret content;
- shell startup path/type/mode/hash manifest without recording content;
- repository HEAD, real index checksum, and `git status --porcelain=v2 -z` digest;
- native review authority/status identity obtained only through the native read-only facade;
- S0 configuration/asset conformance matrix digest and every managed asset root digest;
- Pi and Engram package/executable identities;
- all GGA targets as the previewed-change set and every non-GGA managed binary as the must-not-change set;
- credential/provider directories as path/type/mode metadata only, without content enumeration.

A dry-run sentinel change is a failed mutation despite its label and stops execution. After the real component recovery, any changed must-not-change sentinel or any changed path absent from `gga-recovery-targets.json` is `failed-partial`.

#### Command constraints and decision

`GGA-R0` passes only if the dual-evidence eligibility decision is `eligible` and ownership, source provenance, exact targets, snapshots/backups, official rollback, and all pre/dry-run sentinels pass. The sealed decision record contains both eligibility record IDs and their normalized statuses, the eligibility decision digest, the dry-run digest, target-set digest, backup-manifest digest, rollback-plan digest, sentinel digest, and the single approved recovery argv:

```bash
gentle-ai install --component gga
```

Execute it at most once for this run, without command substitution, input piping, privilege escalation, force flags, alternate `HOME`, installer-channel overrides, additional component/agent flags, or post-preview environment/path changes. If the real command requests confirmation inconsistent with the sealed plan, changes its advertised target set, or attempts network/source retrieval inconsistent with the pinned artifact, decline and stop. A blocked decision does not fall back to `upgrade`, upstream GGA installation, another component, or any manual route.

#### Ordered validation sequence

After a successful command exit, validate in this exact order and stop at the first failure:

1. Capture the immediate post-target and sentinel snapshot before running any repaired binary.
2. Prove actual changed paths are exactly the authorized effects in `gga-recovery-targets.json`; require every planned GGA target to reach its expected type, mode, owner, symlink target, and hash/package identity.
3. Verify the Gentle AI manager identity and installation channel remain owned and coherent.
4. Run `bash -n` on the GGA entrypoint. No GGA invocation occurs if syntax fails.
5. Resolve required libraries without sourcing them; verify canonical paths, hashes, modes, source commit, manifest ownership, and no v2.6.1 checkout reference.
6. Run the documented GGA version command in the isolated probe and require the officially managed expected version.
7. Run the documented non-destructive help command in the isolated probe with timeout and temporary writable state.
8. Re-run Gentle AI version and doctor; GGA must be healthy, while OpenCode duplication remains owned by S4 rather than being waived.
9. Reconcile every non-GGA managed binary as a must-not-change sentinel and require byte/package identity equality with S0.
10. Compare every must-not-change sentinel, including the complete configuration/asset matrix digest. Any difference fails.
11. Seal the conditional GGA recovery receipt with invalid-probe eligibility, dry-run, target, backup, rollback, changed-path, validation, and sentinel evidence.
12. Stop the run after a successful recovery and create a fresh S0 baseline. Only that fresh run, now with a valid GGA probe, may execute the preferred `gentle-ai upgrade`; recovery success does not satisfy the managed-binary upgrade acceptance criterion by itself.

A nonzero exit, partial target application, validation failure, or sentinel drift transitions the recovery work unit to `failed-partial`. Do not run `sync`, switch to `upgrade` in the failed run, retry component installation, invoke upstream GGA installers, or manually restore files. Preserve evidence and use only the preapproved official rollback after explicit recovery authorization; then create a fresh S0 run.

### Postchecks

1. Re-resolve and hash all managed binaries; unexpected additions, removals, or roots cause `failed-partial`.
2. Re-run Gentle AI version and doctor.
3. Run `bash -n` on managed GGA before any GGA invocation.
4. Prove GGA entrypoint and required libraries share compatible official ownership and match the installed manifest or commit-pinned expected artifacts.
5. Run documented non-destructive GGA version and help forms in the isolated probe.
6. Require the officially managed expected version; an unreadable or inconsistent version fails acceptance.
7. Confirm hooks, shell startup sentinels, repository sentinel, and native authority sentinel are unchanged.

If the command fails or postchecks are mixed, do not run `sync` or copy a binary. Seal the partial state, invoke only the pre-recorded owner-supported restoration procedure after explicit recovery authorization, and re-baseline into a new run.

## Stage S2 — Managed asset synchronization

### Authorization

The only mutation is:

```bash
gentle-ai sync
```

Its receipt must state: **asset synchronization does not constitute binary repair**.

### Preconditions

- S1 passed, or S0 independently proved binaries healthy and assets stale.
- The complete S0 configuration/asset conformance matrix and its expected-inventory digest are sealed.
- Every `sync-required` row maps to a commit-pinned official source, deterministic destination/transformation rule, proven sync ownership, and exact rollback; there are no unexpected, conflicting, or unknown rows.
- Asset ownership roots and sorted pre-sync manifest are sealed.
- Binary identities are recorded as no-change sentinels.
- Official asset restoration procedure is known.

### Postchecks

1. Rebuild the entire configuration/asset matrix from scratch using the same authority checkout, enumeration boundaries, row schema, ordering, and comparison rules as S0; do not update only paths printed by `sync`.
2. Require the official expected-inventory digest to equal S0. An authority or expectation change mid-run blocks the stage.
3. Diff pre/post concrete rows and map every changed row to both an S0 `sync-required` row and the sync command receipt. An unpredicted change is unexplained drift and causes `failed-partial`.
4. Record the exact changed asset paths, types, modes, owners, symlink targets, and pre/post hashes. Reject any changed path outside proven asset roots.
5. Require every asset, template, skill, configuration fragment, generated metadata item, manifest, checksum, directory contract, and symlink row to finish as `exact-match` or a commit-pinned `allowed-declared-variant`.
6. Revalidate manifest path-set equality, checksum completeness/digests, generated output from isolated official generation, and all declared render transformations. Doctor success cannot waive a matrix failure.
7. Treat any missing row, modified row, unexpected extra, unknown expectation, ownership conflict, ambiguous transform, parse failure, uncovered checksum target, or undocumented generated-field difference as a blocking S2 postcondition.
8. Assert binary identities, hooks, shell startup sentinels, repository sentinel, and native authority sentinel are unchanged.
9. Run doctor as an independent health signal, but do not treat doctor alone as asset provenance or conformance proof.
10. Seal the final sorted row set, aggregate counts, expected-inventory digest, installed-inventory digest, and pre/post matrix diff in the S2 receipt.

A binary identity change or any other cross-boundary mutation during sync stops execution. A matrix mismatch is not repaired manually and does not authorize a second sync attempt; seal the partial state and follow the pre-recorded official restoration/escalation process.

## Stage S3 — Conditional Pi package-managed repair

### Decision and validation

Pi repair is skipped only if S0/S2 evidence proves all of: one canonical executable, valid supported version probe, healthy doctor result, known package source, package database ownership, and package integrity. `skipped-healthy` is a passed conditional outcome with evidence.

If any required health field fails, repair is authorized only as:

```bash
gentle-ai install --agent pi
```

No direct npm, pnpm, bun, Homebrew, system-package, or file-copy command may substitute for this route.

### Preconditions

- The Pi package manager/source and exact installed package identity are observed, not inferred.
- `gentle-ai install --help` from the pinned manager confirms the agent route.
- Package-manager metadata and lock/global manifest identities are sealed.
- The manager-supported rollback/reinstall of the exact prior Pi package is documented before mutation.
- The target package root does not overlap hooks, repository paths, shell startup, or native authority state.

### Postchecks

- Re-resolve Pi path and canonical owner.
- Verify package database identity, source, version, executable hash, and package integrity using the detected manager's read-only verification route.
- Run only the package's documented version/help probe in isolation.
- Re-run doctor.
- Compare package root, hook, repository, and native authority sentinels; reject unrelated changes.

If the Gentle AI command delegates to a package manager different from the proven source, installs outside the expected root, or leaves multiple unexplained Pi candidates, stop as partial and use only the pre-recorded supported rollback.

## Stage S4 — OpenCode owner-resolution decision tree

OpenCode's duplicate warning is blocking. The audit may proceed automatically; mutation requires a separately approved owner-supported command after the following tree produces one unambiguous result.

1. **Enumerate candidates.** Build the ordered list by scanning each captured `PATH` directory for the exact command name. Record duplicate `PATH` directory entries separately from distinct executable candidates. Resolve symlinks and hash targets.
2. **Classify identity.** If two entries resolve to the same inode/realpath, classify `alias-duplicate`; otherwise classify `distinct-installations`.
3. **Resolve owner for each candidate.** Require exactly one of Gentle AI manifest ownership, Homebrew formula/cask ownership, OS package ownership, npm-family package ownership, another official installer receipt, or explicitly documented user ownership. Location alone is insufficient.
4. **Resolve canonical candidate.** Use the owner documentation, configured update channel, doctor expectation, and first-hit `PATH` precedence. Do not choose merely by highest version.
5. **Select an owner-authorized resolution:**
   - If an owning installer/package manager exposes an official unlink, uninstall, relink, or configuration command that removes only the noncanonical candidate, record its commit/version-pinned documentation, dry-run/target preview where supported, exact command, affected paths, and exact reinstall/relink rollback.
   - If duplicate detection is caused by the same managed candidate being reported twice and the owning Gentle AI/OpenCode configuration interface has an official deduplication command, use only that interface after separate approval.
   - If resolution requires direct shell startup editing, direct `PATH` rewriting, blind deletion/unlinking, hook changes, manual symlink creation, or native review mutation, stop and escalate. This design does not authorize it.
   - If ownership is unknown, shared, conflicting, or an official rollback is absent, stop and escalate.
6. **Apply once.** Execute the separately approved owner command as its own receipt. Do not improvise flags.
7. **Verify.** Re-enumerate candidates, precedence, owners, hashes, and doctor output. The canonical executable must remain healthy and doctor must no longer report the duplicate warning.
8. **Rollback on regression.** Use exactly the recorded owner-supported reinstall/relink/configuration command. A rollback failure escalates; it does not authorize manual repair.

Hook, shell-startup, repository, and native-authority sentinels must remain byte-identical. If the warning remains, S4 is blocked even when OpenCode itself runs.

## Stage S5 — All-agent reconciliation algorithm

The reconciliation operates on the doctor-reported set, not a hard-coded agent list.

1. Parse the sealed baseline doctor output into stable records using normalized agent ID plus reported installation channel.
2. Require cardinality 11 at baseline. A parse ambiguity blocks reconciliation rather than dropping a row.
3. Re-run doctor and parse with the same parser/version.
4. Join baseline and final records by stable ID. Classify `unchanged`, `authorized-change`, `missing`, `new`, or `ambiguous`.
5. For each of the 11 records, resolve all executable/package candidates, canonical path, version-probe support, probe result, owner, package/installer provenance, doctor health, and official repair route.
6. Validate each probe with an agent-specific allowlist derived from official documentation. Never execute arbitrary discovered binaries or assume `--version` support.
7. Require every changed record to map to exactly one authorized S1-S4 receipt. A new or missing agent without such a receipt is unexplained.
8. Require zero `unknown`, `ambiguous`, failed supported probes, ownership conflicts, unexplained health failures, and duplicate OpenCode warnings.
9. Seal a sorted 11-row matrix and its digest. Newly discovered repair needs become a new scoped work unit; S5 never repairs in place.

## Stage S6 — Exact nine-path Phase 1 isolation and validation

### Fixed manifest

The manifest is an ordered constant:

1. `.github/workflows/theme-validation.yml`
2. `DreamcoderThemes/dreamcoder/tokens.json`
3. `DreamcoderThemes/dreamcoder/tokens.schema.json`
4. `docs/DREAMCODER_DESIGN_SYSTEM.md`
5. `scripts/apply-theme-mode.sh`
6. `scripts/verify-theme-health.py`
7. `src/dreamcoder_theme/palette_tokens.py`
8. `tests/test_token_parity.py`
9. `tests/test_theme_health.py`

### Isolation algorithm

Validation must not run against the 93-path dirty workspace. Build a synthetic candidate with a temporary index and temporary object directory, leaving the real index, worktree, hooks, and Git object database unchanged:

```bash
repo="$(git rev-parse --show-toplevel)"
probe="$(mktemp -d)"
mkdir -p "$probe/objects" "$probe/tree"
export GIT_INDEX_FILE="$probe/index"
export GIT_OBJECT_DIRECTORY="$probe/objects"
export GIT_ALTERNATE_OBJECT_DIRECTORIES="$(git -C "$repo" rev-parse --git-path objects)"
git -C "$repo" read-tree HEAD
git -C "$repo" add -- \
  .github/workflows/theme-validation.yml \
  DreamcoderThemes/dreamcoder/tokens.json \
  DreamcoderThemes/dreamcoder/tokens.schema.json \
  docs/DREAMCODER_DESIGN_SYSTEM.md \
  scripts/apply-theme-mode.sh \
  scripts/verify-theme-health.py \
  src/dreamcoder_theme/palette_tokens.py \
  tests/test_token_parity.py \
  tests/test_theme_health.py
candidate_tree="$(git -C "$repo" write-tree)"
git -C "$repo" diff-tree --no-commit-id --name-only -r HEAD "$candidate_tree"
git -C "$repo" archive --format=tar "$candidate_tree" | tar -xf - -C "$probe/tree"
```

Before use, check that every temporary path is under the private probe root and every manifest path is repository-relative, nonescaping, and of the expected file type. The `diff-tree` result must equal the fixed nine-path set exactly; missing, extra, renamed, or type-changed paths block the stage. The actual index checksum and `git status --porcelain=v2 -z` digest are captured before and after and must be identical. Temporary Git objects remain outside the repository.

All validation runs with `cwd=$probe/tree`, a sanitized environment, and caches/temp output redirected under `$probe`. Before and after each command, compare a complete path/hash manifest. Any changed path outside declared temporary caches or the nine paths fails the command; generated output expected to synchronize a tracked path must be compared, not silently accepted.

### Validation plan

The executor derives exact supported invocations from the nine checked-in files and project test configuration in the synthetic tree; it must not invent flags. At minimum, the receipt contains separate records for:

- JSON parse and JSON Schema validation of `tokens.json` against `tokens.schema.json`.
- `scripts/verify-theme-health.py` against the isolated candidate.
- static/generated synchronization check for `src/dreamcoder_theme/palette_tokens.py` against canonical tokens.
- focused `tests/test_token_parity.py`.
- focused `tests/test_theme_health.py`.
- syntax/non-mutating check of `scripts/apply-theme-mode.sh`, followed by its documented isolated runtime scenario if it supports a temporary target; otherwise explicit `N/A` with the exact safety reason.
- workflow syntax/configuration validation for `.github/workflows/theme-validation.yml` using the repository's documented local validator when available; absence is an explicit blocker or documented CI dependency, not a fabricated local pass.

Each command records exact interpreter/test-runner path and version, dependencies, environment digest, timestamp, output, exit status, and before/after scope manifest. The candidate tree ID and nine path blob IDs bind all results to exact content.

### Phase 1 rollback

Before delivery, record HEAD blob/mode and candidate blob/mode for all nine paths. Rollback is a nine-path-specific inverse patch or owner-reviewed restoration from those exact blob identities. Repository-wide reset, checkout, clean, stash, or reclassification is prohibited. If a path contained pre-existing intended content that cannot be separated from this change, delivery stops rather than overwriting it.

## Stage S7 — Native review lock and delivery boundary

S7 is parent/maintainer-owned. Global remediation and S6 may observe native authority but may not modify it.

1. If unrelated correction-required lineages still hold the authority lock, record the native status and stop. Do not run `review start`, `finalize`, reconcile-terminal-mirrors, delete authority files, or invalidate a lineage.
2. The parent/maintainer resolves or completes the unrelated lineage through its existing native process. This change does not prescribe or perform that recovery.
3. Only after native authority reports eligibility may the parent explicitly start review for the exact S6 candidate tree and nine-path set. A broader worktree or repository receipt is invalid for this change.
4. Any review correction must remain within the nine paths, create a new candidate tree/evidence seal, and follow the bounded native correction transaction. It must not alter global evidence or unrelated paths.
5. Before commit, stage exactly the reviewed nine paths without content or mode drift, then run `gentle-ai review validate --gate pre-commit --cwd <repo>`. Before push or PR, validate the same content-bound receipt with the corresponding native gate. Gate validation never starts a new review budget.
6. Missing, scope-changed, invalidated, escalated, or lock-blocked authority stops delivery. Terminal mirrors may be reconciled only after native allow and only by the parent-owned lifecycle.

No commit, push, PR, hook update, or review-state mutation is authorized by this design phase.

## Stop, recovery, and escalation protocol

### Universal stop conditions

Stop the current stage immediately when:

- ownership, provenance, expected target set, or rollback is missing or conflicting;
- a command exits nonzero, times out, is interrupted, or reports partial success;
- pre/post sentinels show an undeclared mutation;
- a supported probe is unavailable or disagrees with package/installer metadata;
- GGA syntax, libraries, version, help, ownership, or provenance fail;
- `GGA-R0` lacks either a sealed invalid syntax/probe record or a separate sealed official upgrade-checker result reporting GGA version unknown/health unestablished, or the two records conflict, are ambiguous, cross-run, stale, or show sentinel drift;
- any agent is new, missing, ambiguous, or newly unhealthy without an authorized receipt;
- OpenCode ownership is unresolved or duplicate warning remains;
- a command would touch hooks, startup files, credentials, unrelated user data, repository dirt, or native authority;
- nine-path isolation differs from the exact manifest;
- evidence chain validation fails;
- native authority is not eligible for the exact candidate.

### Recovery sequence

1. Stop issuing mutating commands.
2. Capture exit state and post-failure target identities using read-only probes only.
3. Seal the stage as `failed-partial` or `blocked`; never edit the receipt.
4. Compare observed effects to the predeclared ownership and rollback boundary.
5. If no mutation occurred, correct the plan in a new run.
6. If mutation occurred, request recovery authorization for the already-recorded owner-supported rollback only.
7. After rollback, create a fresh baseline run and prove restoration. Do not continue the old run.
8. If rollback is unavailable or fails, escalate to the owner/maintainer and preserve the machine state. Do not repair forward.

Escalation identifies the blocked stage, exact evidence record IDs, affected owner, observed versus expected paths, safe official alternatives and tradeoffs, and the smallest additional authorization required. It never waives an acceptance criterion.

## Acceptance-to-test traceability

| Acceptance                          | Evidence/test                                                                                                                     | Pass rule                                                                                                                                                                                                                                                                                                                                                                                    |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GAI-1 authority recorded            | S0 authority records                                                                                                              | Gentle AI commit equals `9c7bac8129e7936f414b25830ef591e173ed48ed`; GGA v2.10.1 resolves to one full official commit                                                                                                                                                                                                                                                                         |
| GAI-2 complete inventory            | S0 inventory schema plus configuration/asset matrix validation                                                                    | Required domains present; agent cardinality is 11; expected/installed union covers every managed asset/template/skill/configuration fragment/generated metadata/manifest/checksum item; each row has commit-pinned expectation; no unexplained drift or required unknown                                                                                                                     |
| GAI-3 official binary upgrade       | S1 preferred-upgrade receipt plus conditional `GGA-R0` dual-evidence and recovery receipts                                        | Valid baseline probe uses `gentle-ai upgrade`. Recovery requires both a sealed invalid syntax/probe record and an independent sealed official checker record reporting GGA version unknown or health unestablished, followed by documented component dry-run, one scoped install, successful validation, fresh S0, and preferred upgrade; recovery alone does not satisfy upgrade acceptance |
| GAI-4 GGA conformance               | `GGA-R0` probe/checker eligibility, target, rollback, sentinel evidence and ordered syntax/library/version/help/provenance probes | Invalid probe alone cannot authorize recovery; both immutable records are from the same run, checker semantics/parser are commit-pinned, checker status is unknown-version/unestablished-health, no target identity or rollback is missing, actual effects equal exact GGA-only preview, validations pass in order, and no other fallback is used                                            |
| GAI-5 no unrelated GGA source       | S0/S1 realpath, package, hash, source commit comparison                                                                           | No runtime path or library comes from the v2.6.1 checkout or unknown root                                                                                                                                                                                                                                                                                                                    |
| GAI-6 asset sync separation         | S2 command receipt and complete post-sync conformance matrix                                                                      | Exact `gentle-ai sync`, exit 0, assets only, explicit non-binary statement; every concrete row is exact or a commit-pinned declared variant, with manifests/checksums complete and no unknown or unexplained item                                                                                                                                                                            |
| GAI-7 Pi package health             | S3 package integrity and doctor                                                                                                   | Healthy package-owned Pi; if repaired, exact Gentle AI agent command is recorded                                                                                                                                                                                                                                                                                                             |
| GAI-8 all agents reconciled         | S5 11-row matrix validator                                                                                                        | Exactly 11 complete rows, no unexplained failure or unknown                                                                                                                                                                                                                                                                                                                                  |
| GAI-9 OpenCode ownership/precedence | S4 candidate graph                                                                                                                | Every candidate has owner, identity, and ordered precedence                                                                                                                                                                                                                                                                                                                                  |
| GAI-10 duplicate removed            | S4 post-doctor                                                                                                                    | No duplicate OpenCode PATH warning                                                                                                                                                                                                                                                                                                                                                           |
| GAI-11 prohibited mutations absent  | Sentinel comparisons across S0-S5                                                                                                 | Hooks, startup files, direct PATH config, review state, and repository sentinel unchanged                                                                                                                                                                                                                                                                                                    |
| GAI-12 complete post evidence       | Evidence schema and seal verifier                                                                                                 | Hash chain, blobs, commands, versions, paths, package IDs, provenance, and doctor records validate                                                                                                                                                                                                                                                                                           |
| DCT-1 exact manifest                | S6 synthetic `diff-tree` equality                                                                                                 | Set equality with exactly nine fixed paths                                                                                                                                                                                                                                                                                                                                                   |
| DCT-2 isolated evidence             | S6 candidate tree and real-index/status sentinels                                                                                 | Evidence binds to candidate tree; real index/status digests unchanged                                                                                                                                                                                                                                                                                                                        |
| DCT-3 schema/parity/health/tests    | S6 command receipts                                                                                                               | All supported focused checks exit 0 with no undeclared writes                                                                                                                                                                                                                                                                                                                                |
| DCT-4 content-bound receipt         | S7 native gate                                                                                                                    | Valid receipt covers exact candidate content and nine paths before delivery                                                                                                                                                                                                                                                                                                                  |
| DCT-5 unrelated state preserved     | S6/S7 before-after sentinels                                                                                                      | No unrelated path, hook, or authority artifact changed or staged                                                                                                                                                                                                                                                                                                                             |
| GATE-1 domain separation            | Receipt domain validator                                                                                                          | Every receipt belongs to exactly one domain; no global path enters Phase 1                                                                                                                                                                                                                                                                                                                   |
| GATE-2 authority immutability       | Native authority sentinel and status                                                                                              | Existing lineages unchanged by S0-S6                                                                                                                                                                                                                                                                                                                                                         |
| GATE-3 blocked delivery             | Stop-state test                                                                                                                   | Any unresolved blocker yields no commit/push/PR authorization                                                                                                                                                                                                                                                                                                                                |

## File and ownership impact

This design phase creates only:

- `openspec/changes/repair-gga-and-theme-delivery/design.md`

Later execution may create external evidence and temporary probe files, mutate official global ownership domains through the explicitly authorized commands, and eventually stage the exact nine repository paths only after native eligibility. It must not change repository implementation files during planning, global hooks, shell startup/PATH files, unrelated dirty paths, or native review authority artifacts.

## Work-unit and rollout boundaries

Each stage is one reviewable work unit with focused verification, runtime evidence or explicit `N/A`, and independent rollback. Global machine remediation never enters a repository commit. Theme delivery uses one content-bound nine-path unit unless later task forecasting requires a chain; any chain must preserve exact candidate identity and native receipt rules. No rollout advances automatically across a blocked or partial stage.

## Design risks

- **Critical:** The v2.10.1 GGA source commit is not yet pinned. Mitigation: S0 resolves and seals it; failure blocks S1.
- **Critical:** An official rollback command may not exist for the observed Gentle AI channel. Mitigation: no mutation until one is proven; escalate rather than rely on copied backups.
- **High:** OpenCode may have multiple legitimate owners with no safe automated resolution. Mitigation: audit-only decision tree and separately approved owner command; unresolved warning blocks acceptance.
- **High:** A lifecycle command may mutate beyond its advertised domain. Mitigation: target previews where available, broad sentinels, partial-state sealing, and no repair-forward behavior.
- **High:** Tests could accidentally consume unrelated dirty files. Mitigation: synthetic tree from HEAD plus exactly nine overlays, temporary Git index/object storage, and scope manifests.
- **High:** Existing native lineages can block delivery. Mitigation: immutable boundary and parent-owned recovery; no bypass.
- **Medium:** Tool output may leak secrets. Mitigation: allowlisted environment, targeted commands, pre-persistence redaction, and no complete environment/config dumps.
