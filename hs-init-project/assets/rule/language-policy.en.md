# Language Policy Rule

## Purpose

Define the authoritative language policy for human-facing generated documents, `subagents_docs/` working documents, and stable filename/path conventions.

## Selected Language

- Use the selected language for human-facing generated documents.
- Use the selected language for generated `AGENTS.md` contents.
- Use the selected language for `subagents_docs/` working documents.
- Use the selected language for generated starter local skill `SKILL.md` contents under `.codex/skills/`.

## English Mode

- Write generated document prose in English.
- Keep generated `AGENTS.md` prose in English.

## Korean Mode

- Write generated document prose in Korean.
- Write generated `AGENTS.md` prose in Korean.
- Korean filenames are allowed only for non-control documents under `docs/guide/` and `docs/implementation/`.

## Shared Invariants

- Keep control filenames stable: [`README.md`](../../README.md), [`AGENTS.md`](../../AGENTS.md), [`rule/index.md`](../index.md).
- Keep indexed rule documents under `rule/rules/*.md`.
- Keep directory names in English.
- Keep code, commands, config keys, slugs, and path literals in English.
- Keep predictable rule-path conventions in English.
- Prefer Markdown links for real entrypoint or control-document references, and leave placeholder or example paths as plain literals.

## Related Rules

- Use [`rule/rules/cycle-document-contract.md`](cycle-document-contract.md) for cycle file structure and provenance.
