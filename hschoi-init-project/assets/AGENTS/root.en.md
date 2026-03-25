# Repository Instructions

This file defines repository-wide Codex guidance.
Keep this file thin and use it to route work to detailed documents under `rule/`.

## Role Of This File

- Define project-wide instruction boundaries.
- Point to authoritative rule documents in `rule/`.
- Do not duplicate detailed rules that belong in rule documents or local instruction files.

## Rule Model

- Treat `rule/index.md` as the discovery point for authoritative rule documents.
- Read the relevant `rule/*.md` documents before changing project structure or writing new long-lived docs.
- Update `rule/index.md` whenever rule documents are added, removed, renamed, or moved.

## Scope Model

- This root file applies repository-wide.
- A local `AGENTS.md` may narrow or extend instructions for its own directory scope.
- Local instruction files should refine local behavior, not restate repository-wide rules without a reason.

## Document Roles

- `rule/` contains authoritative Codex execution rules.
- `docs/guide/` contains human-facing project guidance.
- `docs/implementation/` contains human-facing implementation records and work history.

## Documentation Automation

- Keep the root `README.md` current as the primary human-facing summary of the repository.
- In fresh repositories, start `README.md` from a minimal template and replace placeholders as the real project purpose becomes known.
- In existing repositories, update `README.md` from observed project structure and durable project facts instead of inventing missing details.
- When work produces durable human-facing guidance, create or update the appropriate guide document under `docs/guide/`.
- In existing repositories, seed focused guide documents from observed repository structure or observed test layout when that information is already stable enough to help readers navigate the project.
- For every implementation change, create or update the corresponding implementation record under `docs/implementation/` in the correct concern-based category and keep the record numbering in order.
- For behavior changes, add or update the most relevant test layer when practical and keep `rule/testing-standards.md` aligned with real test conventions as they emerge.
- When a rule gains new explicit requirements or an existing rule changes, create or update the corresponding document under `rule/` and update `rule/index.md` in the same change.
- When project-specific implementation standards become clearer, update `rule/development-standards.md` so it reflects observed conventions instead of generic defaults.
- If starter rules still contain placeholders, replace them with observed values once the real structure or boundaries become known.

## Skill Work

- If this repository contains Codex skills or a new skill is being created, use `skill-creator`.
- Write each skill so it can be invoked both explicitly by name and implicitly by matching task descriptions through clear `SKILL.md` descriptions and metadata.
- Unless explicit-only behavior is requested, set `policy.allow_implicit_invocation: true` in each skill's `agents/openai.yaml`.
- Have each skill reference the relevant `rule/*.md` documents instead of copying stable repository-wide rules into the skill body.

## Language Policy

- Write human-facing generated documents in English.
- Keep control filenames stable: `README.md`, `AGENTS.md`, `rule/index.md`.
- Keep directory names in English.
- Keep code, commands, config keys, slugs, and path literals in English.
- Keep rule document paths stable in English where predictable pathing matters.

## Non-Duplication

- Keep this file thin as the project evolves.
- Move stable, detailed guidance into `rule/*.md`.
- Add local `AGENTS.md` files only where they improve scope clarity.
