# Dev Task Loop — instance automation template

Use this when bootstrapping a new instance project that should run YouPD-style scheduled implementation/documentation work from the project task board.

## Purpose

Every few minutes, resume dependency-ready in-flight work or pick the next eligible dependency-ready task, route it through the project workflow skills, and close it out when scheduler gates pass.

This automation is separate from the Daily Reconciliation Sweep:

| Automation | Primary job | Default cadence |
|---|---|---|
| Dev Task Loop | Execute dependency-ready tasks through documentation / implementation / verification workflows | `*/5 * * * *` |
| Daily Reconciliation Sweep | Detect and triage graph/task/repo drift | `0 9 * * *` |

## Prerequisites

- Instance repo checkout linked to Cursor Automation (`gitConfig.repo`, `gitConfig.branch`)
- Notion MCP access to the instance Goals, Nodes, Edges, and Tasks databases
- Project workflow skills installed under `{SKILLS_INSTALL_DIR}`
- `AGENTS.md` includes the scheduler loop and close-out mode rules
- Integration branch exists and is pushable by the automation
- PR/merge preflight has passed before enabling autonomous merges

## Automation metadata

| Field | Value |
|---|---|
| Name | `{PROJECT_NAME} Dev Task Loop` |
| Description | Every 5 minutes, resumes dependency-ready in-flight work or picks the next eligible task for `{PROJECT_NAME}`; routes to documentation, implementation, verification, or reconciliation workflow; and applies scheduler close-out when gates pass. |
| Schedule | `*/5 * * * *` |
| Repo | `{GITHUB_REPO}` |
| Branch | `{INTEGRATION_BRANCH}` |
| Tools | Git PR/check actions, Notion MCP |

## Workflow JSON shape

Use this reviewed payload with Cursor Automations create/open tools. Replace placeholders before saving. If the Automations editor represents GitHub PR/check capabilities differently, select the equivalent Git PR and check-run tools in the editor; do not save without Notion MCP.

```json
{
  "name": "{PROJECT_NAME} Dev Task Loop",
  "description": "Every 5 minutes, resumes dependency-ready in-flight work or picks the next eligible task for {PROJECT_NAME}; routes to project workflow skills; and applies scheduler close-out when gates pass.",
  "workflow": {
    "triggers": [
      { "cron": { "cron": "*/5 * * * *" } }
    ],
    "actions": [
      { "gitPr": {} },
      { "manageCheckRun": {} },
      { "mcp": { "server": { "name": "plugin-notion-workspace-notion" } } }
    ],
    "prompts": [
      {
        "prompt": "You are the {PROJECT_NAME} scheduled development agent for repo {GITHUB_REPO}.\n\nAlways read `AGENTS.md` first, especially the Delivery SSOT, Agent Router, Scheduler Loop, Task Rules, and Reconciliation State sections. Then read `.adf/config.json` and the project workflow skills under `{SKILLS_INSTALL_DIR}`.\n\nRun mode: scheduler automation. This matters: when close-out gates pass, apply `완료` directly instead of merely proposing it. If gates fail, set `보류` with a concise blocker note.\n\nEach run:\n1. Notion gate: load `.adf/config.json`; query the instance Tasks DB; if Notion is unavailable, stop and record a reconciliation/drift note if possible. Do not implement from memory.\n2. De-dupe and conflict-first: inspect open PRs targeting `{INTEGRATION_BRANCH}` and active `진행중` tasks. Resume in-progress work before starting new work. Resolve merge conflicts before new features.\n3. Reconciliation gate: if there is known P0/P1 drift that affects the selected scope, run `{PROJECT_SLUG}-reconciliation` or set the candidate task `보류`; do not start new implementation that depends on broken graph/task/repo state.\n4. Pick work: resume only dependency-ready in-progress work, or pick the next eligible `대기` task whose `선행 작업` are `완료` and whose required durable inputs exist. If no task is eligible, no-op for this tick.\n5. Route by `작업 유형`: node/documentation work -> `{PROJECT_SLUG}-node-authoring` or documentation workflow if installed; edge work -> `{PROJECT_SLUG}-edge-workflow`; `구현` or `검증` -> `{PROJECT_SLUG}-implementation-workflow`; reconciliation -> `{PROJECT_SLUG}-reconciliation`.\n6. Branch and PR: use `{INTEGRATION_BRANCH}` as the integration branch and `{RELEASE_BRANCH}` as the human promotion branch. Never auto-merge to `{RELEASE_BRANCH}`.\n7. Guarded merge to `{INTEGRATION_BRANCH}` only when checks are green or not configured, the PR is mergeable, no P0 drift remains, no secrets/destructive operations are present, and task acceptance criteria are met.\n8. Scheduler close-out: when gates pass, update task `상태=완료`, link durable outputs through `관련 노드`, `관련 엣지`, and `저장소 경로`, and update reconciliation state. Do not wait for human approval in scheduler mode.\n9. End with: task ID or no-op reason, PR URL if any, merge status, verification commands/evidence, Notion status applied, open drift, and next eligible task if obvious."
      }
    ],
    "model": "",
    "gitConfig": {
      "repo": "{GITHUB_REPO}",
      "branch": "{INTEGRATION_BRANCH}"
    },
    "agentOptions": { "skipInstall": false },
    "memoryEnabled": true
  }
}
```

## Bootstrap procedure

1. Confirm `integrationBranch` and `releaseBranch` in `.adf/config.json`.
2. Confirm the integration branch exists remotely and the automation has write access.
3. Replace placeholders in the workflow JSON.
4. Create or open the Cursor Automation for the dev task loop.
5. Keep the automation disabled or draft until PR/check/merge preflight has passed.
6. Record the automation URL in the bootstrap report and, if useful, in the bootstrap/implementation plan node.

## Guardrails

- Do not auto-merge to the release branch.
- Do not bypass `선행 작업` / dependency readiness.
- Do not start speculative work when no eligible task exists.
- Do not continue implementation when selected task scope has unresolved P0/P1 drift.
- Scheduler mode may set `완료` only after close-out gates pass; interactive mode still requires user request or approval before `완료`.
