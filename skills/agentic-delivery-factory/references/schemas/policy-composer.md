# Policy composer — bootstrap procedure

**Architecture SSOT**: ADF node `adf.factory-bootstrap.v0-5.dynamic-gate-architecture` (factory Notion).

**Runtime SSOT for instance bootstrap**: follow this bundled procedure. Read inputs from repo refs only — not factory Notion.

## Inputs (read bundled paths)

| Input | Path |
|---|---|
| Profile Matrix | `references/schemas/delivery-profile-matrix.md` |
| Stage Map | `references/schemas/delivery-workflow-stage-map.md` |
| Stack Adapter manifests | `references/presets/{stackId}.manifest.json` |
| Instance config | `.adf/config.json` — `surfaces`, `stacks`, `gateMode`, `profileId` |

## Output

| Output | Target |
|---|---|
| Implementation Gate Policy node | `{PROJECT_SLUG}.delivery-workflow.implementation-gate-policy` (Draft) |
| Seeded DOC tasks | One per required catalog type + one per distinct `policyRole` |
| Config trace | Composer assumptions section on gate policy node body |

Composer MUST NOT set gate policy **Active** without explicit human confirmation.

## Procedure (deterministic)

| Step | Action |
|---|---|
| 1 | Validate intake vs Matrix invalid combinations; abort or human override with memo |
| 2 | If `gateMode=legacy` → write minimal policy referencing Stage Map §6/§7 only; skip steps 3–8 dynamic merge |
| 3 | Load surface foundation + gate scope from Matrix for each selected surface; **stricter union** if multi-surface |
| 4 | Load each selected Stack Adapter manifest; merge `policySeeds`, `policyContributions`, `catalogCandidates`, `gateCandidates` |
| 5 | Union Matrix §6.2–§6.4 for resolved reference profile when alias matches; do not drop surface-required items |
| 6 | **Stricter union** with Stage Map §6/§7 applicable rows (R-003) |
| 7 | Dedupe and merge (§7 below); surface conflicts in **Composer assumptions** |
| 8 | Write **Draft** gate policy node: required catalog types, required policies, implementation gate table, verification gate table, source trace |
| 9 | Seed DOC tasks: gate policy authoring + all merged catalog types + policy roles |

## Dedupe and merge rules

| Overlap | Rule |
|---|---|
| Same catalog type (surface + profile + stack) | **One** catalog row + **one** seeded DOC task |
| Stack `policySeeds` | Must use `policyRole` keys; must not duplicate foundation catalog types owned by surface |
| Stack `policyContributions` | Add **required sections** to existing foundation policy/catalog DOC tasks — do **not** create duplicate catalog tasks |
| `prof.web-full-stack` + `stk.supabase` + `stk.vercel` | Seed **one** `policy.combined-supabase-vercel-ops` (Matrix §6.3), not three ops tasks |
| Same `policyRole` from two stacks | One policy node; source trace lists both stacks |
| Stack verification-only concern | Add to verification gate table via `gateCandidates`; no extra foundation catalog task |
| Contradictory manifest hints or gate rows | Record `conflict:` in assumptions; block Active until human resolves |

**Not composer scope**: merged policy prose. Seeded DOC tasks + documentation-workflow / doc-coauthoring write content. Stack `skillRef` on gate rows points to verification runbooks — execution guides, not gate SSOT.

### Policy contributions merge

When a stack manifest defines `policyContributions[]`:

1. Resolve `targetCatalogType` against merged required catalog types from surface/profile.
2. If the catalog type already has a seeded DOC task, append a **Stack contributions** subsection to that task body listing `requiredSections` + source stack.
3. If the target catalog type is absent for the selected surface, record `conflict: policyContribution targets missing catalog type` in assumptions.
4. Union `requiredSections` by `(targetPolicyRole, stackId)` — same target from one stack merges sections; duplicate section titles dedupe.

Example (`stk.supabase` on `surf.web-saas`):

| targetPolicyRole | targetCatalogType | Sections added |
|---|---|---|
| `policy.test-strategy` | Test Strategy | RLS access matrix; auth role coverage; migration smoke scope |
| `policy.qa-env-test-data` | QA Environment & Test Data Policy | Supabase project/env mapping; seed users; service role handling; reset strategy |
| `policy.e2e-scenarios` | E2E Scenario List | auth/session flow; data persistence flow; RLS negative case |

## Gate policy node template (Draft body)

```markdown
## Composer assumptions
- Surfaces: [surf.*]
- Stacks: [stk.*]
- Gate mode: full | legacy
- Resolved profile: [profileId or composed]
- [conflict: ... if any]

## Required catalog types
| Catalog type | Source trace | Lifecycle |
|---|---|---|
| ... | surface §3 / matrix §6.2 / stack manifest | Foundation / Current / ... |

## Required policy nodes
| policyRole | Title | Source trace |
|---|---|---|
| ... | ... | stack manifest / matrix §6.3 |

## Policy contributions (stack sections on foundation docs)
| targetCatalogType | targetPolicyRole | Required sections | Source stack |
|---|---|---|---|
| ... | ... | ... | stk.* |

## Implementation gate
| checkId | gateClass | Required nodes | Blocks |
|---|---|---|---|
| ... | ... | ... | ... |

## Verification gate
| checkId | gateClass | Required evidence |
|---|---|---|
| ... | ... | ... |

## First product IMPL block
Instance gate policy MUST be Active before first product `구현` when gateMode=full and bootstrapVersion>=0.5.
```

## Suggested seeded DOC task chain

| Order | Task focus | Blocks |
|---|---|---|
| 1 | Author Implementation Gate Policy node | First product `구현` |
| 2+ | Foundation policies (Test Strategy, Component Policy, …) | Per gate policy tables |
| n | Catalog types per §6.2 | Per gate policy tables |

Link all seeded tasks to bootstrap goal; set `선행 작업` so gate policy authoring precedes dependent foundation docs when appropriate.

## Validation

Before composer run, validate Stack Adapter manifests:

```bash
python3 references/presets/validate-manifests.py
```

(from shipped skill root: `skills/agentic-delivery-factory/references/presets/validate-manifests.py`)

## Wizard placement

Run composer after Notion DB seed (Nodes/Tasks exist) and delivery profile intake confirmed. See `references/init/wizard.md` Phase 2.5.
