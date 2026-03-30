# 서브에이전트 워크플로

이 저장소는 planner, generator, evaluator를 분리해서 사용하는 기본 하네스를 가진다.
상세 실행 규칙은 `rule/rules/subagent-orchestration.md`가 기준이며, 이 문서는 사람이 따라야 할 흐름을 설명한다.
메인 에이전트는 이 세 역할을 직접 겸하지 않고, 순서 유지와 handoff 정리만 담당하는 orchestration-only 역할이다.

## 역할

- planner: 무엇을 만들지 정의하고 planning 문서를 남긴다.
- generator: planning 문서를 바탕으로 구현하고 단위 수준 검증을 맞춘다.
- evaluator: generator가 만든 구현 결과를 plan과 acceptance criteria 기준으로 end-to-end 점검하고 평가 보고서를 남긴다.

## 실행 순서

1. planner가 `subagents_docs/plans/` 아래에 planning 문서를 만든다.
2. generator가 그 문서를 읽고 `hs-init-project/`와 관련 문서를 수정한다.
3. evaluator가 `subagents_docs/evaluations/` 아래에 plan과 acceptance criteria 기준 평가 문서를 만든다.
4. evaluator가 구현 결과에서 실패나 blocker를 확인했을 때만 planner가 같은 plan을 재계획한다.
5. 같은 plan은 evaluator가 구현 결과를 pass로 판정할 때까지 `planner -> generator -> evaluator` 순서로 반복한다.

## 문서 연결

- planner 문서는 `subagents_docs/plans/` 아래에 둔다.
- 구현 기록은 `subagents_docs/changes/` 아래에 둔다.
- planner, generator, evaluator 문서는 서로의 최신 문서를 참조한다.
- 평가 보고서에는 design quality, originality, completeness, functionality 평가가 들어가야 한다.
- overall 판단에서는 design quality와 originality를 더 높게 반영한다.
- `docs/implementation/`에는 evaluator pass 이후의 최종 브리핑만 둔다.

## 현재 저장소 적용 원칙

- skill 구조 변경, generation flow 변경, template 변경처럼 의미 있는 작업은 세 역할을 모두 거친다.
- 메인 에이전트는 planner/generator/evaluator를 직접 대행하지 않고, 각 subagent 결과를 모으고 다음 순서를 조정한다.
- planner가 정한 범위를 generator가 임의로 바꾸지 않는다.
- evaluator는 구현을 고치지 않고 구현 결과와 문제를 기록한다.
