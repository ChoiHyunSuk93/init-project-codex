# Subagent Orchestration

Every repository initialized by this skill uses a **team-first, Ralph-led** harness.

## Core Rule

`omx setup --scope project` provides the local OMX runtime scaffold.
The generated repository adds repository-owned rules and human-facing docs on top of that scaffold.

The leader stays outside worker lanes and owns:

- intake and acceptance criteria
- staffing and launch decisions
- clean-workspace checks before team launch
- PASS/FAIL judgment
- deciding whether another team cycle is required

Default execution is `omx team` / `$team`.
At minimum, the team must separate planning, implementation, and evaluation across distinct lanes or subagents.
Additional specialist lanes may be added on top of that minimum split.
The leader uses a Ralph-style persistence loop around that team execution until fresh evidence shows the cycle has passed.
Internal coordination state lives under `.omx/` and does not need a repository-owned working-doc directory.
The durable human-facing output is the final briefing under `docs/implementation/` after PASS.

## Clean Workspace Gate

Before launching `omx team`, the leader must check whether the workspace is already dirty.
If the workspace is dirty before the new task begins, team launch is blocked by default.
Create a preservation commit first, then proceed from a clean HEAD state.
Only explicit user override may bypass that default.

## Role Boundaries

### leader / Ralph owner

- Defines the current goal, constraints, acceptance criteria, and staffing plan.
- Verifies workspace cleanliness and creates the preservation commit when needed before launch.
- Launches or resumes the team.
- Reads verification evidence and records PASS or FAIL.
- If the cycle fails, prepares the next team cycle instead of disappearing into a worker lane.

### team planner lane

- Produces or revises the concrete plan for the active cycle.
- Defines acceptance criteria, constraints, and handoff targets for the implementation lane.
- Must not self-approve implementation output.

### team generator lane

- Implements the approved plan.
- Records changed files, implementation scope, and verification performed.
- Must not self-approve its own output.

### team evaluator lane

- Reviews the generated result against the plan and acceptance criteria.
- Records concrete evaluation evidence and unresolved issues.
- Must remain distinct from the lane that performed the implementation work for the same review step.

### optional specialist lanes

- Add more lanes when the task warrants finer specialization.
- Examples: research, backend, frontend, migration, test-debug, security, performance, docs, release verification.
- Specialist lanes refine the minimum plan / generate / evaluate split rather than replacing it.

## Workflow

1. The leader confirms the workspace is clean or creates a preservation commit first.
2. The leader launches or resumes `omx team`.
3. The team planner lane works.
4. Optional specialist lanes contribute as needed.
5. The team generator lane works.
6. Optional specialist review lanes contribute as needed.
7. The team evaluator lane works.
8. The leader performs Ralph-style review and judges PASS or FAIL.
9. On PASS, publish or update the final human-facing briefing under `docs/implementation/`.
10. On FAIL, start the next team cycle.
