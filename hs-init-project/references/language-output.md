# Language Output Rules

## First question

Before any structural clarification question, check whether a valid language selection is already present. If not, ask this plain-text question first:

```md
1. English
2. Korean(한국어)
```

If no valid language selection is already present, the entire next user-facing message must be exactly those two lines and nothing else.
After printing the language question, stop and wait for the answer.
Do not inspect the repository, load templates, or send progress updates before the language is fixed.

Use the selected language for:

- generated repository prose under `README.md`, `rule/`, `docs/guide/`, and `docs/implementation/`
- the repository-specific root `AGENTS.md` overlay that this skill applies after `omx setup --scope project`
- all follow-up clarification questions

OMX-managed prompt, skill, agent, and config catalogs under `.codex/` remain OMX-managed; this skill should not rewrite them just to localize prose.

## English mode

- Write generated document contents in English.
- Write the repository-specific `AGENTS.md` overlay in English.

## Korean mode

- Write generated document contents in Korean.
- Write the repository-specific `AGENTS.md` overlay in Korean.
- Add Korean magic-keyword aliases when revising the OMX-generated root `AGENTS.md`.

In Korean mode, prose should be fully Korean even when code or path literals stay English.
