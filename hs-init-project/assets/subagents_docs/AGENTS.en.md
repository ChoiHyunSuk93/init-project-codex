# Subagents Docs

This directory stores working documents used by the planner, generator, and evaluator roles.

## Scope

- `subagents_docs/plans/` holds planner outputs.
- `subagents_docs/changes/` holds generator change records.
- `subagents_docs/evaluations/` holds evaluator reports.
- Keep these documents separate from user-facing `docs/guide/` and `docs/implementation/`.
- Do not place working plans, change notes, or evaluation reports under `docs/implementation/`.
- Write these working documents in the selected language for the active run.

## Cycle Rule

- Each plan follows planner -> generator -> evaluator.
- The main agent stays orchestration-only and does not directly become planner, generator, or evaluator unless the user explicitly waives the split.
- Evaluator reviews the implemented result against the plan and acceptance criteria.
- If evaluator finds failures or blockers in the implemented result, the same plan cycles again until it passes.
- Independent plans may run in parallel. Dependent plans must run in order.
- Multiple plans should be numbered and handled as separate cycles when they are not independent.
- If subagents are slow, the coordinator must wait or re-plan instead of directly implementing.

## Ownership

- Planner owns planning documents.
- Generator owns change records.
- Evaluator owns evaluation reports.
- Do not mix those responsibilities into a single file unless the user explicitly asks for that exception.
