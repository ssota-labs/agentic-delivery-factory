# Bootstrap Delivery Profile Matrix (repo reference)

**Notion edit SSOT**: ADF Knowledge Node `adf.factory-bootstrap.delivery-profile-matrix`.

**Map version**: `1.3.3` — record in `.adf/config.json` as `profileMatrixVersion`.

Bootstrap wizard and policy composer MUST read **this bundled file**, not factory Notion URLs. Instance bootstrap agents do not have ADF factory Notion access.

## Surface registry (§3.1)

| Surface ID | Label | Gate contract section |
|---|---|---|
| `surf.web-saas` | Web SaaS | §3.2 |
| `surf.mobile-app` | Mobile app | §3.3 |
| `surf.api-backend` | API / backend-only | §3.4 |
| `surf.mcp-tool` | MCP / agent tool | §3.5 |
| `surf.content` | Content / docs-primary | §3.6 |

Multi-surface intake: composer applies **stricter union** of selected surface contracts (R-003).

## Surface foundation catalog types (composer input)

Foundation types required **before first product `구현`** for each surface (dedupe across multi-surface):

| Surface | Foundation / seeded catalog types |
|---|---|
| `surf.web-saas` | Information Architecture, Design Token Spec, Component Policy, Accessibility Baseline, Test Strategy, QA Environment & Test Data Policy, E2E Scenario List; S1–S5 catalog path (PRD, IA, Screen Flow, Wireframe Spec, Screen Spec, Tech Spec, API/Functional Spec) |
| `surf.mobile-app` | Mobile flow/IA, platform release policy, backend auth/data policy, Test Strategy, QA Environment & Test Data Policy; PRD, Tech Spec, API/Functional Spec, Screen Spec |
| `surf.api-backend` | Test Strategy, QA Environment & Test Data Policy, deploy/runtime ops policy, auth/RLS/migration policy; PRD, Tech Spec, API Spec or Functional Spec |
| `surf.mcp-tool` | Tool/API contract policy, deploy/runtime policy, Test Strategy; PRD, Functional Spec or API/tool contract |
| `surf.content` | Content hierarchy, publishing workflow policy, Test Strategy + QA Environment when site CI; PRD; attach §3.4/§3.2 rows when backend/UI added |

Surface owns **Test Strategy** and other foundation catalog types. Stack manifests MUST NOT duplicate them as `policySeeds`.

## Stack registry (§4.1)

| Stack ID | Layer | Compatible surfaces |
|---|---|---|
| `stk.vercel` | Runtime / deploy | `surf.web-saas`, `surf.mcp-tool` |
| `stk.supabase` | Data / auth | `surf.web-saas`, `surf.mobile-app`, `surf.api-backend` |
| `stk.shadcn-ui` | UI kit | `surf.web-saas` only |
| `stk.none` | Legacy bypass | any with `gateMode=legacy` |

Stack Adapter manifest paths: `references/presets/{stackId}.manifest.json`.

### Stack contract — `stk.supabase`

| Layer | Artifact | Role |
|---|---|---|
| Policy seeds | `policy.supabase-data-auth`, `policy.supabase-test-fixtures` | Stack-owned policy nodes (DOC tasks) |
| Policy contributions | → Test Strategy, QA Environment & Test Data Policy, E2E Scenario List | Required **sections** on surface foundation docs — no duplicate catalog tasks |
| Implementation gates | `supabase-schema-change`, `supabase-env-binding-change`, `supabase-auth-boundary-change` | Block impl until stack policies Active |
| Verification gates | `supabase-rls-access-matrix`, `supabase-migration-smoke`, `supabase-e2e-auth-data` | Block verification until evidence present |
| Runbook | `references/presets/guides/stk.supabase-rls-review.md` | How to produce RLS evidence (not gate SSOT) |

When `stk.vercel` is also selected, Matrix §6.3 adds `policy.combined-supabase-vercel-ops` for preview/env wiring — not duplicated in Supabase manifest alone.

## Profile resolution (§4.3)

| Surface(s) | Stacks | Resolved `profileId` |
|---|---|---|
| `surf.web-saas` | `stk.vercel`, `stk.shadcn-ui` | `prof.web-vercel-shadcn` |
| `surf.web-saas` | `stk.vercel`, `stk.supabase`, `stk.shadcn-ui` | `prof.web-full-stack` |
| `surf.api-backend` | `stk.supabase` | `prof.api-supabase-lean` |
| `surf.mobile-app` | `stk.supabase` (+ platform TBD) | `prof.mobile-full-stack` |
| `surf.mcp-tool` | `stk.vercel` or none | `prof.mcp-lean` |
| any | `stk.none` + legacy | `prof.legacy-v04` |
| other valid combo | — | `prof.composed.{surfaceSig}.{stackSig}` or omit |

**Invalid** (wizard block/warn): `stk.shadcn-ui` without `surf.web-saas`; product stacks with `gateMode=legacy`; `stk.none` with non-legacy product profile.

## Reference profiles — catalog types (§6.2)

