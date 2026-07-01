# Dreamcoder AI Session State
# Detects active AI coding sessions and writes state for Starship prompt.
# Sources: Claude Code (~/.claude/sessions/), OpenCode (~/.opencode/state)
#
# Starship reads ~/.cache/dreamcoder/ai-session.state via custom.ai_session module.
# This script should be called by fish_prompt or via a systemd path unit.

set -l CACHE_DIR "$HOME/.cache/dreamcoder"
mkdir -p "$CACHE_DIR"
set -l STATE_FILE "$CACHE_DIR/ai-session.state"

# Reset state
echo -n >"$STATE_FILE"

# Check Claude Code sessions
set -l CLAUDE_SESSIONS "$HOME/.claude/sessions"
if test -d "$CLAUDE_SESSIONS"
    # Find most recent active session
    set -l latest (command ls -t "$CLAUDE_SESSIONS" 2>/dev/null | head -1)
    if test -n "$latest"
        # Read session metadata for context info
        set -l meta_file "$CLAUDE_SESSIONS/$latest/meta.json"
        if test -f "$meta_file"
            set -l model (jq -r '.model // "claude"' "$meta_file" 2>/dev/null)
            set -l tokens (jq -r '.total_tokens // ""' "$meta_file" 2>/dev/null)
            if test -n "$model"
                if test -n "$tokens"
                    printf '%s %sK' "$model" (math "$tokens / 1000" 2>/dev/null) >"$STATE_FILE"
                else
                    printf '%s' "$model" >"$STATE_FILE"
                end
            end
        end
    end
end

# Check OpenCode sessions (falls through if Claude didn't write state)
if not test -s "$STATE_FILE"
    set -l OPENCODE_STATE "$HOME/.opencode/state"
    if test -f "$OPENCODE_STATE"
        set -l model (jq -r '.model // "opencode"' "$OPENCODE_STATE" 2>/dev/null)
        if test -n "$model" -a "$model" != "null"
            printf '%s' "$model" >"$STATE_FILE"
        end
    end
end
