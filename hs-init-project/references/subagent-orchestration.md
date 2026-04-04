# Subagent Orchestration

Every repository initialized by this skill uses the planner / generator / evaluator harness.
Use this reference as the baseline harness model for generated repositories.

## Core Rule

Keep the harness additive. It sits on top of the existing `README.md`, `AGENTS.md`, `rule/`, `docs/guide/`, and `docs/implementation/` model instead of replacing it.
The main agent is orchestration-only in this harness: it coordinates planner/generator/evaluator handoffs and does not directly become one of those roles unless the user explicitly waives the split.
Generated repositories must store planner, generator, and evaluator working documents in `subagents_docs/`, not in `docs/guide/` or `docs/implementation/`.
Use `rule/rules/language-policy.md` for the exact language rules for `subagents_docs/` working documents.
Use `docs/guide/` for user-facing guidance and `docs/implementation/` only for short final implementation briefings inside concern-based categories after a plan cycle passes.
Generated repositories must include `rule/rules/cycle-document-contract.md` and `rule/rules/language-policy.md` as the authoritative cycle and language rules.
Generated repositories may include process-oriented starter local skills under `.codex/skills/`; keep their `SKILL.md` descriptions, metadata, and `allow_implicit_invocation` support aligned.
The coordinator may wait as long as needed for subagent output, but it must close completed or no-longer-needed subagent threads after integrating their outputs.
If stale sessions or thread-limit blockage prevent more delegation, cleanup is required orchestration work before continuing.

## Intent Gate

Do not start the planner / generator / evaluator implementation cycle unless the user explicitly requested implementation, change, creation, update, fix, or materialization.
If the user request is analysis-only, question-only, review-only, explanation-only, or otherwise non-implementation, stay in analysis and do not edit files or spawn generator.
If implementation intent is ambiguous, clarify or stop at analysis instead of guessing.

## Cycle Document Model

Use `rule/rules/cycle-document-contract.md` as the authoritative detailed rule for this section.

- Track each plan as one append-only cycle document under `subagents_docs/cycles/<NN>-<slug>.md`.
- This is one document per plan, not one global shared log.
- Keep the top status block coordinator-owned and keep the body append-only by role section.

## Role Boundaries

### planner

- Defines what should be built.
- Appends planner sections only.
- Uses `subagents_docs/cycles/` for owned outputs.
- Follows `rule/rules/cycle-document-contract.md` for exact section contents and provenance.
- Does not edit implementation, templates, scripts, or evaluation output.

### generator

- Implements the approved plan.
- Appends generator sections only.
- Uses `subagents_docs/cycles/` for owned outputs.
- Follows `rule/rules/cycle-document-contract.md` for exact section contents and verification-basis requirements.
- Does not publish final `docs/implementation/` briefings before evaluator pass.
- Does not rewrite planner intent, evaluator findings, or the coordinator-owned header.

### evaluator

- Runs the strongest feasible end-to-end validation of the implemented result against the plan and acceptance criteria, including a real user-level test when that surface exists.
- Records observations, issues, and final quality assessment.
- Uses `subagents_docs/cycles/` for owned outputs.
- Follows `rule/rules/cycle-document-contract.md` for exact PASS/FAIL recording, provenance, and dirty-worktree comparison requirements.
- Does not modify product files.

## Artifact Contract

Use `rule/rules/cycle-document-contract.md` for exact header transitions, provenance, and dirty-worktree comparison rules.

- Keep one cycle document per plan and keep the same numeric prefix or slug across the file name and the plan identity.
- `docs/implementation/` remains a human-facing summary layer and must not replace planner, generator, or evaluator working records.

## Evaluation Criteria

- design quality
- originality
- completeness
- functionality

Weight `design quality` and `originality` more heavily than `completeness` and `functionality`.

## Workflow

1. planner creates the cycle document when needed, then appends the current planner section.
2. generator reads the latest planner section and implements the change.
3. evaluator verifies the implemented result end to end against that planner section and the acceptance criteria, then appends the evaluation outcome.
4. If evaluator finds failures or blockers in the implemented result, return to planner for re-planning and repeat the same plan cycle until it passes.
5. When evaluator records `FAIL`, restart the cycle without another user question unless the blocker is truly unresolved external input.
6. If subagents are slow, the coordinator must wait or re-plan instead of directly implementing.
7. After a subagent output is integrated and the thread is no longer needed, the coordinator closes that thread instead of leaving stale sessions open.

## Multi-Plan Rules

- Split distinct user requirements into separate plans when that makes the work clearer.
- Run independent plans in parallel only when they do not affect each other.
- Run dependent plans in sequence when one plan changes the inputs or outcomes of another.

## Practical Guardrails

- Keep the three roles in separate owned sections even though they share one cycle document.
- Keep the main agent limited to orchestration; do not let it directly absorb planner, generator, or evaluator ownership by default.
- If a plan is ambiguous, resolve it in the planning document instead of letting generator improvise.
- If end-to-end automation is incomplete, evaluator should still record the strongest manual or scripted user-level validation available.
- Do not treat plan-only artifacts as a cycle pass/fail evaluation before implementation exists.
- Do not create or update final `docs/implementation/` briefings from a plan-only or generator-only state.
- Do not create `docs/implementation/briefings/`; keep `docs/implementation/` category-based.
