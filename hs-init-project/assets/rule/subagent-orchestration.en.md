# Subagent Orchestration Rule

## Purpose

Enforce planner / generator / evaluator role separation as an additive workflow.

`subagents_docs/` is the working-document area for these roles.
Use `rule/rules/language-policy.md` for the exact language rules for those working documents.
`docs/guide/` and `docs/implementation/` are user-facing only.
`docs/implementation/` stores only final, passed-cycle implementation briefings inside concern-based categories.
The main agent is orchestration-only and does not directly become planner, generator, or evaluator unless the user explicitly waives the split.
The coordinator may wait as long as needed for subagent output, but it must close completed or no-longer-needed threads after integrating their outputs.
If stale sessions or thread limits block more delegation, cleanup is required before continuing.

## Intent Gate

- Do not start the implementation cycle for analysis-only, question-only, review-only, or explanation-only requests.
- Start planner -> generator -> evaluator only when the user explicitly requested implementation, change, creation, update, fix, or materialization.
- If implementation intent is ambiguous, stop at analysis or ask instead of guessing.

## Cycle Document Model

Use `rule/rules/cycle-document-contract.md` as the authoritative detailed rule for exact cycle file paths, header transitions, append-only section rules, provenance, and dirty-worktree evaluation.

- New cycles use one append-only working document per plan under `subagents_docs/cycles/<NN>-<slug>.md`.
- Keep role outputs in role-owned sections inside that same file.

## Role Boundaries

### planner

- Defines what should be built and appends planner sections under `subagents_docs/cycles/`.
- Follows `rule/rules/cycle-document-contract.md` for exact section contents and provenance.
- Does not edit implementation files, scripts, templates, or evaluation outputs.

### generator

- Implements the approved plan and records implementation details in generator sections under `subagents_docs/cycles/`.
- Follows `rule/rules/cycle-document-contract.md` for exact section contents and verification-basis requirements.
- May add unit-level checks when helpful.
- Does not publish final `docs/implementation/` briefings before evaluator pass.
- Does not revise planning intent or evaluation findings.

### evaluator

- Validates the implemented result end-to-end against the plan and acceptance criteria, then appends evaluator sections under `subagents_docs/cycles/`.
- Tests functionality, structure, and workflow compliance.
- Follows `rule/rules/cycle-document-contract.md` for exact PASS/FAIL recording, provenance, and dirty-worktree comparison requirements.
- Does not edit implementation files or planning outputs.

## Artifact Contract

- Use one cycle document per plan and keep the file name aligned with the plan number or slug.
- Use `rule/rules/cycle-document-contract.md` for exact section requirements and coordinator-owned header behavior.
- `docs/implementation/` remains a human-facing summary layer and never replaces working records.

## Orchestrated Cycle

1. planner creates the cycle document when needed, then appends the current planner section.
2. generator implements from the latest planner section.
3. evaluator checks the implemented result and appends the current evaluation section.
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

- Keep role outputs in their own sections even though they share one cycle file.
- Do not place planning, implementation, or evaluation records in `docs/implementation/`.
- If subagents are slow, the coordinator must wait or re-plan instead of directly implementing.
- After a subagent result is integrated and no longer needed, the coordinator closes that thread.
- Do not let the main agent directly absorb planner, generator, or evaluator ownership by default.
- If plan scope is unclear, force clarification in planner output before generator changes code.
- Do not treat a plan-only artifact as a cycle pass/fail evaluation before implementation exists.
- Do not create or update final `docs/implementation/` briefings from a plan-only or generator-only state.
