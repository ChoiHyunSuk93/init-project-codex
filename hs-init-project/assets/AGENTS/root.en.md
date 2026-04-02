## Repository-Specific Rule Overlay

- Use `rule/index.md` as the discovery point for repository-specific execution rules.
- Read the relevant `rule/rules/*.md` files before changing project structure, long-lived docs, or workflow policy.
- Keep `rule/` authoritative, keep `docs/guide/` user-facing, and keep `docs/implementation/` limited to short passed-cycle briefings.
- Treat `.omx/` as OMX runtime state, not as user-facing documentation.
- Keep the root `README.md` current as durable project-facing facts change.

## Default Execution Model

- Treat `omx team` / `$team` as the default multi-agent execution surface for implementation work.
- The leader stays outside worker lanes and owns Ralph-style completion: launch team work, read the evidence, decide PASS/FAIL, and relaunch another team cycle when the current one does not pass.
- Within that team run, planning, implementation, and evaluation are mandatory minimum distinct lanes or subagents.
- Add more specialist lanes when the task warrants it, but do not merge away the minimum separation.
- Before any team launch, check whether the workspace is already dirty. If it is, create a preservation commit first and then proceed from a clean state by default.
- The durable human-facing output is the final briefing under `docs/implementation/` after PASS.

## Language Policy

- Follow `rule/rules/language-policy.md` for document-language and stable filename/path rules.
- Keep OMX-managed `.codex/` and `.omx/` artifacts under OMX control; add repository-specific guidance through rules and this overlay instead of replacing OMX catalogs.
