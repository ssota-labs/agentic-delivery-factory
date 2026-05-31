# Automation seed blueprint

Use during bootstrap Phase 2 seeding after Nodes/Edges/Tasks exist.

## Dev task loop plan node

Suggested properties:

- `노드`: `{PROJECT_NAME} Dev Task Loop`
- `키`: `{PROJECT_SLUG}.automation.dev-task-loop`
- `타입`: Implementation Plan
- `카테고리`: Engineering
- `범위`: Instance
- `상태`: Draft until automation preflight passes
- `요약`: Scheduled task execution loop for dependency-ready implementation, documentation, verification, and reconciliation work.
- `저장소 경로`: `{SKILLS_INSTALL_DIR}/{PROJECT_SLUG}-implementation-workflow/SKILL.md`

Body sections:

- `## 전제 조건`
- `## 작업 선택 규칙`
- `## 라우팅`
- `## Scheduler Close-Out`
- `## Preflight`

## Daily sweep runbook node

Suggested properties:

- `노드`: `{PROJECT_NAME} Daily Reconciliation Sweep`
- `키`: `{PROJECT_SLUG}.reconciliation.daily-sweep`
- `타입`: Runbook
- `카테고리`: Ops
- `범위`: Instance
- `상태`: Active
- `요약`: Daily incremental reconciliation sweep runbook for this instance.
- `저장소 경로`: `{SKILLS_INSTALL_DIR}/{PROJECT_SLUG}-reconciliation/SKILL.md`

Body sections:

- `## 전제 조건`
- `## 절차`
- `## 검증`
- `## 롤백`

## Weekly run log node

Suggested properties:

- `노드`: `{PROJECT_NAME} Reconciliation Run Log — YYYY-WNN`
- `키`: `{PROJECT_SLUG}.reconciliation.run-log.YYYY-wNN`
- `타입`: Evidence / Run Log (choose the closest catalog type available)
- `카테고리`: Ops
- `범위`: Instance
- `상태`: Active
- `요약`: Weekly execution log for daily reconciliation sweeps.

Body sections:

- `## 기록 목적`
- `## 핵심 내용`
- bootstrap checkpoint with `run_at`, `repo_sha`, `counts`, `handled`, `open_drifts`

## Required edges

- Bootstrap / implementation plan -> defines -> dev task loop plan node
- Dev task loop plan node -> depends on -> task workflow skill node (if present)
- Dev task loop plan node -> depends on -> implementation workflow skill node (if present)
- Runbook -> governed by -> reconciliation validation-state policy node (if present)
- Runbook -> documents -> weekly run log node
- Architecture or bootstrap plan node -> defines -> runbook node
