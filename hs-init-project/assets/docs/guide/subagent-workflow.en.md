# Subagent Workflow

This repository uses a role-separated harness with `planner`, `generator`, and `evaluator`.
The main agent stays orchestration-only in that harness and does not directly become one of those roles unless the user explicitly waives the split.

## Document Areas

- `subagents_docs/` is the working area for subagent outputs.
- `subagents_docs/` working documents follow the selected language.
- `docs/guide/` is user-facing guidance only.
- `docs/implementation/` is user-facing implementation summary output only after a cycle passes, kept as short readable briefings inside concern-based categories.

## Cycle

1. `planner` writes a plan in `subagents_docs/plans/`.
   - scope, acceptance criteria, constraints, risks, and dependencies
2. `generator` implements the plan and updates `subagents_docs/changes/`.
   - code, templates, scripts, and practical validation
3. `evaluator` runs end-to-end checks on the implemented result and writes `subagents_docs/evaluations/`.
   - compare the result against the plan and acceptance criteria
   - design quality, originality, completeness, functionality
4. If evaluator finds failures or blockers in the implemented result, planner re-plans and the same plan cycle repeats until pass.
5. If subagents are slow, the coordinator waits or re-plans instead of directly implementing.

## Multi-Plan Coordination

- Independent plans can be executed in parallel.
- Dependent plans must follow order and only start after prerequisite plans pass.
- Keep each independent alternative as a separate plan cycle (`plan1`, `plan2`, `plan3`).

## Output Rule

- Do not place working plans, change notes, or evaluation reports in `docs/guide` or `docs/implementation`.
- Treat this directory as user-facing documentation only.
- Keep final implementation briefings in `docs/implementation/` only after evaluator passes the cycle.
