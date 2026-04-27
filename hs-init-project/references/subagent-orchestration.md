# Subagent Orchestration

Every repository initialized by this skill supports an adaptive harness instead of one mandatory fixed pipeline.
Use this reference as the baseline harness model for generated repositories.

## Core Rule

Keep the harness additive. It sits on top of the existing `README.md`, `AGENTS.md`, `rule/`, `docs/guide/`, and `docs/implementation/` model instead of replacing it.
The main agent owns task classification, plan approval, implementation integration, and handoff decisions.
The main agent may autonomously invoke subagents when needed.
Document analysis should prefer parallel `explorer` calls when the questions are independent.
Generated repositories must store cycle-backed working documents in `subagents_docs/`, not in `docs/guide/` or `docs/implementation/`.
Use `rule/rules/language-policy.md` for the exact language rules for `subagents_docs/` working documents.
Use `docs/guide/` for user-facing guidance and `docs/implementation/` only for short final implementation briefings inside concern-based categories after a plan cycle passes.
Generated repositories must include `rule/rules/cycle-document-contract.md` and `rule/rules/language-policy.md` as the authoritative cycle and language rules.
Generated repositories must include `rule/rules/planning-roadmap.md`, root `PROJECT_OVERVIEW.md`, and `subagents_docs/roadmap.md` so implementation cycles start from a project-level requirements baseline and phase checklist.
Generated repositories may include process-oriented starter local skills under `.codex/skills/`; keep their `SKILL.md` descriptions, metadata, and `allow_implicit_invocation` support aligned.
The coordinator may wait as long as needed for subagent output, but it must close completed or no-longer-needed subagent threads immediately after integrating their outputs.
If stale sessions or thread-limit blockage prevent more delegation, cleanup is required coordination work before continuing.

## Intent Gate

Do not start implementation unless the user explicitly requested implementation, change, creation, update, fix, or materialization.
If the user request is analysis-only, question-only, review-only, explanation-only, or otherwise non-implementation, stay in analysis and do not edit files.
If implementation intent is ambiguous, clarify or stop at analysis instead of guessing.

## Overview And Roadmap Gate

Before implementation work:

- Create or refresh `PROJECT_OVERVIEW.md` from the initial requirements in fresh repositories.
- In existing repositories, inspect the source root, major modules, existing docs, test/build signals, and current request before writing or refining `PROJECT_OVERVIEW.md`.
- Create or refresh `subagents_docs/roadmap.md` from `PROJECT_OVERVIEW.md`.
- Break the work into implementation phases with required checklists and verification methods.
- Link each implementation cycle to one roadmap phase or phase section.
- Do not start a dependent next phase until the previous phase reaches `PASS` and its required checklist is satisfied.
- When evaluator records `FAIL`, update the same phase checklist and notes, then repeat planning and implementation in that phase.

## Execution Modes

### small

- Default path: `main/generator -> evaluator`
- Use when the scope is small and the request is already clear.
- A cycle document is optional when no shared working record is needed.

### medium

- Default path: `main(plan+implementation) -> evaluator`
- Use when a short plan is useful but a full delegated planning loop would be overhead.
- Keep the short plan and implementation in the same cycle document when a cycle is opened.

### large-clear

- Default path: `main-led decomposition + delegated implementation + evaluator`
- Use when the work is large but the shape is already clear enough for bounded implementation slices.
- The main agent owns top-level planning and integration.

### large-ambiguous

- Default path: `parallel explorer analysis + planner assist if needed + main-approved plan + delegated implementation + evaluator`
- Use when the work is large and ambiguity is still material.
- The main agent approves the final plan after explorer or planner assistance, then integrates delegated implementation slices.

## Cycle Document Model

Use `rule/rules/cycle-document-contract.md` as the authoritative detailed rule for this section.

- Track each cycle-backed plan as one append-only document under `subagents_docs/cycles/<NN>-<slug>.md`.
- This is one document per plan, not one global shared log.
- Keep the top status block coordinator-owned and keep the body append-only by phase section.
- Small direct changes may skip the cycle document when no shared working record is needed.

## Phase Boundaries

### planner

- Optional planning assist for large ambiguous work.
- Uses `subagents_docs/cycles/` for owned outputs when a cycle is open.
- Follows `rule/rules/cycle-document-contract.md` for exact section contents and provenance.
- Does not edit implementation, templates, scripts, or evaluation output.

### generator

- Implementation assist for bounded delegated work or direct small changes.
- Uses `subagents_docs/cycles/` for owned outputs when a cycle is open.
- Follows `rule/rules/cycle-document-contract.md` for exact section contents and verification-basis requirements.
- Does not publish final `docs/implementation/` briefings before evaluator pass.

### evaluator

- Runs the strongest feasible validation of the implemented result against the plan and acceptance criteria by directly exercising the representative user surface when that surface exists.
- Records observations, issues, and final quality assessment.
- Uses `subagents_docs/cycles/` for owned outputs when a cycle is open.
- Follows `rule/rules/cycle-document-contract.md` for exact PASS/FAIL recording, provenance, and dirty-worktree comparison requirements.
- Does not modify product files.

## Artifact Contract

Use `rule/rules/cycle-document-contract.md` for exact header transitions, provenance, and dirty-worktree comparison rules.

- Keep one cycle document per plan and keep the same numeric prefix or slug across the file name and the plan identity.
- `docs/implementation/` remains a human-facing summary layer and must not replace working records.

## Evaluation Criteria

- design quality
- originality
- completeness
- functionality

Weight `design quality` and `originality` more heavily than `completeness` and `functionality`.

## Workflow

1. The main agent classifies the work as `small`, `medium`, `large-clear`, or `large-ambiguous`.
2. If analysis is needed first, split it into parallel explorer calls when practical.
3. If a cycle document is opened, append `Planner vN` and `Generator vN` sections according to the selected mode, then hand off to evaluator.
4. If evaluator finds failures or blockers in the implemented result, return to the appropriate planning depth for that mode and repeat until it passes.
5. When evaluator records `FAIL`, restart without another user question unless the blocker is truly unresolved external input.
6. After a subagent output is integrated and the thread is no longer needed, the coordinator closes that thread immediately instead of leaving stale sessions open.

## Multi-Plan Rules

- Split distinct user requirements into separate plans when that makes the work clearer.
- Run independent plans in parallel only when they do not affect each other.
- Run dependent plans in sequence when one plan changes the inputs or outcomes of another.

## Practical Guardrails

- Keep cycle-backed planning, implementation, and evaluation sections append-only.
- Keep evaluator separate even when planning or implementation stay local to the main agent.
- If a plan is ambiguous, resolve it through parallel explorer work or planner assistance before delegated implementation begins.
- If a representative user surface exists, evaluator should prioritize direct validation through that surface, such as browser UI, app simulator/runtime, game runtime/scene, CLI entrypoints, or API request/response flows.
- If direct user-surface validation is unavailable, evaluator should record why, what environment or access is missing, what substitute validation was used, and why any critical unverified surface cannot be soft-passed.
- Do not treat plan-only artifacts as a cycle pass/fail evaluation before implementation exists.
- Do not create or update final `docs/implementation/` briefings from a plan-only or generator-only state.
- Do not create `docs/implementation/briefings/`; keep `docs/implementation/` category-based.
