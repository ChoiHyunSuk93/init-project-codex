# Subagent Workflow

This repository uses a team-first execution model.
The leader stays outside worker lanes, launches `omx team` / `$team`, and keeps a Ralph-style ownership loop until the active cycle passes.
The minimum team shape is distinct planning, implementation, and evaluation lanes; complex tasks may add specialist lanes.
Internal coordination state lives under `.omx/` rather than a repository-owned working-doc directory.

## Durable Output

- `docs/guide/` is user-facing guidance only.
- `docs/implementation/` is the durable PASS-only summary output.
- `.omx/` holds runtime coordination state and should not be treated as user-facing documentation.

## Cycle

1. The leader checks whether the workspace is already dirty.
2. If dirty, the leader creates a preservation commit before team launch.
3. The leader launches or resumes `omx team` / `$team`.
4. Planning, implementation, and evaluation run in distinct team lanes.
5. The leader performs Ralph-style review and decides PASS or FAIL.
6. On PASS, publish or update the final briefing under `docs/implementation/`.
7. On FAIL, start the next team cycle.
