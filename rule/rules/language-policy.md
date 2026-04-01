# 언어 정책 규칙

## 목적

current repo와 generated structure에서 문서 본문 언어, 제어 파일 이름, 경로 표기 규칙을 authoritative하게 정의한다.

## current repo 기본값

- current repo의 사람이 읽는 rule/doc/control file 본문은 한국어를 기본으로 사용한다.
- 적용 대상에는 `AGENTS.md`, `rule/`, `docs/guide/`, `docs/implementation/AGENTS.md`, `subagents_docs/AGENTS.md`, cycle 문서가 포함된다.
- machine-oriented config나 prompt인 `.codex/*.toml`은 영어를 유지할 수 있다.

## generated structure 기본값

- generated repository의 사람이 읽는 문서와 `AGENTS.md` 본문은 사용자가 선택한 언어를 따른다.
- generated repository의 `subagents_docs/` working document도 선택된 언어를 따른다.
- generated repository의 `.codex/skills/*/SKILL.md` 본문도 선택된 언어를 따른다.
- English mode에서는 사람이 읽는 생성 문서를 영어로 쓴다.
- Korean mode에서는 사람이 읽는 생성 문서를 한국어로 쓴다.

## 공통 불변 조건

- 제어 파일 이름은 `README.md`, `AGENTS.md`, `rule/index.md`로 유지한다.
- indexed rule 문서는 `rule/rules/*.md` 아래에 둔다.
- 디렉토리 이름은 영어로 유지한다.
- 코드, 명령어, 설정 키, 슬러그, path literal은 영어로 유지한다.
- 예측 가능한 경로 유지가 중요한 rule path는 영어를 유지한다.

## Korean mode 추가 규칙

- `docs/guide/`, `docs/implementation/` 아래 제어 파일이 아닌 문서 파일명은 한국어를 사용할 수 있다.
- control filename과 rule path convention은 영어로 유지한다.

## 참조 규칙

- cycle 문서의 경로, header, section provenance는 `rule/rules/cycle-document-contract.md`를 따른다.
- root/local AGENTS와 guide 문서는 전체 언어 정책을 다시 길게 복제하지 말고 이 규칙을 기준으로 요약만 남긴다.
