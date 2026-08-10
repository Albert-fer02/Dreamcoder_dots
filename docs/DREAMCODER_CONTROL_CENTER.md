# Dreamcoder Control Center

← Back to [docs/README.md](README.md)

Dreamcoder Dots is moving from loose dotfiles to an operator-grade desktop product. The Control Center provides stable JSON contracts for automation and Markdown output for humans.

## Quick path

1. Inspect the system: `./scripts/dreamcoder doctor-json` and `./scripts/dreamcoder dashboard --json`
2. Preview any change with `--dry-run` before applying it
3. Read the generated report at `docs/generated/DREAMCODER_OPERATOR_REPORT.md`

## Visual dashboard

```text
┌──────────────────────── Dreamcoder Control Center ────────────────────────┐
│ State   │ theme mode, active profile, active motion preset, settings path  │
│ Health  │ doctor summary: ok / warn / fail / skip                          │
│ Safety  │ installer conflicts, managed targets, repair actions, backups    │
│ Actions │ doctor, repair, profile, motion, installer, verify commands      │
└────────────────────────────────────────────────────────────────────────────┘
```

Run it locally:

```bash
./scripts/dreamcoder dashboard --markdown
./scripts/dreamcoder dashboard --json
./scripts/dreamcoder tui render
./scripts/dreamcoder tui render --json
./scripts/dreamcoder tui set terminal.default_mode light --dry-run --json
./scripts/dreamcoder docs report --markdown
./scripts/dreamcoder docs report --write --json
./scripts/dreamcoder audit compare --markdown
./scripts/dreamcoder audit compare --json
```

## Contracts

| Command | Schema | Purpose |
| --- | --- | --- |
| `doctor-json` | `dreamcoder.doctor.v1` | Health checks with actionable repair commands. |
| `dashboard --json` | `dreamcoder.dashboard.v1` | Single operator summary for future TUI/GUI surfaces. |
| `tui render --json` | `dreamcoder.tui.v1` | Terminal settings UI model generated from dashboard and settings schema. |
| `tui set --json` | `dreamcoder.tui-apply.v1` | Preview or apply one settings value through the terminal UI contract. |
| `docs report --json` | `dreamcoder.docs-report.v1` | Visual operator report data for generated documentation. |
| `audit compare --json` | `dreamcoder.audit.v1` | Capability scoring and remaining gaps against dotfile baselines. |
| `settings schema --json` | `dreamcoder.settings-schema.v1` | Typed settings contract for future TUI/GUI forms. |
| `settings validate --json` | `dreamcoder.settings-validation.v1` | Validates persisted settings before apply/repair flows. |
| `repair catalog --json` | `dreamcoder.repair-catalog.v1` | Lists deterministic safe repairs available to the engine. |
| `repair plan --json` | `dreamcoder.repair-plan.v1` | Separates safe automatic repairs from manual actions. |
| `repair apply --json` | `dreamcoder.repair-apply.v1` | Applies only safe repairs after creating a backup manifest. |
| `installer plan --json` | `dreamcoder.install-plan.v1` | Classifies managed, missing, and conflicting stow targets. |
| `backup create/list/restore --json` | `dreamcoder.backup.v1` | Manifest-based rollback for risky changes. |

## Safety checklist

- [ ] Inspect first: `doctor-json`, `dashboard --json`, and `installer plan --json` do not mutate user files.
- [ ] Preview risky changes: profile, motion, backup restore, and repair support dry-run flows.
- [ ] Back up before mutation: profile apply, motion apply, repair apply, install, and repair create manifest backups.
- [ ] Keep manual boundaries: only deterministic low-risk repairs are automatic; system services and installer conflicts stay manual until reviewed.

## Quality gates

```bash
./scripts/verify.sh
python -m unittest tests/test_dreamcoder_control_center.py
./scripts/dreamcoder doctor-json
./scripts/dreamcoder dashboard --json
./scripts/dreamcoder tui render --json
./scripts/dreamcoder tui set terminal.default_mode light --dry-run --json
./scripts/dreamcoder docs report --json
./scripts/dreamcoder docs report --markdown
./scripts/dreamcoder audit compare --json
./scripts/dreamcoder audit compare --markdown
./scripts/dreamcoder settings schema --json
./scripts/dreamcoder settings validate --json
./scripts/dreamcoder repair catalog --json
./scripts/dreamcoder repair plan --json
```

The dashboard is intentionally terminal-first today. A future TUI/GUI should consume `dreamcoder.dashboard.v1` instead of scraping human output. Generated visual docs live at `docs/generated/DREAMCODER_OPERATOR_REPORT.md` after running `./scripts/dreamcoder docs report --write --json`.
