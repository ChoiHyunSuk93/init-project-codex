# Language Output Rules

## First question

Before any structural clarification question, check whether a valid language selection is already present. If not, ask this plain-text question first:

```md
1. English
2. Korean(한국어)
```

If no valid language selection is already present, the entire next user-facing message must be exactly those two lines and nothing else.
Do not request a chooser, submit dialog, modal, or any other structured selection UI for this prompt.
After printing the language question, stop and wait for the answer.
Do not inspect the repository, load templates, or send progress updates before the language is fixed.

If the current request or the current session already includes a valid language selection such as `1`, `2`, `English`, or `Korean(한국어)`, do not ask the question again.
If the environment is non-interactive and no answer can be collected, ask once and stop instead of repeating the same prompt.

Use the selected language for:

- generated document contents
- generated `AGENTS.md` contents
- `subagents_docs/` working documents
- generated starter local skill `SKILL.md` contents under `.codex/skills/`
- all follow-up clarification questions
- any inspect-result questions that must be answered before generation resumes

Use `assets/rule/language-policy.en.md` and `assets/rule/language-policy.ko.md` as the canonical detailed templates for the generated repository rule.
Generated repositories should materialize `rule/rules/language-policy.md` and let other generated docs point to that rule instead of duplicating the full contract.

## English mode

- Write generated document contents in English.
- Write generated `AGENTS.md` contents in English.
- Follow the generated `rule/rules/language-policy.md` for exact filename and path invariants.

## Korean mode

- Write generated document contents in Korean.
- Write generated `AGENTS.md` contents in Korean.
- Follow the generated `rule/rules/language-policy.md` for exact control-filename, directory, and filename/path rules.

In Korean mode, prose should be fully Korean even when code or path literals stay English.

## AGENTS.md language clause

Generated `AGENTS.md` files should include an explicit language policy section or equivalent guidance.
Generated repositories should also materialize `rule/rules/language-policy.md` as the authoritative detailed language rule.

The local guidance should name the active language and point readers to `rule/rules/language-policy.md` for the exact rules.

### English example meaning

```md
## Language Policy

- Write human-facing generated documents in English.
- Follow `rule/rules/language-policy.md` for exact filename and path rules.
```

### Korean example meaning

```md
## 언어 규칙

- 사람이 읽는 생성 문서는 한국어로 작성한다.
- exact 언어 규칙과 filename/path 불변 조건은 `rule/rules/language-policy.md`를 따른다.
```

## Rule index templates

Use these starter templates:

- English: `assets/rule/index.en.md`
- Korean: `assets/rule/index.ko.md`

Use these implementation-record templates when a record is created:

- English: `assets/docs/implementation/record.en.md`
- Korean: `assets/docs/implementation/record.ko.md`

These skill-bundled templates are internal sources for generation.
Do not copy the skill's `assets/` directory into the target repository.
