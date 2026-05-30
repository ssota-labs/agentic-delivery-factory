# Verify Notion task/docs schema

Compare fetched database schemas against the expected SSOT shape. Use during **adopt** mode or after **create** + relation setup.

## How to run

1. `notion-fetch` the database URL or ID
2. Parse property names and types from the response
3. Compare to expected lists below

## Expected — Tasks database

| Property | Type | Required |
|---|---|---|
| `Task` | title | yes |
| `Task ID` | rich_text | yes |
| `상태` | status | yes — options include 대기, 진행중, 보류, 완료, 취소 |
| `작업 유형` | select | yes — includes PRD 작성, 설계 작성, 구현, 검증, 상세 로드맵 작성 |
| `종속성` | rich_text | yes |
| `관련 문서` | relation → Docs | yes |
| `Blocked by` | relation → Tasks (self) | yes |
| `Blocking` | relation → Tasks (self) | yes |

## Expected — Docs database

| Property | Type | Required |
|---|---|---|
| `Name` | title | yes |
| `태그` | multi_select | yes — includes PRD, 설계, 스펙, 정책, ADR, 정합성, 제품 로드맵 |
| `상태` | select | yes — includes 초안, 확정 |
| `관련 태스크` | relation → Tasks | yes (synced dual of Tasks.`관련 문서`) |

## Report format

```markdown
## Schema verification — Tasks
- OK: (list)
- Missing: (list)
- Extra: (list — informational only)

## Schema verification — Docs
- OK: (list)
- Missing: (list)
- Extra: (list)

## Suggested fixes (if missing)
- ALTER TABLE ... (only if user approved apply)
```

## Suggested ALTER snippets

**Add missing Docs `태그` option `정합성`:**

```sql
ALTER COLUMN "태그" SET multi_select('가이드', '제품 로드맵', 'PRD', 'ADR', '설계', '릴리즈 노트', '리서치', '정책', '스펙', '정합성')
```

Include **all** existing options when altering multi_select — merge, do not replace unknown options.

**Add missing relation on Tasks (after both DS IDs known):**

See [../schemas/relations-setup.md](../schemas/relations-setup.md).

## Pass criteria

Adopt mode may proceed to write target repo files only when all **Required** rows are OK or user explicitly accepted partial setup with documented gaps.
