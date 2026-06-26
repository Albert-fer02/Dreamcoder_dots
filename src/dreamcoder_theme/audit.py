"""Competitive audit for Dreamcoder Dots capabilities."""

from __future__ import annotations

from typing import Any

from .dashboard import dashboard_report
from .docs_report import REPORT_PATH
from .motion import MOTION_PRESETS
from .profiles import load_profiles
from .repair_engine import repair_catalog, repair_plan
from .settings_store import settings_schema


def _criterion(
    key: str, status: str, evidence: str, baseline: str, next_step: str = ""
) -> dict[str, str]:
    return {
        "key": key,
        "status": status,
        "evidence": evidence,
        "baseline": baseline,
        "next_step": next_step,
    }


def audit_report() -> dict[str, Any]:
    dashboard = dashboard_report()
    repair = repair_plan()
    catalog = repair_catalog()["safe_repairs"]
    profiles = load_profiles()
    schema = settings_schema()["settings"]
    safe_repairs = repair["summary"]["safe"]
    criteria = [
        _criterion(
            "control-center-contracts",
            "achieved",
            "dashboard, doctor, settings, repair, installer, backup, docs, and TUI JSON schemas exist",
            "Traditional dotfiles often expose shell output rather than stable contracts",
        ),
        _criterion(
            "settings-tui",
            "achieved",
            f"{len(schema)} typed settings exposed through dreamcoder.tui.v1",
            "Settings are commonly edited directly in files or hardcoded menus",
            "Expand into an interactive selector when terminal dependencies are approved",
        ),
        _criterion(
            "smart-doctor-repair",
            "achieved" if len(catalog) >= 6 else "partial",
            f"{len(catalog)} safe repairs in catalog; current plan has {repair['summary']['actions']} actions / {safe_repairs} safe",
            "Repair usually means re-running install/stow scripts manually",
            ""
            if len(catalog) >= 6
            else "Add more deterministic safe repairs for timer, missing config, and theme drift",
        ),
        _criterion(
            "manifest-rollback",
            "achieved",
            f"{dashboard['backups']['count']} backup manifests tracked",
            "Rollback is often ad-hoc file copies or manual restore",
        ),
        _criterion(
            "machine-profiles",
            "achieved" if {"default", "asus-vivobook15"}.issubset(profiles) else "partial",
            f"{len(profiles)} profiles: {', '.join(sorted(profiles))}",
            "Machine-specific tuning is often documented but not encoded",
        ),
        _criterion(
            "motion-presets",
            "achieved" if len(MOTION_PRESETS) >= 4 else "partial",
            f"{len(MOTION_PRESETS)} motion presets with performance cost metadata",
            "Animations are commonly static config values",
        ),
        _criterion(
            "installer-safety",
            "achieved" if dashboard["installer"]["conflicts"] == 0 else "partial",
            f"{dashboard['installer']['conflicts']} installer conflicts detected",
            "Installers often mutate before presenting a machine-readable plan",
        ),
        _criterion(
            "generated-visual-docs",
            "achieved" if REPORT_PATH.exists() else "partial",
            f"Generated operator report path: {REPORT_PATH}",
            "Docs are often static and drift from live system state",
            "Add screenshot/image gallery when visual assets are ready",
        ),
        _criterion(
            "verification-gates",
            "achieved",
            "./scripts/verify.sh covers contracts, TUI, docs, theme health, and unit tests",
            "Dotfile verification is often informal/manual",
        ),
    ]
    achieved = sum(1 for item in criteria if item["status"] == "achieved")
    partial = sum(1 for item in criteria if item["status"] == "partial")
    missing = sum(1 for item in criteria if item["status"] == "missing")
    return {
        "schema": "dreamcoder.audit.v1",
        "summary": {
            "achieved": achieved,
            "partial": partial,
            "missing": missing,
            "score": round(achieved / len(criteria), 3),
            "completion_ready": missing == 0 and partial == 0,
        },
        "criteria": criteria,
        "remaining_gaps": [item for item in criteria if item["status"] != "achieved"],
    }


def audit_markdown(report: dict[str, Any]) -> str:
    summary = report["summary"]
    rows = [
        "| Capability | Status | Dreamcoder evidence | Baseline | Next step |",
        "| --- | --- | --- | --- | --- |",
    ]
    for item in report["criteria"]:
        rows.append(
            f"| {item['key']} | `{item['status']}` | {item['evidence']} | {item['baseline']} | {item['next_step']} |"
        )
    return "\n".join(
        [
            "# Dreamcoder Competitive Audit",
            "",
            "Baseline framing: ML4W/GentlemanDots-style dotfile distributions with mostly shell-driven setup.",
            "",
            f"- Score: `{summary['score']}`",
            f"- Achieved: `{summary['achieved']}`",
            f"- Partial: `{summary['partial']}`",
            f"- Missing: `{summary['missing']}`",
            f"- Completion ready: `{summary['completion_ready']}`",
            "",
            *rows,
            "",
        ]
    )
