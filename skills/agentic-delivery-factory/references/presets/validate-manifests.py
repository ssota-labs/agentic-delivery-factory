#!/usr/bin/env python3
"""Validate ADF preset manifest JSON files against preset-manifest.schema.json."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PRESETS_DIR = ROOT / "presets"
SCHEMA_PATH = ROOT / "schemas" / "preset-manifest.schema.json"

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
        "stackId",
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

    stack_id = manifest.get("stackId", "")
    if not re.fullmatch(r"stk\.[a-z0-9-]+", stack_id):
        errors.append(f"{path.name}: invalid stackId `{stack_id}`")

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
    manifest_paths = sorted(PRESETS_DIR.glob("stk.*.manifest.json"))
    if not manifest_paths:
        print("No preset manifests found.", file=sys.stderr)
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
        if manifest.get("stackId") != path.stem.replace(".manifest", ""):
            all_errors.append(
                f"{path.name}: stackId `{manifest.get('stackId')}` must match filename stem"
            )
        all_errors.extend(validate_manifest(manifest, path))

    if all_errors:
        print("Preset manifest validation failed:")
        for error in all_errors:
            print(f"  - {error}")
        return 1

    print(f"OK: validated {len(manifest_paths)} preset manifest(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
