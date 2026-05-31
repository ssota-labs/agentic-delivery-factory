# Reconciliation Report Template

Store durable reconciliation output in Notion as a Knowledge Node or task note. Do not save reports under repo `docs/` unless the user explicitly asks.

```markdown
# 정합성 체크 — YYYY-MM-DD

## Scope
- Tasks: {{TASKS_DB_URL}}
- Nodes: {{NODES_DB_URL}}
- Edges: {{EDGES_DB_URL}}
- Repo SHA: [sha]

## Summary
P0=0 / P1=0 / P2=0 / P3=0

## Findings
- [P1] [Node] ...

## Suggested Fixes
- Create/update task ...
- Update node ...
- Deprecate/create edge ...
```
