# Work Record Instructions

This directory tracks plans, handoffs, implementation evidence, and verification working state for main and delegated agents.
It does not replace user-facing guides or verified implementation history.

## When To Use A Cycle

- A small direct change may omit a cycle when it has no shared handoff or audit-worthy state transition.
- Create `cycles/<NN>-<slug>.md` for medium-or-larger work, explicit work-sharing, multiple handoffs, long-running work, or independent evaluation.
- Connect each cycle to one phase or clear phase section in [`roadmap.md`](roadmap.md).

## Ownership

- Keep roadmap state, cycle headers, shared journals, and final integration single-writer owned by the main agent or coordinator.
- Have delegated agents return results, changed scope, verification evidence, and remaining risk instead of editing shared records.
- Do not have parallel agents edit the same file or shared record.

## Cycle Contract

- Keep `Status`, `Current Plan Version`, and `Next Handoff` in the header.
- Allowed statuses are `in_progress`, `BLOCKED`, `PASS`, and `FAIL`.
- Keep `Planner vN`, `Generator vN`, and `Evaluator vN` sections append-only.
- Record main or delegated provenance, the governing section, actual change or evaluation scope, verification, remaining risk, and next handoff in each section.
- Set the header and phase to `PASS` only after `Evaluator vN` confirms all acceptance criteria and roadmap checklist items.

Record verified user-facing outcomes separately following [`docs/implementation/AGENTS.md`](../docs/implementation/AGENTS.md).
