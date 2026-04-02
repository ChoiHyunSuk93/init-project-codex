# Subagent Orchestration Rule

## Purpose

Define a team-first delivery model with the leader owning Ralph-style completion.
The mandatory minimum team split is planning, implementation, and evaluation in distinct lanes.
More specialist lanes may be added when the task warrants it.

## Intent Gate

- Do not start the implementation cycle for analysis-only, question-only, review-only, or explanation-only requests.
- Start the team / Ralph cycle only when the user explicitly requested implementation, change, creation, update, fix, or materialization.

## Clean Workspace Gate

- Before `omx team` launch, check whether the workspace is already dirty.
- If it is dirty before the new task starts, team launch is blocked by default.
- Create a preservation commit first, then proceed from a clean HEAD state.

## Output Model

- `.omx/` holds internal coordination state.
- `docs/implementation/` holds the durable PASS-only human-facing briefing.
- Do not create a repository-owned working-doc directory for the team runtime.
