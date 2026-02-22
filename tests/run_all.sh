#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

pass=0
fail=0

test_case() {
    local name="$1"
    local result="$2"
    if [[ "$result" == "pass" ]]; then
        echo "✓ $name"
        ((pass++)) || true
    else
        echo "✗ $name"
        ((fail++)) || true
    fi
    return 0
}

echo "=== Dreamcoder Dotfiles Tests ==="
echo ""

# Test: Shell modules exist
echo "--- Core Modules ---"
for f in core aliases functions; do
    [[ -d "$ROOT_DIR/shell/.config/shell/$f" ]] && test_case "shell/$f exists" "pass" || test_case "shell/$f exists" "fail"
done

# Test: Config files exist
echo "--- Config Files ---"
[[ -f "$ROOT_DIR/shell/.zshrc" ]] && test_case ".zshrc exists" "pass" || test_case ".zshrc exists" "fail"
[[ -f "$ROOT_DIR/shell/.bashrc" ]] && test_case ".bashrc exists" "pass" || test_case ".bashrc exists" "fail"
[[ -f "$ROOT_DIR/kitty/.config/kitty/kitty.conf" ]] && test_case "kitty.conf exists" "pass" || test_case "kitty.conf exists" "fail"
[[ -f "$ROOT_DIR/nvim/.config/nvim/init.lua" ]] && test_case "nvim/init.lua exists" "pass" || test_case "nvim/init.lua exists" "fail"
[[ -f "$ROOT_DIR/tmux/.tmux.conf" ]] && test_case ".tmux.conf exists" "pass" || test_case ".tmux.conf exists" "fail"
[[ -f "$ROOT_DIR/gitconfig/.config/git/config" ]] && test_case "git/config exists" "pass" || test_case "git/config exists" "fail"

# Test: Shell syntax
echo "--- Syntax Validation ---"
for f in "$ROOT_DIR"/shell/.config/shell/*/*.sh; do
    [[ -f "$f" ]] || continue
    if bash -n "$f" 2>/dev/null; then
        test_case "$(basename $f) syntax" "pass"
    else
        test_case "$(basename $f) syntax" "fail"
    fi
done

# Test: Main shell configs syntax
bash -n "$ROOT_DIR/shell/.bashrc" 2>/dev/null && test_case ".bashrc syntax" "pass" || test_case ".bashrc syntax" "fail"
zsh -n "$ROOT_DIR/shell/.zshrc" 2>/dev/null && test_case ".zshrc syntax" "pass" || test_case ".zshrc syntax" "fail"

# Test: install.sh exists and is executable
echo "--- Scripts ---"
[[ -x "$ROOT_DIR/scripts/install.sh" ]] && test_case "install.sh executable" "pass" || test_case "install.sh executable" "fail"
[[ -f "$ROOT_DIR/Makefile" ]] && test_case "Makefile exists" "pass" || test_case "Makefile exists" "fail"

# Summary
echo ""
echo "=== Summary ==="
echo "Passed: $pass"
echo "Failed: $fail"

[[ $fail -eq 0 ]] && exit 0 || exit 1
