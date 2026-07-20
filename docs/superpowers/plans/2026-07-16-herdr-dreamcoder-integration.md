# Native Dreamcoder Herdr Light/Dark Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a first-class, evidence-gated Herdr 0.7.3 target that renders Dreamcoder Light and Dark tokens, installs without taking ownership of user files, and reports only observable activation outcomes.

**Architecture:** Start with a reproducible compatibility investigation and make its complete, version-bound profile the sole authority for Herdr schema, validation, active-path, selection, reload, and postcondition behavior. Keep rendering deterministic and token-only; isolate ownership classification, backup/restore, selector transactions, and runtime activation in Python so the existing shell entrypoint remains a small strict delegator. Integrate the resulting managed module through the established renderer, path, sync, installer, and Fish seams only after the profile gate passes.

**Tech Stack:** Python 3, pytest, existing Dreamcoder theme engine, Bash with `set -euo pipefail`, Fish, GNU Stow, installed Herdr 0.7.3, JSON/TOML data generated only from discovered contract evidence.

## Global Constraints

- Use a new linked worktree for execution because the primary checkout is dirty; do not stage, reset, stash, revert, or otherwise alter its existing changes.
- Create the execution worktree at `/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots-worktrees/herdr-dreamcoder-integration` on branch `feat/herdr-dreamcoder-integration`; it must have its own `.codegraph/` index and must never reuse or copy the primary checkout's index.
- The first behavior-changing implementation task is blocked until the Herdr 0.7.3 compatibility evidence is complete and reproducible.
- Support only installed Herdr version `0.7.3`; an absent, upgraded, downgraded, or incompletely profiled binary fails closed without modifying a Herdr configuration.
- Do not encode a Herdr TOML field, validation command, selector representation, config path, launch argument, reload command, success signal, or postcondition before the compatibility investigation proves it.
- `DreamcoderThemes/dreamcoder/tokens.json` is the exclusive color authority. Do not use Gentleman styling, static Gentleman Herdr files, fallback palettes, timestamps, random values, absolute host paths, or environment-dependent colors in generated variants.
- Render only `light` and `dark`; reject `dusk` and every other mode before touching any selector or invoking Herdr.
- Preserve Dreamcoder token guardrails: WCAG text contrast at least `4.5:1`, preferred main text contrast at least `7.0:1`, APCA body minimum `75` for light and `50` for dark.
- Preserve Fish as the Herdr startup owner in `DreamcoderShell/.config/fish/config.fish`; do not add a second process, terminate a process by guessed name, or alter Fish unless the profile proves a path/argument handoff is required.
- Installer changes are limited to paths proven managed by both the ownership marker and manifest. Unmanaged files remain unchanged unless explicit migration is requested; create backups before the first affected user-file write and restore every changed file on transaction failure.
- A selector transaction validates the managed candidate first, captures the prior complete state, atomically replaces one complete selector state, and rolls back atomically after any later failure.
- Expose status `applied`, `rolled_back`, `restart_required`, or `failed`. `scripts/apply-theme-mode.sh` exits successfully only for `applied`; all other statuses include phase diagnostics on stderr and produce a non-zero exit.
- Shell scripts remain at or below 30 lines, start with `set -euo pipefail`, quote variables, and use `[[ ... ]]` for tests. Do not mask Herdr errors with `|| true` or redirect their diagnostics away.
- Tests use disposable `HOME`, `XDG_CONFIG_HOME`, and `XDG_DATA_HOME` directories. They must never inspect, mutate, reload, or migrate the developer's live Herdr setup.
- Keep Ghostty repair artifacts, canonical Dreamcoder tokens, and unrelated renderer behavior unchanged; verification must prove this explicitly.

---

## Execution Workspace

Run this setup once, before Task 1, from the primary checkout. It is setup only; Task 1 remains the first behavior-changing gate.

- [ ] Confirm the primary checkout and dirty state without altering it.

Run: `git -C /home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots status --short`

Expected: Existing unrelated changes are listed; none are staged, reverted, stashed, or edited by this work.

- [ ] Create the parent directory and linked worktree without placing it under the primary checkout.

Run: `mkdir -p /home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots-worktrees`

Expected: Exit code `0`.

Run: `git -C /home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots worktree add -b feat/herdr-dreamcoder-integration /home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots-worktrees/herdr-dreamcoder-integration`

Expected: Git reports preparation of the new worktree and branch `feat/herdr-dreamcoder-integration`.

- [ ] Initialise a separate CodeGraph index in the new worktree only if `/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots-worktrees/herdr-dreamcoder-integration/.codegraph` does not exist; never copy or symlink the primary index.

Run: `test -d /home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots-worktrees/herdr-dreamcoder-integration/.codegraph`

Expected: Exit code `0` after the worktree-specific index is available.

- [ ] Use `/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots-worktrees/herdr-dreamcoder-integration` as the working directory for every remaining command and edit in this plan.

## File Structure

