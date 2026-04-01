# 서브에이전트 워크플로

이 저장소는 planner, generator, evaluator를 분리해서 사용하는 기본 하네스를 가진다.
상세 실행 규칙은 `rule/rules/subagent-orchestration.md`가 기준이며, 이 문서는 사람이 따라야 할 흐름을 설명한다.
메인 에이전트는 이 세 역할을 직접 겸하지 않고, 순서 유지와 handoff 정리만 담당하는 orchestration-only 역할이다.
구현, 변경, materialize를 사용자가 명시적으로 요청하지 않았다면 이 흐름을 구현 사이클로 시작하지 않는다.
exact cycle 문서 형식, header, provenance, dirty-worktree 평가는 `rule/rules/cycle-document-contract.md`를 따른다.
문서 언어와 안정적인 filename/path 규칙은 `rule/rules/language-policy.md`를 따른다.

## 역할

- planner: 무엇을 만들지 정의하고 cycle 문서에 planner 섹션을 append한다. exact section requirements는 `rule/rules/cycle-document-contract.md`를 따른다.
- generator: 같은 cycle 문서의 planner 섹션을 바탕으로 구현하고 generator 섹션을 append한다. exact section requirements는 `rule/rules/cycle-document-contract.md`를 따른다.
- evaluator: generator가 만든 구현 결과를 같은 cycle 문서 안에서 plan과 acceptance criteria 기준으로 end-to-end 점검하고 evaluator 섹션을 append한다. exact PASS/FAIL, provenance, dirty-worktree 기준은 `rule/rules/cycle-document-contract.md`를 따른다.

## cycle 문서

- 신규 작업 문서는 기본적으로 `subagents_docs/cycles/<NN>-<slug>.md` 한 파일로 관리한다.
- 상단 상태 블록은 coordinator가 관리하고, 본문은 append-only로 유지한다.
- 섹션 이름은 `Planner v1`, `Generator v1`, `Evaluator v1`, `Planner v2`처럼 역할과 버전을 함께 쓴다.
- 각 역할은 자기 섹션만 수정하고 다른 역할 섹션은 참조만 한다.

## 실행 순서

1. planner가 cycle 문서를 만들거나 기존 cycle 문서에 planner 섹션을 추가한다.
2. generator가 같은 cycle 문서의 최신 planner 섹션을 읽고 `hs-init-project/`와 관련 문서를 수정한 뒤 generator 섹션을 추가한다.
3. evaluator가 같은 cycle 문서에서 planner/generator 섹션을 참조하며 평가 섹션을 추가한다.
4. evaluator가 구현 결과에서 실패나 blocker를 확인했을 때만 planner가 같은 plan을 재계획한다.
5. 같은 plan은 evaluator가 구현 결과를 pass로 판정할 때까지 `planner -> generator -> evaluator` 순서로 반복한다.
6. coordinator는 오래 기다릴 수 있지만, 결과를 반영한 completed/unused subagent thread는 정리한다.

## 문서 연결

- 신규 cycle working document는 `subagents_docs/cycles/` 아래에 둔다.
- planner, generator, evaluator는 같은 cycle 문서 안의 최신 섹션을 서로 참조한다.
- coordinator는 handoff가 바뀔 때 문서 상단의 상태 블록을 갱신한다. exact 상태 전이는 `rule/rules/cycle-document-contract.md`를 따른다.
- 평가 보고서에는 design quality, originality, completeness, functionality 평가가 들어가야 한다.
- overall 판단에서는 design quality와 originality를 더 높게 반영한다.
- `docs/implementation/`에는 evaluator pass 이후의 최종 브리핑만 둔다. plan-only 또는 generator-only 상태로는 최종 브리핑을 발행하지 않는다.

## 현재 저장소 적용 원칙

- skill 구조 변경, generation flow 변경, template 변경처럼 의미 있는 작업은 세 역할을 모두 거친다.
- 분석, 질문, 설명, 리뷰 요청은 구현 지시가 명시되지 않았다면 generator 실행이나 파일 수정으로 넘어가지 않는다.
- 메인 에이전트는 planner/generator/evaluator를 직접 대행하지 않고, 각 subagent 결과를 모으고 다음 순서를 조정한다.
- planner가 정한 범위를 generator가 임의로 바꾸지 않는다.
- evaluator는 구현을 고치지 않고 구현 결과와 문제를 기록한다.
