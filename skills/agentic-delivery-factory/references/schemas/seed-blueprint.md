# Seed Project Overview Node

Use when the user opted to seed the first instance milestone. Create this as a Knowledge Node in the Nodes DB, not as a loose docs page.

## Suggested properties

- `노드`: {{PROJECT_NAME}} — 프로젝트 개요
- `키`: {{PROJECT_SLUG}}.project-overview
- `타입`: Project Brief
- `카테고리`: Product
- `범위`: Instance
- `상태`: Draft
- `요약`: One-sentence project contract.

## Body

```markdown
## Executive Summary
{{PROJECT_OVERVIEW}}

## Goals
- [Goal]

## Factory Instance Contract
- Repo: {{GITHUB_REPO}}
- Tasks: {{TASKS_DB_URL}}
- Nodes: {{NODES_DB_URL}}
- Edges: {{EDGES_DB_URL}}

## Open Questions
- [Unknowns]
```
