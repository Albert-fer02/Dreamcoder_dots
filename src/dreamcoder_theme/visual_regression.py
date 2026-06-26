"""Visual regression planning and auditing for Dreamcoder UI targets."""

from __future__ import annotations

import os
from pathlib import Path
from typing import Any

BASELINE_DIR = Path("docs/visual-regression/baselines")

TARGETS = [
    (
        "neovim",
        "Neovim editor",
        "themes/dreamcoder/nvim-dreamcoder.lua",
        "manual: open sample buffers and capture Neovim window",
    ),
    (
        "kitty",
        "Kitty terminal",
        "Kitty/.config/kitty/colors-dreamcoder.conf",
        "manual: open themed Kitty and capture terminal window",
    ),
    (
        "ghostty",
        "Ghostty terminal",
        "Ghostty/.config/ghostty/themes/dreamcoder",
        "manual: open themed Ghostty and capture terminal window",
    ),
    (
        "waybar",
        "Waybar desktop bar",
        "themes/dreamcoder/waybar-light.css",
        "manual: capture top bar after applying mode",
    ),
    (
        "rofi",
        "Rofi launcher",
        "themes/dreamcoder/rofi-light.rasi",
        "manual: open Rofi theme preview and capture launcher",
    ),
    (
        "codex-cli",
        "Codex CLI theme",
        "Codex-CLI/Dreamcoder.tmTheme",
        "manual: open Codex CLI sample session and capture terminal",
    ),
    (
        "opencode",
        "opencode TUI theme",
        ".opencode/themes/dreamcoder.json",
        "manual: open opencode sample session and capture terminal",
    ),
    (
        "bat",
        "bat syntax viewer",
        "Bat/.config/bat/themes/Dreamcoder-Light.tmTheme",
        "manual: run bat against shell/python/markdown samples",
    ),
    (
        "delta",
        "delta git diff",
        "themes/dreamcoder/delta-dreamcoder-light.gitconfig",
        "manual: preview git diff with additions/deletions",
    ),
    (
        "fzf",
        "fzf picker",
        "themes/dreamcoder/fzf-dreamcoder-light.sh",
        "manual: open fzf with preview window",
    ),
    (
        "btop",
        "btop monitor",
        "themes/dreamcoder/btop-dreamcoder-light.theme",
        "manual: open btop and capture process + graph panels",
    ),
    (
        "dunst",
        "Dunst notifications",
        "themes/dreamcoder/dunst-dreamcoder-light.conf",
        "manual: trigger low/normal/critical notifications",
    ),
    (
        "cava",
        "Cava visualizer",
        "themes/dreamcoder/cava-dreamcoder-light.config",
        "manual: capture Cava bars on light terminal",
    ),
    (
        "obsidian",
        "Obsidian notes",
        "themes/dreamcoder/obsidian-dreamcoder-light.css",
        "manual: capture note, code block, and callout",
    ),
    (
        "firefox",
        "Firefox chrome",
        "themes/dreamcoder/firefox-dreamcoder-light.css",
        "manual: capture toolbar, tabs, and page chrome",
    ),
]


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


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


def visual_audit() -> dict[str, Any]:
    """Return source, baseline, and runtime readiness for visual QA."""
    root = _repo_root()
    plan = visual_plan()
    sources = [
        {
            "key": target["key"],
            "path": target["source"],
            "exists": (root / target["source"]).exists(),
        }
        for target in plan["targets"]
    ]
    baselines = [
        {
            "key": target["key"],
            "path": target["baseline"],
            "exists": (root / target["baseline"]).exists(),
        }
        for target in plan["targets"]
    ]
    home = Path(os.environ.get("HOME", str(Path.home())))
    runtime = {
        "kitty_ui": (home / ".config/kitty/dreamcoder-ui.conf").exists(),
        "ghostty_config": (home / ".config/ghostty/config").exists(),
        "fish_icon_hook": (home / ".config/fish/conf.d/16-dreamcoder-icons.fish").exists(),
        "bat_themes": all(
            (home / f".config/bat/themes/{name}").exists()
            for name in [
                "Dreamcoder.tmTheme",
                "Dreamcoder-Light.tmTheme",
                "Dreamcoder-Dark.tmTheme",
            ]
        ),
    }
    ready = (
        all(item["exists"] for item in sources)
        and all(item["exists"] for item in baselines)
        and all(runtime.values())
    )
    return {
        "schema": "dreamcoder.visual-audit.v1",
        "checks": {"sources": sources, "baselines": baselines, "runtime": runtime},
        "readiness": {
            "ready": ready,
            "source_files": f"{sum(item['exists'] for item in sources)}/{len(sources)}",
            "screenshot_baselines": f"{sum(item['exists'] for item in baselines)}/{len(baselines)}",
            "policy": "Missing baselines block top-tier visual release readiness but not local theme usage.",
        },
    }


def visual_markdown(report: dict[str, Any]) -> str:
    """Render the visual regression plan as Markdown."""
    rows = ["| Target | Source | Baseline | Capture command |", "| --- | --- | --- | --- |"]
    for target in report["targets"]:
        rows.append(
            f"| {target['label']} | `{target['source']}` | `{target['baseline']}` | {target['capture_command']} |"
        )
    return "\n".join(
        [
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
        ]
    )


def visual_audit_markdown(report: dict[str, Any]) -> str:
    """Render visual audit as operator Markdown."""
    rows = ["| Check | Status |", "| --- | --- |"]
    for item in report["checks"]["sources"]:
        rows.append(f"| Source `{item['path']}` | {'ok' if item['exists'] else 'missing'} |")
    rows.append("| Screenshot baselines | " + report["readiness"]["screenshot_baselines"] + " |")
    rows.append(
        "| Runtime contracts | "
        + ("ok" if all(report["checks"]["runtime"].values()) else "attention")
        + " |"
    )
    return "\n".join(
        [
            "# Dreamcoder Visual Audit",
            "",
            f"Ready: `{report['readiness']['ready']}`",
            "",
            *rows,
            "",
        ]
    )
