# Cycle Document Contract Rule

## Purpose

Define the authoritative contract for cycle file paths, header transitions, append-only sections, provenance, and dirty-worktree evaluation.

## Scope

- `subagents_docs/cycles/`
- `.codex/agents/*.toml`
- `subagents_docs/AGENTS.md`
- `docs/guide/subagent-workflow.md`

## Cycle File Path

- Use one cycle file per plan at `subagents_docs/cycles/<NN>-<slug>.md`.
- Keep one file identity per plan cycle rather than splitting plan, change, and evaluation into separate working files.

## Header Contract

- Keep `Status`, `Current Plan Version`, and `Next Handoff` at the top of every cycle file.
- Allowed `Status` values are only `in_progress`, `PASS`, and `FAIL`.
- The coordinator owns header updates.
- Planner may create the initial scaffold only when the file does not exist yet.

## Coordinator Transitions

- After planner creates or appends `Planner vN`:
  - `Status: in_progress`
  - `Current Plan Version: Planner vN`
  - `Next Handoff: generator`
- After generator appends `Generator vN`:
  - `Status: in_progress`
  - `Current Plan Version: Generator vN`
  - `Next Handoff: evaluator`
- After evaluator appends `Evaluator vN` with `PASS`:
  - `Status: PASS`
  - `Current Plan Version: Evaluator vN`
  - `Next Handoff: complete`
- After evaluator appends `Evaluator vN` with `FAIL`:
  - `Status: FAIL`
  - `Current Plan Version: Evaluator vN`
  - `Next Handoff: planner`

## Section Model

- Keep the body append-only.
- Use role-version section names such as `Planner v1`, `Generator v1`, `Evaluator v1`, `Planner v2`.
- Each role edits only its own sections.
- Reference related work by exact section name inside the same file.

## Provenance Requirements

### Planner

- State whether the section starts a new cycle or responds to a specific `Evaluator vN`.
- Include goals, scope, non-goals, user-visible outcome, acceptance criteria, constraints, risks, dependencies, open questions, and next handoff.

### Generator

- Record the implemented planner section reference.
- Record implemented scope, changed files, verification, and the workspace or baseline scope used for verification.
- Record remaining gaps or risks and next handoff.

### Evaluator

- Record the evaluated planner section and generator section.
- Record exact checks, acceptance-criteria judgment, findings, and next handoff.
- Record the dirty-worktree comparison basis used for the judgment.

## Dirty Worktree Evaluation

- Evaluator may judge a cycle even when unrelated diffs exist.
- Separate cycle-owned changes from unrelated diffs in the record.
- Base `PASS` or `FAIL` only on the cycle-owned scope and the acceptance criteria.
- Do not soft-pass when the comparison basis is unclear.
