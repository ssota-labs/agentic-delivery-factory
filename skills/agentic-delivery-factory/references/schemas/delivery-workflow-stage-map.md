# Catalog-Aligned Delivery Workflow Stage Map (repo reference)

**Notion SSOT**: instance Knowledge Node `{PROJECT_SLUG}.delivery-workflow.catalog-stage-map` (seed from ADF `adf.delivery-workflow.catalog-stage-map`).

**Map version**: `1.3` — record in `.adf/config.json` as `workflowVersion`.

This file is a **bootstrap/upgrade reference** for agents and dev-loop pre-pick. It does not replace the Notion node body.

## Lifecycle classes

| Class | Meaning | Examples |
|---|---|---|
| Foundation Baseline | Project-wide policy/standard | Component Policy, Test Strategy, QA Environment & Test Data Policy |
| Current Contract | Living structure or protected coverage | Information Architecture, E2E Scenario List |
| Version Delta / Plan | Version/feature scope | PRD, Tech Spec, Test Plan |
| Execution Evidence | Run results | QA Test Cases, Test Run Report |

## Stages (summary)

| Stage | Primary types | Task `작업 유형` |
|---|---|---|
| S1 Version intent | PRD | `노드 문서 작성` |
| S2 Product structure | IA, Screen Flow | `노드 문서 작성` |
| S3 Screen design | Wireframe Spec, Screen Spec | `노드 문서 작성` |
| S4 UI foundation delta | Design Token, Component Policy, Interaction, Accessibility | `노드 문서 작성` |
| S5 Technical contract | Tech Spec, Functional Spec, Data Model, API Spec | `노드 문서 작성` |
| S6 Implementation | repo artifacts | `구현` |
| S7 Verification | Test Plan, QA cases, Test Run Report, Design QA | `검증` |

## Design / implementation gate (minimum rows)

Before `구현` pickup, evaluate linked `관련 노드` against applicable rows:

| Class | Required nodes | `상태` |
|---|---|---|
| Any feature | PRD | `Active` |
| New product / first UI | PRD + IA baseline + UI foundation baseline | `Active` |
| Backend/API | PRD + Tech Spec + (Functional Spec or API Spec) | `Active` |
| Lean backend-only | PRD (+ S5 if API/data) | `Active` |

On fail → task `보류` with missing node/type list. Route documentation tasks to `documentation-workflow`, never `implementation-workflow`.

## Verification gate (summary)

| Class | Required evidence |
|---|---|
| Foundation QA | Test Strategy + QA Environment & Test Data Policy |
| Automated E2E | E2E Scenario List + Test Run Report |
| Feature/release QA | Test Plan (+ QA Test Cases when manual QA needed) |

## Handoff

- Interactive agents MUST NOT promote planning/design nodes to `Active` without explicit human confirmation when scope is still forming.
- Scheduler MUST NOT pick `구현`/`검증` when required gate nodes are `Draft` or missing.
- Scheduler MUST NOT promote node `상태`.

Policy SSOT: `{PROJECT_SLUG}.delivery-workflow.intent-handoff-gate`.

## Repo paths (018 ship)

- Bundled skills: `{SKILLS_INSTALL_DIR}/{PROJECT_SLUG}-documentation-workflow/`, `{PROJECT_SLUG}-doc-coauthoring/` (delegate only)
- Gate reference: `{SKILLS_INSTALL_DIR}/{PROJECT_SLUG}-implementation-workflow/references/implementation-gate.md`
