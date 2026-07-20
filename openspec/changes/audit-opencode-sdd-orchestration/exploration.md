# Exploration: Audit OpenCode SDD Orchestration Configuration

## Current State

The project uses OpenCode v1.18.2 with a custom config at `DreamcoderOpenCode/.config/opencode/opencode.json`. The config defines a `gentle-orchestrator` agent (primary, SDD orchestrator) plus 10 SDD phase sub-agents (sdd-apply, sdd-archive, sdd-design, sdd-explore, sdd-init, sdd-onboard, sdd-propose, sdd-spec, sdd-tasks, sdd-verify), plus additional agents (architect, dangerous-gentleman, security-reviewer, tester).

All agents use `deepseek/deepseek-v4-flash` as their model via the `cursor-acp` provider (OpenAI-compatible at localhost:32124). The OpenSpec SDD config at `openspec/config.yaml` defines project context, rules, and testing capabilities.

## Affected Areas

- `DreamcoderOpenCode/.config/opencode/opencode.json` — OpenCode configuration with SDD agents
- `openspec/config.yaml` — OpenSpec SDD project configuration
- `openspec/project.md` — SDD project context
- `AGENTS.md` — Project-level agent instructions
- `~/.config/opencode/opencode.json` — Global OpenCode configuration
- `~/.config/opencode/instructions/morph-tools.md` — Global instructions
- `~/.config/opencode/AGENTS.md` — Global agent instructions

## Findings

### 1. Model Assignment: All SDD phases use the SAME model
**Status: CONFIGURATION ISSUE**

All 10 SDD phase sub-agents AND the orchestrator use `deepseek/deepseek-v4-flash`. The user's target is GPT 5.6 Medium as orchestrator with remaining SDD roles selected by quality/cost/efficiency. Gentle AI's intended-usage docs explicitly describe multi-mode SDD where different models are assigned to different phases. The current config has no model differentiation.

**Verified**: Read `opencode.json` — every agent has `"model": "deepseek/deepseek-v4-flash"`.

### 2. Model ID Format: `deepseek/deepseek-v4-flash` is non-standard
**Status: CONFIGURATION ISSUE**

The official OpenCode model schema at `https://models.dev/model-schema.json` lists `abacus/deepseek-ai/DeepSeek-V4-Flash` as the canonical ID, not `deepseek/deepseek-v4-flash`. The current ID works because the `cursor-acp` provider is OpenAI-compatible and passes the model name through, but it does not match the official schema. This may cause issues with model picker, variant selection, and cost tracking.

**Verified**: Fetched `https://models.dev/model-schema.json` — the `Model` enum contains `abacus/deepseek-ai/DeepSeek-V4-Flash` but NOT `deepseek/deepseek-v4-flash`.

### 3. Missing `instructions/` directory in project config
**Status: CONFIGURATION ISSUE**

The config references `instructions/morph-tools.md` and `AGENTS.md` in the `instructions` field. These files do not exist at the project config level (`DreamcoderOpenCode/.config/opencode/`). They DO exist at the global level (`~/.config/opencode/`). OpenCode merges project and global config, so the global files are used, but the project-level references are misleading.

**Verified**: `ls -la DreamcoderOpenCode/.config/opencode/instructions/` returns "No such file or directory". `ls -la DreamcoderOpenCode/.config/opencode/AGENTS.md` returns "No such file or directory".

### 4. `sdd-onboard` agent has `hidden: true` but is a user-facing command
**Status: MINOR ISSUE**

The `sdd-onboard` agent is marked `hidden: true`, which hides it from the @ autocomplete menu. However, `/sdd-onboard` is a user-facing SDD command that users should be able to invoke.

**Verified**: Read `opencode.json` — `agent.sdd-onboard.hidden: true`.

### 5. `sdd-archive` and `sdd-explore` have `thinking: disabled`
**Status: CONFIGURATION ISSUE**

The `sdd-archive` and `sdd-explore` agents have `thinking.type: disabled` while other SDD phase agents have `thinking.type: enabled`. The `sdd-explore` agent in particular benefits from reasoning for codebase investigation. The `sdd-archive` agent is more mechanical, so disabling thinking there is reasonable, but `sdd-explore` should have thinking enabled.

