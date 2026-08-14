# Existing Project Analysis

Use this procedure after the baseline structure is materialized in a repository that already contains code or meaningful project content.

## Required Evidence Pass

Read representative files instead of stopping at a directory inventory:

1. Read root and scoped instruction files, the README, existing overview or architecture docs, and relevant user-owned guides.
2. Read package, workspace, dependency, build, task, and environment-example files that define the stack and commands.
3. Locate runtime entrypoints and read enough real source to identify major modules, their responsibilities, and important data or control-flow boundaries.
4. Read representative tests and test configuration to determine actual test layers, naming, and supported commands.
5. Inspect CI, deployment, release, or automation definitions only when they exist and affect documented workflows.
6. Trace commands to their defining source. Do not promote a guessed or merely conventional command into project documentation.

For a large repository, sample by intentional runtime area and follow imports or call paths far enough to explain the top-level architecture. Do not attempt exhaustive line-by-line reading when representative evidence answers the initialization questions.

## Required Documentation Updates

Update or merge these documents from the evidence pass:

- `PROJECT_OVERVIEW.md`: purpose, users or operators, core flows, requirements, non-goals, source/module boundaries, constraints, verified commands, open questions, and repository-relative evidence paths
- `docs/guide/README.md`: existing human-facing guides and confirmed run, test, build, deploy, or operating workflows; do not turn a file inventory into a guide
- `subagents_docs/roadmap.md`: phases derived from the observed current state and user request, with status, acceptance checklist, verification, and dependencies
- relevant generated rules: observed source ownership, development conventions, test entrypoints, documentation locations, and agent work-record expectations

Keep a meaningful existing document and refine it rather than replacing it with a generic template. If a selected materialization path was preserved, update it only when the user authorized semantic refinement.

## Work History Model

- Keep the roadmap as mutable current phase status.
- Create `subagents_docs/cycles/<NN>-<slug>.md` for medium or larger work, work-sharing, multiple handoffs, or audit-worthy state changes.
- Keep cycle role sections append-only and record whether the main agent or a delegated agent produced the section.
- Let delegated agents return findings or patches; keep shared cycle headers, roadmap status, and integration coordinator-owned.
- After required verification passes, add a new category-based implementation briefing instead of rewriting older history.

## Completion Gate

Do not call initialization complete when any of these are true:

- `HS_INIT_SEMANTIC_TODO` remains in required control documents.
- The overview only lists directories and does not explain observed module responsibilities or flows.
- Existing-project evidence does not name any real repository-relative path.
- Commands, frameworks, architecture, users, or delivery surfaces are asserted without evidence.
- The roadmap is not derived from the overview or lacks a verifiable phase.
- Required documentation or work-record entrypoints are missing.

Run:

```bash
python3 /path/to/hs-init-project/scripts/validate_materialized_repo.py \
  --root <repo> \
  --project-mode existing
```

Treat this deterministic check as a floor. Also review factual accuracy against the files read during the evidence pass.