| Path | Responsibility |
| --- | --- |
| `docs/superpowers/evidence/herdr-0.7.3-contract.md` | Reproducible, sanitized command transcripts and observed evidence for the exact 0.7.3 executable; no unsupported behavior is claimed. |
| `src/dreamcoder_theme/herdr_profile.py` | Immutable, complete compatibility-profile data model and profile loader; refuses incomplete or mismatched evidence. |
| `src/dreamcoder_theme/herdr_profile_0_7_3.json` | Machine-independent profile data whose every schema, command, selector, path, and postcondition value cites Task 1 evidence. |
| `src/dreamcoder_theme/renderers_herdr.py` | Deterministic `herdr_content()` renderer driven solely by a supplied Dreamcoder palette and the verified field mapping. |
| `src/dreamcoder_theme/herdr_install.py` | Managed-path classification, manifest verification, migration backup creation, restore, and idempotent provisioning. |
| `src/dreamcoder_theme/herdr_activation.py` | Candidate validation, lock-protected atomic selector replacement, profile-defined activation, postcondition verification, and rollback. |
| `src/dreamcoder_theme/herdr_cli.py` | Narrow command-line adapter used by shell scripts; translates typed outcomes to stable stdout, stderr, and exit codes. |
| `src/dreamcoder_theme/renderers.py` | Public export of `herdr_content`. |
| `src/dreamcoder_theme/settings.py` | `ThemePaths` additions for repository managed variants and only discovery-proven runtime boundaries. |
| `src/dreamcoder_theme/sync.py` | Generates repository Light/Dark Herdr variants through the established sync path without activating a user configuration. |
| `src/dreamcoder_theme/installer.py` | Adds the `DreamcoderHerdr` module to installer planning and delegates Herdr-specific safety checks to `herdr_install.py`. |
| `DreamcoderHerdr/.config/herdr/` | Stowable, repository-managed Light/Dark generated variants and machine-independent ownership metadata; active selector material appears here only if Task 1 proves it is the runtime boundary. |
| `DreamcoderShell/.config/fish/config.fish` | Retains the current single Herdr startup responsibility; changes only for a proven explicit-path requirement. |
| `scripts/herdr-theme-switch.sh` | Strict, 30-lines-or-fewer delegator to `python -m dreamcoder_theme.herdr_cli activate`. |
| `scripts/apply-theme-mode.sh` | Consumes the Herdr CLI's stable result; prints Dreamcoder success only after `applied`. |
| `docs/herdr.md` | Operator guide for supported version, ownership, migration, recovery, status meanings, and evidence limitations. |
| `tests/test_herdr_profile.py` | Profile completeness/version gate and evidence parsing tests. |
| `tests/test_renderers_herdr.py` | Token-only mapping, Light/Dark parity, deterministic bytes, trailing newline, and contrast tests. |
| `tests/test_herdr_install.py` | Ownership classification, manifest, backup, migration, and restore transaction tests. |
| `tests/test_herdr_activation.py` | Selector atomicity, validation, reload/restart, postcondition, rollback, and status tests using a fake executable only. |
| `tests/test_herdr_cli.py` | CLI stdout/stderr/exit-status contract and `apply-theme-mode.sh` propagation tests. |
| `tests/test_herdr_fish_e2e.py` | Real Herdr 0.7.3 Fish startup and Light/Dark activation in a disposable XDG environment. |

## Compatibility Contract

The following interfaces are intentionally independent of unknown Herdr TOML keys. Task 1 supplies the only accepted profile data; Tasks 2-8 must not proceed on missing evidence.

```python
@dataclass(frozen=True)
class CommandContract:
    argv: tuple[str, ...]
    success: str
    evidence_reference: str


@dataclass(frozen=True)
class HerdrCompatibilityProfile:
    version: str
    executable_identity: str
    config_path_rule: str
    variant_selection_rule: str
    schema_mapping: dict[str, str]
    validation: CommandContract | None
    reload: CommandContract | None
    postcondition: CommandContract | None
    unsupported_behavior: tuple[str, ...]


@dataclass(frozen=True)
class HerdrOutcome:
    status: Literal["applied", "rolled_back", "restart_required", "failed"]
    mode: Literal["light", "dark"]
    phase: Literal["preflight", "validation", "selector", "reload", "postcondition", "rollback"]
    message: str
```

`load_verified_profile(profile_path: Path, *, detected_version: str) -> HerdrCompatibilityProfile` raises `HerdrProfileError` for any version mismatch or missing schema, path, selector, validation, reload/restart, or postcondition evidence. `herdr_content(palette: dict[str, str], profile: HerdrCompatibilityProfile) -> str` raises `HerdrRenderError` if a mapped token is absent or fails the relevant contrast requirement. `install_herdr(...) -> HerdrInstallResult` and `activate_herdr(...) -> HerdrOutcome` are the only mutations of runtime Herdr state; `sync.py` only writes the repository module.

### Task 1: Produce the Version-Bound Compatibility Contract

**Files:**
- Create: `docs/superpowers/evidence/herdr-0.7.3-contract.md`
- Create: `src/dreamcoder_theme/herdr_profile.py`
- Create: `src/dreamcoder_theme/herdr_profile_0_7_3.json`
- Test: `tests/test_herdr_profile.py`

**Interfaces:**
- Consumes: The installed `herdr` executable, its version/help output, a disposable `HOME`/XDG environment, and `themes/dreamcoder/tokens.json` only as later renderer input.
- Produces: `load_verified_profile(executable: Path) -> HerdrCompatibilityProfile`; a complete evidence record whose references are verified by the loader.

- [ ] **Step 1: Write failing profile-gate tests before inspecting implementation behavior.**

```python
def test_rejects_profile_when_version_is_not_0_7_3(tmp_path: Path) -> None:
    profile = complete_profile(tmp_path, version="0.7.4")
    with pytest.raises(HerdrProfileError, match="supported profile version.*detected version"):
        load_verified_profile(profile, detected_version="0.7.4")


def test_rejects_profile_with_missing_contract_evidence(tmp_path: Path) -> None:
    profile = complete_profile(tmp_path, validation=None)
    with pytest.raises(HerdrProfileError, match="incomplete compatibility profile"):
        load_verified_profile(profile, detected_version="0.7.3")
```

