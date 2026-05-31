# Implementation gate

Run before editing code or docs for a `구현` or `검증` task.

## Checklist

1. **Intake decided** — confirm whether this work needs a node, task, and edges before proceeding.
2. **Task located** — read `선행 작업`, `후행 작업`, `상태`, `관련 노드`, `관련 엣지`, and linked `목표`.
3. **Task state** — set `진행중` and `진행일` when starting; use `보류` for blockers.
4. **Node contracts loaded** — linked nodes are not empty and have `상태` Draft/Active, `키`, `타입`, `카테고리`, and `요약`.
5. **Edge dependencies loaded** — active linked edges have valid `출발 노드`, `대상 노드`, and `관계 종류`.
6. **Repo context loaded** — read `AGENTS.md`, `.adf/config.json`, relevant `저장소 경로`, and implementation files.
7. **Override** — only proceed past gaps if user explicitly accepts risk.

## Blocker template

```markdown
Cannot start implementation yet.

Selected task: [task ID]
Blocked by:
- [missing task row or goal link]
- [missing linked node / empty node contract]
- [missing or invalid edge dependency]
- [Notion 선행 작업 relation or incomplete predecessor]
- [repo vs node contract mismatch]

Next recommended action:
- [node/edge/task to create or fix]
```
