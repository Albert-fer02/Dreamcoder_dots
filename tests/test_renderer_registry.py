"""Renderer registry validation tests (hexagonal-architecture-v2 tasks 1.1/1.3).

Asserts the validation failure modes: duplicate consumer IDs, unsupported
contract versions, empty/undeclared mode sets, non-string renderer results,
invalid output ownership, deterministic assembly, and discovery/conformance
purity (no files written, no selectors/subprocess/installer/settings calls).
"""

from __future__ import annotations

import json
import os
import subprocess
import sys
from pathlib import Path
from typing import cast

from dreamcoder_theme.palette_tokens import VARIANTS
from dreamcoder_theme.renderer_contract import (
    SUPPORTED_CONTRACT_VERSION,
    ActiveStrategy,
    MutationStrategy,
    OutputKind,
    Renderer,
    RendererRegistration,
    RendererStrategy,
    RenderMode,
    RepositoryStrategy,
    SupportedContractVersion,
    SyncDefinition,
)
from dreamcoder_theme.renderer_registry import (
    EXPECTED_CONSUMER_IDS,
    REGISTRATIONS,
    validate_registry,
)
from dreamcoder_theme.renderers_kitty import kitty_content

REPO_ROOT = Path(__file__).resolve().parent.parent
DARK = dict(VARIANTS["dark"])
FROZEN_IDS = frozenset(
    json.loads(
        (Path(__file__).resolve().parent / "fixtures" / "expected_consumer_ids.json").read_text()
    )["expected_consumer_ids"]
)


def make_registration(
    consumer_id: str = "test_consumer",
    renderer: object = kitty_content,
    contract_version: int = SUPPORTED_CONTRACT_VERSION,
    modes: frozenset[str] = frozenset({"dark", "light", "night"}),
    output_kind: str = "active",
    sync: SyncDefinition | None = None,
    summary_label: str = "Test consumer",
) -> RendererRegistration:
    return RendererRegistration(
        consumer_id=consumer_id,
        renderer=cast(Renderer, renderer),
        contract_version=cast(SupportedContractVersion, contract_version),
        modes=cast(frozenset[RenderMode], modes),
        output_kind=cast(OutputKind, output_kind),
        sync=sync
        or SyncDefinition(
            renderer=RendererStrategy.DIRECT_CONTENT,
            active=ActiveStrategy.RESOLVED_ACTIVE_PATH,
            repository=RepositoryStrategy.NO_VARIANTS,
            mutation=MutationStrategy.WRITE_IF_CHANGED,
        ),
        summary_label=summary_label,
    )


class TestExpectedSet:
    def test_expected_set_is_the_frozen_33(self) -> None:
        assert len(EXPECTED_CONSUMER_IDS) == 33
        assert EXPECTED_CONSUMER_IDS == FROZEN_IDS

    def test_registrations_are_an_exact_bijection(self) -> None:
        ids = [r.consumer_id for r in REGISTRATIONS]
        assert len(ids) == 33
        assert set(ids) == FROZEN_IDS
        assert len(set(ids)) == len(ids)
        assert validate_registry(REGISTRATIONS) == []


