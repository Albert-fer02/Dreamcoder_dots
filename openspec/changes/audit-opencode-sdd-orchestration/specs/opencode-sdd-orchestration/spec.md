# Delta for OpenCode SDD Orchestration Configuration

## ADDED Requirements

### Requirement: Native OpenAI Provider

Replace `provider.cursor-acp` with `provider.openai` (no `baseURL`). OAuth via `/connect` MUST complete before activation.

| Scenario | GIVEN | WHEN | THEN |
|----------|-------|------|------|
| Provider swap | `cursor-acp` exists | migration applies | `cursor-acp` absent; `openai` present |
| OAuth gate | `/connect` incomplete | provider set to `openai` | MUST NOT activate |

### Requirement: Model/Variant Routing

Orchestrator MUST use `openai/gpt-5.6-terra` variant `medium`. All 10 SDD sub-agents MUST use `openai/gpt-5.6-luna` variant `medium`. Non-SDD agents unchanged.

| Scenario | GIVEN | WHEN | THEN |
|----------|-------|------|------|
| Orchestrator model | `gentle-orchestrator` defined | migration writes | `model = openai/gpt-5.6-terra`, `variant = medium` |
| SDD sub-agent model | Each of 10 SDD agents | migration writes | `model = openai/gpt-5.6-luna`, `variant = medium` |
| Non-SDD preserved | non-SDD agents exist | migration applies | model + options unchanged |

### Requirement: Shared Managed Block

`providers.openai`, `gentle-orchestrator`, 10 SDD agents, and `instructions` refs MUST be semantically identical across scopes. Each scope MUST preserve its non-SDD agents.

| Scenario | GIVEN | WHEN | THEN |
|----------|-------|------|------|
| Block identity | global + project configs | block extracted | same model/variant/options |
| Scope agents preserved | project has non-SDD agents | shared block written | those agents still present |

### Requirement: Schema Validation Before Edits

Every `opencode.json` write MUST validate against the `$schema` URL declared in that file. Both configs MUST use the same supported schema URL; reject if they differ or validation fails.

| Scenario | GIVEN | WHEN | THEN |
|----------|-------|------|------|
| Valid passes | valid config | validate against its `$schema` URL | pass, file written |
| Invalid rejected | bad model ID or missing field | validate against its `$schema` URL | fail, file NOT written |
| Schema mismatch | configs declare different `$schema` URLs | pre-edit check | migration blocked |

### Requirement: Safe Backup and Rollback

Before any write, create `~/.config/opencode/opencode.json.bak`. Rollback via `cp`, never `git checkout`.

| Scenario | GIVEN | WHEN | THEN |
|----------|-------|------|------|
| Backup created | migration about to write | pre-write backup runs | `.bak` exists, checksum matches |
| Rollback restores | migration failed | `cp .bak` to original | byte-identical |

### Requirement: Remove cursor-acp

`cursor-acp` MUST be absent from both configs after migration.

| Scenario | GIVEN | WHEN | THEN |
|----------|-------|------|------|
| cursor-acp absent | migration complete | inspect both configs | `cursor-acp` key absent |

### Requirement: Verification Before Apply Completion

Apply MUST run `test_command` before task completion. Failures block it.

| Scenario | GIVEN | WHEN | THEN |
|----------|-------|------|------|
| Tests pass | config changes made | `test_command` exits 0 | task MAY be marked complete |
| Tests fail | config changes made | `test_command` exits non-zero | task MUST NOT complete |

### Requirement: Restart Notice

After writing configs, display: "Restart OpenCode for provider and agent changes to take effect."

| Scenario | GIVEN | WHEN | THEN |
|----------|-------|------|------|
| Notice displayed | both configs written | apply phase finishes | notice displayed |

## MODIFIED Requirements

### Requirement: sdd-explore Thinking Mode

`agent.sdd-explore.options.thinking.type` MUST be `"enabled"` with `reasoning_effort: "max"`.
(Previously: `disabled`)

| Scenario | GIVEN | WHEN | THEN |
|----------|-------|------|------|
| Thinking enabled | `sdd-explore` defined | migration applies | `thinking.type = enabled`, `reasoning_effort = max` |

### Requirement: sdd-onboard Visibility

`agent.sdd-onboard.hidden` MUST be `false`.
(Previously: `true`)

| Scenario | GIVEN | WHEN | THEN |
|----------|-------|------|------|
| Unhidden | `sdd-onboard` defined | migration applies | `hidden = false` |

### Requirement: sdd-archive Temperature and top_p

`sdd-archive` MUST NOT have `temperature` or `top_p` fields.
(Previously: `temperature: 0.15`, `top_p: 0.85`)

| Scenario | GIVEN | WHEN | THEN |
|----------|-------|------|------|
| Orphaned fields removed | `sdd-archive` defined | migration applies | `temperature` and `top_p` absent |
