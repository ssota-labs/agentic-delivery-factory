# Verify ADF Notion schema

Compare fetched database schemas against the expected ADF instance shape. Use during **adopt** mode or after **create** + relation setup.

## How to run

1. `notion-fetch` each database URL or data source ID.
2. Parse property names and types from the response.
3. Compare to expected lists below.

## Expected — Nodes database

| Property | Type | Required |
|---|---|---|
| `노드` | title | yes |
| `키` | text | yes |
| `요약` | text | yes |
| `상태` | select | yes — Draft, Active, Deprecated, Archived |
| `카테고리` | select | yes — native select for board grouping |
| `범위` | select | yes — Meta, Instance, Shared |
| `타입` | relation → Catalog | yes |
| `저장소 경로` | text | recommended |
| `정합성 확인됨` | checkbox | yes |
| `정합성 상태` | select | yes — 미확인, 정상, 주의, 깨짐 |
| `마지막 정합성 확인일` | date | recommended |
| `정합성 메모` | text | recommended |

## Expected — Edges database

| Property | Type | Required |
|---|---|---|
| `관계` | title | yes |
| `출발 노드` | relation → Nodes | yes |
| `대상 노드` | relation → Nodes | yes |
| `관계 종류` | select | yes |
| `상태` | select | yes |
| `메모` | text | recommended |
| `정합성 확인됨` | checkbox | yes |
| `정합성 상태` | select | yes — 미확인, 정상, 주의, 깨짐 |
| `마지막 정합성 확인일` | date | recommended |
| `정합성 메모` | text | recommended |

## Expected — Goals database

Every goal must be quantitative. Do not accept goals without numeric `목표값`, `단위`, and `측정 기준`.

| Property | Type | Required |
|---|---|---|
| `목표` | title | yes |
| `목표 ID` | text | yes |
| `상태` | select | yes — 대기, 진행중, 보류, 완료, 취소 |
| `트랙` | select | yes |
| `우선순위` | select | yes |
| `범위` | select | recommended |
| `KPI 영역` | select | yes — 콘텐츠 반응, 유료 판매, 실행 산출물, Platform 구축 |
| `지표` | select | yes — 콘텐츠 발행 수, 총 반응 수, 판매 페이지 공개, 유료 구매 수, 유료 매출, Platform milestone 완료 |
| `기준값` | number | yes — usually 0 |
| `현재값` | number | yes |
| `목표값` | number | yes |
| `단위` | select | yes — 개, 건, 원 |
| `달성률` | formula | recommended — 현재값 / 목표값 |
| `측정 기준` | text | yes — how 현재값 is counted |
| `요약` | text | recommended |
| `상위 목표` / `하위 목표` | self relation | optional — for KPI hierarchy |
| `시작일` / `마감일` | date | recommended |
| `작업` | relation → Tasks | yes — dual from `목표` |

## Expected — Tasks database

| Property | Type | Required |
|---|---|---|
| `작업` | title | yes |
| `작업 ID` | text | yes |
| `상태` | select/status | yes — 대기, 진행중, 보류, 완료, 취소 |
| `작업 유형` | select | yes |
| `트랙` | select | yes |
| `우선순위` | select | yes |
| `목표` | relation → Goals | yes |
| `진행일` | date (datetime values) | recommended — set with `is_datetime=1` at pickup |
| `마감일` | date (date-only values) | recommended |
| `관련 노드` | relation → Nodes | yes |
| `관련 엣지` | relation → Edges | yes |
| `선행 작업` / `후행 작업` | self relation | yes |
| `정합성 확인됨` | checkbox | yes |
| `정합성 상태` | select | yes — 미확인, 정상, 주의, 깨짐 |
| `마지막 정합성 확인일` | date | recommended |
| `정합성 메모` | text | recommended |

Project-page task timeline view should mirror the ADF source page: `TIMELINE BY "진행일" TO "진행일"`.

## Expected — Project page layout and views

Use [../schemas/project-page-layout.md](../schemas/project-page-layout.md) as the source manifest.

Required project page order:

1. Factory definition callout
2. Knowledge Nodes inline linked database
3. Tasks inline linked database
4. Goals inline linked database
5. Reference DB toggle
6. Toggle children in order: Catalog, Nodes, Edges, Tasks, Goals

Required views:

| Data source | View | Type | Required configuration |
|---|---|---|---|
| Nodes | `Active SSOT` | list | `범위 = Instance` (or `Meta` for ADF itself), `상태 in Active/Draft`, sort `키 ASC`, show source property list |
| Nodes | `카테고리별` | board | same filter, `GROUP BY "카테고리"`, sort `키 ASC`, show source property list |
| Tasks | `Default view` | timeline | `TIMELINE BY "진행일" TO "진행일"`, sort `진행일 ASC`, `작업 ID ASC`, show `작업`, `작업 유형`, `트랙` |
| Goals | `Active Goals` | table | `상태 in 대기/진행중/보류`, sort `목표 ID ASC`, show source property list |

If Notion API cannot expose or set a view affordance such as timeline dependency rendering, report the manual parity step. Do not mark project-page parity complete until every API-visible view setting matches the manifest.

## Report format

```markdown
## Schema verification

### Nodes
- OK:
- Missing:
- Extra:

### Edges
- OK:
- Missing:
- Extra:

### Goals
- OK:
- Missing:
- Extra:

### Tasks
- OK:
- Missing:
- Extra:

### Project Page Parity
- OK:
- Missing:
- Manual:

## Suggested fixes
- ADD COLUMN ... (only if user approved apply)
```

## Pass criteria

Adopt mode may proceed only when all required rows are OK or the user explicitly accepts partial setup with documented gaps.
