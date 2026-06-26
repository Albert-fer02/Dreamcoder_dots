"""Terminal UI model for Dreamcoder settings."""

from __future__ import annotations

from typing import Any

from .dashboard import dashboard_report
from .settings_store import settings_get, settings_schema, settings_set, validate_setting_value, validate_settings


def setting_rows() -> list[dict[str, Any]]:
    current = settings_get()
    schema = settings_schema()["settings"]
    rows = []
    for key, spec in schema.items():
        value: Any = current
        for part in key.split("."):
            value = value.get(part) if isinstance(value, dict) else None
        rows.append({
            "key": key,
            "value": value if value is not None else spec.get("default"),
            "default": spec.get("default"),
            "type": spec.get("type"),
            "enum": spec.get("enum", []),
            "description": spec.get("description", ""),
        })
    return rows


def tui_model() -> dict[str, Any]:
    dashboard = dashboard_report()
    validation = validate_settings()
    return {
        "schema": "dreamcoder.tui.v1",
        "title": "Dreamcoder Settings",
        "state": dashboard["state"],
        "health": dashboard["health"]["summary"],
        "settings": setting_rows(),
        "validation": validation,
        "commands": {
            "render": "./scripts/dreamcoder tui render",
            "dry_run_set": "./scripts/dreamcoder tui set <key> <value> --dry-run --json",
            "apply_set": "./scripts/dreamcoder tui set <key> <value> --json",
            "verify": "./scripts/verify.sh",
        },
    }


def tui_render(model: dict[str, Any]) -> str:
    health = model["health"]
    state = model["state"]
    lines = [
        "╭──────────── Dreamcoder Settings ────────────╮",
        f"│ Theme: {state['theme_mode']:<8} Profile: {state['profile']:<16} │",
        f"│ Motion: {state['motion']:<7} Health: {health['ok']} ok / {health['warn']} warn / {health['fail']} fail │",
        "├─────────────────────────────────────────────┤",
    ]
    for row in model["settings"]:
        allowed = f" ({', '.join(row['enum'])})" if row["enum"] else ""
        lines.append(f"│ {row['key']:<24} = {str(row['value']):<10} │")
        lines.append(f"│   {row['description']}{allowed}"[:45].ljust(45) + "│")
    lines.extend([
        "├─────────────────────────────────────────────┤",
        "│ Apply: dreamcoder tui set <key> <value>     │",
        "│ Safe: add --dry-run --json before applying  │",
        "╰─────────────────────────────────────────────╯",
    ])
    return "\n".join(lines) + "\n"


def tui_apply_setting(key: str, value: str, dry_run: bool) -> dict[str, Any]:
    errors = validate_setting_value(key, value)
    if errors:
        raise ValueError("; ".join(errors))
    result: dict[str, Any] = {
        "schema": "dreamcoder.tui-apply.v1",
        "dry_run": dry_run,
        "key": key,
        "value": value,
        "valid": True,
    }
    if not dry_run:
        result["settings"] = settings_set(key, value)
    return result
