# Catalog migrations — ADF instance bootstrap

Use this when bootstrapping or upgrading an instance project's Document Type Catalog.

## Source of truth

- **Canonical source database**: ADF Document Type Catalog
- **Source URL**: https://www.notion.so/371346dac45681e89a65c51ec5825017
- **Source data source ID**: `collection://c63346da-c456-83e8-9a6c-0761ab378479`

Public web publishing is **not** required. Duplication/adoption works when the bootstrap session has workspace-member access to the private ADF catalog.

Do **not** reconstruct the full 71-type catalog from CSV/MD export unless the user explicitly approves fallback after duplication fails.

## Bootstrap version marker

Record these in the instance `.adf/config.json` after catalog setup:

```json
{
  "bootstrapVersion": "0.5",
  "workflowVersion": "1.3",
  "profileMatrixVersion": "1.3.3",
  "taskPolicyVersion": "1.0",
  "catalogSourceUrl": "https://www.notion.so/371346dac45681e89a65c51ec5825017",
  "catalogMigrationVersion": "0.2",
  "deliveryProfile": {
    "surfaces": ["surf.web-saas"],
    "stacks": [],
    "gateMode": "full",
    "profileId": ""
  },
  "automation": {
    "integrationBranch": "dev",
    "releaseBranch": "main",
    "autoCompleteOnScheduler": true
  }
}
```

## Default bootstrap path

1. Confirm Notion MCP access to the ADF catalog source.
2. **Duplicate** the ADF catalog into the instance project, or **adopt** an existing instance catalog when the user already has one.
3. Fetch the resulting catalog database URL and data source ID.
4. Apply the migration steps for the target `catalogMigrationVersion`.
5. Record the resolved catalog URL/ID in `.adf/config.json`.
6. Do not store catalog page bodies in the repo. Catalog writing templates remain Notion SSOT.

## Adopt path

When the user already has a catalog:

1. Fetch the existing catalog schema and a sample of rows.
2. Compare against expected catalog properties from ADF source shape.
3. Apply only the migration deltas listed below.
4. Do not overwrite instance-specific catalog customizations unless the user approves.

## Migration 0.1 -> 0.2

Apply after duplicate/adopt when `catalogMigrationVersion` is missing or `< 0.2`.

### Required catalog DB properties

Ensure the catalog database has at least:

| Property | Type | Notes |
|---|---|---|
| `문서 타입` | title | document type name |
| `카테고리` | select | board grouping |
| `목적` | text | one-line purpose |
| `문서 성격` | select | e.g. Version Spec, Policy, Evidence |
| `관리 방식` | select | e.g. Versioned, Living |
| `권장 생성 시점` | text | when to create this doc type |
| `대표 예시` | text | example node title/key |
| `상태` | select | Active / Deprecated |
| `정렬` | number | optional ordering |

If properties are missing, add them with `notion-update-data-source` only after user approval.

### Required page-body contract

For each **Active** catalog row used by the instance:

- Page body must contain `## … 작성 템플릿` or equivalent Korean template section.
- If missing, write the template into the catalog page first, then create Knowledge Nodes from it.

Do **not** bulk-import all catalog page bodies from CSV/MD in v0.2. Migrate structure first; fill missing templates incrementally or through dedicated catalog-template tasks.

### Instance graph additions introduced in 0.2

After catalog setup, ensure the instance also has:

- reconciliation validation-state properties on Nodes, Edges, Tasks
- a Daily Reconciliation Sweep runbook node
- a current weekly Reconciliation Run Log node
- a Cursor Automation created from `references/automations/daily-reconciliation-sweep.md`

### Instance automation additions introduced in 0.3

After the v0.2 graph additions, ensure the instance also has:

- `bootstrapVersion = 0.3` in `.adf/config.json`
- `automation.integrationBranch`, `automation.releaseBranch`, and `automation.autoCompleteOnScheduler` in `.adf/config.json`
- a Dev Task Loop automation plan node or bootstrap plan section
- a Cursor Automation draft or created automation from `references/automations/dev-task-loop.md`

Do not enable the dev task loop until repo, branch, PR, check-run, and Notion MCP preflight passes.

### Instance operating policy additions introduced in 0.4

After the v0.3 automation additions, ensure the instance also has:

