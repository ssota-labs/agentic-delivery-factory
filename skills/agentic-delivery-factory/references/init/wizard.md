# Init wizard — ADF instance bootstrap

Use this for creating a new instance project from the Agentic Delivery Factory pattern.

## Phase 0 — Collect inputs

Ask in one batch:

| Field | Rule |
|---|---|
| Target repo path | absolute path; create only after confirmation |
| `projectSlug` | kebab-case |
| `projectName` | display name |
| `projectOverview` | one sentence |
| `taskIdPrefix` | uppercase short prefix |
| `githubRepo` | `org/repo` |
| `integrationBranch` | branch used by scheduled agent PRs, default `dev` when present or `main` for simple repos |
| `releaseBranch` | human promotion branch, default `main` |
| Notion mode | create new project/DBs or adopt existing |
| Skills install dir | `.cursor/skills` default |
| `factoryTemplateId` | Factory Template ID from `references/templates/factories/*.json`; default `factory.web-saas.001` |
| `surfaces[]` | 1..n from `references/schemas/delivery-profile-matrix.md` §3.1; default `surf.web-saas` |
| `stacks[]` | 0..n stack IDs; filter by compatible surfaces; default per profile or empty |
| `gateMode` | `full` (default) or `legacy` (`apt.none` only) |

Summarize Factory Template, surfaces, Stack Adapter defaults/overrides, legacy `profileId` if still used, and gate mode. Get explicit approval before Notion writes or file overwrites.

## Phase 1 — Create/adopt Notion

Create under the project page:

1. Goals: schema from `references/schemas/goals-database.ddl`.
2. Document Type Catalog: duplicate/adopt the private ADF catalog source, then apply `references/catalog/migrations.md`.
3. Knowledge Nodes: schema from `references/schemas/nodes-database.ddl`.
4. Knowledge Edges: schema from `references/schemas/edges-database.ddl`.
5. Tasks: schema from `references/schemas/tasks-database.ddl`.

Fetch every database and record URLs/data source IDs.

Run `references/schemas/relations-setup.md`.

Apply `references/schemas/project-page-layout.md`:

- Match the current ADF project page block order.
- Create linked database views for Nodes, Tasks, and Goals with the same view names, filters, sorts, grouping/timeline settings, and visible properties.
- Preserve the Reference DB toggle order: Catalog, Nodes, Edges, Tasks, Goals.
- Report any Notion API-unsupported view property, such as timeline dependency rendering, as a manual parity step instead of claiming full parity.

Catalog rules:

- Source: https://www.notion.so/371346dac45681e89a65c51ec5825017
- Prefer duplicate/adopt over CSV/MD reconstruction.
- If source access is unavailable, stop and ask for shared access or explicit fallback approval.
- After catalog setup, set `bootstrapVersion = 0.5`, `profileMatrixVersion = 1.3.3`, `workflowVersion = 1.3`, `taskPolicyVersion = 1.0`, `catalogMigrationVersion = 0.2`, `integrationBranch`, and `releaseBranch` in `.adf/config.json`.
- Record selected `factoryTemplateId`, `deliveryProfile.surfaces`, `deliveryProfile.stacks`, `deliveryProfile.gateMode`, and resolved legacy `deliveryProfile.profileId` from Phase 0 intake.

## Phase 2 — Seed

Create starter nodes:

- Project Overview (`Project Brief`, Product, Meta/Instance depending on project)
- Architecture Overview (`Architecture Overview`, Engineering)
- Knowledge Graph Model (`Functional Spec`, Product)
- Bootstrap/Implementation Plan (`Implementation Plan`, Engineering)
- Dev Task Loop automation plan (`Implementation Plan`, Engineering)
- Daily Reconciliation Sweep runbook (`Runbook`, Ops)
- Current weekly Reconciliation Run Log node (`Evidence` or closest catalog type, Ops)

Use `references/schemas/automation-seed-blueprint.md` for runbook/log node shape.

Create starter edges:

- Project Overview defines Architecture
- Project Overview defines Knowledge Graph Model
- Architecture defines Bootstrap/Implementation Plan
- Bootstrap/Implementation Plan defines Dev Task Loop automation plan
- Dev Task Loop automation plan depends on Task workflow and Implementation workflow skills
- Architecture or Bootstrap Plan defines Daily Reconciliation Sweep runbook
- Runbook documents current weekly run log node

Create starter goals:

- `{TASK_PREFIX}-GOAL-001`: first Platform milestone for the instance bootstrap

Create starter tasks:

