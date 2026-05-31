# Implementation close-out

Required at end of every `구현` or `검증` session.

## 1. Verify

Run verification commands from AGENTS.md. Document exact commands and results.

## 2. Record in Notion

- Update or create Knowledge Nodes for durable contracts changed by this work.
- Create/update Knowledge Edges for important dependencies, definitions, or validations.
- Link task `관련 노드` and `관련 엣지`.
- Move task to `진행중` when starting; `보류` if blocked.

## 3. Small Node / Policy Updates

Update via node authoring in the same workflow when all apply:

- Change shipped in this PR/session.
- One node contract or one policy rule.
- Update is limited to Contract / Operating Procedure / Change Log.

Use `{{PROJECT_SLUG}}-node-authoring` for larger restructures or new node families.

## 4. Reconcile Delta

| Finding | Severity |
|---|---|
| Code changed but linked node not updated | P1 |
| User asked `완료` but expected artifact missing | P0 |
| Active edge contradicts implementation | P1 |
| Task can be proposed complete but status remains `진행중` | P2 |

For `검증` tasks: run or recommend [{{PROJECT_SLUG}}-reconciliation](../../{{PROJECT_SLUG}}-reconciliation/SKILL.md).

## 5. Report

- Task ID, repo changes, Notion changes.
- Verification commands and results.
- Reconcile delta / P0-P1.
- Whether `완료` can be proposed.
