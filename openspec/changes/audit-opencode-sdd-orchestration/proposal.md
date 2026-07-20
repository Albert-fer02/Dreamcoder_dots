# Proposal: Audit OpenCode SDD Orchestration Configuration

## Intent

All 10 SDD agents share `deepseek/deepseek-v4-flash` via `cursor-acp` — no tier differentiation. Migrate to native OpenAI with per-phase routing and a shared managed block (provider, SDD agents, orchestrator, instructions) applied identically at global and project scopes while preserving scope-specific config.

## Scope

### In Scope
- Provider: `cursor-acp` → native OpenAI (`/connect` OAuth). OpenAI-only.
- Model routing: orchestrator `openai/gpt-5.6-terra` variant `medium`; all SDD sub-agents `openai/gpt-5.6-luna` (fallback tier).
- Shared managed block: `providers.openai`, gentle-orchestrator + 10 SDD agents, instructions refs — synced to global `~/.config/opencode/`. Preserve per-scope non-SDD agents (dangerous-gentleman, architect, security-reviewer, tester).
- Fixes: `sdd-explore.thinking.type = enabled`, `sdd-onboard.hidden = false`, create `instructions/` files.
- Verification gate: `test_command` before apply-phase task-complete.
- Backup-based rollback — no `git checkout` on `~/.config/` files.

### Out of Scope
- LSP, non-SDD agent behavior changes, `gentle-ai` re-init, plugins.

## Capabilities

Config-only — no spec-level capabilities. None under New or Modified.

## Approach

1. **Provider**: Remove `cursor-acp`. Add native `openai` (no `baseURL`). Run `/connect` for OAuth.
2. **Model routing**: Orchestrator → `openai/gpt-5.6-terra` variant `medium`. All sub-agents → `openai/gpt-5.6-luna`.
3. **Shared block**: Extract `providers.openai`, orchestrator + 10 SDD agent definitions, instructions refs. Write to project config. Copy identical block to global. Both scopes retain their non-SDD agents untouched.
4. **Instructions**: Create `instructions/morph-tools.md` referencing global version. Create project `AGENTS.md` with SDD context.
5. **Minor**: Enable thinking on sdd-explore. Unhide sdd-onboard. Remove sdd-archive orphaned temperature/top_p.
6. **Gate**: Prepend `test_command` runner to sdd-apply prompt.

## Affected Areas

| Area | Impact |
|------|--------|
| `DreamcoderOpenCode/.config/opencode/opencode.json` | Modified — provider + SDD routing; non-SDD untouched |
| `~/.config/opencode/opencode.json` | Modified — shared block; global non-SDD untouched |
| `DreamcoderOpenCode/.config/opencode/instructions/` | Created — morph-tools.md + AGENTS.md |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Schema rejects model IDs | Med | Validate against schema pre-landing |
| Shared block drifts between scopes | Med | One-time sync; archive captures block identity |
| Global backup overwritten | Low | Verify checksum before rollback |

## Rollback

1. Project: `git checkout DreamcoderOpenCode/.config/opencode/opencode.json`
2. Global: `cp ~/.config/opencode/opencode.json.bak ~/.config/opencode/opencode.json` (taken at apply start)
3. Re-enable `cursor-acp` from backup
4. Verify: `opencode agent list` resolves all agents

## Dependencies

- `/connect` OAuth before provider swap goes live
- Model IDs validated against current schema

## Success Criteria

- [ ] All SDD agents use distinct OpenAI model IDs (orchestrator != sub-agents)
- [ ] `cursor-acp` removed from both configs
- [ ] `sdd-explore.thinking = enabled`; `sdd-onboard.hidden = false`
- [ ] Project `instructions/` has both files
- [ ] Shared block identical at both scopes; non-SDD agents preserved
- [ ] ≤ 400 changed lines
