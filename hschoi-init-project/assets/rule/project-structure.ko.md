# 프로젝트 구조 규칙

## 목적

이 저장소의 최상위 디렉토리 모델을 정의하고, 각 주요 영역의 역할을 분명하게 한다.

## 최상위 영역

- `AGENTS.md`: 저장소 전역 orchestration 지침
- `rule/`: authoritative Codex 실행 규칙
- `docs/guide/`: 사람이 읽는 사용자 가이드 문서
- `docs/implementation/`: 사람이 읽는 구현 기록 문서

## Runtime 영역

runtime으로 취급하는 디렉토리를 여기에 적는다.

예시 placeholder:

- `[runtime-directory]`

## Non-Runtime 영역

non-runtime으로 취급하는 디렉토리를 여기에 적는다.

예시 placeholder:

- `rule/`
- `docs/`
- `[non-runtime-directory]`

## 변경 규칙

- runtime과 non-runtime 경계는 명시적으로 유지한다.
- 실제 디렉토리 구조가 확정되면 placeholder 항목을 관찰된 경로로 교체한다.
- 최상위 구조가 바뀌면 `rule/rules/project-structure.md`에 그 구조를 실제 값으로 반영한다.
- 확립된 최상위 영역을 이동하거나 이름 변경할 때는 `rule/index.md`와 관련 `rule/rules/*.md` 문서도 함께 갱신한다.
- local 구조가 복잡해지면 scope를 분명하게 해주는 곳에만 local instruction 파일을 추가한다.
