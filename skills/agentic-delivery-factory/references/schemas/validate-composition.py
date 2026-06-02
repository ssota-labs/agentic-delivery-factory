#!/usr/bin/env python3
"""Validate ADF Composition Contract JSON files."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCHEMA_PATH = ROOT / "schemas" / "composition-contract.schema.json"
DEFAULT_EXAMPLE = ROOT / "schemas" / "composition.factory.web-saas.001.example.json"

PATTERNS = {
    "compositionId": re.compile(r"^comp\.[a-z0-9.-]+$"),
    "factoryTemplateId": re.compile(r"^factory\.[a-z0-9-]+\.[0-9]{3}$"),
    "surface": re.compile(r"^surf\.[a-z0-9-]+$"),
    "port": re.compile(r"^port\.[a-z0-9-]+$"),
    "adapter": re.compile(r"^apt\.[a-z0-9-]+$"),
    "policyRole": re.compile(r"^policy\.[a-z0-9-]+$"),
}


def load_json(path: Path) -> dict:
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def validate_composition(composition: dict, path: Path) -> list[str]:
    errors: list[str] = []

    required = [
        "compositionVersion",
        "compositionId",
        "composedAt",
        "factoryTemplateId",
        "surface",
        "gateMode",
        "selectedAdapters",
        "requiredNodeTypes",
        "policySeeds",
        "policyContributions",
        "adapterSkillInstallPlan",
        "repoScaffoldPlan",
        "implementationGateRows",
        "verificationGateRows",
        "conflicts",
        "sourceTrace",
    ]
    for key in required:
        if key not in composition:
            errors.append(f"{path.name}: missing required field `{key}`")

    if composition.get("compositionVersion") != "1.0":
        errors.append(f'{path.name}: compositionVersion must be "1.0"')

    composition_id = composition.get("compositionId", "")
    if not PATTERNS["compositionId"].fullmatch(composition_id):
        errors.append(f"{path.name}: invalid compositionId `{composition_id}`")

    factory_template_id = composition.get("factoryTemplateId", "")
    if not PATTERNS["factoryTemplateId"].fullmatch(factory_template_id):
        errors.append(f"{path.name}: invalid factoryTemplateId `{factory_template_id}`")

    surface = composition.get("surface", "")
    if not PATTERNS["surface"].fullmatch(surface):
        errors.append(f"{path.name}: invalid surface `{surface}`")

    if composition.get("gateMode") not in {"full", "legacy"}:
        errors.append(f"{path.name}: gateMode must be `full` or `legacy`")

    selected_adapters = composition.get("selectedAdapters", {})
    if not isinstance(selected_adapters, dict) or not selected_adapters:
        errors.append(f"{path.name}: selectedAdapters must be a non-empty object")
    else:
        for port, adapter in selected_adapters.items():
            if not PATTERNS["port"].fullmatch(port):
                errors.append(f"{path.name}: invalid port key `{port}`")
            if not PATTERNS["adapter"].fullmatch(adapter):
                errors.append(f"{path.name}: invalid adapter `{adapter}` for `{port}`")

    required_node_types = composition.get("requiredNodeTypes", {})
    for section in ("projectPersistent", "environmentPolicy", "workSpecific"):
        values = required_node_types.get(section, [])
        if not isinstance(values, list):
            errors.append(f"{path.name}: requiredNodeTypes.{section} must be an array")

    for seed in composition.get("policySeeds", []):
        role = seed.get("policyRole", "")
        if not PATTERNS["policyRole"].fullmatch(role):
            errors.append(f"{path.name}: invalid policyRole `{role}`")
        if not seed.get("title"):
            errors.append(f"{path.name}: policySeed `{role}` missing title")
        if not seed.get("sourceAdapters"):
            errors.append(f"{path.name}: policySeed `{role}` missing sourceAdapters")

    for contribution in composition.get("policyContributions", []):
        role = contribution.get("targetPolicyRole", "")
        sections = contribution.get("requiredSections", [])
        guidance = contribution.get("sectionGuidance", {})
        if not PATTERNS["policyRole"].fullmatch(role):
            errors.append(f"{path.name}: invalid targetPolicyRole `{role}`")
        if not sections:
            errors.append(f"{path.name}: policyContribution `{role}` requires requiredSections")
        if not isinstance(guidance, dict):
            errors.append(f"{path.name}: policyContribution `{role}` requires sectionGuidance object")
        else:
            missing = [section for section in sections if not guidance.get(section)]
            if missing:
                errors.append(
                    f"{path.name}: policyContribution `{role}` missing sectionGuidance for {missing}"
                )
        if not contribution.get("sourceAdapters"):
            errors.append(f"{path.name}: policyContribution `{role}` missing sourceAdapters")

    repo_scaffold = composition.get("repoScaffoldPlan", {})
    for field in ("base", "includes", "paths"):
        if field not in repo_scaffold:
            errors.append(f"{path.name}: repoScaffoldPlan missing `{field}`")

    for section in ("implementation", "verification"):
        rows_key = "implementationGateRows" if section == "implementation" else "verificationGateRows"
        for row in composition.get(rows_key, []):
            for field in ("checkId", "gateClass", "summary", "sourceTrace"):
                if not row.get(field):
                    errors.append(f"{path.name}: {rows_key} row missing `{field}`")

    for conflict in composition.get("conflicts", []):
        for field in ("code", "message", "blockingActive"):
            if field not in conflict:
                errors.append(f"{path.name}: conflict missing `{field}`")

    source_trace = composition.get("sourceTrace", {})
    for field in (
        "factoryTemplatePath",
        "adapterManifestPaths",
        "profileMatrixVersion",
        "gatePolicyNodeKey",
    ):
        if not source_trace.get(field):
            errors.append(f"{path.name}: sourceTrace missing `{field}`")

    return errors


def main() -> int:
    targets = [Path(arg) for arg in sys.argv[1:]] or [DEFAULT_EXAMPLE]
    if not SCHEMA_PATH.exists():
        print(f"Schema missing: {SCHEMA_PATH}", file=sys.stderr)
        return 1

    all_errors: list[str] = []
    for path in targets:
        if not path.exists():
            all_errors.append(f"{path}: file not found")
            continue
        try:
            composition = load_json(path)
        except json.JSONDecodeError as exc:
            all_errors.append(f"{path.name}: invalid JSON — {exc}")
            continue
        all_errors.extend(validate_composition(composition, path))

    if all_errors:
        print("Composition contract validation failed:")
        for error in all_errors:
            print(f"  - {error}")
        return 1

    print(f"OK: validated {len(targets)} composition contract file(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