- `bootstrapVersion = 0.4`, `workflowVersion = 1.3`, and `taskPolicyVersion = 1.0` in `.adf/config.json`
- bundled `task-workflow/references/responsibility-unit.md` installed under `{SKILLS_INSTALL_DIR}`
- `AGENTS.md` Task Rules referencing responsibility-unit policy when `taskPolicyVersion >= 1.0`
- optional seeded Knowledge Node `{PROJECT_SLUG}.task-policy.responsibility-unit` copied from ADF policy or linked as Shared reference

### Instance workflow surface additions introduced in 0.4

After the 0.4 operating policy markers, ensure the instance also has:

- `{SKILLS_INSTALL_DIR}/{PROJECT_SLUG}-documentation-workflow/` installed and listed in `AGENTS.md` router
- `{SKILLS_INSTALL_DIR}/{PROJECT_SLUG}-doc-coauthoring/` installed as a **documentation-workflow delegate only** (not a separate AGENTS router row)
- repo reference `references/schemas/delivery-workflow-stage-map.md` copied or linked from bootstrap bundle when seeding workflow nodes
- seeded or adopted Knowledge Nodes for:
  - `{PROJECT_SLUG}.delivery-workflow.catalog-stage-map` (stage map v1.3)
  - `{PROJECT_SLUG}.delivery-workflow.intent-handoff-gate`
  - `{PROJECT_SLUG}.delivery-workflow.doc-coauthoring`
- `implementation-workflow/references/implementation-gate.md` includes lifecycle-aware design gate checks when `workflowVersion >= 1.3`
- Dev Task Loop prompt routes `노드 문서 작성` to documentation-workflow and evaluates design gate before autonomous `구현`/`검증` pickup

Upgrade path from 0.3: bump config markers (`bootstrapVersion`, `workflowVersion`), copy documentation-workflow + doc-coauthoring skills, patch `AGENTS.md` router, and adopt stage map / handoff nodes. Do not require full re-bootstrap.

### Instance dynamic gate additions introduced in 0.5

After the 0.4 workflow surface markers, ensure the instance also has:

- `bootstrapVersion = 0.5`, `profileMatrixVersion = 1.3.3`, and `deliveryProfile` object in `.adf/config.json`:
  - `surfaces[]`, `stacks[]`, `gateMode` (`full` | `legacy`), optional `profileId`
- Bundled repo references copied or linked:
  - `references/schemas/delivery-profile-matrix.md`
  - `references/schemas/policy-composer.md`
  - `references/presets/*.manifest.json` for selected stacks
- Run policy composer per `references/schemas/policy-composer.md` when upgrading to `gateMode=full`
- Seeded or composed Knowledge Node `{PROJECT_SLUG}.delivery-workflow.implementation-gate-policy` (Draft → human Active)
- Seeded DOC tasks for gate policy + merged catalog types / policy roles (Matrix §8)
- `implementation-workflow/references/implementation-gate.md` includes **dynamic gate** checks when `bootstrapVersion >= 0.5` and `gateMode != legacy`
- Dev Task Loop evaluates instance gate policy before autonomous first product `구현`/`검증` pickup

Upgrade path from 0.4:

1. Bump `bootstrapVersion` to `0.5` and add `profileMatrixVersion` + `deliveryProfile`.
2. Copy bundled matrix, composer procedure, and selected preset manifests from factory skill package.
3. Re-run composer intake (surfaces/stacks) or adopt `prof.legacy-v04` via `gateMode=legacy` to preserve static gate behavior without composer merge.
4. Do not require full re-bootstrap when adopting legacy mode; full mode requires composer pass + gate policy node.

Validate preset manifests after copy:

```bash
python3 references/presets/validate-manifests.py
```

## Failure handling

| Condition | Action |
|---|---|
| Cannot access ADF catalog source | Stop bootstrap. Ask user to grant workspace access or provide a shareable duplicate source. |
| Duplicate succeeds but migration fails | Report exact missing properties/templates. Do not claim bootstrap complete. |
| User rejects catalog DB edits | Continue with repo scaffold only and leave exact Notion DDL/migration commands for later. |

## Verification

After migration:

1. Fetch catalog database schema.
2. Confirm required properties exist.
3. Spot-check 3 catalog rows including at least one with a populated `## … 작성 템플릿` section.
4. Record `catalogDatabaseUrl`, `catalogDataSourceId`, and `catalogMigrationVersion` in `.adf/config.json`.
