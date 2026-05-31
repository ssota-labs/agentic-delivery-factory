---
name: {{PROJECT_SLUG}}-version-bootstrap
description: Bootstrap a new {{PROJECT_NAME}} milestone on the Notion task board with starter tasks, nodes, and edges. Use when the user asks to add a version, milestone, or project slice.
---

# {{PROJECT_NAME}} Milestone Bootstrap

Create Notion task/node/edge structure only; no code edits unless separately requested.

## Workflow

1. Agree on milestone ID and topic.
2. Create or reuse milestone overview node.
3. Create task rows for node writing, edge linking, implementation, and verification.
4. Link tasks to related nodes/edges.
5. Report first recommended task.

## Template Tasks

| Task ID | 작업 유형 | Notes |
|---|---|---|
| `{{TASK_PREFIX}}-PLAT-x-NODE` | 노드 문서 작성 | Write/update milestone nodes |
| `{{TASK_PREFIX}}-PLAT-x-EDGE` | 엣지 생성 | Connect dependencies |
| `{{TASK_PREFIX}}-PLAT-x-IMPL` | 구현 | Repo changes |
| `{{TASK_PREFIX}}-PLAT-x-VERF` | 검증 | Run reconciliation |
