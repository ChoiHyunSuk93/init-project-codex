# Project Roadmap

This roadmap derives phases from [`PROJECT_OVERVIEW.md`](../PROJECT_OVERVIEW.md) and tracks completion criteria for each phase.
A dependent next phase must not start until the previous phase reaches `PASS`.

## Operating Rules

- Each phase keeps `Status`, `Goal`, `Scope`, `Non-goals`, `Required Checklist`, `Verification`, `Cycle`, and `Notes`.
- Each implementation cycle links to one phase or clear phase section.
- When evaluator records `FAIL`, update that phase's checklist and notes, then repeat within the same phase.
- When a phase reaches `PASS`, record the evaluation evidence and linked cycle here before moving to the next phase.
- When requirements or implementation results change, sync [`PROJECT_OVERVIEW.md`](../PROJECT_OVERVIEW.md) and this roadmap before the next implementation cycle.

## Phase 0 - Requirements And Roadmap Baseline

- `Status`: `pending`
- `Goal`: Capture the initial requirements in `PROJECT_OVERVIEW.md` and create a complete phase roadmap.
- `Scope`: requirements capture, phase breakdown, completion checklist definition
- `Non-goals`: product implementation
- `Required Checklist`:
  - [ ] `PROJECT_OVERVIEW.md` reflects initial requirements or observed project structure.
  - [ ] Every phase has a user-visible goal plus included and excluded scope.
  - [ ] Every phase has mandatory completion checks and verification methods.
  - [ ] Phase dependencies and parallel-safe phases are explicit.
- `Verification`: document review, requirements gap check, phase-gate check
- `Cycle`: `subagents_docs/cycles/[NN-phase-slug].md`
- `Notes`: Add Phase 1 and later items when actual project requirements are concrete.
