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
- `subagents_docs/` working documents when the harness is active
- all follow-up clarification questions
- any inspect-result questions that must be answered before generation resumes

## English mode

- Write generated document contents in English.
- Write generated `AGENTS.md` contents in English.
- Use English filenames for generated documents unless another rule explicitly overrides this.

## Korean mode

- Write generated document contents in Korean.
- Write generated `AGENTS.md` contents in Korean.
- Keep control filenames stable in English, including `README.md`, `AGENTS.md`, and `rule/index.md`.
- Use Korean filenames only for non-control generated documents under `docs/guide/` and `docs/implementation/`.
- Keep directory names in English.
- Keep code, commands, config keys, slugs, and path literals in English.
- Keep predictable rule-path conventions in English, including `rule/index.md` and `rule/rules/*.md`.

In Korean mode, prose should be fully Korean even when code or path literals stay English.

## AGENTS.md language clause

Generated `AGENTS.md` files should include an explicit language policy section or equivalent guidance.

The guidance should communicate these rules:

- which language is active for human-facing generated documents
- that control filenames remain `README.md`, `AGENTS.md`, and `rule/index.md`
- that indexed rule documents remain under `rule/rules/*.md`
- that directories remain English
- that code, commands, config keys, slugs, and path literals remain English
- that only non-control `docs/guide/` and `docs/implementation/` document filenames become Korean in Korean mode
- that rule-path conventions stay stable in English where predictable pathing matters

### English example meaning

```md
## Language Policy

- Write human-facing generated documents in English.
- Keep control filenames stable: `README.md`, `AGENTS.md`, `rule/index.md`.
- Keep indexed rule documents under `rule/rules/*.md`.
- Keep directory names in English.
- Keep code, commands, config keys, slugs, and path literals in English.
- Keep rule document paths stable in English when predictable pathing matters.
```

### Korean example meaning

```md
## 언어 규칙

- 사람이 읽는 생성 문서는 한국어로 작성한다.
- 제어 파일 이름은 `README.md`, `AGENTS.md`, `rule/index.md`로 유지한다.
- 상세 rule 문서는 `rule/rules/*.md` 아래에 유지한다.
- 디렉토리 이름은 영어로 유지한다.
- 코드, 명령어, 설정 키, 슬러그, 경로 표기는 영어로 유지한다.
- `docs/guide/`, `docs/implementation/`에 생성하는 문서 중 제어 파일이 아닌 문서 파일명은 한국어를 사용한다.
- 예측 가능한 경로 유지가 중요한 rule 문서 경로는 영어 규칙을 유지한다.
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
