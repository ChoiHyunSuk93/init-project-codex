# Subagent Workflow

This repository uses a role-separated harness with `planner`, `generator`, and `evaluator`.
The main agent stays orchestration-only in that harness and does not directly become one of those roles unless the user explicitly waives the split.
Use `rule/rules/subagent-orchestration.md` as the authoritative role/workflow rule.
Use `rule/rules/cycle-document-contract.md` for exact cycle-file, header, provenance, and dirty-worktree evaluation rules.
Use `rule/rules/language-policy.md` for document-language and stable filename/path rules.
Analysis-only, question-only, review-only, and explanation-only requests do not start the implementation cycle unless the user explicitly asks for changes or materialization.

## Document Areas

- `subagents_docs/` is the working area for subagent outputs.
- `subagents_docs/` working documents follow the selected language.
- `docs/guide/` is user-facing guidance only.
- `docs/implementation/` is user-facing implementation summary output only after a cycle passes, kept as short readable briefings inside concern-based categories.

## Cycle

1. `planner` creates the cycle document when needed, then appends a planner section in `subagents_docs/cycles/`.
   - the planner section contents follow `rule/rules/cycle-document-contract.md`
2. `generator` implements the plan and appends a generator section in that same cycle document.
   - the generator section contents follow `rule/rules/cycle-document-contract.md`
3. `evaluator` runs end-to-end checks on the implemented result and appends an evaluator section in that same cycle document.
   - the evaluator section contents and dirty-worktree comparison basis follow `rule/rules/cycle-document-contract.md`
4. If evaluator finds failures or blockers in the implemented result, planner re-plans and the same plan cycle repeats until pass.
5. If subagents are slow, the coordinator waits or re-plans instead of directly implementing.
6. After a subagent output is integrated and the thread is no longer needed, the coordinator closes that thread.

## Multi-Plan Coordination

- Independent plans can be executed in parallel.
- Dependent plans must follow order and only start after prerequisite plans pass.
- Keep each independent alternative as a separate plan cycle (`plan1`, `plan2`, `plan3`).

## Output Rule

- Do not place working plans, change notes, or evaluation reports in `docs/guide` or `docs/implementation`.
- Treat this directory as user-facing documentation only.
- Keep final implementation briefings in `docs/implementation/` only after evaluator passes the cycle.
- Do not publish final briefings from a plan-only or generator-only state.
## Cycle Document

- New work uses one append-only cycle document per plan, typically `subagents_docs/cycles/NN-slug.md`.
- Keep the top status block coordinator-owned and keep role outputs append-only.
- Use section names such as `Planner v1`, `Generator v1`, `Evaluator v1`, `Planner v2`.
- For exact header transitions and provenance requirements, follow `rule/rules/cycle-document-contract.md`.
