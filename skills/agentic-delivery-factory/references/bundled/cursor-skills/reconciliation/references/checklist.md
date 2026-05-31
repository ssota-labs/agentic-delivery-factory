# Reconciliation checklist

Scope default: full Tasks + Nodes + Edges + repo at audit revision.

## Validation State

Nodes, Edges, and Tasks should include:

- `정합성 확인됨` checkbox
- `정합성 상태` select: `미확인`, `정상`, `주의`, `깨짐`
- `마지막 정합성 확인일` date
- `정합성 메모` text

Daily sweeps start from unchecked or non-normal rows. Full sweeps may ignore these properties.

## Severity

| Level | Meaning | Example |
|---|---|---|
| P0 | Wrong agent/human action likely | `완료` task with no repo/node/edge output |
| P1 | SSOT trust degraded | Active edge points to missing node; code contradicts Active node |
| P2 | Hygiene | Missing `저장소 경로`; category mismatch |
| P3 | Doc quality | Weak summary or stale open question |

## Axis A — Task ↔ Output

| Check | P0/P1 if |
|---|---|
| `완료` task | No durable output in repo, node, edge, or GTM artifact |
| `진행중` task | No linked node/edge and no current repo activity |
| `보류` task | No blocker relation or blocker note |
| Validation state | `정합성 확인됨` true while `정합성 상태` is not `정상` |

## Axis B — Node ↔ Repo

| Check | P1 if |
|---|---|
| Active node with `저장소 경로` | Path missing or contradicts node contract |
| Node `카테고리` | Does not match type/category and no rationale |
| Duplicate `키` | More than one active/draft node shares key |

## Axis C — Edge Graph

| Check | P1 if |
|---|---|
| Active edge endpoints | `출발 노드` or `대상 노드` missing |
| Duplicate edge | Same `출발 노드` / `대상 노드` / kind repeated |
| Deprecated edge | Still used as active dependency |
| Prose-only dependency | Active node/task cites dependency with no matching edge |
| Bootstrap output | New instance nodes exist without required bootstrap/spec edges |

## Scheduler default prompt

```text
정합성 체크해줘. ADF task/node/edge/repo 전체 기준.
```

After the run, record durable findings in Notion when tools are available. Do not save reports in the repo unless explicitly requested.
