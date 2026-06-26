"""CLI command handlers for Dreamcoder Control Center."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from dreamcoder_theme.audit import audit_markdown, audit_report
from dreamcoder_theme.backups import create_backup, list_backups, restore_backup
from dreamcoder_theme.core import (
    active_ghostty_config,
    active_hyprland_conf,
    active_hyprland_input_lua,
    active_kitty_ui,
    active_motion_path,
    active_profile_path,
    emit,
    settings_path,
    write_json,
)
from dreamcoder_theme.dashboard import dashboard_markdown, dashboard_report
from dreamcoder_theme.docs_report import docs_markdown, docs_report, write_docs_report
from dreamcoder_theme.installer import installer_plan
from dreamcoder_theme.motion import MOTION_PRESETS, apply_motion_files
from dreamcoder_theme.profiles import apply_profile_files, load_profiles, profile_changes
from dreamcoder_theme.repair_engine import apply_safe_repairs, repair_catalog, repair_plan
from dreamcoder_theme.settings_store import (
    set_nested_setting,
    settings_get,
    settings_schema,
    settings_set,
    validate_settings,
)
from dreamcoder_theme.tui import tui_apply_setting, tui_model, tui_render
from dreamcoder_theme.visual_regression import (
    visual_audit,
    visual_audit_markdown,
    visual_markdown,
    visual_plan,
)


def handle_dashboard(args: argparse.Namespace) -> int:
    report = dashboard_report()
    if args.markdown:
        print(dashboard_markdown(report), end="")
        return 0
    emit(report, args.json)
    return 0


def handle_repair(args: argparse.Namespace) -> int:
    if args.repair_cmd == "catalog":
        emit(repair_catalog(), args.json)
        return 0
    if args.repair_cmd == "plan":
        emit(repair_plan(), args.json)
        return 0
    if args.repair_cmd == "apply":
        emit(apply_safe_repairs(args.dry_run), args.json)
        return 0
    return 2


def handle_tui(args: argparse.Namespace) -> int:
    if args.tui_cmd == "render":
        model = tui_model()
        if args.json:
            emit(model, True)
        else:
            print(tui_render(model), end="")
        return 0
    if args.tui_cmd == "set":
        try:
            result = tui_apply_setting(args.key, args.value, args.dry_run)
        except ValueError as exc:
            print(str(exc), file=sys.stderr)
            return 2
        emit(result, args.json)
        return 0
    return 2


def handle_docs(args: argparse.Namespace) -> int:
    if args.docs_cmd == "report":
        report = docs_report()
        if args.write:
            emit(write_docs_report(), args.json)
        elif args.markdown:
            print(docs_markdown(report), end="")
        else:
            emit(report, args.json)
        return 0
    return 2


def handle_audit(args: argparse.Namespace) -> int:
    if args.audit_cmd == "compare":
        report = audit_report()
        if args.markdown:
            print(audit_markdown(report), end="")
        else:
            emit(report, args.json)
        return 0
    return 2


def handle_visual(args: argparse.Namespace) -> int:
    if args.visual_cmd == "plan":
        report = visual_plan()
        if args.markdown:
            print(visual_markdown(report), end="")
        else:
            emit(report, args.json)
        return 0
    if args.visual_cmd == "audit":
        report = visual_audit()
        if args.markdown:
            print(visual_audit_markdown(report), end="")
        else:
            emit(report, args.json)
        return 0
    return 2


def handle_profile(args: argparse.Namespace) -> int:
    profiles = load_profiles()
    if args.profile_cmd == "list":
        emit({"profiles": profiles}, args.json)
        return 0
    if args.name not in profiles:
        print(f"Unknown profile: {args.name}", file=sys.stderr)
        return 2
    profile = profiles[args.name]
    if args.profile_cmd == "show":
        emit({"profile": profile}, args.json)
        return 0
    planned = profile_changes(profile)
    result = {"dry_run": args.dry_run, "profile": profile, "planned_changes": planned}
    if not args.dry_run:
        manifest = create_backup(
            [
                active_profile_path(),
                settings_path(),
                active_hyprland_conf(),
                active_hyprland_input_lua(),
            ],
            f"profile apply {args.name}",
        )
        write_json(active_profile_path(), profile)
        set_nested_setting("profile.active", args.name)
        set_nested_setting("terminal.default_mode", profile.get("terminal_default_mode", "light"))
        set_nested_setting("motion.active", profile.get("motion_preset", "balanced"))
        apply_profile_files(profile)
        result["backup_id"] = manifest["backup_id"]
    emit(result, args.json)
    return 0


def handle_motion(args: argparse.Namespace) -> int:
    if args.motion_cmd == "list":
        emit({"presets": MOTION_PRESETS}, args.json)
        return 0
    if args.name not in MOTION_PRESETS:
        print(f"Unknown motion preset: {args.name}", file=sys.stderr)
        return 2
    preset = MOTION_PRESETS[args.name]
    if args.motion_cmd == "show":
        emit({"preset": preset}, args.json)
        return 0
    result = {
        "dry_run": args.dry_run,
        "preset": preset,
        "planned_changes": {
            "kitty:cursor_trail": str(preset["kitty_cursor_trail"]),
            "ghostty:cursor_shader": str(preset["ghostty_cursor_shader"]),
            "hyprland:animation": str(preset["hyprland_animation"]),
        },
    }
    if not args.dry_run:
        manifest = create_backup(
            [active_motion_path(), settings_path(), active_kitty_ui(), active_ghostty_config()],
            f"motion apply {args.name}",
        )
        write_json(active_motion_path(), preset)
        set_nested_setting("motion.active", args.name)
        apply_motion_files(preset)
        result["backup_id"] = manifest["backup_id"]
    emit(result, args.json)
    return 0


def handle_settings(args: argparse.Namespace) -> int:
    if args.settings_cmd == "schema":
        emit(settings_schema(), args.json)
        return 0
    if args.settings_cmd == "validate":
        report = validate_settings()
        emit(report, args.json)
        return 0 if report["valid"] else 1
    if args.settings_cmd == "get":
        emit({"key": args.key, "value": settings_get(args.key)}, args.json)
        return 0
    if args.settings_cmd == "list":
        emit({"settings": settings_get()}, args.json)
        return 0
    try:
        emit(settings_set(args.key, args.value), args.json)
        return 0
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        return 2


def handle_installer(args: argparse.Namespace) -> int:
    if args.installer_cmd == "plan":
        emit(installer_plan(), args.json)
        return 0
    return 2


def handle_backup(args: argparse.Namespace) -> int:
    try:
        if args.backup_cmd == "create":
            emit(create_backup([Path(path) for path in args.paths], args.reason), args.json)
            return 0
        if args.backup_cmd == "list":
            emit({"backups": list_backups()}, args.json)
            return 0
        if args.backup_cmd == "restore":
            emit(restore_backup(args.backup_id, args.dry_run), args.json)
            return 0
    except FileNotFoundError as exc:
        print(str(exc), file=sys.stderr)
        return 2
    return 2
