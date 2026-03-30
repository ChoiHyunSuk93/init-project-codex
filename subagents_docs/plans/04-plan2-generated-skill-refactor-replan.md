# Plan 2 Replan: Generated Skill Refactor

## 목표

Plan 2의 생성 구조를 실제 deterministic generation까지 통과하도록 다시 계획한다.
이번 재계획은 `hschoi-init-project`가 생성하는 저장소가 `subagents_docs/` 기반 작업 문서 모델과 user-facing 문서 경계를 끝까지 materialize할 수 있게 만드는 데 집중한다.

## 재계획 배경

- 이전 Plan 2 평가가 `fail`이었다.
- 핵심 원인은 deterministic generation 중 누락된 rule template를 복사하려다 생성이 즉시 실패한 점이다.
- 문서와 설명은 방향이 맞았지만, fresh repository 생성이 실제로 끝까지 성공하지 못했기 때문에 아직 pass로 볼 수 없다.

## 요구사항 수정

- 생성 스크립트와 템플릿 세트는 실제로 존재하는 파일만 참조해야 한다.
- generated repository는 `subagents_docs/`를 planner / generator / evaluator 작업 문서 영역으로 materialize해야 한다.
- `docs/guide/`와 `docs/implementation/`은 user-facing 문서로만 생성해야 한다.
- `docs/implementation/`은 cycle 통과 후 최종 브리핑만 담는 구조로 유지해야 한다.
- `planner -> generator -> evaluator` 사이클은 plan이 pass될 때까지 반복 가능해야 한다.
- 여러 plan이 필요하면 독립 plan은 병렬, 의존 plan은 순차로 처리해야 한다.

## 다음 사이클 검증 조건

1. English fresh repository 생성이 끝까지 성공해야 한다.
2. Korean fresh repository 생성이 끝까지 성공해야 한다.
3. 두 경우 모두 generated repository에 `subagents_docs/` working-doc 영역이 생겨야 한다.
4. 두 경우 모두 `docs/guide/`와 `docs/implementation/`은 user-facing 문서로만 생성되어야 한다.
5. deterministic generation이 템플릿 누락으로 실패하지 않아야 한다.
6. evaluator는 파일 존재와 경계 정합성뿐 아니라 생성 결과 전체를 pass로 판정할 수 있어야 한다.

## 범위

- 이 문서는 requirements and workflow 조정용이다.
- 구현 diff, 파일 이동 세부, 코드 수정 지시는 적지 않는다.
- 다음 generator와 evaluator 사이클의 성공 조건만 고정한다.
