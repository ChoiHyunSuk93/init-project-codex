# Subagents Docs

This directory stores working documents used by the planner, generator, and evaluator roles.

## Scope

- `subagents_docs/cycles/` holds the active single working document for each plan.
- Keep these documents separate from user-facing `docs/guide/` and `docs/implementation/`.
- Do not place working plans, change notes, or evaluation reports under `docs/implementation/`.
- Write these working documents in the selected language for the active run.
- Use [`rule/rules/subagent-orchestration.md`](../rule/rules/subagent-orchestration.md) for role boundaries and cycle order.
- Use [`rule/rules/cycle-document-contract.md`](../rule/rules/cycle-document-contract.md) for exact cycle-file, header, provenance, and dirty-worktree rules.
- Use [`rule/rules/language-policy.md`](../rule/rules/language-policy.md) for document-language and stable filename/path rules.

## Cycle Rule

- Small direct changes may skip the cycle document.
- Medium changes use `main(plan+implementation) -> evaluator`.
- Large-clear changes use `main-led decomposition + delegated implementation + evaluator`.
- Large-ambiguous changes use parallel `explorer` analysis, planner assistance when needed, a main-approved plan, delegated implementation, and a separate evaluator.
- The main agent may autonomously invoke subagents when needed and should prefer parallel `explorer` calls for independent analysis questions.
- Do not open an implementation cycle for analysis-only, question-only, review-only, or explanation-only requests.
- Evaluator reviews the implemented result against the plan and acceptance criteria with the strongest feasible representative user-surface validation.
- If evaluator finds failures or blockers in the implemented result, the same plan cycles again until it passes, and `FAIL` restarts automatically unless the blocker truly needs external input.
- Independent plans may run in parallel. Dependent plans must run in order.
- Multiple plans should be numbered and handled as separate cycles when they are not independent.
- If subagents are slow, the coordinator must wait or re-plan instead of directly implementing.
- After integrating a completed or no-longer-needed subagent result, the coordinator closes that thread immediately.

## Document Contract

- Keep one append-only cycle document per plan under `subagents_docs/cycles/`.
- Let the coordinator manage the top status block and let the actual planning, implementation, and evaluation owner append only that section.
- Record plan, implementation, and evaluation provenance exactly as required by [`rule/rules/cycle-document-contract.md`](../rule/rules/cycle-document-contract.md).
- Do not treat `docs/implementation/` as a substitute for plan, change, or evaluation records.

## Ownership

- Coordinator or delegated planner owns planner sections.
- Coordinator or delegated generator owns generator sections.
- Evaluator owns evaluator sections only.
- Follow [`rule/rules/cycle-document-contract.md`](../rule/rules/cycle-document-contract.md) for the exact required contents of planner, generator, and evaluator sections.
- Even inside one cycle file, roles must not rewrite another role's sections.
