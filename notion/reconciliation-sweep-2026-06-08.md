# Pending ADF Daily Reconciliation Sweep — 2026-06-08

This file is the exact pending Notion update packet for the 2026-06-08 daily sweep.
It exists because the Notion MCP server was unavailable in Cursor Cloud (`needsAuth`) during
the scheduled run, so the agent could not read or mutate the ADF SSOT.

## Required Notion context

- Daily sweep runbook node: `adf.reconciliation.daily-sweep`
- Validation-state policy node: `adf.reconciliation.validation-state-policy`
- Expected weekly run log node: `adf.reconciliation.run-log.2026-w23`
- Databases from `.adf/config.json`:
  - Nodes: `collection://5c132d44-02c7-4b8c-96ea-e2a3bfeb41fa`
  - Edges: `collection://f9567f0b-8ff2-434d-b011-31ce4d4d1372`
  - Tasks: `collection://b0b5515b-00b4-4a2c-ae31-e591c048cd72`

## Notion operations to apply after MCP authentication

1. Resolve the three required nodes by `키`.
2. If `adf.reconciliation.run-log.2026-w23` exists, append the checkpoint below to that
   node.
3. If the W23 run log node does not exist, do not create one silently. Append a drift entry
   to the latest existing reconciliation run log node asking for a new current weekly run
   log node.
4. Select daily scope from Nodes, Edges, and Tasks where:
   - `정합성 확인됨` is not true,
   - `정합성 상태` is empty or not `정상`,
   - completed tasks are missing durable output, or
   - nodes have `저장소 경로` and repo HEAD changed since the previous run-log checkpoint.
5. Apply Node Schema, Edge Graph, Task Flow, and Repo Alignment checks. Only deterministic
   P2/P3 hygiene may be fixed automatically. Record P0/P1 as open drift.
6. For rows checked successfully, set:
   - `정합성 확인됨 = true`
   - `정합성 상태 = 정상`
   - `마지막 정합성 확인일 = 2026-06-08`
   - `정합성 메모 = Daily sweep 2026-06-08: passed applicable checks.`
7. For drift rows, leave `정합성 확인됨 = false`, set `정합성 상태` to `주의` or `깨짐`,
   and write `정합성 메모` with severity plus suggested fix.

## Checkpoint to append

```markdown
## ADF Daily Reconciliation Sweep — 2026-06-08

- run_at: 2026-06-08T09:01:47Z
- repo_sha: a441ea259ca2ae6d0fadf1bb318b885ce2212822
- expected_weekly_run_log_key: adf.reconciliation.run-log.2026-w23
- scope:
  - Notion Nodes: blocked; MCP server `Notion` reported `needsAuth`
  - Notion Edges: blocked; MCP server `Notion` reported `needsAuth`
  - Notion Tasks: blocked; MCP server `Notion` reported `needsAuth`
  - Repo Alignment: checked locally at current HEAD
- counts:
  - P0: 0
  - P1: 1
  - P2: 0
  - P3: 0

### Handled items

- Repo Alignment checked locally:
  - `package.json` is valid JSON and names `@ssota-labs/agentic-delivery-factory`.
  - `.adf/config.json` is valid JSON and points to `ssota-labs/agentic-delivery-factory`.
  - `README.md`, `AGENTS.md`, and package metadata use the current repo slug.
  - Internal skills exist: task workflow, node authoring, edge workflow, reconciliation.
  - Shipped bootstrap router exists at `skills/agentic-delivery-factory/SKILL.md`.
  - `AGENTS.md` routes instance bootstrap to the shipped skill.
  - Internal skills do not claim to execute instance bootstrap end-to-end.
  - Preset manifests and composition contract validators passed.
  - `legacy repo slug` matches are limited to the documented hygiene command and explanatory text.

### Open drifts

- [P1] [SSOT access] Notion MCP server requires authentication, so the sweep could not
  resolve required nodes, select the daily Nodes/Edges/Tasks scope, update validation-state
  properties, or append this checkpoint to the weekly run log. Suggested fix: authenticate
  the Notion MCP server in Cursor, then replay this packet and continue from the Notion
  scope-selection step.

### Next start

- Authenticate Notion MCP, resolve `adf.reconciliation.run-log.2026-w23`, select rows where
  `정합성 확인됨` is not true or `정합성 상태` is empty/not `정상`, and continue with Node
  Schema plus Edge Graph checks before Task Flow row updates.
```

## Local verification evidence

Commands run successfully:

```bash
python3 -m json.tool package.json >/dev/null
python3 -m json.tool .adf/config.json >/dev/null
python3 skills/agentic-delivery-factory/references/presets/validate-manifests.py
python3 skills/agentic-delivery-factory/references/schemas/validate-composition.py
rg "legacy repo slug" .
```

Validator output:

```text
OK: validated 7 Stack Adapter manifest(s)
OK: validated 1 composition contract file(s)
```
