# Documentation Boundaries Rule

## Purpose

Define the difference between rule documents, guide documents, and implementation records.

## Directory Roles

- `README.md`: primary human-facing repository summary at the root
- `rule/`: authoritative Codex execution rules
- `docs/guide/`: user-facing guides for real workflows
- `docs/implementation/`: human-facing implementation records and outcomes

## Default Control Files

- `rule/` -> `index.md`, `rules/`
- `docs/guide/` -> `README.md`
- `docs/implementation/` -> `AGENTS.md`

Keep these control filenames stable across language modes.

## Directory Defaults

- Do not create `docs/guide/AGENTS.md` by default when `README.md` is sufficient.
- Do create `docs/implementation/AGENTS.md` by default so Codex can place and maintain implementation records consistently.
- Do not treat `docs/guide/` or `docs/implementation/` as the primary rule authority.
- If an existing top-level `docs/` tree already carries project meaning, inspect it first and ask before reinterpreting it.
- If an existing top-level `rule/` tree already carries project meaning, inspect it first and ask before reinterpreting or overwriting it.

## Documentation Automation

- Create or update the root `README.md` when durable repository-facing facts or project structure become clearer.
- Add or update guide documents only when a stable user-facing workflow exists, such as running, deploying, testing, operations, or request intake.
- Do not create guide documents from observed structure, test layout, tooling inventories, or implementation notes alone.
- Keep implementation details in `docs/implementation/` and execution rules in `rule/`.
- Keep implementation records synchronized with actual implementation changes.
- Create or update rule documents under `rule/rules/` and keep `rule/index.md` aligned when explicit rule requirements are added or changed.

## Language Note

Apply the active language policy to human-facing docs, while keeping directory names, code, commands, and path literals in English.
