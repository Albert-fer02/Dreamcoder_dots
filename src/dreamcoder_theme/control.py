"""Dreamcoder Control Center CLI entrypoint."""

from __future__ import annotations

from dreamcoder_theme.cli_handlers import (
    handle_audit,
    handle_backup,
    handle_dashboard,
    handle_docs,
    handle_installer,
    handle_motion,
    handle_profile,
    handle_repair,
    handle_settings,
    handle_theme,
    handle_tui,
    handle_visual,
)
from dreamcoder_theme.cli_parser import build_parser
from dreamcoder_theme.core import emit
from dreamcoder_theme.doctor import doctor_report


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    if args.cmd == "doctor":
        emit(doctor_report(), args.json)
        return 0
    handlers = {
        "dashboard": handle_dashboard,
        "audit": handle_audit,
        "docs": handle_docs,
        "tui": handle_tui,
        "settings": handle_settings,
        "profile": handle_profile,
        "motion": handle_motion,
        "installer": handle_installer,
        "repair": handle_repair,
        "backup": handle_backup,
        "visual": handle_visual,
        "theme": handle_theme,
    }
    return handlers[args.cmd](args)


if __name__ == "__main__":
    raise SystemExit(main())
