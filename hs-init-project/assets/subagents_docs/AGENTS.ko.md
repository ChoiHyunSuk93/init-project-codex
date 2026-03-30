# Subagents Docs

이 디렉토리는 planner, generator, evaluator 역할이 함께 쓰는 작업 문서를 저장한다.

## 범위

- `subagents_docs/plans/`에는 planner 산출물을 둔다.
- `subagents_docs/changes/`에는 generator 변경 기록을 둔다.
- `subagents_docs/evaluations/`에는 evaluator 보고서를 둔다.
- 이 문서들은 사용자-facing `docs/guide/`와 `docs/implementation/`과 분리한다.
- 작업용 계획, 변경 노트, 평가 보고서는 `docs/implementation/`에 두지 않는다.
- 이 작업 문서들은 활성 run의 선택 언어로 작성한다.

## 사이클 규칙

- 각 plan은 planner -> generator -> evaluator 순서로 진행한다.
- 메인 에이전트는 orchestration-only 역할로 남아 이 세 역할의 순서와 handoff만 조정하며, 사용자가 명시적으로 허용하지 않는 한 planner/generator/evaluator를 직접 겸하지 않는다.
- evaluator는 generator가 만든 구현 결과를 plan과 acceptance criteria에 대조해 평가한다.
- evaluator가 구현 결과에서 부족한 점이나 blocker를 확인했을 때만 같은 plan을 pass될 때까지 다시 순환한다.
- 독립적인 plan은 병렬로 진행할 수 있다. 의존적인 plan은 순서대로 진행한다.
- 여러 plan이 필요하면 서로 독립한 것끼리만 병렬로 두고, 그렇지 않으면 별도 cycle로 분리한다.
- subagent 응답이 느리더라도 coordinator는 직접 구현하지 않고 기다리거나 재계획한다.

## 소유권

- Planner는 planning 문서를 소유한다.
- Generator는 change record를 소유한다.
- Evaluator는 evaluation report를 소유한다.
- 사용자가 명시적으로 예외를 요청하지 않는 한 한 파일에 역할 책임을 섞지 않는다.
