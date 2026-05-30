# Implementation gate

Run **before** editing code for a `구현` or `검증` task.

## Checklist

1. **Task located** — current row in [development task database]({{TASKS_DB_URL}}); read `Blocked by`, `Blocking`, `종속성`, `상태`, `관련 문서`.
2. **PRD + D3 linked** — version PRD and D3 (설계) exist in docs DB and appear in `관련 문서`. Empty pages do not count.
3. **Predecessors** — prior milestone IMPL is `완료` (or accepted WIP) **and** expected code exists on `main`.
4. **Override** — only if user explicitly accepted risk after a gap report (record in PR/commit).
5. **On failure** — do not open a "starter" implementation PR.

## Blocker template

```markdown
Cannot start implementation yet.

Selected candidate: [task ID / milestone]
Blocked by:
- [missing or blank PRD / D3 / ADR]
- [Notion Blocked by relation or incomplete predecessor]
- [repo vs Notion contract mismatch, if any]

Next recommended action:
- [{{TASK_PREFIX}}-Px.x-PRD / DSGN / ADR task or doc to complete first]
```
