# 언어 정책 규칙

## 목적

사람이 읽는 생성 문서, `subagents_docs/` working document, 안정적인 filename/path 규칙에 대한 authoritative 언어 정책을 정의한다.

## 선택 언어

- 사람이 읽는 생성 문서는 선택된 언어를 따른다.
- 생성되는 `AGENTS.md` 본문도 선택된 언어를 따른다.
- `subagents_docs/` working document도 선택된 언어를 따른다.
- `.codex/skills/` 아래 생성되는 starter local skill의 `SKILL.md` 본문도 선택된 언어를 따른다.

## English mode

- 생성 문서 본문은 영어로 작성한다.
- 생성되는 `AGENTS.md` 본문도 영어로 작성한다.

## Korean mode

- 생성 문서 본문은 한국어로 작성한다.
- 생성되는 `AGENTS.md` 본문도 한국어로 작성한다.
- 한국어 filename은 `docs/guide/`, `docs/implementation/` 아래 제어 파일이 아닌 문서에서만 허용한다.

## 공통 불변 조건

- 제어 파일 이름은 [`README.md`](../../README.md), [`AGENTS.md`](../../AGENTS.md), [`rule/index.md`](../index.md)로 유지한다.
- indexed rule 문서는 `rule/rules/*.md` 아래에 둔다.
- 디렉토리 이름은 영어로 유지한다.
- 코드, 명령어, 설정 키, 슬러그, path literal은 영어로 유지한다.
- 예측 가능한 rule path convention은 영어로 유지한다.
- 실제로 열 수 있는 진입점 문서와 제어문서 참조는 Markdown 링크를 우선하고, placeholder/example path는 path literal로 남긴다.

## 관련 규칙

- cycle 파일 구조와 provenance는 [`rule/rules/cycle-document-contract.md`](cycle-document-contract.md)를 따른다.
