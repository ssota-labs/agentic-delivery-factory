# Project page layout and view parity

Use this during instance bootstrap after Goals, Catalog, Nodes, Edges, and Tasks databases exist.

The instance project page should mirror the current ADF project page surface, not merely contain links to databases. Layout, linked database order, view names, filters, sorts, timeline settings, grouping, and visible properties are part of the bootstrap contract.

## Source page

- ADF source project: https://www.notion.so/371346dac456814d9aa5eb7bbe5b1511

Preferred path:

1. Fetch the ADF source project page.
2. Duplicate the page or apply this manifest to a newly created project page.
3. Rewire linked database views to the instance data sources.
4. Verify page block order and view configurations before declaring bootstrap complete.

If duplication preserves child databases and views, prefer duplication for visual parity, then replace source-linked databases with instance-linked views. If duplication is unavailable or creates unwanted source DB clones, build the page from the manifest below.

## Page block order

Render the instance project page in this exact order:

1. Callout with icon `🏭` and `green_bg` color.
2. Inline linked database view for Knowledge Nodes.
3. Inline linked database view for Tasks.
4. Inline linked database view for Goals.
5. Toggle titled `Reference DB (카탈로그 · Goals · Edges · Nodes · Tasks full)`.
6. Inside the toggle, database subpage/link blocks in this exact order:
   1. Document Type Catalog
   2. Knowledge Nodes
   3. Knowledge Edges
   4. Tasks
   5. Goals

## Callout template

```markdown
<callout icon="🏭" color="green_bg">
	**공장 정의**
	*{PROJECT_NAME} | Notion SSOT + 에이전트 워크플로우로 instance를 빠르게 생산하는 제품 공장*
</callout>
```

## Linked view manifest

The source ADF project uses project-local scope value `Meta`. For generated instance projects, use `Instance` unless the bootstrap target is the ADF meta project itself.

### Knowledge Nodes — Active SSOT

Type: `list`

Configure:

```text
FILTER "범위" = "{PROJECT_SCOPE}"
FILTER ("상태" = "Active" OR "상태" = "Draft")
SORT BY "키" ASC
SHOW "노드", "타입", "카테고리", "키", "요약", "상태"
```

Source view properties:

- Name: `Active SSOT`
- Source type: linked database view
- Source data source: Knowledge Nodes

### Knowledge Nodes — 카테고리별

Type: `board`

Configure:

```text
FILTER "범위" = "{PROJECT_SCOPE}"
FILTER ("상태" = "Active" OR "상태" = "Draft")
GROUP BY "카테고리"
SORT BY "키" ASC
SHOW "노드", "타입", "카테고리", "요약", "상태", "키"
```

Source view properties:

- Name: `카테고리별`
- Source type: second view tab on the same inline Knowledge Nodes linked database
- Source data source: Knowledge Nodes

## Tasks — Default view

Type: `timeline`

Configure:

```text
TIMELINE BY "진행일" TO "진행일"
SORT BY "진행일" ASC, "작업 ID" ASC
SHOW "작업", "작업 유형", "트랙"
```

Source view properties:

- Name: `Default view`
- Source type: inline linked database view
- Source data source: Tasks
- Timeline table display: enabled when supported by Notion UI/API

Dependency settings:

- Tasks schema must include `선행 작업` and `후행 작업` self-relations.
- If the Notion view API exposes timeline dependency rendering, enable dependency display using those relations.
- If the API does not expose dependency rendering, record this as a manual UI parity step in the bootstrap report instead of claiming full parity.

## Goals — Active Goals

Type: `table`

Configure:

```text
FILTER "상태" IN ("대기", "진행중", "보류")
SORT BY "목표 ID" ASC
SHOW "목표", "목표 ID", "상태", "트랙", "우선순위", "현재값", "목표값", "마감일", "작업"
```

Source view properties:

- Name: `Active Goals`
- Source type: inline linked database view
- Source data source: Goals

## Verification checklist

- Project page block order matches the manifest.
- Knowledge Nodes inline linked database appears before Tasks and Goals.
- Knowledge Nodes has both `Active SSOT` and `카테고리별` views.
- `Active SSOT` and `카테고리별` filters use the correct `{PROJECT_SCOPE}` and `상태 in Active/Draft`.
- Tasks timeline uses `TIMELINE BY "진행일" TO "진행일"`, sorts by `진행일`, then `작업 ID`, and shows `작업`, `작업 유형`, `트랙`.
- Goals table uses `상태 in 대기/진행중/보류`, sorts by `목표 ID`, and shows the source property list.
- Reference DB toggle contains Catalog, Nodes, Edges, Tasks, Goals in order.
- Any API-unsupported view property or dependency rendering is explicitly reported as a manual parity step.
