---
name: {{PROJECT_SLUG}}-doc-coauthoring
description: Co-author {{PROJECT_NAME}} Knowledge Node documents with the user through context gathering, structure, drafting, and reader testing. Use when human intent is still forming, when the user asks to write a doc together, or before PRD/design handoff approval — not for one-shot catalog template fills.
---

# {{PROJECT_NAME}} Doc Co-Authoring

Use this when **human intent is the primary input** and the document structure is not yet stable. Invoked from `{{PROJECT_SLUG}}-documentation-workflow` — **not** a separate AGENTS.md router entry. For clear spec input and single-pass SSOT writes, stay on documentation-workflow template-fill path instead.

Policy SSOT: Knowledge Node `{PROJECT_SLUG}.delivery-workflow.intent-handoff-gate` or ADF seed `adf.delivery-workflow.intent-handoff-gate`.

Stage map SSOT: `{PROJECT_SLUG}.delivery-workflow.catalog-stage-map` or ADF seed `adf.delivery-workflow.catalog-stage-map`.

## When to use

| Signal | Route here | Route to documentation-workflow |
|---|---|---|
| "같이 문서 짜자", "의도 정리부터" | Yes | No |
| PRD scope still ambiguous | Yes | No |
| Catalog template known; fill node from task | No | Yes |
| Post-approval maintenance edit | No | Yes |

## Workflow

1. Load task, linked nodes, and target catalog type template.
2. **Context gathering** — ask or infer: audience, decision, constraints, non-goals, success criteria. See [references/context-gathering.md](references/context-gathering.md).
3. **Structure** — propose section outline mapped to catalog template; get user confirmation before full draft.
4. **Drafting** — write node body section-by-section; surface open questions inline.
5. **Reader test** — summarize what a new reader would believe; list gaps; revise.
6. Link task via `관련 노드`; create edges for dependencies.
7. Do **not** set node `상태 = Active` or unblock `구현` without explicit human handoff per intent-handoff-gate policy.
8. Apply completion rule for current run mode on the **task**, not on handoff approval.

## Handoff boundary

Co-authoring may produce `Draft` nodes. Moving to `Active` and unblocking implementation is a **human handoff** action, not automatic close-out.

## Anti-patterns

- Skipping structure and dumping a full PRD in one shot when user intent was unclear.
- Using co-authoring for repo implementation or E2E verification.
- Marking `구현` tasks dependency-ready because a Draft node exists.
