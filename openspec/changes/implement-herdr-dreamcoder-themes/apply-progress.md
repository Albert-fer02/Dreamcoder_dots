# Apply Progress: Implement Herdr Dreamcoder Themes

## PR 1 — Contract Evidence and Disabled-by-Default Profile

### Completed implementation tasks

- [x] Added fail-closed contract tests for exact version selection, absent/unknown/malformed runtime output, incomplete evidence, ambiguous validation/reload semantics, and byte-identical no-mutation behavior.
- [x] Added sanitized fixture evidence, including `herdr-0.7.2-rejected-version.json`, exercised by a focused unsupported-runtime test. The complete fixture is explicitly synthetic and tests only generic contract mechanics; it is not a production Herdr configuration reference.
- [x] Added typed profile/evidence selection in `src/dreamcoder_theme/herdr_contract.py`; only exact complete profiles can be selected, and production registers none.
- [x] Replaced the existing Herdr renderer/update behavior with a disabled boundary: rendering raises and active configuration updates return `False` without reading, creating, or changing the path.
- [x] Added adjacent evidence documentation. It records the only verified observations and that no TOML keys, color representation, validation, reload, or restoration contract is proven. `window-title` and `tab-title` are excluded.
- [x] Checked the six completed PR 1 rows and the completed evidence-unavailable slice-boundary row in `tasks.md`; the changed-line-budget verification row is deferred.

### Files changed

- `src/dreamcoder_theme/herdr_contract.py`
- `src/dreamcoder_theme/renderers_herdr.py`
- `src/dreamcoder_theme/herdr-contract-evidence.md`
- `tests/test_herdr_contract.py`
- `tests/test_herdr_theme_generation.py`
- `tests/fixtures/herdr/*.json`
- `openspec/changes/implement-herdr-dreamcoder-themes/tasks.md`

### Test and quality evidence

| Command                                                                                                                                                       | Result                                                                                                                                             |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `python -m pytest tests/test_herdr_contract.py -v` (initial RED)                                                                                              | Expected collection failure: `dreamcoder_theme.herdr_contract` was absent.                                                                         |
| `python -m pytest tests/test_herdr_contract.py -v` (fixture RED)                                                                                              | Expected failure: `herdr-0.7.2-rejected-version.json` was absent.                                                                                  |
| `python -m pytest tests/test_herdr_contract.py tests/test_herdr_theme_generation.py -v`                                                                       | PASS — 11 passed.                                                                                                                                  |
| `ruff check src/dreamcoder_theme/herdr_contract.py src/dreamcoder_theme/renderers_herdr.py tests/test_herdr_contract.py tests/test_herdr_theme_generation.py` | PASS.                                                                                                                                              |
| `python -m pytest tests/ -v`                                                                                                                                  | 231 passed, 8 failed. This command result does not establish failure provenance; the failing test IDs are recorded below for deferred remediation. |
| `mypy` / `python -m mypy`                                                                                                                                     | Not run: `mypy` is not installed in this environment.                                                                                              |
| Scoped `git diff --no-index --check /dev/null <PR 1 path>`                                                                                                    | PASS for every PR 1 source, test, fixture, task, and progress path.                                                                                |

### Design deviations

The design proposed a future `herdr-0.7.3` profile, but the available authoritative help evidence does not prove TOML fields, representation, isolated validation, reload observability, or restoration. PR 1 therefore intentionally ships **no enabled production profile** and no color-bearing Herdr output. This is the required fail-closed behavior, not a guessed partial integration.

### Workload and PR boundary

- Delivery: `auto-chain`, `stacked-to-main`.
- PR boundary: **PR 1 only — contract evidence and disabled-by-default profile**.
- No PR 2–5 tasks were started.
- The scoped whitespace diff check passed; it does not prove an authored-line budget or ownership/provenance of unrelated workspace changes.
- Protected paths were not edited by this slice.

### Remaining tasks

All unchecked PR 2–5 implementation rows remain deferred. The slice-boundary verification row remains unchecked because the exact changed-line budget is not proven from the current mixed/untracked workspace state.

Deferred remediation: investigate the eight full-suite failures before claiming suite-wide success or assigning provenance: `tests/test_dreamcoder_ember_noir.py` (3), `tests/test_dreamcoder_theme_quality.py` (1), `tests/test_nvim_readability.py` (2), and `tests/test_pi_theme_generation.py` (2).

Parent-owned lifecycle actions remain byte-for-byte unchanged:

- `- [ ] Start or reuse the bounded native review after implementation, honoring the external review lock and never changing review state to bypass it. <!-- sdd-owner: parent -->`
- `- [ ] Validate the existing review receipt at the applicable lifecycle gate; do not commit or alter protected artifacts while the native review lock remains a blocker. <!-- sdd-owner: parent -->`

### Structured status consumed

```json
{
  "change": "implement-herdr-dreamcoder-themes",
  "artifactStore": "openspec",
  "applyState": "ready",
  "authoritative": true,
  "actionContext": {
    "mode": "workspace-implementation",
    "allowedEditRoots": [
      "/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots"
    ]
  },
  "delivery": "auto-chain",
  "chain": "stacked-to-main",
  "warnings": [
    "External native review lock blocks receipts/commits only.",
    "Full pytest recorded 8 failures; their provenance is not established and remediation is deferred."
  ]
}
```

## PR 2 — Canonical static variants and bounded activation (partial)

### Completed implementation tasks

