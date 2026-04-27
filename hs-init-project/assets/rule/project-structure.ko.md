# 프로젝트 구조 규칙

## 목적

이 저장소의 최상위 디렉토리 모델을 정의하고, 각 주요 영역의 역할을 분명하게 한다.

## 최상위 영역

- [`AGENTS.md`](../../AGENTS.md): 저장소 전역 orchestration 지침
- [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md): 프로젝트 전체 요구사항과 핵심 흐름의 기준 문서
- `.codex/`: 프로젝트 스코프 Codex 설정, planner/generator/evaluator 정의, starter local skill 세트
- `rule/`: authoritative Codex 실행 규칙. 탐색 시작점은 [`rule/index.md`](../index.md)다.
- `subagents_docs/`: planner, generator, evaluator 작업 문서. 기본 진입점은 [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md)이고 phase 로드맵은 [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md)다.
- `docs/guide/`: 사람이 읽는 사용자 가이드 문서. 기본 진입점은 [`docs/guide/README.md`](../../docs/guide/README.md)다.
- `docs/implementation/`: 사람이 읽는 구현 기록 문서. 제어 파일은 [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md)다.

## Source Root 영역

프로젝트 루트 아래에서 구현체를 모으는 단일 source root 디렉토리를 여기에 적는다.

예시 placeholder:

- `[source-root-directory]`

## Non-Runtime 영역

non-runtime으로 취급하는 디렉토리를 여기에 적는다.

예시 placeholder:

- `.codex/`
- `rule/`
- `subagents_docs/`
- `docs/`
- `[non-runtime-directory]`

## 변경 규칙

- source root와 non-runtime 경계는 명시적으로 유지한다.
- 프로젝트 루트 바로 아래에 여러 runtime 디렉토리를 흩뿌리지 말고, 구현체는 단일 source root 아래에 둔다.
- 실제 디렉토리 구조가 확정되면 placeholder 항목을 관찰된 경로로 교체한다.
- 최상위 구조가 바뀌면 [`rule/rules/project-structure.md`](project-structure.md)에 그 구조를 실제 값으로 반영한다.
- 요구사항 흐름이나 phase 구조가 바뀌면 [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md)와 [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md)도 함께 갱신한다.
- 확립된 최상위 영역을 이동하거나 이름 변경할 때는 [`rule/index.md`](../index.md)와 관련 `rule/rules/*.md` 문서도 함께 갱신한다.
- local 구조가 복잡해지면 scope를 분명하게 해주는 곳에만 local instruction 파일을 추가한다.
