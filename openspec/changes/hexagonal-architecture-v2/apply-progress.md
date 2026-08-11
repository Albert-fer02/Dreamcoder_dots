# Apply Progress — hexagonal-architecture-v2

## Batch 1 (PR1, Phase 0 + 1) — renderer port + registry

- Phase 0: 32-consumer ID set frozen (from sync.py COVERAGE); sync plan characterization captured (resolved paths/bytes baseline); payload-tree verification of the installer catalog rows flagged by the design validator (codex/pi/antigravity destinations + partial sets) recorded for Phase 3; legacy kebab->Pascal alias map frozen.
- Phase 1: renderer_contract.py (formal Protocol render(palette: dict[str,str]) -> str, RendererRegistration dataclass, closed strategy enums, contract version 1); renderer_adapters.py (TransparentOpenCodeAdapter, NvimDispatcherAdapter, NamedZellijAdapter, VersionedHerdrAdapter); renderer_registry.py (deterministic assembly from 18 leaf modules, validation: duplicates/contract version/modes/ownership/strategy/renderer conformance, EXPECTED_CONSUMER_IDS 32-set, purity).
- All 32 consumers registered (adjacent REGISTRATIONS tuples in leaf modules; special consumers via adapters: opencode active, zellij named, nvim dispatcher, herdr versioned, matugen active-only bridges).
- Tests: test_renderer_contract.py, test_renderer_registry.py, test_registry_bijection.py, test_registry_purity.py (bijection exact 32, purity spies, conformance per mode).
- Gate: 501 passed (+31 subtests), ruff clean, mypy clean (53 files), format clean, health exit 0, bats 23/23.
- Deviations: the sdd-apply subagent was interrupted twice leaving the tree broken (renderers_extra_shell IndentationError, 13 modules missing REGISTRATIONS, fixture-ordering bug in a purity test); the parent completed the registrations (8 modules), fixed the syntax/purity issues, and hoisted noqa'd intentional lazy imports. Also fixed a live user-reported breakage of `dreamcoder light` (IndentationError) caused by the interrupted edit.
- Remaining phases: 2 (sync registry declarativo), 3 (installer SSOT), 4 (migration), 5 (validation+docs).