- [ ] **Step 2: Run the focused tests to confirm the gate does not exist yet.**

Run: `python -m pytest tests/test_herdr_profile.py -q`

Expected: FAIL during collection because `dreamcoder_theme.herdr_profile` does not exist.

- [ ] **Step 3: Run the reproducible discovery in a disposable runtime environment and record every command, exit status, diagnostic, and observable result.**

Run: `export HERDR_DISCOVERY_HOME="$(mktemp -d)"`

Expected: `HERDR_DISCOVERY_HOME` names an empty temporary directory used only for the remaining Task 1 discovery commands in the current shell.

Run: `env -i PATH="$PATH" HOME="${HERDR_DISCOVERY_HOME}" XDG_CONFIG_HOME="${HERDR_DISCOVERY_HOME}/.config" XDG_DATA_HOME="${HERDR_DISCOVERY_HOME}/.local/share" herdr --version`

Expected: Exact version output `0.7.3`; otherwise record the detected version and stop this plan with no Herdr implementation edits.

Run: `herdr --help`

Expected: Captured evidence for documented default-path and environment-override behavior only; do not infer undocumented behavior.

Run: `herdr config --help`

Expected: Captured evidence of whether a validator exists. If it does not expose a validator, the record must say so and the plan stops before Tasks 2-8 unless another authoritative, reproducible validation path is discovered.

Run: `herdr server reload-config --help`

Expected: Captured command availability only. Do not treat help text as proof of success, active-path parsing, or live reload.

- [ ] **Step 4: Complete the remaining evidence matrix against a temporary config tree without changing the user's configuration.**

Record in `docs/superpowers/evidence/herdr-0.7.3-contract.md`: executable identity; accepted minimal schema; per-intended-field acceptance/effect; deliberate invalid-config signal; actual active config path under Fish; exact Light/Dark selector form; supported validation invocation and success criterion; reload or restart behavior; and a visible/queryable postcondition for both modes. Include sanitized stdout/stderr, exit statuses, configuration bytes, and the observation method for every row.

Stop condition: If any row cannot be proven, mark the contract incomplete, keep `load_verified_profile()` fail-closed, do not create color-bearing Herdr TOML, and do not continue to Tasks 2-8. This is a successful safety outcome, not a reason to guess.

- [ ] **Step 5: Implement only the profile loader after the evidence record is complete.**

```python
def load_verified_profile(
    profile_path: Path, *, detected_version: str
) -> HerdrCompatibilityProfile:
    """Load only a complete profile tied to the inspected Herdr version."""
    profile = parse_profile(profile_path)
    if detected_version != profile.version:
        raise HerdrProfileError(
            f"supported profile version {profile.version}; detected version {detected_version}"
        )
    if not profile_complete(profile):
        raise HerdrProfileError("incomplete compatibility profile")
    return profile
```

Populate `src/dreamcoder_theme/herdr_profile_0_7_3.json` and the loader's profile path constant with the `schema_mapping`, command argv, path rule, selector rule, and success criteria quoted and cross-referenced to the completed evidence file. Do not create a synthetic profile fixture that claims unobserved Herdr behavior.

- [ ] **Step 6: Run profile tests and verify the evidence document is internally complete.**

Run: `python -m pytest tests/test_herdr_profile.py -q`

Expected: PASS; tests cover exact `0.7.3`, rejected version mismatch, and every required evidence category.

Run: `rg -n "(schema|field matrix|invalid|path|selector|validation|reload|restart|postcondition)" docs/superpowers/evidence/herdr-0.7.3-contract.md`

Expected: At least one cited reproducible evidence entry for every required category; no unresolved claim.

- [ ] **Step 7: Commit the evidence gate as an independently reviewable unit.**

Run: `git add docs/superpowers/evidence/herdr-0.7.3-contract.md src/dreamcoder_theme/herdr_profile.py src/dreamcoder_theme/herdr_profile_0_7_3.json tests/test_herdr_profile.py && git commit -m "feat: add Herdr 0.7.3 compatibility gate"`

Expected: One commit containing only the evidence profile and tests.

### Task 2: Render Deterministic Dreamcoder Variants

**Files:**
- Create: `src/dreamcoder_theme/renderers_herdr.py`
- Modify: `src/dreamcoder_theme/renderers.py`
- Create: `DreamcoderHerdr/.config/herdr/config.dark.toml`
- Create: `DreamcoderHerdr/.config/herdr/config.light.toml`
- Test: `tests/test_renderers_herdr.py`

**Interfaces:**
- Consumes: `HerdrCompatibilityProfile.schema_mapping`, verified serialization rules, `dict[str, str]` palette values from the established Dreamcoder palette path, `guard()` and `contrast()` from `dreamcoder_theme.palette`.
- Produces: `herdr_content(palette: dict[str, str], profile: HerdrCompatibilityProfile) -> str` and byte-identical repository Light/Dark variants ending in exactly one newline.

- [ ] **Step 1: Write renderer tests that establish token provenance and determinism.**

```python
@pytest.mark.parametrize("mode", ["light", "dark"])
def test_herdr_output_is_deterministic_and_uses_verified_mapping(mode: str) -> None:
    palette = load_variants()[mode]
    profile = verified_profile()
    first = herdr_content(palette, profile)
    assert first == herdr_content(dict(palette), profile)
    assert first.endswith("\n")
    assert rendered_values(first, profile) == expected_token_values(palette, profile)


def test_main_text_meets_contrast_guardrail() -> None:
    profile = verified_profile()
    for mode in ("light", "dark"):
        palette = load_variants()[mode]
        assert contrast(palette["text"], palette["bg"]) >= 7.0
        assert applicable_apca(palette["text"], palette["bg"], mode) >= profile_apca_minimum(mode)
```

