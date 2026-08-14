# Repository Instructions

This file is the thin repository-wide agent entrypoint.
Start detailed rule discovery at [`rule/index.md`](rule/index.md).

## Baseline Behavior

- Read [`PROJECT_OVERVIEW.md`](PROJECT_OVERVIEW.md) and the relevant rules before working.
- When a phase or handoff is active, read [`subagents_docs/roadmap.md`](subagents_docs/roadmap.md) and the related cycle.
- Do not interpret analysis, questions, or review requests as authorization to implement.
- Prefer existing structure and conventions, and change only the necessary scope.
- Do not invent unobserved stacks, commands, paths, or product behavior.
- Run the closest verification proportional to risk and report observed results.

## Rule Discovery

- Project structure: [`rule/rules/project-structure.md`](rule/rules/project-structure.md)
- Development standards: [`rule/rules/development-standards.md`](rule/rules/development-standards.md)
- Testing and verification: [`rule/rules/testing-standards.md`](rule/rules/testing-standards.md)
- Documentation and language: [`rule/rules/documentation.md`](rule/rules/documentation.md)
- Agent workflow: [`rule/rules/agent-workflow.md`](rule/rules/agent-workflow.md)

## Documentation And Work Records

- User guides: [`docs/guide/README.md`](docs/guide/README.md)
- Verified implementation history: [`docs/implementation/AGENTS.md`](docs/implementation/AGENTS.md)
- Plans, handoffs, and verification working records: [`subagents_docs/AGENTS.md`](subagents_docs/AGENTS.md)

Update [`rule/index.md`](rule/index.md) in the same change when adding, removing, or moving rules.
Add local instruction files only when a narrower directory scope is genuinely needed.
