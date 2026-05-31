# Daily Reconciliation Sweep — instance automation template

Use this when bootstrapping a new instance project or when the user asks to install the daily drift sweep automation.

## Purpose

Run an incremental reconciliation sweep daily and append results to the current weekly Reconciliation Run Log Knowledge Node.

## Prerequisites

- Instance repo checkout linked to Cursor Automation (`gitConfig.repo`, `gitConfig.branch`)
- Notion MCP access to the instance Goals, Nodes, Edges, and Tasks databases
- Nodes, Edges, and Tasks include reconciliation validation-state properties
- Runbook node exists, keyed like `{projectSlug}.reconciliation.daily-sweep`
- Current weekly run log node exists, keyed like `{projectSlug}.reconciliation.run-log.YYYY-wNN`

## Automation metadata

| Field | Value |
|---|---|
| Name | `{PROJECT_NAME} Daily Reconciliation Sweep` |
| Description | Runs a daily incremental reconciliation sweep and appends results to the weekly run log Knowledge Node. |
| Schedule | `0 9 * * *` (daily 09:00; adjust in Automations UI if needed) |
| Repo | `{GITHUB_REPO}` |
| Branch | `{INTEGRATION_BRANCH}` |
| Tools | Notion MCP |

## Workflow JSON shape

Use this reviewed payload with Cursor Automations create/open tools. Replace placeholders before saving.

```json
{
  "name": "{PROJECT_NAME} Daily Reconciliation Sweep",
  "description": "Runs a daily incremental reconciliation sweep for {PROJECT_NAME} and appends results to the weekly run log Knowledge Node.",
  "workflow": {
    "triggers": [
      { "cron": { "cron": "0 9 * * *" } }
    ],
    "actions": [
      { "mcp": { "server": { "name": "plugin-notion-workspace-notion" } } }
    ],
    "prompts": [
      {
        "prompt": "Run the {PROJECT_NAME} Daily Reconciliation Sweep.\n\nRepository and SSOT:\n- Repo: {GITHUB_REPO} on {INTEGRATION_BRANCH}\n- Read `.adf/config.json`, `AGENTS.md`, `{SKILLS_INSTALL_DIR}/{PROJECT_SLUG}-reconciliation/SKILL.md`, and the Notion nodes `{PROJECT_SLUG}.reconciliation.daily-sweep`, reconciliation validation-state policy if present, and the current weekly run log node.\n\nProcedure:\n1. Resolve the current weekly run log node. If the calendar week changed and no current weekly log node exists, do not invent silently; create a clear drift entry in the latest log asking for a new weekly run log node.\n2. Select daily scope from Nodes, Edges, and Tasks where `정합성 확인됨` is not true, `정합성 상태` is empty or not `정상`, completed tasks missing durable output, and nodes with `저장소 경로` when repo HEAD changed since the previous run.\n3. Apply reconciliation checks: Node Schema, Edge Graph, Task Flow, Repo Alignment.\n4. You may fix only deterministic P2/P3 hygiene. Do not silently fix P0/P1. Record P0/P1 as open drift with suggested action.\n5. For rows checked successfully, set `정합성 확인됨=true`, `정합성 상태=정상`, update `마지막 정합성 확인일`, and keep `정합성 메모` concise. For drift, leave `정합성 확인됨=false`, set `정합성 상태=주의` or `깨짐`, and write `정합성 메모`.\n6. Append a checkpoint to the weekly run log node with run_at, repo_sha, scope, counts P0/P1/P2/P3, handled items, open drifts, and next_start.\n7. End with a short summary. Do not create PRs, do not mark tasks complete, and do not rewrite policy nodes unless explicitly instructed."
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

1. Seed the runbook node and first weekly run log node in the instance graph.
2. Replace placeholders in the workflow JSON.
3. Create the automation with Cursor Automations if backend tools are available; otherwise open the Automations editor with the reviewed draft.
4. Link the runbook node to the automation URL in Notion if useful.
5. Do not mark bootstrap complete until the automation repo setting matches `{GITHUB_REPO}` and branch matches `{INTEGRATION_BRANCH}`.

## Guardrails

- Do not auto-fix P0/P1 drift.
- Do not create rolling reconciliation tasks; use weekly run log nodes.
- Do not rewrite catalog templates during sweep runs.
- Disable the automation in Cursor if it over-modifies Notion rows.
