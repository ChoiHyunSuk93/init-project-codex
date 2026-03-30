# Subagent Orchestration

Use this reference when the task should run through a planner / generator / evaluator harness.

## Core Rule

Keep the harness additive. It sits on top of the existing `README.md`, `AGENTS.md`, `rule/`, `docs/guide/`, and `docs/implementation/` model instead of replacing it.
The main agent is orchestration-only in this harness: it coordinates planner/generator/evaluator handoffs and does not directly become one of those roles unless the user explicitly waives the split.
Generated repositories must store planner, generator, and evaluator working documents in `subagents_docs/`, not in `docs/guide/` or `docs/implementation/`.
Use the selected language for `subagents_docs/` working documents.
Use `docs/guide/` for user-facing guidance and `docs/implementation/` only for short final implementation briefings inside concern-based categories after a plan cycle passes.

## Role Boundaries

### planner

- Defines what should be built.
- Writes the planning document only.
- Uses `subagents_docs/plans/` for owned outputs.
- Does not edit implementation, templates, scripts, or evaluation output.

### generator

- Implements the approved plan.
- Updates focused verification and implementation records.
- Uses `subagents_docs/changes/` for owned outputs.
- Does not rewrite planner intent or evaluator findings.

### evaluator

- Runs the strongest feasible end-to-end validation of the implemented result against the plan and acceptance criteria.
- Records observations, issues, and final quality assessment.
- Uses `subagents_docs/evaluations/` for owned outputs.
- Does not modify product files.

## Evaluation Criteria

- design quality
- originality
- completeness
- functionality

Weight `design quality` and `originality` more heavily than `completeness` and `functionality`.

## Workflow

1. planner writes a planning document.
2. generator reads the plan and implements the change.
3. evaluator verifies the implemented result end to end against the plan and acceptance criteria, then documents the outcome.
4. If evaluator finds failures or blockers in the implemented result, return to planner for re-planning and repeat the same plan cycle until it passes.
5. If subagents are slow, the coordinator must wait or re-plan instead of directly implementing.

## Multi-Plan Rules

- Split distinct user requirements into separate plans when that makes the work clearer.
- Run independent plans in parallel only when they do not affect each other.
- Run dependent plans in sequence when one plan changes the inputs or outcomes of another.

## Practical Guardrails

- Keep the three roles in separate owned outputs.
- Keep the main agent limited to orchestration; do not let it directly absorb planner, generator, or evaluator ownership by default.
- If a plan is ambiguous, resolve it in the planning document instead of letting generator improvise.
- If end-to-end automation is incomplete, evaluator should still record the strongest manual or scripted validation available.
- Do not treat plan-only artifacts as a cycle pass/fail evaluation before implementation exists.
- Do not create `docs/implementation/briefings/`; keep `docs/implementation/` category-based.
