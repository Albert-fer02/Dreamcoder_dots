"""Visual documentation report generation."""

from __future__ import annotations

from pathlib import Path
from typing import Any

from .dashboard import dashboard_report
from .tui import tui_model, tui_render

REPORT_PATH = Path("docs/generated/DREAMCODER_OPERATOR_REPORT.md")


def docs_report() -> dict[str, Any]:
    dashboard = dashboard_report()
    tui = tui_model()
    health = dashboard["health"]["summary"]
    return {
        "schema": "dreamcoder.docs-report.v1",
        "path": str(REPORT_PATH),
        "status": {
            "theme_mode": dashboard["state"]["theme_mode"],
            "profile": dashboard["state"]["profile"],
            "motion": dashboard["state"]["motion"],
            "health": health,
            "installer_conflicts": dashboard["installer"]["conflicts"],
            "repair_actions": dashboard["repair"]["actions"],
        },
        "sections": [
            "visual-dashboard",
            "terminal-settings-tui",
            "safety-model",
            "quality-gates",
            "competitive-checklist",
        ],
        "contracts": [
            "dreamcoder.dashboard.v1",
            "dreamcoder.tui.v1",
            "dreamcoder.settings-schema.v1",
            "dreamcoder.repair-plan.v1",
            "dreamcoder.install-plan.v1",
            "dreamcoder.backup.v1",
        ],
        "commands": dashboard["commands"],
        "tui_preview": tui_render(tui),
    }


def docs_markdown(report: dict[str, Any]) -> str:
    status = report["status"]
    health = status["health"]
    commands = report["commands"]
    contracts = "\n".join(f"- `{contract}`" for contract in report["contracts"])
    return f"""# Dreamcoder Operator Report

Generated from current machine state and Control Center contracts.

## Visual Dashboard

```text
┌──────────────────────── Dreamcoder Health ────────────────────────┐
│ Theme: {status['theme_mode']:<8} Profile: {status['profile']:<18} │
│ Motion: {status['motion']:<7} Health: {health['ok']} ok / {health['warn']} warn / {health['fail']} fail       │
│ Installer conflicts: {status['installer_conflicts']:<3} Repair actions: {status['repair_actions']:<3}         │
└───────────────────────────────────────────────────────────────────┘
```

## Terminal Settings TUI Preview

```text
{report['tui_preview'].rstrip()}
```

## Safety Model

- Inspect before mutating: doctor, dashboard, installer plan, and TUI render are read-only.
- Preview before writing: TUI set, profile apply, motion apply, repair apply, and backup restore support dry-run flows.
- Back up before mutation: apply flows create `dreamcoder.backup.v1` manifests.
- Keep risky operations manual: installer conflicts and system service changes require operator review.

## Quality Gates

```bash
./scripts/verify.sh
./scripts/dreamcoder doctor-json
./scripts/dreamcoder dashboard --json
./scripts/dreamcoder tui render --json
./scripts/dreamcoder settings validate --json
./scripts/dreamcoder repair plan --json
```

## Contracts

{contracts}

## Competitive Checklist

| Capability | Dreamcoder | ML4W/GentlemanDots baseline |
| --- | --- | --- |
| Machine-readable health | `dreamcoder.doctor.v1` | Usually human shell output |
| Safe repair planning | `dreamcoder.repair-plan.v1` | Mostly manual reapply |
| Settings UI contract | `dreamcoder.tui.v1` + schema | Often hardcoded UI/settings |
| Rollback | Manifest backups | Ad-hoc backups/manual restore |
| Visual docs | Generated operator report | Static docs/screenshots |

## Commands

- Doctor: `{commands['doctor']}`
- Repair plan: `{commands['repair_plan']}`
- Profile preview: `{commands['profile']}`
- Motion preview: `{commands['motion']}`
- Installer plan: `{commands['installer']}`
- Verify: `{commands['verify']}`
"""


def write_docs_report(path: Path = REPORT_PATH) -> dict[str, Any]:
    report = docs_report()
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(docs_markdown(report))
    return {"schema": "dreamcoder.docs-write.v1", "path": str(path), "report": report}
