# 문서 경계 규칙

## 목적

rule 문서, guide 문서, implementation 기록 문서의 차이를 정의한다.

## 디렉토리 역할

- `rule/`: 기준 Codex 실행 규칙
- `docs/guide/`: 사람이 읽는 안내 및 참고 문서
- `docs/implementation/`: 사람이 읽는 구현 기록과 결과 문서

## 기본 제어 파일

- `rule/` -> `index.md`
- `docs/guide/` -> `README.md`
- `docs/implementation/` -> `AGENTS.md`

이 제어 파일 이름은 언어 모드와 무관하게 유지한다.

## 디렉토리 기본값

- `README.md`로 충분한 경우 `docs/guide/AGENTS.md`는 기본적으로 만들지 않는다.
- Codex가 구현 기록을 일관되게 배치하고 유지할 수 있도록 `docs/implementation/AGENTS.md`는 기본적으로 만든다.
- `docs/guide/`와 `docs/implementation/`을 기준 규칙 권한으로 취급하지 않는다.

## 문서화 자동화

- 오래 유지해야 할 guide 성격의 내용이 생기면 guide 문서를 추가하거나 수정한다.
- 구현 변경은 항상 구현 기록 문서와 함께 동기화하고, 카테고리 안의 번호 순서를 유지한다.
- 명시 규칙이 추가되거나 바뀌면 해당 rule 문서를 생성하거나 수정하고, 같은 변경에서 `rule/index.md`도 함께 갱신한다.

## 언어 메모

사람이 읽는 문서에는 활성 언어 규칙을 적용하되, 제어 파일 이름, 디렉토리 이름, 코드, 명령어, 경로 표기는 영어로 유지한다.
