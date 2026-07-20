# Design: Audit OpenCode SDD Orchestration Configuration

## Technical Approach

Config-only migration: replace `provider.cursor-acp` with `provider.openai`; route orchestrator → `openai/gpt-5.6-terra` variant `medium`, all SDD agents → `openai/gpt-5.6-luna` variant `medium`; sync a semantically identical managed block (provider + gentle-orchestrator + 10 SDD base agents + instructions refs) across global (`~/.config/opencode/`) and project (`DreamcoderOpenCode/.config/opencode/`) scopes while preserving scope-specific fields — non-SDD agents (`architect`, `dangerous-gentleman`, `database`, `devops`, `security-reviewer`, `tester`), SDD variant tiers (`-go`, `-gpt` suffixes, global-only surplus), and orchestrator prompt-density differences.

## Architecture Decisions

| Decision | Choice | Alternative | Rationale |
|----------|--------|-------------|-----------|
| Provider | `provider.openai` (native, no baseURL) | Keep cursor-acp | Native OpenAI is target; OAuth via `/connect` before go-live |
| Orchestrator model | `openai/gpt-5.6-terra` variant `medium` | Same as sub-agents | Terra is premium tier — orchestrator needs higher planning capacity |
| Sub-agent model | `openai/gpt-5.6-luna` variant `medium` | Same as orchestrator | Luna is fallback tier — sufficient for executor sub-agents |
| Identity contract | Semantic identity (same model/variant/options/content in managed block) | Byte-for-byte copy | Non-SDD agents, variant tiers, and prompt lengths differ between scopes — exact copy impossible |
| Schema validation | Validate against `$schema` URL before edit | Manual review | Catches malformed IDs, missing fields, structural errors |
| sdd-explore thinking | `thinking.type: "enabled"` | Keep disabled | Consistent with other planning-phase agents needing reasoning depth |
| sdd-onboard visibility | `hidden: false` | Keep hidden | Onboarding should be discoverable by users |
| Archive orphaned fields | Remove `temperature` and `top_p` from `sdd-archive` | Keep them | Non-standard OpenCode schema fields, accidentally included |
| Verification gate | `test_command` in `config.yaml` + agent prompt instruction | Hard-code into prompt | Declarative config, not embedded system prompt |

## Data Flow

```
User edits → schema validate → backup global → apply both configs
                                                    ↓
                                        create missing instruction files
                                                    ↓
                                        post-edit verify (agent list,
                                        checksum backup, run one SDD task)
```

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `~/.config/opencode/opencode.json` | Modify | Swap provider; reroute 27 SDD agents + orchestrator to OpenAI models; enable thinking on sdd-explore; unhide sdd-onboard; remove temperature/top_p from sdd-archive |
| `DreamcoderOpenCode/.config/opencode/opencode.json` | Modify | Same provider swap; reroute 10 SDD agents + orchestrator; enable thinking; unhide sdd-onboard; create missing instructions dir + files |
| `DreamcoderOpenCode/.config/opencode/instructions/morph-tools.md` | Create | Copy from global scope |
| `DreamcoderOpenCode/.config/opencode/AGENTS.md` | Create | Copy from repo root |
| `~/.config/opencode/opencode.json.bak` | Create | Pre-edit backup for rollback |
| `openspec/config.yaml` | Modify | Add `apply.test_command` field |

## Interfaces / Contracts

**Managed Block Identity Contract** — fields that must be semantically identical across scopes:

```
provider.openai               // identical shape (name, models, no baseURL)
agent.gentle-orchestrator     // model: "openai/gpt-5.6-terra", variant: "medium"
agent.sdd-* (base 10)        // model: "openai/gpt-5.6-luna", variant: "medium"
instructions                  // ["instructions/morph-tools.md", "AGENTS.md"]
```

Scope-surplus fields (excluded from identity): `sdd-*-go`, `sdd-*-gpt` variants (global only); `database`, `devops` agents (global only).

**Model IDs**: `openai/gpt-5.6-terra` variant `medium` (orchestrator); `openai/gpt-5.6-luna` variant `medium` (all sub-agents). No `opencode-go/` prefix in managed block.

## Testing Strategy

| Layer | Approach |
|-------|----------|
| Schema | Validate both configs against `$schema` URL before edit |
| Agent resolution | `opencode agent list` confirms all agents resolve |
| Fallback path | Run one SDD task to confirm Luna works |
| Rollback | `sha256sum` matches between backup and restored file |

**Threat Matrix**: N/A — no routing, shell, subprocess, VCS/PR, or process-integration boundary. Pure static config transformation.

## Migration / Rollout

1. **OAuth precondition**: Run `opencode /connect` to authorize OpenAI before provider swap. Without OAuth, the new config has no working provider.
2. **Backup**: `cp ~/.config/opencode/opencode.json ~/.config/opencode/opencode.json.bak`. Record `sha256sum`.
3. **Validate**: Check both configs against `$schema` URL before any edits.
4. **Apply**: Edit global config, then project config. Create missing instruction files.
5. **Verify**: `opencode agent list` — all agents resolve. Run one SDD task. Compare backup checksum.
6. **Rollback**: Project → `git checkout`. Global → `cp .bak` restore. Re-enable cursor-acp.

## Verification Gate & strict_tdd=false

`test_command` in `config.yaml` is prepended to `sdd-apply` prompt as: *"Before marking each task complete, run `{test_command}` to verify existing behavior."* This is **orthogonal** to `strict_tdd=false`: verification runs available tests as a completion gate; strict TDD would require test-before-code discipline. No contradiction.

## Open Questions

- [ ] Does OpenCode have a built-in validate command, or must we use `ajv` against the published `$schema` URL?
- [ ] What is the exact `provider.openai` config shape for native OpenAI — is it inferred from the `openai/` model prefix or does it require explicit `name`/`npm`/`models` fields?
- [ ] Should Luna variant be `"medium"` (default) or `"low"` for cost-optimal sub-agent execution?
