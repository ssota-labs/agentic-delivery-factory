# Implementation close-out

Required at end of every `구현` or `검증` session.

## 1. Verify

Run verification commands from AGENTS.md. Document exact commands and results.

## 2. Record in Notion

- Update or create Knowledge Nodes for durable contracts changed by this work.
- Create/update Knowledge Edges for important dependencies, definitions, or validations.
- Link task `관련 노드` and `관련 엣지`.
- Keep task `진행중` while evidence is still incomplete; use `보류` if blocked.

## 2.5. Completion mode

Close-out behavior depends on run mode:

| Run mode | Rule |
|---|---|
| Interactive chat | Do not set `완료` unless the user explicitly asks or approves it. |
| Scheduler automation | If `.adf/config.json` has `automation.autoCompleteOnScheduler = true` and all close-out gates pass, set task `상태 = 완료` directly. |

Scheduler automation must not leave a gate-passing task in `진행중` waiting for human sign-off, because that blocks dependency-ready downstream tasks. If any gate fails, set `상태 = 보류` and write a concise blocker note instead.

## 3. Reconciliation state

When materially changing linked Nodes, Edges, or the task row:

- set `정합성 확인됨 = false`
- set `정합성 상태 = 미확인`
- add `정합성 메모` when the reason is not obvious

If reconciliation ran in the same session and the row passed, set `정합성 확인됨 = true`, `정합성 상태 = 정상`, and update `마지막 정합성 확인일`.

## 4. Small Node / Policy Updates

Update via node authoring in the same workflow when all apply:

- Change shipped in this PR/session.
- One node contract or one policy rule.
- Update is limited to Contract / Operating Procedure / Change Log.

Use `{{PROJECT_SLUG}}-node-authoring` for larger restructures or new node families.

## 5. Reconcile Delta

| Finding | Severity |
|---|---|
| Code changed but linked node not updated | P1 |
| User asked `완료` but expected artifact missing | P0 |
| Active edge contradicts implementation | P1 |
| Task can be proposed complete but status remains `진행중` | P2 |
| Validation state says `정상` while evidence is missing | P1 |

For `검증` tasks: run or recommend [{{PROJECT_SLUG}}-reconciliation](../../{{PROJECT_SLUG}}-reconciliation/SKILL.md).

## 6. Report

- Task ID, repo changes, Notion changes.
- Whether a node/task should have been created and what was created.
- Verification commands and results.
- Reconcile delta / P0-P1.
- Completion action: proposed, applied, blocked, or not applicable.

Interactive runs should not set `완료` unless the user explicitly asks. Scheduler runs should apply the scheduler completion rule above.