- [ ] **Step 2: Run renderer tests to prove the renderer is missing.**

Run: `python -m pytest tests/test_renderers_herdr.py -q`

Expected: FAIL during collection because `herdr_content` is not exported.

- [ ] **Step 3: Implement the renderer with the verified semantic mapping and no literals other than structure required by the profile.**

```python
def herdr_content(palette: dict[str, str], profile: HerdrCompatibilityProfile) -> str:
    mapped = map_verified_roles(profile.schema_mapping, palette)
    assert_required_tokens(mapped, palette)
    assert_contrast_guardrails(mapped, palette)
    return serialize_with_profile(profile, mapped)
```

`map_verified_roles()` may source only `bg`, `bg_soft` or a profile-selected `surface*`, `text`, `muted` or `subtle`, `focus` or `accent`, `selection`, `error`, `warning`, `success`, and `info` from the supplied mode palette. It must raise `HerdrRenderError` if the profile requests an unavailable role. `serialize_with_profile()` uses only Task 1's accepted TOML hierarchy and value syntax.

- [ ] **Step 4: Export and generate variants through the normal renderer path.**

Add `herdr_content` to `renderers.py` imports and `__all__`. Generate `DreamcoderHerdr/.config/herdr/config.dark.toml` and `config.light.toml` from `tokens.json` using the Task 1 profile; do not create an active selector in this task.

- [ ] **Step 5: Run renderer, token-health, and byte-stability checks.**

Run: `python -m pytest tests/test_renderers_herdr.py tests/test_renderer_output.py -q`

Expected: PASS; both modes have equivalent verified field coverage and no unverified fields.

Run: `python scripts/verify-theme-health.py`

Expected: Exit code `0` with Dreamcoder Light and Dark token health passing.

Run: `git diff --no-index -- DreamcoderHerdr/.config/herdr/config.dark.toml <(python -m dreamcoder_theme.herdr_cli render --mode dark)`

Expected: Exit code `0`; repeat for `light` with the same result.

- [ ] **Step 6: Commit the renderer unit.**

Run: `git add src/dreamcoder_theme/renderers_herdr.py src/dreamcoder_theme/renderers.py DreamcoderHerdr/.config/herdr/config.dark.toml DreamcoderHerdr/.config/herdr/config.light.toml tests/test_renderers_herdr.py && git commit -m "feat: render Dreamcoder Herdr variants"`

Expected: One commit containing deterministic generated variants and renderer tests.

### Task 3: Integrate Generation Without Runtime Mutation

**Files:**
- Modify: `src/dreamcoder_theme/settings.py`
- Modify: `src/dreamcoder_theme/sync.py`
- Modify: `tests/test_dreamcoder_sync.py`
- Modify: `tests/test_renderer_output.py`

**Interfaces:**
- Consumes: `herdr_content()`, verified repository-module paths, active Dreamcoder palette and all loaded Light/Dark variants.
- Produces: `ThemePaths.herdr_module: Path`; `sync_active_targets()` result key `herdr_variants`; repository sync that writes variants but never installs, selects, reloads, or touches a user's active Herdr path.

- [ ] **Step 1: Add failing sync tests for an isolated repository module.**

```python
def test_sync_writes_herdr_variants_without_touching_runtime_selector(mock_paths, variants) -> None:
    runtime_selector = mock_paths.runtime_sentinel
    runtime_selector.write_bytes(b"unchanged")
    result = sync.sync_herdr_variants(mock_paths, variants)
    assert result == {"dark": True, "light": True}
    assert runtime_selector.read_bytes() == b"unchanged"
```

The test fixture must use a `tmp_path` module boundary and a separate sentinel runtime selector; the sentinel bytes must remain unchanged.

- [ ] **Step 2: Run the focused sync test and confirm the integration point is absent.**

Run: `python -m pytest tests/test_dreamcoder_sync.py -k herdr -q`

Expected: FAIL because `ThemePaths` has no Herdr module fields and `sync_herdr_variants` is undefined.

- [ ] **Step 3: Add only repository-generation paths to `ThemePaths` and sync.**

```python
def sync_herdr_variants(
    paths: ThemePaths, variants: dict[str, dict[str, str]]
) -> dict[str, bool]:
    return {
        mode: write_if_changed(
            paths.herdr_module / f"config.{mode}.toml",
            herdr_content(variants[mode], load_verified_profile(paths.herdr_profile)),
        )
        for mode in ("dark", "light")
    }
```

Set `ThemePaths.herdr_module` to the repository-managed `DreamcoderHerdr/.config/herdr` location. Add `ThemePaths.herdr_profile` only as the checked-in Task 1 profile path. Do not add a runtime selector path until discovery proves its exact location and ownership boundary.

- [ ] **Step 4: Run focused and regression sync tests.**

Run: `python -m pytest tests/test_dreamcoder_sync.py tests/test_renderer_output.py -q`

Expected: PASS; sync reports `herdr_variants`, writes Light/Dark repository files, and leaves the runtime sentinel untouched.

- [ ] **Step 5: Commit the generation integration.**

Run: `git add src/dreamcoder_theme/settings.py src/dreamcoder_theme/sync.py tests/test_dreamcoder_sync.py tests/test_renderer_output.py && git commit -m "feat: sync managed Herdr variants"`

