# Reconciliation checklist

Scope default: **full** development task database + `main` at audit revision.

## Severity

| Level | Meaning | Example |
|---|---|---|
| **P0** | Wrong agent/human action likely | `완료` IMPL, no matching code on `main`; IMPL with no linked PRD/D3 |
| **P1** | SSOT trust degraded | D3 contradicts merged code; `보류` without blocker note |
| **P2** | Hygiene | Stale `AGENTS.md`; orphan doc not linked to any task |
| **P3** | Doc quality | PRD contains implementation-only detail that belongs in D3; ADR edited in place |

## Axis A — Task ↔ Code

For each row with `작업 유형` = `구현` or `검증`:

| Check | P0 if |
|---|---|
| `완료` | Expected artifacts absent on `main` (per D3/IMPL title) |
| `진행중` | No branch/PR activity and no WIP note on task |
| `대기` | Blocking relations claim predecessor `완료` but predecessor code missing |

## Axis B — Doc ↔ Code

For each page in `관련 문서` on IMPL/VERF/Spec-related tasks:

| Doc `태그` | Check |
|---|---|
| `설계` (D3) | Interfaces, data model, verification plan match `main` |
| `스펙` | Current Contract section matches `main`; tests cited in doc exist |
| `PRD` | No implementation detail that contradicts D3/code without open question |

## Axis C — Task ↔ Doc links

| Check | P0 if |
|---|---|
| IMPL / VERF | Zero linked PRD or D3 |
| PRD / 설계 tasks | `완료` but linked doc empty or missing |
| Any task | Linked doc `태그` mismatches work type (PRD content under `설계`) |

## Axis E — Dependency graph

| Check | P1 if |
|---|---|
| `Blocked by` / `종속성` | Names predecessor milestone whose IMPL not `완료` and code absent |
| Blueprint / roadmap | Version in task title not reflected in phase Blueprint scope |

## Scheduler default prompt

```text
정합성 체크해줘. 개발 태스크 DB 전체, main 최신 기준.
```

After the run, file a Notion log page (`태그` = `정합성`) — see [report-template.md](report-template.md). Do not save reports in the repo.

## Out of scope (unless explicit)

- Product/runtime SSOT separate from development Notion (e.g. local workspace DB, production config)
- End-user shipped skill contracts unless project defines a separate eval policy in AGENTS.md
