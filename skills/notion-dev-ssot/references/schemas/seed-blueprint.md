# Blueprint seed page body

Use when the user opted to seed milestone P1.0. Create in **Docs DB** with:

- **Name:** `{{PROJECT_NAME}} Phase 1 Blueprint`
- **태그:** `제품 로드맵`
- **상태:** `초안`

## Page content (Notion markdown)

```markdown
## Purpose

Phase-level route map, domain model, and milestone plan for **{{PROJECT_NAME}}**.

## Milestones (draft)

| Version | Topic | Outcome |
|---|---|---|
| P1.0 | Foundation | Dev SSOT wired; first shippable slice |
| P1.1+ | (fill in) | |

## Scope

### In scope (Phase 1)

- (fill in)

### Out of scope (Phase 1)

- (fill in)

## Open questions

- (fill in)

## Linked tasks

Link PRD / DSGN / IMPL / VERF rows from the development task database via `관련 문서`.
```

After creating the page, link it from `{{TASK_PREFIX}}-P1.0-PRD` task row when seed tasks are created.