- [x] Added static-renderer assertions for Dark/Light-only output, TOML validity, deterministic LF output, canonical `[ui]` and `[keys]`, and excluded fields.
- [x] Updated the renderer and regenerated only the two checked-in 0.7.3 static variants with canonical upstream `[ui]` and `[keys]` values.
- [ ] Activation-task completion is intentionally withheld: the initial focused activation tests do not yet cover every specified fault injection and unsafe-path case.

### Files changed in this attempt

- `src/dreamcoder_theme/renderers_herdr.py`
- `src/dreamcoder_theme/herdr_activation.py` (new)
- `DreamcoderHerdr/.config/herdr/dreamcoder/0.7.3/config.dark.toml`
- `DreamcoderHerdr/.config/herdr/dreamcoder/0.7.3/config.light.toml`
- `tests/test_herdr_theme_generation.py`
- `tests/test_herdr_activation.py` (new)
- `openspec/changes/implement-herdr-dreamcoder-themes/tasks.md`

### Verification evidence

| Command                                                                                                                                                           | Result                                                                                                                              |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `python -m pytest tests/test_herdr_theme_generation.py tests/test_herdr_activation.py -v`                                                                         | PASS — 17 passed; tests use temporary XDG paths and fake `herdr` binaries.                                                          |
| `ruff check src/dreamcoder_theme/renderers_herdr.py src/dreamcoder_theme/herdr_activation.py tests/test_herdr_theme_generation.py tests/test_herdr_activation.py` | PASS.                                                                                                                               |
| `python scripts/verify-theme-health.py`                                                                                                                           | BLOCKED: cannot import `dreamcoder_theme` in this checkout without `PYTHONPATH=src`.                                                |
| `PYTHONPATH=src python scripts/verify-theme-health.py`                                                                                                            | BLOCKED by pre-existing unrelated stale artifact `.opencode/themes/dreamcoder.json`; no protected file was changed to remediate it. |

### Blocking conditions

- The focused activation coverage is incomplete against the required matrix (missing executable, timeout, parent symlink, source safety, injected backup/staging/replace/fsync failures, identity conflict, absent-target rollback, and restore-failure cases). Its RED/GREEN tasks remain unchecked.
- The required theme-health command cannot pass due to an unrelated stale OpenCode artifact. Repairing it would exceed this change's protected scope.
- The scoped files total 559 physical lines and the mixed/untracked workspace prevents a trustworthy authored-line delta. The <400-line budget cannot be proven; no size exception was supplied.

### Remaining implementation tasks

- `- [ ] Run \`python -m pytest tests/test_herdr_theme_generation.py -v\` and \`ruff check src/dreamcoder_theme/renderers_herdr.py tests/test_herdr_theme_generation.py\`; verify \`python scripts/verify-theme-health.py\` and unrelated renderer/token files remain unchanged. <!-- sdd-owner: implementation -->`
- All unchecked activation RED/GREEN/TRIANGULATE/REFACTOR rows in `tasks.md`.
- `- [ ] Verify only the files named in this task slice, the focused acceptance criteria, named test/lint commands, and the under-400-line budget; rollback by reverting this slice without changing unrelated WIP. <!-- sdd-owner: implementation -->`

### Workload / status

- Delivery path consumed: single bounded slice; forecast was 330–390 lines with medium budget risk.
- Authoritative status consumed: `openspec`, `applyState: ready`, `nextRecommended: apply`, `actionContext.mode: repo-local`, workspace edit root `/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots`.
- No real home configuration was read or written. No activation was invoked outside pytest temporary paths.
- Parent-owned lifecycle action remains deferred and unchanged.

## Slice 1 — Isolation and verification

### User-authorized isolation

- Deleted only the incomplete, agent-generated Slice 2 files:
  - `src/dreamcoder_theme/herdr_activation.py`
  - `tests/test_herdr_activation.py`
- No real-home Herdr configuration, activation target, or other activation-related path was read or changed.

### Completed Slice 1 task evidence

- Retained the pure static renderer, its focused test, and only the checked-in `config.dark.toml` and `config.light.toml` variants.
- `python -m pytest tests/test_herdr_theme_generation.py -v`: PASS — 9 passed.
- `ruff check src/dreamcoder_theme/renderers_herdr.py tests/test_herdr_theme_generation.py`: PASS.
- `PYTHONPATH=src python scripts/verify-theme-health.py`: expected baseline failure (exit 1) only for `STALE_ARTIFACT: .opencode/themes/dreamcoder.json`; the two APCA messages are advisories. SHA-256 before/after confirmed that artifact was unchanged. It was not repaired.
- The retained static Slice 1 paths total 276 physical lines (`renderers_herdr.py`, static test, and two variants), below the 400-line budget. Scoped status contains only the two variants, renderer, and static test; task/progress records are the allowed SDD artifacts.

### Deferred lifecycle and remaining work

- Slice 2 remains entirely unchecked and unimplemented.
- Parent-owned commit boundary and review actions remain unchanged and deferred. No staging, commit, or review was started.

### Structured status consumed

```json
{
  "changeName": "implement-herdr-dreamcoder-themes",
  "artifactStore": "openspec",
  "applyState": "ready",
  "nextRecommended": "apply",
  "actionContext": {
    "mode": "repo-local",
    "allowedEditRoots": [
      "/home/dreamcoder08/Documents/PROYECTOS/dreamcoder-dots"
    ]
  },
  "warnings": [
    "Theme health baseline remains blocked solely by unchanged unrelated .opencode/themes/dreamcoder.json."
  ]
}
```
