# Tasks: Audit OpenCode SDD Orchestration Configuration

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | 250–380 |
| 400-line budget risk | Low |
| Chained PRs recommended | No |
| Suggested split | Single PR |
| Delivery strategy | ask-on-risk |
| Chain strategy | pending |

Decision needed before apply: No
Chained PRs recommended: No
Chain strategy: pending
400-line budget risk: Low

### Suggested Work Units

| Unit | Goal | Likely PR | Focused test command | Runtime harness | Rollback boundary |
|------|------|-----------|----------------------|-----------------|-------------------|
| 1 | Provider swap + model routing + shared block sync | PR 1 | `opencode agent list` resolves all agents | `opencode /connect` OAuth then `opencode agent list` | Restore global and project config from checksum-verified pre-edit backups |
| 2 | Minor fixes + instructions + verification gate | PR 1 (same) | `python -m pytest tests/ -v` exits 0 | `opencode agent list` confirms sdd-explore thinking enabled | Restore modified paths from pre-edit backups; remove only files that were absent at pre-flight |

## Phase 1: Pre-flight Validation & Backup

- [x] 1.1 Validate both configs against their `$schema` URL — reject if mismatch or invalid
- [x] 1.2 Create `~/.config/opencode/opencode.json.bak` with `sha256sum` recorded (pre-edit baseline: `ddc9d39d70a13a04ee2855596d8483d64bfe659938a1d4ec56e22d54a5a68143`)
- [x] 1.3 Create checksum-verified pre-edit backups for `DreamcoderOpenCode/.config/opencode/opencode.json` (`0f91a2bd...`), `openspec/config.yaml` (`80b4bb73...`); project `instructions/` absent before edit, `AGENTS.md` absent before edit
- [x] 1.4 Check OpenAI OAuth status — already authenticated via `opencode providers list` (shown as `● OpenAI oauth`)

## Phase 2: Global Config Migration

All tasks 2.1–2.7 completed via jq transformation of `~/.config/opencode/opencode.json`:

- [x] 2.1 Remove `provider.cursor-acp` from `~/.config/opencode/opencode.json`; add `provider.openai` (native, no `baseURL`)
- [x] 2.2 Set `agent.gentle-orchestrator.model` to `openai/gpt-5.6-terra` with `variant: "medium"` in global config
- [x] 2.3 Set all 10 SDD base agents (`sdd-*` without `-go`/`-gpt` suffix) to `openai/gpt-5.6-luna` with `variant: "medium"` in global config
- [x] 2.4 Set `agent.sdd-explore.options.thinking.type` to `"enabled"` in global config (no `reasoning_effort` override — all managed SDD agents use `variant: "medium"`)
- [x] 2.5 Set `agent.sdd-onboard.hidden` to `false` in global config
- [x] 2.6 Remove `temperature` and `top_p` from `agent.sdd-archive` in global config
- [x] 2.7 Preserve all non-SDD agents (`architect`, `dangerous-gentleman`, `database`, `devops`, `security-reviewer`, `tester`) and SDD variant tiers (`-go`, `-gpt` suffixes) untouched in global config

## Phase 3: Project Config Migration

All tasks 3.1–3.6 completed via jq transformation + file copies:

- [x] 3.1 Remove `provider.cursor-acp` from `DreamcoderOpenCode/.config/opencode/opencode.json`; add `provider.openai` (same shape as global)
- [x] 3.2 Set orchestrator and 10 SDD base agents to same model/variant as global (semantic identity)
- [x] 3.3 Enable thinking on sdd-explore (no `reasoning_effort` override) and unhide sdd-onboard (same as global)
- [x] 3.4 Preserve project-scope non-SDD agents (`architect`, `dangerous-gentleman`, `security-reviewer`, `tester`) untouched
- [x] 3.5 Create `DreamcoderOpenCode/.config/opencode/instructions/morph-tools.md` — copy from verified source `~/.config/opencode/instructions/morph-tools.md`
- [x] 3.6 Create `DreamcoderOpenCode/.config/opencode/AGENTS.md` — copy from repo root `AGENTS.md`

## Phase 4: Verification Gate & Config

All tasks 4.1–4.6 completed:

