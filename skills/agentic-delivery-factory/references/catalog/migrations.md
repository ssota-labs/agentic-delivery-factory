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
  "bootstrapVersion": "0.4",
  "taskPolicyVersion": "1.0",
  "catalogSourceUrl": "https://www.notion.so/371346dac45681e89a65c51ec5825017",
  "catalogMigrationVersion": "0.2",
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

- `bootstrapVersion = 0.4` and `taskPolicyVersion = 1.0` in `.adf/config.json`
- bundled `task-workflow/references/responsibility-unit.md` installed under `{SKILLS_INSTALL_DIR}`
- `AGENTS.md` Task Rules referencing responsibility-unit policy when `taskPolicyVersion >= 1.0`
- optional seeded Knowledge Node `{PROJECT_SLUG}.task-policy.responsibility-unit` copied from ADF policy or linked as Shared reference

Upgrade path from 0.3: bump config markers, copy the new task-workflow reference, and patch `AGENTS.md` Task Rules. Do not require re-bootstrap.

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
