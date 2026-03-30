# Subagents Docs 규칙

## 목적

`subagents_docs/`를 planner, generator, evaluator가 실제로 읽고 쓰는 작업 문서 영역으로 정의한다.

## 범위

- `subagents_docs/`는 subagent working area다.
- `docs/guide/`와 `docs/implementation/`는 사람이 읽는 문서 영역이다.
- subagent 작업 기록은 `subagents_docs/`에만 둔다.
- `subagents_docs/` 문서는 사용자가 지정한 현재 실행 언어에 따라 작성한다.

## 디렉토리 역할

- `subagents_docs/plans/`: planner가 쓰는 계획 문서
- `subagents_docs/changes/`: generator가 쓰는 구현 기록
- `subagents_docs/evaluations/`: evaluator가 쓰는 평가 기록

## 순환 규칙

- 각 계획은 `planner -> generator -> evaluator` 순서로 실행한다.
- evaluator는 generator가 만든 구현 결과를 해당 plan과 acceptance criteria 기준으로 평가한다.
- evaluator가 구현 결과에서 부족한 점이나 blocker를 확인했을 때만 같은 계획을 다시 계획, 구현, 평가한다.
- 여러 계획이 독립이면 병렬로 돌릴 수 있지만, 의존성이 있으면 순차로 처리한다.
- 각 계획은 모든 하위 평가가 통과할 때까지 planner -> generator -> evaluator 반복으로만 완결된다.

## 문서 경계

- `subagents_docs/`에는 작업용 문서만 둔다.
- 사용자-facing 최종 브리핑은 evaluator pass 이후 `docs/implementation/`에 요약본으로 남긴다.
- 역할별 소유 문서를 섞어 쓰지 않는다.
- 메인 에이전트는 이 문서 흐름을 조정하는 orchestration-only 역할이며, planner/generator/evaluator 산출물을 직접 대신 작성하지 않는다.
- coordinator는 subagent 응답이 느리다는 이유로 직접 구현하지 않는다.
- coordinator는 subagent 응답 지연이 있어도 직접 구현으로 대체할 수 없고, 대기 또는 재계획만 수행한다.
