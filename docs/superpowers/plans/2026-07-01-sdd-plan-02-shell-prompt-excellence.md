# SDD Plan 02: Shell Prompt Excellence — Best-in-Class Starship

> **Goal:** Elevate the dreamcoder Starship prompt to be among the best in the world, learning from top references while keeping the dreamcoder visual identity and cross-shell consistency.
> **References:** seifscape/macos-dot-files (AI session state in prompt), Powerlevel10k (instant prompt), devterm-kit (auto-setup), JaKooLit (multi-distro), alohays/dotfiles (agent-friendly)
> **Target files:** `Shell/.config/starship.toml`, `starship-dark.toml`, `starship-light.toml`, `conf.d/20-dreamcoder-prompt.fish`, `.zshrc`, `.bashrc`
> **Priority:** 🔴 CRITICAL — the prompt is what the user sees every single command
> **Estimated diff:** ~400 lines across 6 files

## Context

The prompt is the most-interacted-with UI in any developer's workflow. dreamcoder-dots already has Starship with dark/light variants, but they can be elevated significantly by learning from the best in the world.

### Current state

- `starship.toml` — base config
- `starship-dark.toml` — dark mode colors
- `starship-light.toml` — light mode colors
- `conf.d/20-dreamcoder-prompt.fish` — fish prompt integration
- Works in bash/zsh/fish via `STARSHIP_CONFIG` env var

### What the best prompts do in 2026

| Feature                                                 | Who does it       | dreamcoder has? |
| ------------------------------------------------------- | ----------------- | --------------- |
| **AI session state** (model, context, cost)             | seifscape         | ❌              |
| **Git info** (branch, status, ahead/behind)             | All               | ✅ Basic        |
| **Language version** (node, python, rust, go)           | All               | ✅ Basic        |
| **Command duration**                                    | JaKooLit          | ❌              |
| **Kubernetes context**                                  | Starship default  | ❌              |
| **Terraform workspace**                                 | Starship default  | ❌              |
| **Exit code indicator** (red ✗ on failure)              | All the best ones | ❌              |
| **Time** (24h in prompt)                                | Many              | ✅              |
| **Username + hostname** (conditional, show on SSH only) | Powerlevel10k     | ❌              |
| **Container/VM indicator**                              | alohays           | ❌              |
| **Battery** (on laptop)                                 | ML4W              | ❌              |
| **Nix shell indicator**                                 | Starship default  | ❌              |

## Design Principles (dreamcoder-specific)

1. **Health first**: No information overload. Show what matters, hide the rest.
2. **Visual hierarchy**: The most important info is most visually prominent.
3. **Context-aware**: Show Kubernetes context only when in a k8s directory.
4. **Speed**: Starship modules load lazily. No blocking calls.
5. **Consistency**: Same prompt in fish, zsh, and bash.
6. **Dark/Light**: Two complete color schemes adapted from tokens.json.

## Prompt Architecture

```
┌──────────────────────────────────────────────────────────────┐
│ $ctx  $git_branch  $git_status  $lang  $time  ❯            │
│  cyan    accent      subtle      diag   muted                │
│                                                              │
│ $cmd_duration  $exit_code  $battery                          │
│  (line 2, only shown when relevant)                          │
└──────────────────────────────────────────────────────────────┘
```

### Module Plan

| Module           | Condition                   | dark color | light color | Priority     |
| ---------------- | --------------------------- | ---------- | ----------- | ------------ |
| **username**     | Only on SSH                 | `#5f95ca`  | `#0d4a68`   | 🟢 Optional  |
| **hostname**     | Only on SSH                 | `#d99555`  | `#824f16`   | 🟢 Optional  |
| **directory**    | Always, truncated           | `#e8dfd0`  | `#17120d`   | ✅ Required  |
| **git_branch**   | In git repo                 | `#d99555`  | `#824f16`   | ✅ Required  |
| **git_status**   | In git repo                 | `#b8a99a`  | `#725e4c`   | ✅ Required  |
| **package**      | Has package.json/Cargo.toml | `#5f95ca`  | `#0d4a68`   | 🟡 Nice      |
| **node_version** | .nvmrc or .node-version     | `#5f95ca`  | `#0d4a68`   | 🟡 Nice      |
| **python_venv**  | Virtual env active          | `#4db35f`  | `#3d723d`   | 🟡 Nice      |
| **rust_version** | Cargo project               | `#c96a45`  | `#a7471c`   | 🟡 Nice      |
| **go_version**   | Go project                  | `#5f95ca`  | `#0d4a68`   | 🟡 Nice      |
| **terraform**    | Terraform dir               | `#a87cb5`  | `#57478b`   | 🟢 Optional  |
| **kubernetes**   | kube context                | `#5f95ca`  | `#0d4a68`   | 🟢 Optional  |
| **cmd_duration** | > 2 seconds                 | `#b8a99a`  | `#725e4c`   | ✅ Required  |
| **exit_code**    | Non-zero                    | `#ed8a7a`  | `#842f24`   | ✅ Required  |
| **time**         | Always (24h)                | `#938274`  | `#554638`   | 🟡 Subdued   |
| **line_break**   | Always                      | —          | —           | ✅ Required  |
| **battery**      | Laptop, < 20%               | `#ed8a7a`  | `#842f24`   | 🟢 Optional  |
| **shell**        | Always                      | `#d99555`  | `#824f16`   | 🟡 Character |
| **ai_session**   | Claude/Codex active         | `#5f95ca`  | `#0d4a68`   | 🔬 **New**   |

