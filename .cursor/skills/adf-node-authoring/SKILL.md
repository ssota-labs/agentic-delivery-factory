---
name: adf-node-authoring
description: Create or update Agentic Delivery Factory Knowledge Nodes and their Notion page content. Use when writing ADF node documents, adding SSOT nodes, updating node status/type/category, or turning discussion into durable factory knowledge.
---

# ADF Node Authoring

A Knowledge Node is the durable unit of ADF SSOT. Use this skill before creating or changing node records.

## Databases

- Catalog: https://www.notion.so/371346dac45681e89a65c51ec5825017
- Nodes: https://www.notion.so/04e803dbef5243e39ed02ab370d2290b
- Project: https://www.notion.so/371346dac456814d9aa5eb7bbe5b1511

## Before Writing

1. Search existing nodes by `키`, title, and related terms.
2. Search Catalog for the intended `타입`, then read that catalog page. The catalog page content is the authoritative writing template for that document type.
3. Confirm `범위`:
   - `Meta`: ADF factory itself
   - `Instance`: generated project/customer/portfolio instance
   - `Shared`: reusable across factory and instances
4. Choose native select `카테고리` for board grouping. Match the catalog category where practical.

## Node Properties

| Property | Rule |
|---|---|
| `노드` | Clear title, human-readable |
| `키` | Stable dotted key, e.g. `adf.task-db.schema` |
| `타입` | Relation to document type catalog |
| `카테고리` | Select: Product, Engineering, Ops, etc. |
| `범위` | Meta / Instance / Shared |
| `상태` | Draft first, Active after review |
| `요약` | One-sentence contract |
| `출처 URL` | ADF project/strategy URL if derived from existing page |
| `저장소 경로` | Repo path if implemented in files |

## Catalog Page Templates (Notion SSOT)

**작성 템플릿의 SSOT는 Document Type Catalog 페이지 본문이다.** 레포 파일, Knowledge Node, DB template row 모두 SSOT가 아니다.

Do **not**:

- create `Template — *` rows in Knowledge Nodes
- store catalog templates in the repository
- invent a node body without reading the catalog page first

Workflow:

1. Open the related Document Type Catalog row and **fetch its page body**.
2. If the page already has `## … 작성 템플릿`, follow that section exactly.
3. If the page body is empty or missing a template section, **write the Korean template into the catalog page first**, using that row's `목적`, `문서 성격`, `관리 방식`, `권장 생성 시점`, `대표 예시`.
4. Then write the Knowledge Node page from that catalog template.
5. Keep the Knowledge Node as the project knowledge SSOT; keep the catalog page as the document-type writing SSOT.

Recommended catalog template sections (Korean headings):

- `## {한국어 문서명} 작성 템플릿`
- `## 문서 목적`
- `## 작성 전 입력`
- `## 권장 구조`
- `## 품질 기준`
- `## 완료 조건`
- `## 노드화 지침`

## After Writing

- Create edges for important relationships via `adf-edge-workflow`.
- Link task row via `관련 노드` when Tasks DB exists.
- Set `상태 = Active` only when the node is usable as SSOT; otherwise `Draft`.
- If the node was materially changed and reconciliation did not run in the same operation, set `정합성 확인됨 = false`, `정합성 상태 = 미확인`, and add `정합성 메모` when useful.
- If the node was reconciled successfully, set `정합성 확인됨 = true`, `정합성 상태 = 정상`, and update `마지막 정합성 확인일`.

## Anti-patterns

- Duplicating strategy memo paragraphs without extracting a reusable contract.
- Creating a node without `키`.
- Leaving edges implicit when dependency/definition relationships matter.
- Using rollup `카테고리` for board grouping; ADF uses native select `카테고리` intentionally.
