# Implementation gate

Run before editing code for a `구현` or `검증` task.

## Checklist

1. **Task located** — read `선행 작업`, `후행 작업`, `종속성`, `상태`, `관련 노드`, `관련 엣지`.
2. **Node contracts loaded** — linked nodes are not empty and have `상태` Draft/Active, `키`, `타입`, `카테고리`, and `요약`.
3. **Edge dependencies loaded** — active linked edges have valid `출발 노드`, `대상 노드`, and `관계 종류`.
4. **Repo context loaded** — read `AGENTS.md`, relevant `저장소 경로`, and implementation files.
5. **Override** — only proceed past gaps if user explicitly accepts risk.

## Blocker template

```markdown
Cannot start implementation yet.

Selected task: [task ID]
Blocked by:
- [missing linked node / empty node contract]
- [missing or invalid edge dependency]
- [Notion 선행 작업 relation or incomplete predecessor]
- [repo vs node contract mismatch]

Next recommended action:
- [node/edge/task to create or fix]
```
