#!/usr/bin/env python3
"""Validate ADF Stack Adapter manifest JSON files."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PRESETS_DIR = ROOT / "presets"
SCHEMA_PATH = ROOT / "schemas" / "stack-adapter-manifest.schema.json"

FOUNDATION_CATALOG_TYPES = {
    "Test Strategy",
    "QA Environment & Test Data Policy",
    "Component Policy",
    "Accessibility Baseline",
    "Information Architecture",
    "Design Token Spec",
    "E2E Scenario List",
    "PRD",
}

CONTRIBUTION_TARGET_ROLES = {
    "policy.test-strategy": "Test Strategy",
    "policy.qa-env-test-data": "QA Environment & Test Data Policy",
    "policy.e2e-scenarios": "E2E Scenario List",
}


def load_json(path: Path) -> dict:
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def validate_manifest(manifest: dict, path: Path) -> list[str]:
    errors: list[str] = []

    required = [
        "manifestVersion",
        "adapterId",
        "label",
        "compatibleSurfaces",
        "policySeeds",
        "gateCandidates",
    ]
    for key in required:
        if key not in manifest:
            errors.append(f"{path.name}: missing required field `{key}`")

    if manifest.get("manifestVersion") != "1.0":
        errors.append(f"{path.name}: manifestVersion must be \"1.0\"")

    adapter_id = manifest.get("adapterId", "")
    if not re.fullmatch(r"apt\.[a-z0-9-]+", adapter_id):
        errors.append(f"{path.name}: invalid adapterId `{adapter_id}`")

    for surface in manifest.get("compatibleSurfaces", []):
        if not re.fullmatch(r"surf\.[a-z0-9-]+", surface):
            errors.append(f"{path.name}: invalid compatibleSurface `{surface}`")

    for seed in manifest.get("policySeeds", []):
        role = seed.get("policyRole", "")
        if not re.fullmatch(r"policy\.[a-z0-9-]+", role):
            errors.append(f"{path.name}: invalid policyRole `{role}`")
        if not seed.get("title"):
            errors.append(f"{path.name}: policySeed missing title for `{role}`")
        catalog_ref = seed.get("catalogTypeRef")
        if catalog_ref in FOUNDATION_CATALOG_TYPES:
            errors.append(
                f"{path.name}: policySeed `{role}` must not duplicate foundation catalog type `{catalog_ref}` — use policyContributions or gateCandidates instead"
            )

    for contribution in manifest.get("policyContributions", []):
        target_role = contribution.get("targetPolicyRole", "")
        target_catalog = contribution.get("targetCatalogType", "")
        sections = contribution.get("requiredSections", [])
        guidance = contribution.get("sectionGuidance", {})

        if not re.fullmatch(r"policy\.[a-z0-9-]+", target_role):
            errors.append(f"{path.name}: invalid targetPolicyRole `{target_role}`")
        expected_catalog = CONTRIBUTION_TARGET_ROLES.get(target_role)
        if expected_catalog and target_catalog != expected_catalog:
            errors.append(
                f"{path.name}: targetPolicyRole `{target_role}` must use targetCatalogType `{expected_catalog}`, got `{target_catalog}`"
            )
        if not sections:
            errors.append(
                f"{path.name}: policyContribution `{target_role}` requires at least one requiredSections entry"
            )
        if not isinstance(guidance, dict) or not guidance:
            errors.append(
                f"{path.name}: policyContribution `{target_role}` requires sectionGuidance for every required section"
            )
        else:
            missing_guidance = [section for section in sections if not guidance.get(section)]
            if missing_guidance:
                errors.append(
                    f"{path.name}: policyContribution `{target_role}` missing sectionGuidance for {missing_guidance}"
                )

    gate_candidates = manifest.get("gateCandidates", {})
    for section in ("implementation", "verification"):
        rows = gate_candidates.get(section, [])
        if not isinstance(rows, list):
            errors.append(f"{path.name}: gateCandidates.{section} must be an array")
            continue
        for row in rows:
            for field in ("checkId", "gateClass", "summary"):
                if not row.get(field):
                    errors.append(
                        f"{path.name}: gateCandidates.{section} row missing `{field}`"
                    )
            for role in row.get("requiredPolicyRoles", []):
                if not re.fullmatch(r"policy\.[a-z0-9-]+", role):
                    errors.append(
                        f"{path.name}: gate row `{row.get('checkId')}` has invalid requiredPolicyRole `{role}`"
                    )

    return errors


def main() -> int:
    manifest_paths = sorted(PRESETS_DIR.glob("apt.*.manifest.json"))
    if not manifest_paths:
        print("No Stack Adapter manifests found.", file=sys.stderr)
        return 1

    if not SCHEMA_PATH.exists():
        print(f"Schema missing: {SCHEMA_PATH}", file=sys.stderr)
        return 1

    all_errors: list[str] = []
    for path in manifest_paths:
        try:
            manifest = load_json(path)
        except json.JSONDecodeError as exc:
            all_errors.append(f"{path.name}: invalid JSON — {exc}")
            continue
        if manifest.get("adapterId") != path.stem.replace(".manifest", ""):
            all_errors.append(
                f"{path.name}: adapterId `{manifest.get('adapterId')}` must match filename stem"
            )
        all_errors.extend(validate_manifest(manifest, path))

    if all_errors:
        print("Stack Adapter manifest validation failed:")
        for error in all_errors:
            print(f"  - {error}")
        return 1

    print(f"OK: validated {len(manifest_paths)} Stack Adapter manifest(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
