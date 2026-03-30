# Documentation Boundaries Rule

## Purpose

Define the difference between rule documents, guide documents, and implementation records.

## Directory Roles

- `README.md`: primary human-facing repository summary at the root
- `rule/`: authoritative Codex execution rules
- `docs/guide/`: user-facing guides for real workflows
- `docs/implementation/`: human-facing final briefings and outcomes only
- `subagents_docs/`: planner, generator, and evaluator working documents

## Default Control Files

- `rule/` -> `index.md`, `rules/`
- `docs/guide/` -> `README.md`
- `docs/implementation/` -> `AGENTS.md`
- `subagents_docs/` -> `AGENTS.md`

Keep these control filenames stable across language modes.

## Directory Defaults

- Do not create `docs/guide/AGENTS.md` by default when `README.md` is sufficient.
- Do create `docs/implementation/AGENTS.md` by default so Codex can place and maintain final briefings consistently.
- Do create `subagents_docs/AGENTS.md` by default so Codex can place and maintain working documents consistently.
- Do not treat `docs/guide/`, `docs/implementation/`, or `subagents_docs/` as the primary rule authority.
- If an existing top-level `docs/` tree already carries project meaning, inspect it first and ask before reinterpreting it.
- If an existing top-level `rule/` tree already carries project meaning, inspect it first and ask before reinterpreting or overwriting it.

## Documentation Automation

- Create or update the root `README.md` when durable repository-facing facts or project structure become clearer.
- Add or update guide documents only when a stable user-facing workflow exists, such as running, deploying, testing, operations, or request intake.
- Do not create guide documents from observed structure, test layout, tooling inventories, or implementation notes alone.
- Keep working documents in `subagents_docs/`, final briefings in `docs/implementation/`, and execution rules in `rule/`.
- Keep final briefings synchronized with completed plan-cycle outcomes.
- Follow `rule/rules/rule-maintenance.md` when explicit rule requirements are added or changed so the relevant `rule/rules/` document and `rule/index.md` stay aligned.

## Language Note

Apply the active language policy to human-facing docs and `subagents_docs/` working docs, while keeping directory names, code, commands, and path literals in English.
