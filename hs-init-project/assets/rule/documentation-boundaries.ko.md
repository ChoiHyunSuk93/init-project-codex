# 문서 경계 규칙

## 목적

rule 문서, guide 문서, implementation 기록 문서의 차이를 정의한다.

## 디렉토리 역할

- [`README.md`](../../README.md): 저장소 루트의 대표 사람이 읽는 요약 문서
- `rule/`: 기준 Codex 실행 규칙. 탐색 시작점은 [`rule/index.md`](../index.md)다.
- `docs/guide/`: 사람이 실제로 따라야 하는 사용자 가이드. 기본 진입점은 [`docs/guide/README.md`](../../docs/guide/README.md)다.
- `docs/implementation/`: 사람이 읽는 최종 브리핑과 결과 문서. 제어 파일은 [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md)다.
- `subagents_docs/`: planner, generator, evaluator 작업 문서. 기본 진입점은 [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md)다.

## 기본 제어 파일

- `rule/` -> [`rule/index.md`](../index.md), `rules/`
- `docs/guide/` -> [`docs/guide/README.md`](../../docs/guide/README.md)
- `docs/implementation/` -> [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md)
- `subagents_docs/` -> [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md)

이 제어 파일 이름은 언어 모드와 무관하게 유지한다.

## 참조 링크 기준

- 사람이 먼저 읽는 진입 문서와 제어 문서 참조는 가능한 한 Markdown 링크로 둔다.
- 대표 대상에는 root/local [`AGENTS.md`](../../AGENTS.md), [`README.md`](../../README.md), [`rule/index.md`](../index.md), [`docs/guide/README.md`](../../docs/guide/README.md), [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md), [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md)가 포함된다.
- 디렉토리 자체를 설명할 때도 실제 진입 제어 파일이 있으면 그 파일을 함께 링크해 navigation entrypoint를 분명히 한다.
- 아직 생성하지 않는 기본값이나 placeholder 경로는 링크로 만들지 않는다.

## 디렉토리 기본값

- `README.md`로 충분한 경우 `docs/guide/AGENTS.md`는 기본적으로 만들지 않는다.
- Codex가 최종 브리핑을 일관되게 배치하고 유지할 수 있도록 [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md)는 기본적으로 만든다.
- Codex가 작업 문서를 일관되게 배치하고 유지할 수 있도록 [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md)는 기본적으로 만든다.
- `docs/guide/`, `docs/implementation/`, `subagents_docs/`를 기준 규칙 권한으로 취급하지 않는다.
- 기존 top-level `docs/` 트리가 이미 프로젝트 의미를 가지고 있으면 먼저 살펴보고, 그 의미를 다시 해석하기 전에 확인한다.
- 기존 top-level `rule/` 트리가 이미 프로젝트 의미를 가지고 있으면 먼저 살펴보고, 그 구조를 다시 해석하거나 덮어쓰기 전에 확인한다.

## 문서화 자동화

- 저장소를 설명하는 오래 유지되는 사실이나 프로젝트 구조가 더 분명해지면 root `README.md`를 생성하거나 수정한다.
- 실행, 배포, 테스트 실행, 디자인 요청처럼 실제 사용자 워크플로가 분명해지면 guide 문서를 추가하거나 수정한다.
- 관찰된 구조, 테스트 디렉토리, 툴링 목록, 구현 메모만으로는 guide 문서를 만들지 않는다.
- 작업 문서는 `subagents_docs/`에 두고, 최종 브리핑은 `docs/implementation/`에 둔다.
- 최종 브리핑은 항상 완료된 plan-cycle 결과와 함께 동기화하고, 카테고리 안의 번호 순서를 유지한다.
- 명시 규칙이 추가되거나 바뀌면 [`rule/rules/rule-maintenance.md`](rule-maintenance.md)를 따라 관련 `rule/rules/` 문서와 [`rule/index.md`](../index.md)를 함께 갱신한다.

## 언어 메모

사람이 읽는 문서와 `subagents_docs/` 작업 문서에 적용되는 exact 언어 규칙과 filename/path 불변 조건은 [`rule/rules/language-policy.md`](language-policy.md)를 따른다.