### AI Session State Module (NEW — cutting edge)

This is what makes dreamcoder STAND OUT. Nobody in the dotfiles world has a prompt that shows AI session state... except seifscape who just started doing it in 2026.

```toml
[custom.ai_session]
command = "~/.config/dreamcoder/scripts/ai-session-status.sh"
when = """test -f ~/.config/dreamcoder/ai-session.env"""
format = "[⎔ $output]($style)"
style = "bold cyan"
```

The script would read:

- `CLAUDE_SESSION_ID` or `OPENCODE_SESSION_ID`
- Token count / context usage
- Cost estimate

This is bleeding edge. Nobody else ships this as a dotfile feature.

## Acceptance Criteria

1. Starship prompt renders in fish, zsh, and bash identically (except shell-specific features)
2. Dark mode: warm dark background (`#100f0d`), warm gold accents (`#d99555`)
3. Light mode: paper background (`#f3eadc`), brown accents (`#824f16`)
4. Git info shows branch name + dirty/clean status
5. Language version shows for node/python/rust/go when in relevant project
6. Exit code turns red on command failure
7. Command duration shows for slow commands (> 2s)
8. AI session state shows when Claude/OpenCode is active
9. All module colors come from dreamcoder `tokens.json`
10. Battery shows on laptop when below 20%
11. Prompt renders in < 50ms (Starship lazy loading)

## Tasks

### Task 1: Starship TOML Architecture

- Redesign `starship.toml` as the single source of truth
- `starship-dark.toml` → only color overrides for dark mode
- `starship-light.toml` → only color overrides for light mode
- Enable all desired modules with proper `when` conditions

### Task 2: Core Modules

- directory, git_branch, git_status, package, node_version, python_venv
- rust_version, go_version, cmd_duration, exit_code, time, line_break

### Task 3: Advanced Modules

- username/hostname (conditional on SSH)
- kubernetes context, terraform workspace
- battery indicator
- shell character

### Task 4: AI Session State (bleeding edge)

- Create `scripts/ai-session-status.sh` — reads Claude/OpenCode session state
- Create `conf.d/25-dreamcoder-ai-env.fish` — sets env vars for AI state
- Update `.zshrc` and `.bashrc` for AI state in zsh/bash
- Add custom Starship module for AI session

### Task 5: Shell Integration Cleanup

- Ensure `STARSHIP_CONFIG` switch works on dark/light toggle in ALL shells
- `conf.d/20-dreamcoder-prompt.fish` — clean up, add path detection
- `.zshrc` — verify p10k compatibility (if user uses p10k instead)
- `.bashrc` — verify starship works in bash too

### Task 6: Verification

- Visual diff in dark and light modes
- Time prompt rendering speed
- Test in fish, zsh, bash
- Test on SSH session (username/hostname shows)
- Test AI session module

## Risks

- **Starship version**: New modules may require latest Starship — pin minimum version
- **AI session state**: Claude/OpenCode don't expose session state as files yet — may need polling or env vars
- **Shell differences**: Nushell prompt config is completely different from Fish/Zsh — document limitation
- **Color consistency**: Each module must use the EXACT color from tokens.json — use the token names, not eyeballed colors

## References

- Current configs: `starship.toml`, `starship-dark.toml`, `starship-light.toml`
- Current integration: `conf.d/20-dreamcoder-prompt.fish`
- seifscape/macos-dot-files: AI session in prompt (reference only)
- Starship docs: <https://starship.rs/config/>
- Tokens: `themes/dreamcoder/tokens.json` (accent, diagnostic, error colors)