| Profile ID | Required catalog types |
|---|---|
| `prof.legacy-v04` | PRD per feature; Stage Map §6/§7 at runtime |
| `prof.api-supabase-lean` | PRD, Tech Spec, API Spec or Functional Spec, Test Strategy, QA Environment & Test Data Policy |
| `prof.web-vercel-shadcn` | PRD, Tech Spec, API Spec or Functional Spec, Information Architecture, Screen Flow, Wireframe Spec, Screen Spec, Component Policy, Design Token Spec, Test Strategy |
| `prof.web-full-stack` | Above + stack auth/data/migration policies (Policy), QA Environment & Test Data Policy, E2E Scenario List |
| `prof.mobile-full-stack` | PRD, Tech Spec, API Spec or Functional Spec, mobile flow/IA, Screen Spec, platform release policy (Policy), Test Strategy, QA Environment & Test Data Policy |
| `prof.mcp-lean` | PRD, Functional Spec or API/tool contract, Test Strategy |

Composer unions surface foundation types + profile §6.2 + stack `catalogCandidates` (dedupe by catalog type name).

## Reference profiles — policy nodes (§6.3)

| Profile ID | Required default policies (`policyRole` → title) |
|---|---|
| `prof.api-supabase-lean` | `policy.test-strategy` → Test Strategy; `policy.supabase-data-auth` → Supabase data/auth/RLS/migration policy; `policy.supabase-test-fixtures` → Supabase QA/test data and auth fixtures policy |
| `prof.web-vercel-shadcn` | Test Strategy; Component Policy; Accessibility Baseline; `policy.vercel-deploy`; `policy.shadcn-usage` |
| `prof.web-full-stack` | Above + QA Environment & Test Data Policy; `policy.combined-supabase-vercel-ops` → Supabase + Vercel combined ops policy |
| `prof.mobile-full-stack` | Test Strategy; mobile platform/release policy; backend auth/data policy; Supabase policy summary; store/release checklist policy |
| `prof.mcp-lean` | Tool/API contract policy; deploy/runtime policy summary |

When `stk.supabase` + `stk.vercel` both selected for web-full-stack, composer seeds **one** combined ops policy (`policy.combined-supabase-vercel-ops`), not separate duplicate ops tasks per stack.

Stack manifest `policySeeds` merge by `policyRole`. Same role from two stacks → one policy node + per-stack subsections in source trace.

## Gate template rows (§6.4)

| Profile ID | First IMPL block | Verification emphasis |
|---|---|---|
| `prof.legacy-v04` | PRD Active per task | Stage Map §7 |
| `prof.api-supabase-lean` | Instance **Implementation Gate Policy** Active | Test Strategy Active; Test Run Report on verification |
| `prof.web-vercel-shadcn` | Instance gate policy Active | Design QA on UI; Test Run Report on automated path |
| `prof.web-full-stack` | Instance gate policy Active | Foundation QA; Test Plan + Test Run Report on release |
| `prof.mobile-full-stack` | Instance gate policy Active | Test Strategy; Test Run Report; platform/release checklist |
| `prof.mcp-lean` | Instance gate policy Active | Test Run Report on verification |

## Delegation rules (§7)

| Rule | Contract |
|---|---|
| R-001 | Runtime pickup loads Stage Map **and** instance Implementation Gate Policy when present |
| R-002 | Matrix gate templates are bootstrap defaults; composer may add stack `gateCandidates` |
| R-003 | Matrix ∩ Stage Map → **stricter union** (no optional downgrade) |
| R-004 | `prof.legacy-v04` / `gateMode=legacy` skips dynamic composer merge |

## Bootstrap seeding (§8)

On profile selection, bootstrap MUST:

1. Persist `surfaces`, `stacks`, `gateMode`, optional `profileId` in `.adf/config.json`.
2. Run policy composer → Draft instance `{PROJECT_SLUG}.delivery-workflow.implementation-gate-policy`.
3. Seed DOC task for gate policy authoring.
4. Seed DOC tasks for merged §6.2 catalog types + §6.3 policy roles (**one task per catalog type; one per policyRole**).
5. NOT require all artifacts Active before bootstrap completes.

Procedure: `references/schemas/policy-composer.md`.

## Repo paths

| Artifact | Path |
|---|---|
| This matrix | `references/schemas/delivery-profile-matrix.md` |
| Composer procedure | `references/schemas/policy-composer.md` |
| Stack Adapter manifests | `references/presets/*.manifest.json` |
| Stack Adapter manifest schema | `references/schemas/stack-adapter-manifest.schema.json` |

## Terminology migration note

`profileId` and "Delivery Profile" remain in this matrix for v0.5 compatibility. New Factory Template work should use:

- **Factory Template** for the user-selected package, e.g. `factory.web-saas.001`
- **Stack Port** for abstract slots, e.g. `port.database`
- **Stack Adapter** for selected implementations, e.g. `stk.supabase-db`
- **Composition Contract** for the generated result formerly approximated by `profileId`

Detailed contract: `references/schemas/factory-template-composition-contract.md`.
