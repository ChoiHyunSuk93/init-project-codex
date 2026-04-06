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

- Keep the root [`AGENTS.md`](../../AGENTS.md) short.
- Put stable, detailed behavior into `rule/rules/*.md`.
- Use local `AGENTS.md` files only for local scope clarification.

## Reference Link Principle

- Use Markdown links whenever a reference points to a real entrypoint or control document that the reader can open directly.
- Typical targets include root/local [`AGENTS.md`](../../AGENTS.md), [`README.md`](../../README.md), [`rule/index.md`](../index.md), [`docs/guide/README.md`](../../docs/guide/README.md), [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md), [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md), and starter local skill `SKILL.md` files.
- The link destination must open correctly using a relative path from the current document.
- Apply this rule consistently across current-repository docs, generated-repository docs, and the template or script source-of-truth that produces them.
- Do not turn placeholders, examples, not-yet-created paths, or plain path-literal explanations into links.

## Non-Duplication

- Do not restate the same rule in multiple places without a reason.
- If a detailed rule changes, follow [`rule/rules/rule-maintenance.md`](rule-maintenance.md) to update the source rule document and any necessary index references instead of copying the edit into many files.
- Put repository-wide implementation quality expectations into [`rule/rules/development-standards.md`](development-standards.md) or a narrower local rule instead of scattering them across multiple instruction files.

## Intent Gate

- Do not interpret analysis-only, question-only, review-only, or explanation-only user requests as implementation requests.
- Stay in analysis and avoid file edits until the user explicitly requests implementation, change, creation, update, fix, or materialization.
- If implementation intent is ambiguous, clarify instead of guessing and editing files.

## Skill Authoring Note

- Use `skill-creator` when creating or updating Codex skills in this repository.
- Write skills with clear `SKILL.md` descriptions and aligned metadata.
- Unless explicit-only behavior is required, set `policy.allow_implicit_invocation: true` in `agents/openai.yaml`.
- If the repository carries starter local skills under `.codex/skills/`, keep their `SKILL.md` descriptions, metadata, and `allow_implicit_invocation` setting aligned.
- Have each skill reference the relevant `rule/rules/*.md` documents instead of duplicating stable repository-wide rules in the skill body.
