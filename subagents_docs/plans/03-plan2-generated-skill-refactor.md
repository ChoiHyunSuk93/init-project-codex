# Plan 2: Generated Skill Refactor

## 목표

`hschoi-init-project`가 생성하는 저장소도 현재 저장소와 같은 subagent 하네스 구조를 따르도록 만든다.
생성된 저장소에서는 `planner -> generator -> evaluator` 사이클이 반복 가능해야 하고, 각 plan은 pass될 때까지 재계획과 재구현, 재평가를 반복한다.

## 생성 구조

- `subagents_docs/`를 planner, generator, evaluator의 작업 문서 영역으로 생성한다.
- `docs/guide/`와 `docs/implementation/`은 사용자-facing 문서로만 생성한다.
- `docs/implementation/`은 사이클 완료 후 최종 구현 브리핑만 담는다.
- 기존 init-project의 기본 구조인 `README.md`, `AGENTS.md`, `rule/`, `docs/guide/`, `docs/implementation/`은 유지한다.
- 언어 우선 선택 흐름과 기존 fresh/existing repository 지원도 유지한다.

## 사이클 규칙

- 각 plan은 `planner -> generator -> evaluator` 순서로 실행한다.
- 평가에서 부족한 점이 나오면 같은 plan 안에서 planner가 재계획하고, generator가 재구현하고, evaluator가 재평가한다.
- 이 반복은 plan이 pass될 때까지 계속한다.

## 다중 계획 규칙

- 여러 계획이 필요하면 계획별로 분리해서 관리한다.
- 서로 독립적인 계획은 병렬로 진행할 수 있다.
- 영향도가 있거나 결과 의존성이 있는 계획은 순차적으로 진행한다.

## 사용자 문서 경계

- `docs/guide/`는 사용자가 따라야 하는 안내 문서만 담는다.
- `docs/implementation/`은 사용자-facing 최종 브리핑만 담는다.
- planner, generator, evaluator의 작업 문서는 `subagents_docs/`에만 둔다.
- 작업 문서와 사용자-facing 문서를 같은 역할로 섞지 않는다.

## 인수 기준

- 생성된 저장소에서 subagents 작업 문서와 사용자-facing 문서의 경계가 명확하다.
- 각 plan은 재계획, 재구현, 재평가를 반복할 수 있다.
- 독립 계획은 병렬, 의존 계획은 순차로 처리하는 규칙이 문서와 생성 결과에 반영된다.
- 생성된 저장소는 기존 init-project의 base structure와 language-first behavior를 유지한다.
