# AGENTS.md

Instructions for AI agents working in **ssota-labs/agentic-delivery-factory**.

## Project Overview

**Agentic Delivery Factory (ADF)** is the meta-factory for creating agentic delivery instance projects. This repo owns the factory skill kit: templates, workflow skills, and operating rules that turn an idea into a repo + Notion project + Knowledge Graph + task board + agent workflow.

This repo is the **factory for making factories**. The ADF Notion project is the operating SSOT; the repository stores the reusable skill/package implementation.


| Layer            | Role                                                                     | SSOT                          |
| ---------------- | ------------------------------------------------------------------------ | ----------------------------- |
| Meta factory     | Build and improve the scaffold, skills, templates, and graph conventions | ADF Project + this repo       |
| Instance project | A generated portfolio/client/product project                             | Its own Notion project + repo |
| GTM proof        | Portfolio, content, delivery partner validation                          | ADF goals/tasks               |


## Notion SSOT

Start every non-trivial task by loading the relevant Notion context. Do not plan from repository files alone.


| Item                  | URL                                                                                                              |
| --------------------- | ---------------------------------------------------------------------------------------------------------------- |
| ADF Project           | [https://www.notion.so/371346dac456814d9aa5eb7bbe5b1511](https://www.notion.so/371346dac456814d9aa5eb7bbe5b1511) |
| Strategy memo         | [https://www.notion.so/371346dac456817c978ed58b5e6b39df](https://www.notion.so/371346dac456817c978ed58b5e6b39df) |
| Document Type Catalog | [https://www.notion.so/371346dac45681e89a65c51ec5825017](https://www.notion.so/371346dac45681e89a65c51ec5825017) |
| Knowledge Nodes       | [https://www.notion.so/04e803dbef5243e39ed02ab370d2290b](https://www.notion.so/04e803dbef5243e39ed02ab370d2290b) |
| Knowledge Edges       | [https://www.notion.so/a2a643eaa6e04981af72bad558115b2c](https://www.notion.so/a2a643eaa6e04981af72bad558115b2c) |
| Goals (project-local) | [https://www.notion.so/e4cbfacc00ee49238b04fb99431bf86b](https://www.notion.so/e4cbfacc00ee49238b04fb99431bf86b) |
| Tasks                 | [https://www.notion.so/6121db0090bf42df96f790bb27b202f4](https://www.notion.so/6121db0090bf42df96f790bb27b202f4) |


Data source IDs are recorded in `[.adf/config.json](.adf/config.json)`. Goals are project-local (`ADF Goals`), not the workspace-wide SSOTA goals tracker.

## Skill Boundary

ADF uses two skill surfaces. Do not mix them.


| Surface                   | Role                                                  | Location                           |
| ------------------------- | ----------------------------------------------------- | ---------------------------------- |
| Internal operating skills | Operate the ADF Notion SSOT and this repo             | `.cursor/skills/adf-`*             |
| Shipped bootstrap skill   | Create a new instance repo + Notion + skills + config | `skills/agentic-delivery-factory/` |


Instance bootstrap execution belongs in the shipped skill, not in internal `.cursor/skills/`. Internal work may define or validate bootstrap spec nodes and run reconciliation against bootstrap output, but it does not execute instance creation.

Operating contract SSOT: Knowledge Node `adf.v0-1.agentic-operating-system` (Active).

## ADF Router

For any request, classify intent first and read the matching skill before acting.


| User intent                                         | Route                   | Read                                                 |
| --------------------------------------------------- | ----------------------- | ---------------------------------------------------- |
| 태스크 만들기, 작업 진행, task board, ADF-P*                  | Task workflow           | `.cursor/skills/adf-task-workflow/SKILL.md`          |
| 노드 문서 작성, node 생성/수정, SSOT 문서화                      | Node authoring          | `.cursor/skills/adf-node-authoring/SKILL.md`         |
| 엣지 생성, 관계 연결, graph relation                        | Edge workflow           | `.cursor/skills/adf-edge-workflow/SKILL.md`          |
| 정합성 체크, 누락 노드/엣지, graph audit                       | Reconciliation          | `.cursor/skills/adf-reconciliation/SKILL.md`         |
| 새 instance bootstrap, scaffold, adopt existing repo | Shipped bootstrap skill | `skills/agentic-delivery-factory/SKILL.md`           |
| ADF meta factory repo/skills/templates 수정           | Implementation work     | Use this AGENTS.md plus repository conventions below |


If Notion write tools are unavailable, do the repository work and leave exact Notion commands or DDL in `notion/` for a later MCP-enabled pass. Do not invent IDs or pretend a Notion write happened.

## Request Intake Gate

Before starting non-trivial work, decide explicitly:

| Question | If yes | If no |
|---|---|---|
| Does this need a Knowledge Node? | Create or update via `adf-node-authoring` before or during the work | Record why chat-only is enough |
| Does this need a Task row? | Create or pick up via `adf-task-workflow`, link `목표`, set `진행중` at start | Keep the work conversational only when truly trivial |
| Does the task scope span multiple responsibilities? | Split into a task chain per [Task Responsibility Unit Policy](https://www.notion.so/371346dac456816eb007f998d44f4602) (`adf.task-policy.responsibility-unit` v1.0) | Keep one task only if deliverable, work type, and close-out gate are single |
| Does this need graph edges? | Create/update via `adf-edge-workflow` | Note prose-only risk in task or node memo |

Close-out rules:

1. Record durable output in nodes/edges/repo paths, not only chat.
2. Link the task through `관련 노드` and `관련 엣지` when graph artifacts changed.
3. Set `정합성 확인됨 = false` and `정합성 상태 = 미확인` on materially changed rows unless reconciliation ran in the same operation.
4. Propose `완료` only when the user explicitly asks.
5. Report task ID, node/edge evidence, repo paths, and next step.

## Task Responsibility Unit Policy

Policy SSOT: Knowledge Node [`adf.task-policy.responsibility-unit`](https://www.notion.so/371346dac456816eb007f998d44f4602) (**v1.0**).

- One task row = one primary deliverable, one `작업 유형`, one close-out gate.
- Do not combine design/policy, skill authoring, implementation, and verification in one task.
- Split into a chain with `선행 작업`, `후행 작업`, and `종속성`; link `목표` to the direct leading KPI only.
- Cancel umbrella tasks when the user says responsibilities do not align.

Internal skill reference: `.cursor/skills/adf-task-workflow/references/responsibility-unit.md`. Shipped instance copy: `skills/agentic-delivery-factory/references/bundled/cursor-skills/task-workflow/references/responsibility-unit.md`.

## Knowledge Graph Rules

ADF Knowledge Nodes are the durable SSOT units. A node should exist for every reusable concept, workflow contract, scaffold template, policy, architecture decision, or instance bootstrap spec.

Required node properties:

- `노드`: human-readable title
- `키`: stable dotted key, e.g. `adf.factory-bootstrap.skill-router`
- `타입`: relation to ADF Document Type Catalog
- `카테고리`: select used for board grouping
- `범위`: `Meta`, `Instance`, or `Shared`
- `상태`: `Draft`, `Active`, `Deprecated`, or `Archived`
- `요약`: one-sentence contract

Use `카테고리` select for operational grouping. It intentionally duplicates the catalog category because Notion board grouping by rollup is unreliable through automation.

Edges are first-class SSOT. Create an edge when a node defines, depends on, supersedes, implements, validates, or references another node.

## Reconciliation State

Nodes, Edges, and Tasks carry validation-state properties:

- `정합성 확인됨`: checked when the row passed the latest applicable reconciliation.
- `정합성 상태`: `미확인`, `정상`, `주의`, or `깨짐`.
- `마지막 정합성 확인일`: when reconciliation last evaluated the row.
- `정합성 메모`: one-line reason or suggested fix when not normal.

When you materially edit a Node, Edge, or Task, mark that row as needing reconciliation:

- Set `정합성 확인됨 = false`.
- Set `정합성 상태 = 미확인`, or `주의` / `깨짐` when you already know the risk.
- Add a short `정합성 메모` if the reason is not obvious.

Daily reconciliation sweeps use these properties to avoid re-reading the full graph. Weekly/full reconciliation may ignore them and audit all active/draft graph rows.

## Repository Layout

```text
skills/agentic-delivery-factory/
  SKILL.md                    # Shipped factory bootstrap router
  references/                 # Progressive disclosure for generated instance projects
.cursor/skills/
  adf-task-workflow/          # ADF task board operations
  adf-node-authoring/         # Knowledge Node creation/update
  adf-edge-workflow/          # Knowledge Edge creation/update
  adf-reconciliation/         # Task/node/edge/repo consistency checks
.adf/config.json                # Machine-readable ADF Notion IDs
```

## Operating Loop

ADF applies the same loop to itself that it ships to instances:

1. Classify intent through this router.
2. Run the request intake gate.
3. Load relevant Goals, Tasks, Nodes, and Edges from Notion.
4. Read the catalog page template before writing a node.
5. Execute the smallest repo or Notion change needed.
6. Create or update edges for meaningful dependencies.
7. Run reconciliation, including edge graph checks.
8. Close out with task status, node/edge evidence, repo paths, and next step.

## Development Workflow

1. Load the relevant Notion goal/node/task context.
2. If changing factory behavior, update the matching Knowledge Node or create a new one.
3. Edit the smallest set of repo files needed.
4. If adding an ADF operating workflow, update `.cursor/skills/adf-*`. If it ships to instance projects, update `skills/agentic-delivery-factory/**` instead.
5. Link every non-trivial task to an ADF goal through the `목표` relation. Goals must always be quantitative: set `기준값`, `현재값`, `목표값`, `단위`, `지표`, `KPI 영역`, and `측정 기준`.
6. Add or update edge rows for important dependencies between nodes.
7. Run reconciliation when graph, repo, or bootstrap boundaries change.
8. Run repository checks available for the touched files.
9. Report Notion updates made or exact Notion updates still needed.

## Coding And Skill Authoring

- Keep `SKILL.md` files concise and route detailed procedures into one-level references when needed.
- Use stable names: `agentic-delivery-factory` for the distributable skill, `adf-*` for internal project workflow skills.
- Do not commit secrets, `.env*`, generated databases, or private exports.
- Do not put fake Notion URLs in templates. Use placeholders or the known ADF URLs above.
- Prefer replacing in-progress factory conventions outright over layering compatibility shims.

## Verification

For documentation-only changes, verify by reading the changed files and checking references resolve.

For package metadata changes:

```bash
python3 -m json.tool package.json >/dev/null
python3 -m json.tool .adf/config.json >/dev/null
```

For broad renames:

```bash
rg "legacy repo slug" .
```

Remaining matches are allowed only in migration notes or historical references.

## Cursor Cloud specific instructions

This repository is a **skills and documentation meta-factory** — there is no dev server, Docker stack, or `package.json` install step. Cloud agents operate on Markdown skills, JSON config/schemas, and the external Notion SSOT.

### What runs locally

| Check | Command |
| --- | --- |
| JSON config | `python3 -m json.tool package.json >/dev/null` and `python3 -m json.tool .adf/config.json >/dev/null` |
| Preset manifests | `python3 skills/agentic-delivery-factory/references/presets/validate-manifests.py` |
| Composition contract | `python3 skills/agentic-delivery-factory/references/schemas/validate-composition.py` |
| Legacy slug grep | `rg "legacy repo slug" .` — matches only in docs describing the check are OK |

There is no dedicated linter or test runner. `package.json` is publish metadata only (no `dependencies` or `scripts`).

### Notion MCP (workflow E2E)

ADF work is incomplete without Notion. Enable the **Notion** MCP server in the environment before task/node/edge operations.

- Machine-readable IDs: `.adf/config.json` (`notion.*DataSourceId` and database URLs).
- Typical flow: `notion-fetch` on the ADF project page or a database URL → `notion-search` / `notion-query-database-view` for rows.
- Active Platform tasks view: `https://www.notion.so/6121db0090bf42df96f790bb27b202f4?v=371346da-c456-8192-b814-000cdd8bc500`
- If Notion writes are unavailable, do repo work and leave exact DDL/commands under `notion/` — do not invent IDs.

### Skill routing

| Context | Read first |
| --- | --- |
| Inside this meta-factory repo | `AGENTS.md` router → `.cursor/skills/adf-*` |
| Bootstrapping a new instance project | `skills/agentic-delivery-factory/SKILL.md` (not `adf-*`) |

### Gotchas

- **No hot reload**: editing skills does not restart anything; re-read the file in the agent session.
- **Do not run instance bootstrap** against production Notion from a casual env-setup pass unless the user asked for it.
- **Ripgrep**: use `rg` (preinstalled); the legacy-slug check is documentation hygiene, not a failing test if only README/AGENTS mention the phrase.