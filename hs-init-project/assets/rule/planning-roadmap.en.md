# Project Overview And Roadmap Rule

## Purpose

Require a project-level requirements overview and phase-based execution roadmap before implementation work proceeds, and enforce completion criteria before dependent phases can start.

## Anchor Documents

- [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md): the top-level requirements specification for project purpose, target users, core flows, requirements, constraints, non-goals, and open questions.
- [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md): the working roadmap that derives implementation phases from `PROJECT_OVERVIEW.md` and tracks each phase checklist and status.
- `subagents_docs/cycles/`: cycle working documents for implementing a specific roadmap phase or phase section.

## Creation Standard

- In a fresh project, create `PROJECT_OVERVIEW.md` from the initial user requirements before planning implementation.
- If fresh-project requirements are incomplete, use safe placeholders and open questions. Do not invent features or stack choices.
- In an existing project, inspect the source root, major modules, existing docs, test/build automation, and current user request before writing or refining `PROJECT_OVERVIEW.md` from observed facts.
- If an existing `PROJECT_OVERVIEW.md` is meaningful, refine it instead of replacing it blindly.
- `subagents_docs/roadmap.md` must derive phases from the requirements and constraints in `PROJECT_OVERVIEW.md`.

## Roadmap Structure

Every phase in `subagents_docs/roadmap.md` must include at least:

- `Status`: one of `pending`, `in_progress`, `blocked`, or `PASS`
- `Goal`: user-visible outcome the phase must achieve
- `Scope`: included work
- `Non-goals`: excluded work
- `Required Checklist`: mandatory checklist before the next phase can start
- `Verification`: tests, runtime checks, manual review, or documentation checks used to judge completion
- `Cycle`: linked `subagents_docs/cycles/<NN>-<slug>.md` document
- `Notes`: blockers, decisions, and remaining risks

## Phase Gate

- Each implementation cycle must link to one phase or clear phase section in `subagents_docs/roadmap.md`.
- A dependent next phase must not start until the previous phase's `Required Checklist` is satisfied and its `Status` is `PASS`.
- Only independent phases may run in parallel.
- When evaluator records `FAIL`, update that phase's checklist and notes, then repeat planning and implementation within the same phase.
- When a phase reaches `PASS`, record the evaluation evidence and linked cycle in `subagents_docs/roadmap.md` before moving to the next phase.
- If the roadmap drifts from actual requirements or implementation results, update `PROJECT_OVERVIEW.md` or `subagents_docs/roadmap.md` before starting the next implementation cycle.

## Document Boundary

- `PROJECT_OVERVIEW.md` is the durable requirements specification, not a short task log or cycle progress journal.
- `subagents_docs/roadmap.md` is the working phase/checklist status document and does not replace user-facing final briefings.
- Cycle planning, implementation, and evaluation records stay under `subagents_docs/cycles/`.
- After evaluator `PASS`, write the user-facing summary under the relevant concern-based category in `docs/implementation/` according to [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md).
