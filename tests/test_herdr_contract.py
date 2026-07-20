"""Tests for the version-bound Herdr runtime compatibility profile."""

from __future__ import annotations

import json
from pathlib import Path

import pytest

from dreamcoder_theme.herdr_contract import (
    HERDR_073_PROFILE,
    ContractEvidence,
    ContractStatus,
    detect_profile,
    profile_from_evidence,
)
from dreamcoder_theme.renderers_herdr import HerdrContractUnavailableError, herdr_content

FIXTURES = Path(__file__).parent / "fixtures" / "herdr"


def load_evidence(name: str) -> ContractEvidence:
    try:
        contents = (FIXTURES / name).read_text()
        return ContractEvidence.from_mapping(json.loads(contents))
    except (OSError, json.JSONDecodeError) as error:
        pytest.fail(f"invalid Herdr test fixture {name}: {error}")


def test_complete_synthetic_profile_is_accepted_for_its_exact_version() -> None:
    profile = profile_from_evidence(load_evidence("complete-test-profile-0.7.3.json"))

    assert profile.is_complete
    selection = detect_profile("herdr 0.7.3", profiles=(profile,))
    assert selection.status is ContractStatus.SUPPORTED


def test_production_profile_is_complete_and_version_bound() -> None:
    assert HERDR_073_PROFILE.is_complete
    assert detect_profile("herdr 0.7.3").profile is HERDR_073_PROFILE
    assert detect_profile("herdr 0.7.4").status is ContractStatus.UNSUPPORTED_CONTRACT


@pytest.mark.parametrize(
    ("version_output", "expected"),
    [
        (None, ContractStatus.SKIPPED_NOT_INSTALLED),
        ("herdr 0.7.4", ContractStatus.UNSUPPORTED_CONTRACT),
        ("not a version", ContractStatus.UNSUPPORTED_CONTRACT),
    ],
)
def test_absent_unknown_and_malformed_runtime_evidence_is_not_supported(
    version_output: str | None, expected: ContractStatus
) -> None:
    selection = detect_profile(version_output, profiles=())
    assert selection.status is expected


def test_rejected_version_fixture_cannot_enable_an_unsupported_runtime() -> None:
    profile = profile_from_evidence(load_evidence("herdr-0.7.2-rejected-version.json"))

    assert not profile.is_complete
    selection = detect_profile("herdr 0.7.2", profiles=(profile,))
    assert selection.status is ContractStatus.UNSUPPORTED_CONTRACT


def test_incomplete_073_evidence_remains_disabled() -> None:
    profile = profile_from_evidence(load_evidence("herdr-0.7.3-incomplete-evidence.json"))

    assert not profile.is_complete
    selection = detect_profile("herdr 0.7.3", profiles=(profile,))
    assert selection.status is ContractStatus.UNSUPPORTED_CONTRACT


def test_ambiguous_validation_or_reload_semantics_make_profile_incomplete() -> None:
    validation_ambiguous = profile_from_evidence(
        load_evidence("herdr-0.7.3-ambiguous-validation.json")
    )
    reload_ambiguous = profile_from_evidence(load_evidence("herdr-0.7.3-ambiguous-reload.json"))

    assert not validation_ambiguous.is_complete
    assert not reload_ambiguous.is_complete


def test_incomplete_profile_cannot_render() -> None:
    incomplete = profile_from_evidence(load_evidence("herdr-0.7.3-incomplete-evidence.json"))

    with pytest.raises(HerdrContractUnavailableError, match="complete profile"):
        herdr_content(incomplete, "dark", {"accent": "#abcdef"})