Expected: One commit with no installer, Fish, selector, or reload behavior change.

### Task 4: Add Ownership-Safe Provisioning, Migration, Backup, and Restore

**Files:**
- Create: `src/dreamcoder_theme/herdr_install.py`
- Modify: `src/dreamcoder_theme/installer.py`
- Create: `DreamcoderHerdr/.config/herdr/.dreamcoder-herdr-manifest.json`
- Test: `tests/test_herdr_install.py`

**Interfaces:**
- Consumes: The verified profile's runtime boundary, the repository module, `Path` inputs, and explicit `migrate: bool`.
- Produces: `classify_herdr_state(...) -> HerdrOwnershipState`, `install_herdr(..., migrate: bool) -> HerdrInstallResult`, `restore_herdr_transaction(transaction: BackupTransaction) -> None`, and manifest entries containing relative managed path plus SHA-256 content identity.

- [ ] **Step 1: Write failing classification and rollback tests.**

```python
def test_unmanaged_config_is_unchanged_without_migration(tmp_path: Path) -> None:
    runtime = tmp_path / "runtime"
    runtime.mkdir()
    selector = verified_profile().selector_path(runtime)
    selector.write_bytes(b"user-owned")
    before = selector.read_bytes()
    result = install_herdr(runtime=runtime, module=managed_module(tmp_path), migrate=False)
    assert result.status == "conflict"
    assert selector.read_bytes() == before


def test_failed_migration_restores_all_altered_files(tmp_path: Path, monkeypatch) -> None:
    transaction = setup_unmanaged_migration(tmp_path)
    monkeypatch.setattr("dreamcoder_theme.herdr_install.install_selector", raise_after_first_write)
    result = install_herdr(**transaction.args, migrate=True)
    assert result.status == "rolled_back"
    assert restored_bytes(transaction.altered_paths) == transaction.original_bytes
```

The test helper reads the selector location from the complete Task 1 profile; no test embeds an inferred selector name or path.

- [ ] **Step 2: Run installer tests and confirm the safety API is missing.**

Run: `python -m pytest tests/test_herdr_install.py -q`

Expected: FAIL during collection because `dreamcoder_theme.herdr_install` does not exist.

- [ ] **Step 3: Implement ownership classification and manifest validation before any write.**

```python
def classify_herdr_state(runtime: Path, module: Path, profile: HerdrCompatibilityProfile) -> HerdrOwnershipState:
    """Classify missing, managed, partial-managed, external symlink, or external content."""


def install_herdr(
    *, runtime: Path, module: Path, profile: HerdrCompatibilityProfile, migrate: bool
) -> HerdrInstallResult:
    state = classify_herdr_state(runtime, module, profile)
    if state.requires_explicit_migration and not migrate:
        return HerdrInstallResult.conflict(state.conflicting_paths)
    transaction = create_backup_before_mutation(state) if state.requires_backup else None
    try:
        provision_only_manifest_owned_paths(state, module, profile)
    except Exception as error:
        restore_herdr_transaction(transaction)
        return HerdrInstallResult.rolled_back(error)
    return HerdrInstallResult.installed_or_unchanged(state)
```

The manifest contains only the managed module's relative paths and content hashes. A directory name or a symlink alone never establishes ownership. Backups live outside `DreamcoderHerdr`, record original path and SHA-256 before mutation, and include only changed paths. Missing, altered, or inconsistent manifests are repair conflicts, not upgrade permission.

- [ ] **Step 4: Register the module with the existing installer plan without weakening generic conflict handling.**

Add `DreamcoderHerdr` and only the discovered runtime boundary to `managed_targets()`, `modules`, and the generated Stow command. Route the Herdr row through `classify_herdr_state()` so generic `classify_target()` cannot mistake an external directory name for ownership.

- [ ] **Step 5: Run the installer matrix.**

Run: `python -m pytest tests/test_herdr_install.py -q`

Expected: PASS for missing install, managed idempotent update, missing/altered manifest conflict, external file conflict, external symlink conflict, backup creation failure before write, explicit migration backup, and injected failure restoration.

Run: `python -m pytest tests/test_dreamcoder_writers.py tests/test_dreamcoder_sync.py -q`

Expected: PASS; existing installer and writer semantics remain unchanged.

- [ ] **Step 6: Commit the ownership boundary.**

Run: `git add src/dreamcoder_theme/herdr_install.py src/dreamcoder_theme/installer.py DreamcoderHerdr/.config/herdr/.dreamcoder-herdr-manifest.json tests/test_herdr_install.py && git commit -m "feat: install Herdr with ownership safeguards"`

Expected: One commit covering provisioning and restoration without activation.

### Task 5: Implement Atomic Validated Activation and Rollback

**Files:**
- Create: `src/dreamcoder_theme/herdr_activation.py`
- Create: `src/dreamcoder_theme/herdr_cli.py`
- Modify: `scripts/herdr-theme-switch.sh`
- Test: `tests/test_herdr_activation.py`
- Test: `tests/test_herdr_cli.py`

**Interfaces:**
- Consumes: A complete `HerdrCompatibilityProfile`, a managed manifest, `mode: Literal["light", "dark"]`, and a lock path located beside the discovery-proven selector boundary.
- Produces: `activate_herdr(mode: str, ...) -> HerdrOutcome`; CLI output `status=<status> mode=<mode> phase=<phase>` on stdout and diagnostics on stderr; non-zero exit for all statuses except `applied`.

- [ ] **Step 1: Write failing transaction tests using a fake Herdr executable and a profile fixture constructed from Task 1 evidence.**

