#!/bin/bash

# Dreamcoder theme colors (ANSI 256)
PRIMARY='\033[38;5;51m'       # #00e5ff Neon Cyan
ACCENT='\033[38;5;220m'      # #ffd166 Gold
SECONDARY='\033[38;5;147m'    # Light Purple
MUTED='\033[38;5;242m'        # Grey
SUCCESS='\033[38;5;150m'      # Green
ERROR='\033[38;5;174m'        # Pink/Red
PURPLE='\033[38;5;183m'       # Purple
BOLD='\033[1m'
NC='\033[0m'

# Read JSON from stdin
input=$(cat)

# Parse basic fields
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
DIR=$(echo "$input" | jq -r '.workspace.current_dir // "~"')
ADDED=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Context window usage
CTX_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
INPUT_TOKENS=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
CACHE_CREATE=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
CACHE_READ=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')

TOTAL_USED=$((INPUT_TOKENS + CACHE_CREATE + CACHE_READ))
if [ "$CTX_SIZE" -gt 0 ] 2>/dev/null; then
  CTX_PERCENT=$((TOTAL_USED * 100 / CTX_SIZE))
else
  CTX_PERCENT=0
fi

# Directory name
DIR_NAME=$(basename "$DIR")

# Git info
BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
  BRANCH=$(git branch --show-current 2>/dev/null)
fi

# Model icon
MODEL_ICON="🚀"

# Progress bar
BAR_WIDTH=8
FILLED=$((CTX_PERCENT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))

BAR="${PRIMARY}["
for ((i=0; i<FILLED; i++)); do BAR+="="; done
for ((i=0; i<EMPTY; i++)); do BAR+="."; done
BAR+="]${NC}"

# Build status line
SEP="${MUTED} | ${NC}"

LINE="${BOLD}${PRIMARY}${MODEL_ICON} ${MODEL}${NC}"
LINE+="${SEP}"
LINE+="${ACCENT}󰉋 ${DIR_NAME}${NC}"

if [ -n "$BRANCH" ]; then
  LINE+="${SEP}"
  LINE+="${SECONDARY} ${BRANCH}${NC}"
fi

LINE+="${SEP}"
LINE+="${SUCCESS}+${ADDED}${NC} ${ERROR}-${REMOVED}${NC}"

LINE+="${SEP}"
LINE+="${MUTED}ctx ${BAR} ${CTX_PERCENT}%${NC}"

echo -e "${LINE}\033[K"
