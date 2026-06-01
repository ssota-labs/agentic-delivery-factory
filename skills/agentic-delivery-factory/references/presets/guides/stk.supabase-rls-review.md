# Supabase RLS review — verification runbook

**Stack**: `stk.supabase`  
**Gate checkId**: `supabase-rls-access-matrix`  
**Policy SSOT**: `{PROJECT_SLUG}.policy.supabase-data-auth` (instance node keyed from `policy.supabase-data-auth`)

This file is a **verification execution guide**, not a gate definition. The gate lives in the instance Implementation Gate Policy verification table. This runbook tells agents/humans how to produce acceptable evidence.

## When to run

- Any `검증` task touching Supabase schema, RLS policies, auth roles, or data access paths
- Before closing data-layer verification when gate policy lists `supabase-rls-access-matrix`

## Required evidence

Record results in **Test Run Report** (or linked verification memo) with:

1. **Positive access** — each intended role can read/write only allowed rows
2. **Negative access** — anon/authenticated/wrong-tenant roles are denied as policy specifies
3. **Policy trace** — table/policy name mapped to test case IDs
4. **Environment** — non-prod Supabase project ref; no production secrets in report body

## Minimum procedure

1. Load Active Supabase data/auth policy node and list tables with RLS enabled.
2. For each role matrix row in policy, run one positive and one negative check.
3. Prefer automated SQL/API tests checked into repo; manual SQL acceptable when automation not yet wired.
4. Attach command output, test names, or screenshot refs to Test Run Report.
5. Fail verification close-out if any negative case passes incorrectly or positive case fails.

## Not in scope

- Writing RLS policy prose (→ policy DOC task + documentation-workflow)
- Deciding whether RLS is required (→ gate policy + Tech Spec)
- Promoting policy node to Active (→ human handoff)