```python
def test_invalid_mode_does_not_touch_selector(tmp_path: Path) -> None:
    selector = active_selector(tmp_path, "dark")
    before = selector.read_bytes()
    outcome = activate_herdr(mode="dusk", context=fake_context(tmp_path))
    assert outcome.status == "failed"
    assert outcome.phase == "preflight"
    assert selector.read_bytes() == before


def test_reload_failure_restores_prior_selector_and_reports_rollback(tmp_path: Path) -> None:
    context = fake_context(tmp_path, reload_result="failure", rollback_postcondition="success")
    before = active_selector(tmp_path, "dark").read_bytes()
    outcome = activate_herdr(mode="light", context=context)
    assert outcome.status == "rolled_back"
    assert outcome.phase == "reload"
    assert active_selector(tmp_path, "dark").read_bytes() == before
```

The fake executable implements only the exact validation/reload/postcondition contract discovered in Task 1. It must not invent a separate command grammar.

- [ ] **Step 2: Run activation tests to establish the missing behavior.**

Run: `python -m pytest tests/test_herdr_activation.py tests/test_herdr_cli.py -q`

Expected: FAIL during collection because activation and CLI modules do not exist.

- [ ] **Step 3: Implement preflight, locking, validation, atomic replacement, activation, and postcondition verification.**

```python
def activate_herdr(mode: str, *, context: HerdrActivationContext) -> HerdrOutcome:
    if mode not in {"light", "dark"}:
        return failed(mode, "preflight", "mode must be light or dark")
    profile = load_verified_profile(context.profile_path, detected_version=context.version())
    candidate = context.manifest.managed_variant(mode)
    validate_candidate(candidate, profile)
    with selector_lock(context.selector_lock):
        previous = capture_selector(context.selector)
        atomically_replace_selector(context.selector, selector_for(candidate, profile))
        return activate_or_restore(mode, previous, context, profile)
```

`atomically_replace_selector()` writes a complete replacement in the selector's directory, fsyncs it, and uses same-directory atomic replacement. It never updates a selector in place. `activate_or_restore()` invokes only the profile-defined reload path when its result is observable; a no-live-reload profile returns `restart_required` after selector validity is confirmed. Any failure after capture atomically restores `previous`, follows the same verified activation path for rollback, and returns `rolled_back` only if the prior state postcondition is confirmed; otherwise it returns `failed` with both primary and rollback diagnostics.

- [ ] **Step 4: Keep the shell adapter small and truthful.**

```bash
#!/usr/bin/env bash
set -euo pipefail

mode="${1:-}"
exec python -m dreamcoder_theme.herdr_cli activate --mode "${mode}"
```

The real command module resolves paths through the verified profile and XDG-aware context. It writes operation, mode, affected path, and phase to stderr on every failure. It must not call `herdr` when the profile gate fails.

- [ ] **Step 5: Run the switcher matrix.**

Run: `python -m pytest tests/test_herdr_activation.py tests/test_herdr_cli.py -q`

Expected: PASS for invalid mode, unsupported version, absent executable, unmanaged candidate, missing variant, validation failure, selector write failure, lock serialization, reload failure with confirmed rollback, postcondition mismatch with confirmed rollback, rollback failure, `restart_required`, and successful Light/Dark activation.

Run: `bash -n scripts/herdr-theme-switch.sh && wc -l < scripts/herdr-theme-switch.sh`

Expected: Syntax succeeds and line count is at most `30`.

- [ ] **Step 6: Commit the activation transaction.**

Run: `git add src/dreamcoder_theme/herdr_activation.py src/dreamcoder_theme/herdr_cli.py scripts/herdr-theme-switch.sh tests/test_herdr_activation.py tests/test_herdr_cli.py && git commit -m "feat: activate Herdr themes atomically"`

Expected: One commit with complete selector and rollback behavior.

### Task 6: Propagate Truthful Status Through the Theme Switcher

**Files:**
- Modify: `scripts/apply-theme-mode.sh`
- Modify: `tests/test_herdr_cli.py`

**Interfaces:**
- Consumes: `scripts/herdr-theme-switch.sh <light|dark>` stdout status line, stderr diagnostics, and exit code.
- Produces: Top-level exit `0` only for `status=applied`; all other outcomes preserve the Herdr phase diagnostic and return non-zero without printing the final Dreamcoder success line.

- [ ] **Step 1: Write failing caller-contract tests.**

```python
@pytest.mark.parametrize("status", ["rolled_back", "restart_required", "failed"])
def test_apply_theme_mode_rejects_non_applied_herdr_status(status: str, tmp_path: Path) -> None:
    result = run_apply_theme_mode(tmp_path, herdr_result=status)
    assert result.returncode != 0
    assert f"status={status}" in result.stderr
    assert "Dreamcoder dark mode applied" not in result.stdout


def test_apply_theme_mode_reports_success_only_after_applied(tmp_path: Path) -> None:
    result = run_apply_theme_mode(tmp_path, herdr_result="applied")
    assert result.returncode == 0
    assert "Dreamcoder dark mode applied" in result.stdout
```

- [ ] **Step 2: Run caller-contract tests and confirm current false-success behavior.**

Run: `python -m pytest tests/test_herdr_cli.py -k apply_theme_mode -q`

Expected: FAIL because the current script prints Herdr and Dreamcoder success without consuming a structured status.

- [ ] **Step 3: Replace only the Herdr call block with strict result propagation.**

