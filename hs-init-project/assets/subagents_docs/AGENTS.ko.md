# Subagents Docs

이 디렉토리는 planner, generator, evaluator 역할이 함께 쓰는 작업 문서를 저장한다.

## 범위

- `subagents_docs/cycles/`에는 plan별 단일 working document를 둔다.
- 이 문서들은 사용자-facing `docs/guide/`와 `docs/implementation/`과 분리한다.
- 작업용 계획, 변경 노트, 평가 보고서는 `docs/implementation/`에 두지 않는다.
- 이 작업 문서들은 활성 run의 선택 언어로 작성한다.
- 역할 경계와 cycle 순서는 `rule/rules/subagent-orchestration.md`를 따른다.
- exact cycle 문서 형식, header, provenance, dirty-worktree 평가는 `rule/rules/cycle-document-contract.md`를 따른다.
- 문서 언어와 안정적인 filename/path 규칙은 `rule/rules/language-policy.md`를 따른다.

## 사이클 규칙

- 각 plan은 planner -> generator -> evaluator 순서로 진행한다.
- 메인 에이전트는 orchestration-only 역할로 남아 이 세 역할의 순서와 handoff만 조정하며, 사용자가 명시적으로 허용하지 않는 한 planner/generator/evaluator를 직접 겸하지 않는다.
- 분석, 질문, 리뷰, 설명 요청은 명시적 구현 지시가 없으면 implementation cycle로 열지 않는다.
- evaluator는 generator가 만든 구현 결과를 plan과 acceptance criteria에 대조해 대표 사용자 surface 직접 검증을 포함한 strongest feasible 검증으로 평가한다.
- evaluator가 구현 결과에서 부족한 점이나 blocker를 확인했을 때만 같은 plan을 pass될 때까지 다시 순환하고, `FAIL`이면 외부 입력이 정말 필요한 경우가 아니면 질문 없이 다음 cycle을 시작한다.
- 독립적인 plan은 병렬로 진행할 수 있다. 의존적인 plan은 순서대로 진행한다.
- 여러 plan이 필요하면 서로 독립한 것끼리만 병렬로 두고, 그렇지 않으면 별도 cycle로 분리한다.
- subagent 응답이 느리더라도 coordinator는 직접 구현하지 않고 기다리거나 재계획한다.
- completed/unused subagent thread는 coordinator가 결과 반영 직후 즉시 닫는다.

## 문서 계약

- 각 plan은 `subagents_docs/cycles/` 아래 append-only cycle 문서 하나로 관리한다.
- 상단 상태 블록은 coordinator가 관리하고, 각 역할은 자기 섹션만 append한다.
- planner/generator/evaluator section의 exact 필수 항목은 `rule/rules/cycle-document-contract.md`를 따른다.
- `docs/implementation/`을 plan, change, evaluation working record의 대체물로 사용하지 않는다.

## 소유권

- Planner는 planner 섹션만 소유한다.
- Generator는 generator 섹션만 소유한다.
- Evaluator는 evaluator 섹션만 소유한다.
- planner/generator/evaluator 섹션의 exact required contents는 `rule/rules/cycle-document-contract.md`를 따른다.
- 같은 문서 안에서도 다른 역할 섹션을 덮어쓰지 않는다.
