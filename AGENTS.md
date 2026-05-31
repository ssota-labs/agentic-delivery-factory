# AGENTS.md

Instructions for AI agents working in **ssota-labs/agentic-delivery-factory**.

## Project Overview

**Agentic Delivery Factory (ADF)** is the meta-factory for creating agentic delivery instance projects. This repo owns the factory skill kit: templates, workflow skills, and operating rules that turn an idea into a repo + Notion project + Knowledge Graph + task board + agent workflow.

This repo is the **factory for making factories**. The ADF Notion project is the operating SSOT; the repository stores the reusable skill/package implementation.

| Layer | Role | SSOT |
|---|---|---|
| Meta factory | Build and improve the scaffold, skills, templates, and graph conventions | ADF Project + this repo |
| Instance project | A generated portfolio/client/product project | Its own Notion project + repo |
| GTM proof | Portfolio, content, delivery partner validation | ADF goals/tasks |

## Notion SSOT

Start every non-trivial task by loading the relevant Notion context. Do not plan from repository files alone.

| Item | URL |
|---|---|
| ADF Project | https://www.notion.so/371346dac456814d9aa5eb7bbe5b1511 |
| Strategy memo | https://www.notion.so/371346dac456817c978ed58b5e6b39df |
| Document Type Catalog | https://www.notion.so/371346dac45681e89a65c51ec5825017 |
| Knowledge Nodes | https://www.notion.so/04e803dbef5243e39ed02ab370d2290b |
| Knowledge Edges | https://www.notion.so/a2a643eaa6e04981af72bad558115b2c |
| Goals (project-local) | https://www.notion.so/e4cbfacc00ee49238b04fb99431bf86b |
| Tasks | https://www.notion.so/6121db0090bf42df96f790bb27b202f4 |

Data source IDs are recorded in [`.adf/config.json`](.adf/config.json). Goals are project-local (`ADF Goals`), not the workspace-wide SSOTA goals tracker.

## Skill Boundary

ADF uses two skill surfaces. Do not mix them.

| Surface | Role | Location |
|---|---|---|
| Internal operating skills | Operate the ADF Notion SSOT and this repo | `.cursor/skills/adf-*` |
| Shipped bootstrap skill | Create a new instance repo + Notion + skills + config | `skills/agentic-delivery-factory/` |

Instance bootstrap execution belongs in the shipped skill, not in internal `.cursor/skills/`. Internal work may define or validate bootstrap spec nodes and run reconciliation against bootstrap output, but it does not execute instance creation.

Operating contract SSOT: Knowledge Node `adf.v0-1.agentic-operating-system` (Draft).

## ADF Router

For any request, classify intent first and read the matching skill before acting.

| User intent | Route | Read |
|---|---|---|
| 태스크 만들기, 작업 진행, task board, ADF-P* | Task workflow | `.cursor/skills/adf-task-workflow/SKILL.md` |
| 노드 문서 작성, node 생성/수정, SSOT 문서화 | Node authoring | `.cursor/skills/adf-node-authoring/SKILL.md` |
| 엣지 생성, 관계 연결, graph relation | Edge workflow | `.cursor/skills/adf-edge-workflow/SKILL.md` |
| 정합성 체크, 누락 노드/엣지, graph audit | Reconciliation | `.cursor/skills/adf-reconciliation/SKILL.md` |
| 새 instance bootstrap, scaffold, adopt existing repo | Shipped bootstrap skill | `skills/agentic-delivery-factory/SKILL.md` |
| ADF meta factory repo/skills/templates 수정 | Implementation work | Use this AGENTS.md plus repository conventions below |

If Notion write tools are unavailable, do the repository work and leave exact Notion commands or DDL in `notion/` for a later MCP-enabled pass. Do not invent IDs or pretend a Notion write happened.

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
2. Load relevant Goals, Tasks, Nodes, and Edges from Notion.
3. Read the catalog page template before writing a node.
4. Execute the smallest repo or Notion change needed.
5. Create or update edges for meaningful dependencies.
6. Run reconciliation, including edge graph checks.
7. Close out with task status, node/edge evidence, and repo paths.

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