```bash
if [[ -f "${HERDR_SCRIPT}" ]]; then
  if ! herdr_output="$(bash "${HERDR_SCRIPT}" "${MODE}")"; then
    printf '%s\n' "${herdr_output}" >&2
    exit 1
  fi
  [[ "${herdr_output}" == "status=applied mode=${MODE} phase=postcondition" ]] || {
    printf '%s\n' "${herdr_output}" >&2
    exit 1
  }
fi
```

Adjust the exact successful status line only if Task 5's CLI contract defines a different proven `applied` phase; retain the same strict equality in the test. Do not alter unrelated target error handling in this task.

- [ ] **Step 4: Run propagation tests and shell checks.**

Run: `python -m pytest tests/test_herdr_cli.py -k apply_theme_mode -q`

Expected: PASS; `applied` is the only successful top-level outcome and all other Herdr outcomes retain stderr diagnostics.

Run: `bash -n scripts/apply-theme-mode.sh`

Expected: Exit code `0`.

- [ ] **Step 5: Commit top-level truthfulness.**

Run: `git add scripts/apply-theme-mode.sh tests/test_herdr_cli.py && git commit -m "fix: preserve Herdr activation failures"`

Expected: One commit limited to status propagation.

### Task 7: Preserve Fish Startup and Prove the Real End-to-End Path

**Files:**
- Modify: `DreamcoderShell/.config/fish/config.fish` only if Task 1 proves an explicit runtime path or argument is required.
- Create: `tests/test_herdr_fish_e2e.py`
- Modify: `tests/test_herdr_activation.py`

**Interfaces:**
- Consumes: Verified Task 1 active-path and startup evidence, managed installation, activation CLI, real `herdr 0.7.3`, and `fish` in a disposable XDG environment.
- Produces: E2E proof that Fish launches a single Herdr instance using the discovered configuration boundary and that `light -> dark` and `dark -> light` report observable `applied` state.

- [ ] **Step 1: Write the real-binary E2E test with strict prerequisites.**

```python
def test_fish_starts_and_switches_real_herdr_light_and_dark(isolated_runtime: HerdrRuntime) -> None:
    require_exact_herdr_version(isolated_runtime.herdr, "0.7.3")
    install = install_herdr(**isolated_runtime.install_args, migrate=False)
    assert install.status in {"installed", "unchanged"}
    fish = start_interactive_fish(isolated_runtime)
    assert profile_postcondition(isolated_runtime, "light")
    assert run_activation(isolated_runtime, "dark").status == "applied"
    assert profile_postcondition(isolated_runtime, "dark")
    assert run_activation(isolated_runtime, "light").status == "applied"
    assert profile_postcondition(isolated_runtime, "light")
    assert fish.started_herdr_count == 1
```

If `herdr 0.7.3` or the full verified profile is unavailable, this test must fail with an explicit prerequisite message in the implementation verification job; it must not silently skip and be counted as complete.

- [ ] **Step 2: Run the E2E test before changing Fish and capture its failure mode.**

Run: `python -m pytest tests/test_herdr_fish_e2e.py -q`

Expected: FAIL until the managed module, runtime profile, installer, and activation path exist; any missing binary/profile reports an explicit prerequisite failure.

- [ ] **Step 3: Make the minimal Fish change only if discovery proved it necessary.**

If Fish's existing `herdr` invocation uses the proven default path, leave `DreamcoderShell/.config/fish/config.fish` byte-identical and record that result in the test. If an explicit path or environment handoff is proven necessary, add exactly that profile-defined handoff inside the existing interactive Herdr guard; retain `not set -q HERDR_ENV`, `not set -q TMUX`, and `not set -q ZELLIJ` safeguards and do not add restart/kill behavior.

- [ ] **Step 4: Run Fish syntax and real integration verification.**

Run: `fish -n DreamcoderShell/.config/fish/config.fish`

Expected: Exit code `0`.

Run: `python -m pytest tests/test_herdr_fish_e2e.py tests/test_herdr_activation.py -q`

Expected: PASS; observed Light and Dark state changes, exactly one Fish-owned launch, and at least one tested rollback path.

- [ ] **Step 5: Commit only proven Fish integration.**

Run: `git add DreamcoderShell/.config/fish/config.fish tests/test_herdr_fish_e2e.py tests/test_herdr_activation.py && git commit -m "feat: verify Herdr Fish integration"`

Expected: One commit; if Fish was unchanged, omit it from `git add` and state that the existing default-path startup was proven sufficient.

### Task 8: Document Operations and Run the Full Verification Matrix

**Files:**
- Create: `docs/herdr.md`
- Modify: `README.md` only if its target index has an established section for supported modules.
- Test: `tests/test_herdr_profile.py`
- Test: `tests/test_renderers_herdr.py`
- Test: `tests/test_herdr_install.py`
- Test: `tests/test_herdr_activation.py`
- Test: `tests/test_herdr_cli.py`
- Test: `tests/test_herdr_fish_e2e.py`

**Interfaces:**
- Consumes: Finished compatibility evidence, stable status values, manifest/backup format, and actual profile-defined commands.
- Produces: An operator guide that tells users how to inspect support, install, migrate, restore, repair, switch, and recover without making unverified claims.

- [ ] **Step 1: Write documentation acceptance tests/checklist entries before publishing the guide.**

```python
def test_operator_guide_links_contract_and_recovery_sections() -> None:
    guide = Path("docs/herdr.md").read_text()
    for heading in ("Herdr 0.7.3", "Managed Paths", "Migration", "Backup and Restore", "Outcomes", "Recovery"):
        assert heading in guide
    assert "Gentleman" not in guide
```

- [ ] **Step 2: Run the guide test and confirm documentation is absent.**

