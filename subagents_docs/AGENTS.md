# Subagents Docs

This directory stores working documents used by the planner, generator, and evaluator roles.

## Scope

- `subagents_docs/plans/` holds planner outputs.
- `subagents_docs/changes/` holds generator change records.
- `subagents_docs/evaluations/` holds evaluator reports.
- Keep these documents separate from user-facing `docs/guide/` and `docs/implementation/`.
- Write the contents in the selected language for the active run. Keep technical path literals, identifiers, and filenames in English.
- Active run language is mandatory for subagents_docs documents, including summaries, plans, changes, and evaluation reports.

## Cycle Rule

- Each plan follows planner -> generator -> evaluator.
- If evaluation fails, the same plan cycles again until it passes.
- Independent plans may run in parallel. Dependent plans must run in order.
- The same plan only moves to completion after every required pass condition is satisfied.

## Ownership

- Planner owns planning documents.
- Generator owns change records.
- Evaluator owns evaluation reports.
- Do not mix those responsibilities into a single file unless the user explicitly asks for that exception.
- If subagents are slow, the coordinator waits or re-plans; it does not directly implement the work.
