# Plan 2 Replan 2: Generated Skill Refactor

## 목표

Plan 2의 deterministic generation이 fresh English/Korean repository 생성까지 끝까지 통과하도록 다시 계획한다.
이번 재계획은 생성 스크립트가 실제로 존재하는 템플릿만 참조하게 만들고, generated repository가 `subagents_docs/` working-doc 모델과 user-facing 문서 경계를 끝까지 materialize할 수 있게 만드는 데 집중한다.

## 재계획 배경

- 이전 Plan 2 재평가가 `fail`이었다.
- 이전 blocker였던 `assets/rule/subagent-orchestration.*.md` 누락은 해결됐다.
- 남은 blocker는 `assets/.codex/agents/*.toml`와 `assets/docs/guide/subagent-workflow.*.md` 템플릿 누락이다.
- 이 누락이 해결되지 않으면 fresh repo 생성이 계속 실패하므로 Plan 2는 pass가 될 수 없다.

## 요구사항 수정

- 생성 스크립트는 실제 존재하는 `assets/.codex/agents/*.toml` 템플릿만 복사해야 한다.
- 생성 스크립트는 실제 존재하는 `assets/docs/guide/subagent-workflow.*.md` 템플릿만 복사해야 한다.
- generated repository는 `subagents_docs/`를 planner, generator, evaluator의 작업 문서 영역으로 materialize해야 한다.
- `docs/guide/`와 `docs/implementation/`은 user-facing 문서로만 생성해야 한다.
- `docs/implementation/`은 cycle 통과 후 최종 브리핑만 담는 구조로 유지해야 한다.
- `planner -> generator -> evaluator` 사이클은 plan이 pass될 때까지 반복 가능해야 한다.
- 여러 plan이 필요하면 독립 plan은 병렬, 의존 plan은 순차로 처리해야 한다.

## 다음 사이클 검증 조건

1. English fresh repository 생성이 끝까지 성공해야 한다.
2. Korean fresh repository 생성이 끝까지 성공해야 한다.
3. 두 경우 모두 generated repository에 `subagents_docs/` working-doc 영역이 생겨야 한다.
4. 두 경우 모두 `docs/guide/`와 `docs/implementation/`은 user-facing 문서로만 생성되어야 한다.
5. deterministic generation이 누락 템플릿 때문에 실패하지 않아야 한다.
6. evaluator는 파일 존재와 경계 정합성뿐 아니라 생성 결과 전체를 pass로 판정할 수 있어야 한다.

## 범위

- 이 문서는 requirements and workflow 조정용이다.
- 구현 diff, 파일 이동 세부, 코드 수정 지시는 여기서 적지 않는다.
- 다음 generator와 evaluator 사이클의 성공 조건만 고정한다.