- `{TASK_PREFIX}-PLAT-001-NODE`: write starter nodes
- `{TASK_PREFIX}-PLAT-002-EDGE`: connect starter edges
- `{TASK_PREFIX}-PLAT-003-IMPL`: implement repo scaffold
- `{TASK_PREFIX}-PLAT-004-VERF`: run reconciliation
- `{TASK_PREFIX}-PLAT-005-SKILL`: verify dev task loop automation wiring
- `{TASK_PREFIX}-PLAT-006-OPS`: verify daily sweep automation + runbook wiring

Link starter tasks to `{TASK_PREFIX}-GOAL-001` through the `목표` relation.

## Phase 2.5 — Delivery profile composer

When `deliveryProfile.gateMode != legacy`:

1. Read selected Factory Template JSON, `references/schemas/delivery-profile-matrix.md`, and `references/schemas/policy-composer.md`.
2. Run `python3 references/presets/validate-manifests.py` on bundled Stack Adapter manifests (from skill package root).
3. Resolve required Stack Ports to selected Stack Adapters, starting from the Factory Template defaults.
4. Execute composer steps 1–10; write **Draft** `{PROJECT_SLUG}.delivery-workflow.implementation-gate-policy` node in instance Nodes DB.
5. Seed DOC tasks per composer output (gate policy + one task per catalog type + one per `policyRole`). Do not mark gate policy Active without human confirm.
6. Add starter edge: Bootstrap/Implementation Plan → defines → Implementation Gate Policy.

When `gateMode=legacy`, skip dynamic composer; seed only Stage Map reference node and static gate behavior (v0.4 path).

## Phase 3 — Write target repo files

Render:

- `references/templates/AGENTS.md.tpl` -> `{target}/AGENTS.md`
- `references/templates/config.json.tpl` -> `{target}/.adf/config.json`

Copy project workflow skills into `{target}/{SKILLS_INSTALL_DIR}/`:

- task workflow
- node authoring
- edge workflow
- documentation workflow (includes co-authoring branch delegate — install `doc-coauthoring/` too; do **not** add it as a separate AGENTS router row)
- doc coauthoring (bundled delegate for documentation-workflow only)
- implementation workflow
- reconciliation

Replace all placeholders. Include `FACTORY_TEMPLATE_ID` and delivery profile JSON arrays in config (`DELIVERY_SURFACES_JSON`, `DELIVERY_STACKS_JSON`, `GATE_MODE`, `PROFILE_ID`).

Copy bundled workflow references into `{target}/references/schemas/` when the instance keeps repo mirrors:

- `delivery-workflow-stage-map.md`
- `delivery-profile-matrix.md`
- `policy-composer.md`
- `factory-template.schema.json`
- `stack-adapter-manifest.schema.json`

Copy selected Factory Template manifests to `{target}/references/templates/factories/`.

Copy selected Stack Adapter manifests to `{target}/references/presets/` when stacks were selected.

## Phase 4 — Install automations

After repo files and Notion seed nodes exist:

1. Read `references/automations/dev-task-loop.md`.
2. Replace `{PROJECT_NAME}`, `{PROJECT_SLUG}`, `{TASK_PREFIX}`, `{GITHUB_REPO}`, `{SKILLS_INSTALL_DIR}`, `{INTEGRATION_BRANCH}`, and `{RELEASE_BRANCH}`.
3. Create or open the Cursor Automation for the dev task loop. Keep it disabled or draft until repo/branch/PR preflight passes.
4. Read `references/automations/daily-reconciliation-sweep.md`.
5. Replace `{PROJECT_NAME}`, `{PROJECT_SLUG}`, `{GITHUB_REPO}`, `{SKILLS_INSTALL_DIR}`, and `{INTEGRATION_BRANCH}` in the workflow payload.
6. Create or open the Cursor Automation for the daily reconciliation sweep.
7. Confirm every installed automation has repo = `{githubRepo}` and the intended branch.
8. Record automation URLs in the bootstrap report if available.

Bootstrap is not complete until the dev task loop install path is resolved, the daily sweep automation repo setting matches the instance repo, and any enabled dev task loop has passed PR/check/merge preflight.

## Phase 5 — Report

Return:

- Project page URL
- Goals / Catalog / Nodes / Edges / Tasks URLs
- Project page view/layout parity result and any manual parity gaps
- Repo path
- Files written
- Runbook node and weekly run log node URLs
- Dev Task Loop automation URL or exact setup still needed
- Daily Reconciliation Sweep automation URL or exact setup still needed
- First recommended task (when `gateMode=full`, gate policy authoring before first product `구현`)
- Delivery profile summary: surfaces, stacks, `profileId`, Draft gate policy node URL

## Abort conditions

- Notion tools unavailable and user requested direct Notion writes
- User declines approval summary
- Target path not writable
- Existing `AGENTS.md` would be overwritten without approval