Run: `python -m pytest tests/test_herdr_profile.py -k operator_guide -q`

Expected: FAIL because `docs/herdr.md` does not exist.

- [ ] **Step 3: Document only evidence-backed operations.**

`docs/herdr.md` must identify 0.7.3 as the sole supported profile; link the Task 1 evidence; list exact managed paths, marker, and manifest format; distinguish normal installation, repair conflict, explicit migration, retained backups, and restore; give the profile-defined validation/reload/restart behavior; define `applied`, `rolled_back`, `restart_required`, and `failed`; explain recovery for unsupported version, conflict, validation failure, and rollback failure; and explicitly state that Ghostty repair is separate. Every Herdr command, path, selector detail, and guarantee must link to a Task 1 evidence reference.

- [ ] **Step 4: Execute the verification matrix in the isolated worktree.**

| Area | Command | Expected output |
| --- | --- | --- |
| Profile contract | `python -m pytest tests/test_herdr_profile.py -q` | PASS; exact 0.7.3 only, full evidence required, fail-closed mismatch behavior. |
| Renderer | `python -m pytest tests/test_renderers_herdr.py -q` | PASS; deterministic Light/Dark output, equivalent verified structure, Dreamcoder token provenance. |
| Contrast | `python scripts/verify-theme-health.py && python -m pytest tests/test_renderers_herdr.py -k contrast -q` | Both commands exit `0`; WCAG/APCA assertions pass for both modes. |
| Sync regression | `python -m pytest tests/test_dreamcoder_sync.py tests/test_renderer_output.py -q` | PASS; Herdr generation does not mutate runtime selectors and unrelated renderers remain valid. |
| Installer | `python -m pytest tests/test_herdr_install.py -q` | PASS; ownership, manifest, backup, migration, conflict, idempotence, and restore cases pass. |
| Selector transaction | `python -m pytest tests/test_herdr_activation.py -q` | PASS; atomicity, serialization, validation, selector failure, reload failure, postcondition failure, rollback, and restart-required cases pass. |
| Top-level status | `python -m pytest tests/test_herdr_cli.py -q` | PASS; `apply-theme-mode.sh` succeeds only for `applied` and preserves phases/errors. |
| Real Fish E2E | `python -m pytest tests/test_herdr_fish_e2e.py -q` | PASS with installed Herdr 0.7.3; Fish starts once and observable Light/Dark activation succeeds in both directions. |
| Shell syntax | `bash -n scripts/herdr-theme-switch.sh && bash -n scripts/apply-theme-mode.sh && fish -n DreamcoderShell/.config/fish/config.fish` | Exit code `0`. |
| Full suite | `python -m pytest tests/ -v` | PASS; no regressions. |
| Protected areas | `git diff --exit-code -- DreamcoderGhostty DreamcoderThemes/dreamcoder/tokens.json` | Exit code `0`; no Ghostty or canonical-token change. |

- [ ] **Step 5: Review the complete diff for unsupported assumptions and generated-file drift.**

Run: `rg -n "(window-title|tab-title|Gentleman|\|\| true|reload-config.*2>/dev/null)" src DreamcoderHerdr scripts docs/herdr.md tests`

Expected: No unverified Herdr field, Gentleman source, suppressed reload error, or generic masked failure appears in implementation files. A cited historical evidence mention is allowed only in the evidence document.

Run: `git status --short && git diff --check`

Expected: Only planned Herdr files are changed; `git diff --check` exits `0`.

- [ ] **Step 6: Commit documentation and verification coverage.**

Run: `git add docs/herdr.md README.md tests/test_herdr_profile.py && git commit -m "docs: document Herdr integration operations"`

Expected: One commit; omit `README.md` if it had no established target index to update.

## Self-Review

### Coverage

| Approved-design requirement | Plan coverage |
| --- | --- |
| Herdr 0.7.3 evidence before behavior change | Task 1, stop condition, profile gate tests. |
| Dreamcoder-only Light/Dark token renderer | Task 2 and global token/contrast constraints. |
| Existing theme-engine integration | Task 3 through `renderers.py`, `ThemePaths`, and `sync.py`. |
| Ownership, manifest, backup, migration, restore | Task 4. |
| Atomic selector and rollback | Task 5. |
| Truthful `apply-theme-mode.sh` result | Task 6. |
| Fish startup preservation and end-to-end path | Task 7. |
| Contract, renderer, contrast, installer, selector, light/dark, Fish verification | Task 8 matrix. |
| No Gentleman styling and protected Ghostty/token areas | Global constraints and Task 8 protected-area checks. |

### Placeholder Scan

The plan deliberately contains no provisional Herdr TOML fields, validation invocation, selector syntax, path, or reload command. These are not omissions: Task 1 makes them evidence-gated profile values and halts the implementation when unproven. All proposed code paths, module interfaces, tests, execution paths, commands, expected outcomes, ownership rules, and rollback outcomes are explicit.

### Interface Consistency

- Tasks 2 and 3 consume `HerdrCompatibilityProfile` solely through `load_verified_profile()` from Task 1.
- Task 4 provisions only generated variants from Tasks 2-3 and creates the manifest required by Task 5.
- Tasks 5-7 expose and consume the same `HerdrOutcome` status/phase contract.
- Task 8 verifies the exact interfaces produced by all prior tasks and does not add a parallel activation path.

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-07-16-herdr-dreamcoder-integration.md`.

Use Subagent-Driven execution (recommended): dispatch a fresh subagent for each task, review the evidence gate before allowing Task 2, and review each task before continuing. The worktree requirement is mandatory before Task 1.
