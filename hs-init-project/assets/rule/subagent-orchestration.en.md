# Subagent Orchestration Rule

## Purpose

Define an adaptive harness where the main agent chooses how much planning and delegation the task needs.

`subagents_docs/` is the working-document area for cycle-backed work.
Use [`rule/rules/language-policy.md`](language-policy.md) for the exact language rules for those working documents.
`docs/guide/` and `docs/implementation/` are user-facing only.
`docs/implementation/` stores only final, passed-cycle implementation briefings inside concern-based categories.
The main agent owns classification, plan approval, implementation integration, and handoff decisions.
The main agent may autonomously invoke subagents when needed.
For document analysis, prefer parallel `explorer` calls when the questions are independent.
The coordinator may wait as long as needed for subagent output, but it must close completed or no-longer-needed threads immediately after integrating their outputs.
If stale sessions or thread limits block more delegation, cleanup is required before continuing.
Use [`rule/rules/planning-roadmap.md`](planning-roadmap.md) as the authority for project requirements and phase gates.

## Intent Gate

- Do not start the implementation cycle for analysis-only, question-only, review-only, or explanation-only requests.
- Start implementation only when the user explicitly requested implementation, change, creation, update, fix, or materialization.
- If implementation intent is ambiguous, stop at analysis or ask instead of guessing.

## Overview And Roadmap Gate

- Before starting an implementation cycle, confirm [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md) describes the current requirements or observed project structure.
- [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md) must derive phases, completion checklists, verification methods, and dependencies from `PROJECT_OVERVIEW.md`.
- Each implementation cycle links to a specific roadmap phase or phase section.
- A dependent next phase must not start until the previous phase is `PASS` and its required checklist is satisfied.
- When evaluator records `FAIL`, do not move to the next phase. Update that phase's checklist and notes, then re-plan within the same phase.

## Execution Modes

### small

- Default path: `main/generator -> evaluator`
- Use when the scope is narrow and already clear.
- A cycle document is optional when no shared working record is needed.

### medium

- Default path: `main(plan+implementation) -> evaluator`
- Use when a short plan helps but a fully delegated planning loop would be overhead.
- Record `Planner vN` and `Generator vN` in one cycle document when a cycle is opened.

### large-clear

- Default path: `main-led decomposition + delegated implementation + evaluator`
- Use when the work is large but clear enough for bounded implementation slices.

### large-ambiguous

- Default path: `parallel explorer analysis + planner assist if needed + main-approved plan + delegated implementation + evaluator`
- Use when the work is large and still materially ambiguous.

## Cycle Document Model

Use [`rule/rules/cycle-document-contract.md`](cycle-document-contract.md) as the authoritative detailed rule for exact cycle file paths, header transitions, append-only section rules, provenance, and dirty-worktree evaluation.

- New cycles use one append-only working document per plan under `subagents_docs/cycles/<NN>-<slug>.md`.
- Keep planning, implementation, and evaluation outputs in append-only sections inside that same file.
- Small direct changes may skip the cycle document when no shared working record is needed.

## Role Boundaries

### planner

- Optional planning assist for large ambiguous work.
- Defines candidate plans and appends planner sections under `subagents_docs/cycles/` when a cycle is open.
- Follows [`rule/rules/cycle-document-contract.md`](cycle-document-contract.md) for exact section contents and provenance.
- Does not edit implementation files, scripts, templates, or evaluation outputs.

### generator

- Implementation assist for bounded delegated work or direct small changes.
- Records implementation details in generator sections under `subagents_docs/cycles/` when a cycle is open.
- Follows [`rule/rules/cycle-document-contract.md`](cycle-document-contract.md) for exact section contents and verification-basis requirements.
- May add unit-level checks when helpful.
- Does not publish final `docs/implementation/` briefings before evaluator pass.

### evaluator

- Validates the implemented result against the plan and acceptance criteria with the strongest feasible check by directly exercising the representative user surface when that surface exists, then appends evaluator sections under `subagents_docs/cycles/` when a cycle is open.
- Tests functionality, structure, and workflow compliance.
- Follows [`rule/rules/cycle-document-contract.md`](cycle-document-contract.md) for exact PASS/FAIL recording, provenance, and dirty-worktree comparison requirements.
- Does not edit implementation files or planning outputs.

## Orchestrated Cycle

1. The main agent classifies the work as `small`, `medium`, `large-clear`, or `large-ambiguous`.
2. If analysis is needed first, split it into parallel explorer calls when practical.
3. If a cycle document is opened, append `Planner vN` and `Generator vN` sections according to the selected mode, then hand off to evaluator.
4. If evaluator finds failures or blockers in the implemented result, return to the appropriate planning depth for that mode and repeat.
5. When evaluator records `FAIL`, the coordinator restarts without another user question unless the blocker truly requires external input.
6. Continue the cycle until the plan passes.

## Multi-Plan Execution

- If several approaches are required, split them as `plan1`, `plan2`, `plan3` and manage each separately.
- Run independent plans in parallel only when they do not affect each other, and keep each plan linked to a roadmap phase or phase section.
- Run dependent plans sequentially when a prior plan affects later inputs or assumptions, and only after the previous phase reaches `PASS` with its required checklist satisfied.

## Guardrails

- Keep cycle-backed outputs in their own sections even though they share one cycle file.
- Do not place planning, implementation, or evaluation records in `docs/implementation/`.
- After a subagent result is integrated and no longer needed, the coordinator closes that thread immediately.
- If a representative user surface exists, evaluator should prioritize direct checks through that surface, such as browser UI, app simulator/runtime, game runtime/scene, CLI commands, or API request/response flows.
- If direct user-surface validation is unavailable, evaluator must record why, what environment or access is missing, what substitute validation was used, and why any critical unverified surface cannot be soft-passed.
- If plan scope is unclear, resolve it through explorer analysis or planner assistance before delegated implementation starts.
- Do not treat a plan-only artifact as a cycle pass/fail evaluation before implementation exists.
- Do not create or update final `docs/implementation/` briefings from a plan-only or generator-only state.
