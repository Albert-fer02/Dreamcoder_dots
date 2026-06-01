"""Visual regression planning for Dreamcoder UI targets."""

from __future__ import annotations

from pathlib import Path
from typing import Any

BASELINE_DIR = Path("docs/visual-regression/baselines")

TARGETS = [
    ("neovim", "Neovim editor", "themes/dreamcoder/nvim-dreamcoder.lua", "manual: open sample buffers and capture Neovim window"),
    ("kitty", "Kitty terminal", "Kitty/.config/kitty/colors-dreamcoder.conf", "manual: open themed Kitty and capture terminal window"),
    ("ghostty", "Ghostty terminal", "Ghostty/.config/ghostty/themes/dreamcoder", "manual: open themed Ghostty and capture terminal window"),
    ("waybar", "Waybar desktop bar", "themes/dreamcoder/waybar-light.css", "manual: capture top bar after applying mode"),
    ("rofi", "Rofi launcher", "themes/dreamcoder/rofi-light.rasi", "manual: open Rofi theme preview and capture launcher"),
    ("codex-cli", "Codex CLI theme", "Codex-CLI/Dreamcoder.tmTheme", "manual: open Codex CLI sample session and capture terminal"),
    ("opencode", "opencode TUI theme", ".opencode/themes/dreamcoder.json", "manual: open opencode sample session and capture terminal"),
]


def visual_plan() -> dict[str, Any]:
    """Return screenshot baseline targets and capture instructions."""
    targets = [
        {
            "key": key,
            "label": label,
            "source": source,
            "baseline": str(BASELINE_DIR / f"{key}.png"),
            "capture_command": command,
        }
        for key, label, source, command in TARGETS
    ]
    return {
        "schema": "dreamcoder.visual-regression-plan.v1",
        "baseline_dir": str(BASELINE_DIR),
        "targets": targets,
        "readiness": {
            "required_targets": len(targets),
            "policy": "Every palette or renderer change should refresh matching screenshots before release.",
        },
    }


def visual_markdown(report: dict[str, Any]) -> str:
    """Render the visual regression plan as Markdown."""
    rows = ["| Target | Source | Baseline | Capture command |", "| --- | --- | --- | --- |"]
    for target in report["targets"]:
        rows.append(
            f"| {target['label']} | `{target['source']}` | `{target['baseline']}` | {target['capture_command']} |"
        )
    return "\n".join([
        "# Dreamcoder Visual Regression Plan",
        "",
        "Screenshot baselines catch visual regressions that token tests cannot see.",
        "",
        f"Baseline directory: `{report['baseline_dir']}`",
        "",
        *rows,
        "",
        "Release gate: refresh affected baselines after any palette, renderer, or layout change.",
        "",
    ])