class TestRegistryValidation:
    def test_duplicate_consumer_id_is_rejected_naming_the_id(self) -> None:
        problems = validate_registry((make_registration("dup"), make_registration("dup")))
        assert any("duplicate" in p and "dup" in p for p in problems)

    def test_unsupported_contract_version_is_rejected(self) -> None:
        problems = validate_registry((make_registration(contract_version=2),))
        assert any("contract version" in p for p in problems)

    def test_empty_mode_set_is_rejected(self) -> None:
        problems = validate_registry((make_registration(modes=frozenset()),))
        assert any("empty" in p for p in problems)

    def test_undeclared_mode_is_rejected(self) -> None:
        problems = validate_registry((make_registration(modes=frozenset({"dark", "solar"})),))
        assert any("unsupported" in p for p in problems)

    def test_non_string_renderer_result_is_rejected_naming_consumer_and_mode(self) -> None:
        def bad_renderer(palette):
            return 42

        problems = validate_registry((make_registration(renderer=bad_renderer),))
        assert any("non-string" in p and "test_consumer" in p for p in problems)

    def test_renderer_that_is_not_callable_is_rejected(self) -> None:
        problems = validate_registry((make_registration(renderer="not-callable"),))
        assert any("callable" in p and "test_consumer" in p for p in problems)

    def test_invalid_output_ownership_is_rejected(self) -> None:
        # output_kind "active" may not declare repository mode variants.
        sync = SyncDefinition(
            renderer=RendererStrategy.DIRECT_CONTENT,
            active=ActiveStrategy.RESOLVED_ACTIVE_PATH,
            repository=RepositoryStrategy.MODE_VARIANTS,
            mutation=MutationStrategy.WRITE_IF_CHANGED,
        )
        problems = validate_registry((make_registration(output_kind="active", sync=sync),))
        assert any("ownership" in p for p in problems)

    def test_repository_only_consumer_with_active_path_is_rejected(self) -> None:
        sync = SyncDefinition(
            renderer=RendererStrategy.DIRECT_CONTENT,
            active=ActiveStrategy.RESOLVED_ACTIVE_PATH,
            repository=RepositoryStrategy.MODE_VARIANTS,
            mutation=MutationStrategy.REPOSITORY_VARIANT_WRITER,
        )
        problems = validate_registry((make_registration(output_kind="repository", sync=sync),))
        assert any("ownership" in p for p in problems)

    def test_active_only_bridge_with_variants_is_rejected(self) -> None:
        sync = SyncDefinition(
            renderer=RendererStrategy.DIRECT_CONTENT,
            active=ActiveStrategy.RESOLVED_ACTIVE_PATH,
            repository=RepositoryStrategy.MODE_VARIANTS,
            mutation=MutationStrategy.ACTIVE_ONLY_BRIDGE,
        )
        problems = validate_registry((make_registration(output_kind="active", sync=sync),))
        assert any("active-only" in p for p in problems)


class TestDeterministicAssembly:
    def test_registrations_are_sorted_by_consumer_id(self) -> None:
        ids = [r.consumer_id for r in REGISTRATIONS]
        assert ids == sorted(ids)

    def test_identical_under_varied_import_order(self) -> None:
        """Same assembly when leaf modules are imported before the registry."""
        snippet = (
            "import json, sys; sys.path.insert(0, {src!r}); {imports}; "
            "from dreamcoder_theme.renderer_registry import REGISTRATIONS; "
            "print(json.dumps([r.consumer_id for r in REGISTRATIONS]))"
        )
        env = dict(os.environ)
        env["PYTHONPATH"] = str(REPO_ROOT / "src")
        registry_first = snippet.format(
            src=str(REPO_ROOT / "src"),
            imports="from dreamcoder_theme.renderer_registry import REGISTRATIONS",
        )
        leaves_first = snippet.format(
            src=str(REPO_ROOT / "src"),
            imports=(
                "from dreamcoder_theme.renderers_kitty import REGISTRATIONS; "
                "from dreamcoder_theme.renderers_extra_nvim import REGISTRATIONS; "
                "from dreamcoder_theme.renderers_herdr import REGISTRATIONS; "
                "from dreamcoder_theme.renderers_hypr_waybar_rofi import REGISTRATIONS"
            ),
        )
        out_a = subprocess.run(
            [sys.executable, "-c", registry_first],
            capture_output=True,
            text=True,
            env=env,
            check=True,
        )
        out_b = subprocess.run(
            [sys.executable, "-c", leaves_first],
            capture_output=True,
            text=True,
            env=env,
            check=True,
        )
        assert (
            json.loads(out_a.stdout) == json.loads(out_b.stdout) == sorted(json.loads(out_a.stdout))
        )


class TestDiscoveryPurity:
    def test_validation_writes_no_files_and_runs_no_selectors(self, monkeypatch, tmp_path) -> None:
        def _forbidden(*args, **kwargs):
            raise AssertionError("side effect during registry discovery/conformance")

        monkeypatch.setattr("subprocess.run", _forbidden)
        monkeypatch.setattr("subprocess.Popen", _forbidden)
        monkeypatch.setattr("os.makedirs", _forbidden)

        before = sorted(str(p.relative_to(tmp_path)) for p in tmp_path.rglob("*"))
        problems = validate_registry(REGISTRATIONS)
        after = sorted(str(p.relative_to(tmp_path)) for p in tmp_path.rglob("*"))

        assert problems == []
        assert before == after
