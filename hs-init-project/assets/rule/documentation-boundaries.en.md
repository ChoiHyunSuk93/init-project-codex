# Documentation Boundaries Rule

## Purpose

Define the difference between rule documents, guide documents, and implementation records.

## Directory Roles

- [`README.md`](../../README.md): primary human-facing repository summary at the root
- [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md): requirements specification for the whole project flow
- `rule/`: authoritative Codex execution rules, with [`rule/index.md`](../index.md) as the discovery entry point
- `docs/guide/`: user-facing guides for real workflows, with [`docs/guide/README.md`](../../docs/guide/README.md) as the default entry point
- `docs/implementation/`: human-facing final briefings and outcomes only, with [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md) as the control file
- `subagents_docs/`: planner, generator, and evaluator working documents, with [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md) as the control file and [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md) as the phase roadmap

## Default Control Files

- `rule/` -> [`rule/index.md`](../index.md), `rules/`
- `docs/guide/` -> [`docs/guide/README.md`](../../docs/guide/README.md)
- `docs/implementation/` -> [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md)
- `subagents_docs/` -> [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md)
- phase roadmap -> [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md)

Keep these control filenames stable across language modes.

## Reference Link Policy

- Use Markdown links when a reference points to a real entrypoint or control document that readers should open directly.
- Typical targets include root/local [`AGENTS.md`](../../AGENTS.md), [`README.md`](../../README.md), [`rule/index.md`](../index.md), [`docs/guide/README.md`](../../docs/guide/README.md), [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md), and [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md).
- When describing a directory with a stable control file, pair the directory description with that actual entrypoint file to keep navigation concrete.
- Do not create links for placeholders or for defaults that are intentionally not created.

## Directory Defaults

- Do not create `docs/guide/AGENTS.md` by default when `README.md` is sufficient.
- Do create [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md) by default so Codex can place and maintain final briefings consistently.
- Do create [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md) by default so Codex can place and maintain working documents consistently.
- Do not treat `docs/guide/`, `docs/implementation/`, or `subagents_docs/` as the primary rule authority.
- If an existing top-level `docs/` tree already carries project meaning, inspect it first and ask before reinterpreting it.
- If an existing top-level `rule/` tree already carries project meaning, inspect it first and ask before reinterpreting or overwriting it.

## Documentation Automation

- Create or update the root `README.md` when durable repository-facing facts or project structure become clearer.
- Create or update [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md) when project purpose, core flows, requirements, or constraints emerge or change.
- Update [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md) when implementation phases or completion criteria change.
- Add or update guide documents only when a stable user-facing workflow exists, such as running, deploying, testing, operations, or request intake.
- Do not create guide documents from observed structure, test layout, tooling inventories, or implementation notes alone.
- Keep working documents in `subagents_docs/`, final briefings in `docs/implementation/`, and execution rules in `rule/`.
- Keep final briefings synchronized with completed plan-cycle outcomes.
- Follow [`rule/rules/rule-maintenance.md`](rule-maintenance.md) when explicit rule requirements are added or changed so the relevant `rule/rules/` document and [`rule/index.md`](../index.md) stay aligned.

## Language Note

Use [`rule/rules/language-policy.md`](language-policy.md) for the exact document-language and filename/path rules that apply to human-facing docs and `subagents_docs/` working docs.