**Verified**: Read `opencode.json` — `agent.sdd-explore.options.thinking.type: "disabled"`, `agent.sdd-archive.options.thinking.type: "disabled"`.

### 6. `sdd-archive` has `temperature: 0.15` and `top_p: 0.85`
**Status: MINOR INCONSISTENCY**

The `sdd-archive` agent has explicit `temperature` and `top_p` values while other SDD phase agents do not. This is not necessarily wrong but is inconsistent.

**Verified**: Read `opencode.json` — only `sdd-archive` has `temperature` and `top_p` set.

### 7. `gentle-orchestrator` has `hidden: false` explicitly
**Status: CORRECT**

The orchestrator is correctly set to visible so users can select it via Tab.

### 8. Permission model: `gentle-orchestrator` has restrictive `task` permissions
**Status: CORRECT**

The orchestrator's `task` permission only allows SDD phase sub-agents (sdd-apply, sdd-archive, etc.) and denies all others. This is the correct security model for an orchestrator.

### 9. `dangerous-gentleman` has `mode: primary` with full permissions
**Status: CORRECT**

This is the default agent with full permissions, which is the intended design.

### 10. OpenSpec config has `strict_tdd: false`
**Status: CORRECT**

The project's testing capabilities are properly documented in `openspec/config.yaml` with `strict_tdd: false`, which matches the project's testing setup.

### 11. `cursor-acp` provider model list is extensive but `deepseek-v4-flash` is NOT listed
**Status: CONFIGURATION ISSUE**

The `cursor-acp` provider's `models` object lists many Claude, GPT, Gemini, and Grok models but does NOT include any DeepSeek model entries. The model `deepseek/deepseek-v4-flash` is used at the top level and in all agents, but it has no corresponding entry in the provider's model list. This means the model picker won't show it, and variant/effort selection won't work for it.

**Verified**: Read `opencode.json` — `provider.cursor-acp.models` has no `deepseek-*` keys. Grep confirms zero DeepSeek entries in the models object.

### 12. `share: manual` is set
**Status: CORRECT**

Gentle AI sets OpenCode SDD agent sharing to `disabled` by default for privacy. The config has `share: manual`, which is a reasonable choice.

### 13. `autoupdate: true` is set
**Status: CORRECT**

Auto-update is enabled, which is the recommended setting.

### 14. `snapshot: true` is set
**Status: CORRECT**

Snapshot tracking is enabled, allowing undo/redo of file changes.

## Approaches

1. **Full reconfiguration via gentle-ai TUI** — Run `gentle-ai` to regenerate the OpenCode SDD profile with proper model assignments
   - Pros: Official tooling, handles model IDs correctly, generates proper provider entries
   - Cons: May overwrite custom config, requires re-running gentle-ai
   - Effort: Low

2. **Manual config edits** — Edit `opencode.json` directly to fix model IDs, add provider entries, and differentiate models per phase
   - Pros: Full control, no external tool dependency
   - Cons: Error-prone, may miss schema requirements
   - Effort: Medium

3. **Hybrid: gentle-ai for profile + manual fixes** — Use gentle-ai to generate the base profile, then manually fix any remaining issues
   - Pros: Best of both worlds
   - Cons: Two-step process
   - Effort: Medium

## Recommendation

Use gentle-ai TUI to create proper SDD profiles with model differentiation, then manually verify and fix any remaining issues. This ensures canonical model IDs and proper provider configuration.

## Risks

- **Model ID ambiguity**: Using non-canonical model IDs may cause issues with future OpenCode updates that enforce schema validation.
- **Missing provider model entries**: Without model entries in the provider, the model picker won't show DeepSeek models, making it harder to switch models.
- **All agents same model**: No cost/quality differentiation means expensive phases (design, verify) use the same model as cheap phases (archive, tasks), wasting resources.
- **Instructions resolution**: The missing instructions files at the project level could cause issues if OpenCode changes its config merging behavior.

## Ready for Proposal

Yes — the findings are clear and actionable. The proposal should focus on:
1. Model differentiation strategy (which models for which phases)
2. Model ID normalization
3. Provider model list updates
4. Minor config fixes (thinking, hidden, instructions)