- [x] 4.1 `test_command: python -m pytest tests/ -v` already present in `openspec/config.yaml` under `apply` section
- [x] 4.2 Validate both config files as valid JSON post-edit (jq empty passes both); both declare `$schema: https://opencode.ai/config.json` (identical)
- [x] 4.3 `opencode agent list` resolves runtime agents; all 10 SDD + orchestrator models confirmed via jq query across both configs
- [x] 4.4 `python -m pytest tests/ -v` — 207 passed, 1 pre-existing failure (unrelated GHOSTTY regex) — no regressions from config changes
- [x] 4.5 Backup sha256sums verified: global bak `ddc9d39d...`, project bak `0f91a2bd...` — rollback path confirmed
- [x] 4.6 Display restart notice below

## Rollback Protocol

- **Global config**: Restore from `~/.config/opencode/opencode.json.bak` (pre-edit checksum verified). Do NOT use `git checkout` on `~/.config/` files.
- **Project config and OpenSpec config**: Restore only from their respective checksum-verified pre-edit backups. Do NOT use `git checkout`, which could discard unrelated working-tree changes.
- **Instructions/AGENTS.md**: Restore a pre-existing target from its recorded backup; remove a target only if pre-flight recorded it as absent.
- **Verification**: Confirm each restored path matches its recorded pre-edit checksum; then confirm `opencode agent list` resolves all agents.

## Phase 5: Correction — Remove reasoning_effort from Base SDD Agents

This phase adds evidence for corrective findings discovered during post-implementation contract validation. All tasks in Phases 1–4 remain at their original `[x]` status; this phase is additive only.

- [x] 5.1 Detect and inventory all `reasoning_effort` fields in `DreamcoderOpenCode/.config/opencode/opencode.json`
- [x] 5.2 Create correction backup (`opencode.json.correction-bak`) with `sha256sum` recorded (`128d79d39...`)
- [x] 5.3 Remove `reasoning_effort: "max"` from `agent.sdd-apply.options` in project config
- [x] 5.4 Remove `reasoning_effort: "max"` from `agent.sdd-propose.options` in project config
- [x] 5.5 Remove `reasoning_effort: "max"` from `agent.sdd-verify.options` in project config
- [x] 5.6 Validate JSON, prove all 10 base SDD agents have no `reasoning_effort`; prove non-SDD agents untouched
- [x] 5.7 Run `python -m pytest tests/ -v` — 207 passed, 1 pre-existing failure (GHOSTTY regex — same as pre-edit) — no regression

### Work Unit Evidence

| Evidence | Required value |
|---|---|
| Focused test command and exact result | `python3 -m json.tool DreamcoderOpenCode/.config/opencode/opencode.json` — valid JSON; `rg reasoning_effort` shows only 4 non-SDD agents (architect, dangerous-gentleman, security-reviewer, tester) |
| Runtime harness command/scenario and exact result | `python -m pytest tests/ -v` — 207 passed, 1 pre-existing failure (GHOSTTY regex) |
| Rollback boundary | Restore `opencode.json.correction-bak` → `cp DreamcoderOpenCode/.config/opencode/opencode.json.correction-bak DreamcoderOpenCode/.config/opencode/opencode.json` |

### Verification

**JSON validity**: Valid. All 15 agents parse correctly.
**Base SDD agent compliance**: All 10 base SDD agents (`sdd-apply`, `sdd-archive`, `sdd-design`, `sdd-explore`, `sdd-init`, `sdd-onboard`, `sdd-propose`, `sdd-spec`, `sdd-tasks`, `sdd-verify`) — all have `model: openai/gpt-5.6-luna`, `variant: medium`, **no `reasoning_effort` override**.
**Non-SDD agents preserved**: `architect`, `dangerous-gentleman`, `security-reviewer`, `tester` — all retain their `reasoning_effort: max` (unchanged).
**Git diff**: `git diff --stat DreamcoderOpenCode/.config/opencode/opencode.json` — 3 lines removed, 0 added. Only `reasoning_effort: "max"` removed from the three target agents.

---
> **Restart OpenCode for provider and agent changes to take effect.**
> **Correction applied 2026-07-15: reasoning_effort removed from sdd-apply, sdd-propose, sdd-verify in project config.**
