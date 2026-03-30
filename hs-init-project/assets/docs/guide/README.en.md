# Guide Directory

Use this directory for user-facing workflow guides.
This `README.md` acts as the default entry point and index for the directory.

## What Belongs Here

- run guides
- deployment guides
- test-running guides
- design request guides
- planner/generator/evaluator workflow guides
- operating procedures that readers actually need to follow

## Documentation Maintenance

- Create or update a document here when a stable user-facing workflow or request flow needs to be explained.
- As the guide set grows, keep this `README.md` as an index and move detailed content into focused documents.
- Do not put repository maps, implementation details, or copied rule text here.
- Keep reader guidance here and keep execution rules in `rule/index.md` and `rule/rules/`.
- If the repository uses a subagent harness, document the user-facing flow here, but keep working plans, change notes, and evaluation reports in `subagents_docs/`.

## Authority

- Do not treat this directory as the primary authority for Codex execution rules.
- The primary execution authority remains the root `AGENTS.md`, `rule/index.md`, and the documents under `rule/rules/`.
- Only add `docs/guide/AGENTS.md` when this directory genuinely needs local execution rules.
