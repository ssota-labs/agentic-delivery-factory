---
name: agentic-delivery-factory
description: Bootstrap agentic delivery instance projects from the ADF pattern — create or adopt a repo, Notion project, Goals, Knowledge Nodes, Knowledge Edges, task board, AGENTS.md, and project workflow skills. Use when the user asks to create a factory instance, scaffold a delivery project, build a Notion Knowledge Graph for a repo, or set up agentic delivery workflows.
---

# Agentic Delivery Factory

Single entry skill for creating **instance projects** from the ADF meta-factory pattern.

This is the **deployment surface** for instance bootstrap. It is not an internal ADF operating skill. When working inside the ADF meta-factory repo itself, use `.cursor/skills/adf-*` instead.

## When To Use

Use this when the user asks for:

- "새 아이디어를 ADF 방식으로 프로젝트화해줘"
- "repo + Notion project + goal/node/edge/task DB 세팅해줘"
- "youpd처럼 AGENTS.md와 skills까지 깔아줘"
- "factory instance scaffold"
- "agentic delivery workflow bootstrap"

## Output

An instance project should have:

1. Local or remote repository scaffold.
2. Notion project page.
3. Goals, Document Type Catalog, Knowledge Nodes, Knowledge Edges.
4. Task DB linked to goals, nodes, and edges.
5. `AGENTS.md` router.
6. Project-scoped skills for task workflow, node authoring, edge workflow, implementation, and reconciliation.

## ADF Source Pattern

The source ADF project is:

- Project: https://www.notion.so/371346dac456814d9aa5eb7bbe5b1511
- Catalog: https://www.notion.so/371346dac45681e89a65c51ec5825017
- Nodes: https://www.notion.so/04e803dbef5243e39ed02ab370d2290b
- Edges: https://www.notion.so/a2a643eaa6e04981af72bad558115b2c
- Goals (project-local): https://www.notion.so/e4cbfacc00ee49238b04fb99431bf86b
- Tasks: https://www.notion.so/6121db0090bf42df96f790bb27b202f4

## Routes

Read the matching reference before writing files or Notion data:

| Intent | Read |
|---|---|
| New instance bootstrap | `references/init/wizard.md` |
| Adopt an existing repo/project | `references/init/adopt-existing.md` |
| Verify an existing instance schema | `references/init/verify-schema.md` |

## Safety Rules

- Get explicit approval before creating or updating Notion databases.
- Do not invent Notion IDs. Fetch and record URLs/data source IDs after creation.
- If Notion tools are unavailable, write an exact setup plan and stop before claiming completion.
- Do not overwrite an existing `AGENTS.md` without showing the replacement summary.
- Instance projects may diverge, but ADF core conventions live in the source project and this repo.

## After Bootstrap

Tell the user:

1. Project page URL
2. Goals / Catalog / Nodes / Edges / Tasks DB URLs
3. Local repo path
4. Files written (`AGENTS.md`, `.adf/config.json`, project skills)
5. First suggested task and node to start from
6. Required graph edges created for bootstrap outputs (spec, workflows, policies, repo paths)

Bootstrap is not complete until the instance graph has edges for important dependencies, not just node rows.
