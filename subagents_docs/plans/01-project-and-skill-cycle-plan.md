# 프로젝트 및 스킬 사이클 계획

## 목표

이 저장소 자체와 `hschoi-init-project` 스킬을 모두, planner -> generator -> evaluator의 반복 사이클이 안정적으로 돌아가는 구조로 개편한다.
`docs/guide/`와 `docs/implementation/`은 사용자에게 보이는 문서로 유지하고, subagents가 읽고 쓰는 문서는 `subagents_docs/`로 분리한다.

## 계획 분리

- Plan 1: 이 저장소 자체를 먼저 개편해 subagents가 `subagents_docs/`를 사용하고, `docs/guide/`와 `docs/implementation/`은 사용자-facing 문서로만 남기도록 만든다.
- Plan 2: 그 다음 `hschoi-init-project`를 개편해 생성되는 저장소도 같은 문서 모델과 사이클 모델을 따르도록 만든다.
- Plan 2는 Plan 1의 결과를 전제로 하므로 기본적으로 순차 처리한다.

## 병렬/순차 규칙

- 서로 독립인 하위 계획이 확인되면 병렬로 진행할 수 있다.
- Plan 1과 Plan 2처럼 구조 의존성이 있는 계획은 순서대로 진행한다.
- 영향도가 있는 변경은 앞선 계획의 결과를 확인한 뒤 다음 계획으로 넘긴다.

## 사이클 규칙

- 각 계획은 `planner -> generator -> evaluator` 순서로 실행한다.
- 평가에서 부족한 점이 나오면 planner가 계획을 다시 세우고, generator가 다시 구현하고, evaluator가 다시 평가한다.
- 이 사이클은 계획이 전부 통과할 때까지 반복한다.
- 작업 지연을 이유로 coordinator가 직접 구현하지 않는다. 반드시 subagents에게 위임하고 결과를 기다린다.

## 문서 경계

- `subagents_docs/`는 planner, generator, evaluator가 읽고 쓰는 작업 문서 영역이다.
- `docs/guide/`와 `docs/implementation/`은 사용자와 리뷰어가 읽는 문서 영역이다.
- cycle이 끝난 뒤에는 최종 구현 브리핑을 사용자-facing `docs/implementation/` 문서로 요약한다.
- 역할별 책임과 문서 소유권을 섞지 않는다.

## 인수 기준

- Plan 1과 Plan 2가 각각 독립된 사이클로 식별된다.
- planner, generator, evaluator의 책임이 문서와 실행 흐름에서 분명히 분리된다.
- 재계획, 재구현, 재평가가 가능한 반복 구조가 문서로 정의된다.
- subagents 문서와 사용자-facing 문서의 경계가 명확하다.
- coordinator는 직접 구현하지 않고, 모든 실작업이 subagents 위임으로만 진행된다.
