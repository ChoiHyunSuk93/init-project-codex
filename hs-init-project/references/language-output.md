# Language Output

Use the language already established by the user's request or current session. Ask once only when it is genuinely unclear.

## Stable Paths

Keep control paths, filenames, config keys, code, commands, and slugs in stable English form regardless of document language:

- `AGENTS.md`
- `CLAUDE.md`
- `PROJECT_OVERVIEW.md`
- `rule/index.md`
- `rule/rules/*.md`
- `docs/guide/README.md`
- `docs/implementation/AGENTS.md`
- `subagents_docs/AGENTS.md`
- `subagents_docs/roadmap.md`
- `subagents_docs/cycles/<NN>-<slug>.md`

## English

Use `*.en.md` assets and write human-facing prose in English.

## Korean

Use `*.ko.md` assets and write human-facing prose in Korean. Keep exact paths, code identifiers, and commands unchanged.

## Alignment

- Load only the selected-language assets during ordinary materialization.
- Keep English and Korean assets structurally and semantically aligned when maintaining this skill.
- Do not create a separate language-policy rule; include stable path and selected-language expectations in `documentation.md`.
- Use the selected language for work records and implementation briefings while keeping control filenames, category slugs, commands, config keys, and code identifiers stable.
