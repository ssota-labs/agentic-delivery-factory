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
| Notion mode | create new project/DBs or adopt existing |
| Skills install dir | `.cursor/skills` default |

Summarize and get explicit approval before Notion writes or file overwrites.

## Phase 1 — Create/adopt Notion

Create under the project page:

1. Goals: schema from `references/schemas/goals-database.ddl`.
2. Document Type Catalog: duplicate/adopt ADF catalog when possible.
3. Knowledge Nodes: schema from `references/schemas/nodes-database.ddl`.
4. Knowledge Edges: schema from `references/schemas/edges-database.ddl`.
5. Tasks: schema from `references/schemas/tasks-database.ddl`.

Fetch every database and record URLs/data source IDs.

Run `references/schemas/relations-setup.md`.

## Phase 2 — Seed

Create starter nodes:

- Project Overview (`Project Brief`, Product, Meta/Instance depending on project)
- Architecture Overview (`Architecture Overview`, Engineering)
- Knowledge Graph Model (`Functional Spec`, Product)
- Bootstrap/Implementation Plan (`Implementation Plan`, Engineering)

Create starter edges:

- Project Overview defines Architecture
- Project Overview defines Knowledge Graph Model
- Architecture defines Bootstrap/Implementation Plan

Create starter goals:

- `{TASK_PREFIX}-GOAL-001`: first Platform milestone for the instance bootstrap

Create starter tasks:

- `{TASK_PREFIX}-PLAT-001-NODE`: write starter nodes
- `{TASK_PREFIX}-PLAT-002-EDGE`: connect starter edges
- `{TASK_PREFIX}-PLAT-003-IMPL`: implement repo scaffold
- `{TASK_PREFIX}-PLAT-004-VERF`: run reconciliation

Link starter tasks to `{TASK_PREFIX}-GOAL-001` through the `목표` relation.

## Phase 3 — Write target repo files

Render:

- `references/templates/AGENTS.md.tpl` -> `{target}/AGENTS.md`
- `references/templates/config.json.tpl` -> `{target}/.adf/config.json`

Copy project workflow skills into `{target}/{SKILLS_INSTALL_DIR}/`:

- task workflow
- node authoring
- edge workflow
- implementation workflow
- reconciliation

Replace all placeholders.

## Phase 4 — Report

Return:

- Project page URL
- Goals / Catalog / Nodes / Edges / Tasks URLs
- Repo path
- Files written
- First recommended task

## Abort conditions

- Notion tools unavailable and user requested direct Notion writes
- User declines approval summary
- Target path not writable
- Existing `AGENTS.md` would be overwritten without approval
