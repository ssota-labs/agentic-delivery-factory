---
name: {{PROJECT_SLUG}}-task-workflow
description: Manage {{PROJECT_NAME}} Notion tasks. Use when creating, updating, picking up, blocking, or closing project tasks, or when the user mentions {{TASK_PREFIX}}-* task IDs.
---

# {{PROJECT_NAME}} Task Workflow

Tasks DB: [{{TASKS_DB_URL}}]({{TASKS_DB_URL}})

## Workflow

1. Load `.adf/config.json`.
2. Fetch the named task row or choose the next `대기` / `진행중` task after confirming with the user.
3. Load linked `관련 노드` and `관련 엣지`.
4. Set `상태 = 진행중` only when starting work. Set `진행일` as a datetime (`date:진행일:is_datetime=1`, ISO-8601) at pickup.
5. Use `보류` for blockers with `선행 작업` or blocker note.
6. Do not set `완료` unless the user explicitly asks.
7. Report task ID, status, linked nodes/edges, and next step.

## Task Rules

- Task IDs use `{{TASK_PREFIX}}-{track}-{number}-{kind}`.
- Implementation tasks should link relevant Knowledge Nodes.
- Graph tasks should link relevant Knowledge Edges.
- Durable outcomes must be recorded in nodes/edges, not only chat.
- `진행일` is the timeline start (datetime). `마감일` is the deadline (date-only). Default timeline views: `TIMELINE BY "진행일" TO "마감일"`.
