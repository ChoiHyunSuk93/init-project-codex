# Instruction Model Rule

## Purpose

Define how root instructions, local instructions, and rule documents work together.

## Authority Order

1. Relevant task-specific user instructions
2. Applicable local `AGENTS.md`
3. Applicable referenced rule documents in `rule/index.md` and `rule/rules/`
4. Root `AGENTS.md`

Use this order to resolve scope, not to justify duplication.

## Thin Root Principle

- Keep the root `AGENTS.md` short.
- Put stable, detailed behavior into `rule/rules/*.md`.
- Use local `AGENTS.md` files only for local scope clarification.

## Non-Duplication

- Do not restate the same rule in multiple places without a reason.
- If a detailed rule changes, follow `rule/rules/rule-maintenance.md` to update the source rule document and any necessary index references instead of copying the edit into many files.
- Put repository-wide implementation quality expectations into `rule/rules/development-standards.md` or a narrower local rule instead of scattering them across multiple instruction files.

## Skill Authoring Note

- Use `skill-creator` when creating or updating Codex skills in this repository.
- Write skills so both explicit invocation and implicit invocation through matching task descriptions work via clear `SKILL.md` descriptions and metadata.
- Unless explicit-only behavior is required, set `policy.allow_implicit_invocation: true` in `agents/openai.yaml`.
- Have each skill reference the relevant `rule/rules/*.md` documents instead of duplicating stable repository-wide rules in the skill body.
