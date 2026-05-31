# agentic-delivery-factory

**Agentic Delivery Factory (ADF)** is the meta-factory for spinning up agentic delivery projects: repo scaffold, Notion project, Knowledge Nodes/Edges, task board, and project-scoped agent workflows.

This repository contains the reusable skill package and the internal ADF operating skills used to manage the factory itself.

## Notion SSOT

| Item | URL |
|---|---|
| ADF Project | https://www.notion.so/371346dac456814d9aa5eb7bbe5b1511 |
| Strategy memo | https://www.notion.so/371346dac456817c978ed58b5e6b39df |
| Document Type Catalog | https://www.notion.so/371346dac45681e89a65c51ec5825017 |
| Knowledge Nodes | https://www.notion.so/04e803dbef5243e39ed02ab370d2290b |
| Knowledge Edges | https://www.notion.so/a2a643eaa6e04981af72bad558115b2c |
| Goals (project-local) | https://www.notion.so/e4cbfacc00ee49238b04fb99431bf86b |
| Tasks | https://www.notion.so/6121db0090bf42df96f790bb27b202f4 |

The ADF project-local Goals and Tasks DBs are connected in Notion and recorded in [`.adf/config.json`](.adf/config.json).

## What This Repo Builds

- A distributable `agentic-delivery-factory` skill for bootstrapping instance projects.
- ADF project workflow skills for task handling, node authoring, edge creation, and reconciliation.
- Templates and operating rules for generated projects.

## Layout

```text
skills/agentic-delivery-factory/     # distributable factory bootstrap skill
.cursor/skills/adf-*                 # internal ADF project management skills
.adf/config.json                       # ADF Notion IDs and conventions
AGENTS.md                            # agent operating router
```

## Local Verification

```bash
python3 -m json.tool package.json >/dev/null
python3 -m json.tool .adf/config.json >/dev/null
rg "legacy repo slug" .
```

The legacy repo slug should not appear in active instructions.
