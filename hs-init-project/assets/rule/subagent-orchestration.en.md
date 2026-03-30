# Subagent Orchestration Rule

## Purpose

Enforce planner / generator / evaluator role separation as an additive workflow.

`subagents_docs/` is the working-document area for these roles.
Its working documents follow the selected language for the active run.
`docs/guide/` and `docs/implementation/` are user-facing only.
`docs/implementation/` stores only final, passed-cycle implementation briefings inside concern-based categories.
The main agent is orchestration-only and does not directly become planner, generator, or evaluator unless the user explicitly waives the split.

## Role Boundaries

### planner

- Defines what should be built and writes planning outputs under `subagents_docs/plans/`.
- Documents scope, acceptance criteria, constraints, and open questions.
- Does not edit implementation files, scripts, templates, or evaluation outputs.

### generator

- Implements the approved plan and records implementation details under `subagents_docs/changes/`.
- May add unit-level checks when helpful.
- Does not revise planning intent or evaluation findings.

### evaluator

- Validates the implemented result end-to-end against the plan and acceptance criteria, then writes assessments under `subagents_docs/evaluations/`.
- Tests functionality, structure, and workflow compliance.
- Does not edit implementation files or planning outputs.

## Orchestrated Cycle

1. planner creates/updates a plan.
2. generator implements from that plan.
3. evaluator checks the implemented result and reports completion quality.
4. If evaluator finds failures or blockers in the implemented result, planner re-plans with corrections, then generator and evaluator repeat.
5. Continue the cycle until the plan passes.

## Multi-Plan Execution

- If several approaches are required, split them as `plan1`, `plan2`, `plan3` and manage each separately.
- Run independent plans in parallel.
- Run dependent plans sequentially when a prior plan affects later inputs or assumptions.

## Evaluation Focus

- Evaluate every implemented result against:
  - design quality
  - originality
  - completeness
  - functionality
- Weight `design quality` and `originality` more heavily than `completeness` and `functionality`.
- Record concrete evidence (including blockers and reproduction notes) for any failure.

## Guardrails

- Keep role outputs in their own directories.
- Do not place planning, implementation, or evaluation records in `docs/implementation/`.
- If subagents are slow, the coordinator must wait or re-plan instead of directly implementing.
- Do not let the main agent directly absorb planner, generator, or evaluator ownership by default.
- If plan scope is unclear, force clarification in planner output before generator changes code.
- Do not treat a plan-only artifact as a cycle pass/fail evaluation before implementation exists.
