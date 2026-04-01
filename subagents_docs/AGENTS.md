# Subagents Docs

이 디렉토리는 planner, generator, evaluator 역할이 쓰는 작업 문서를 저장한다.

## 범위

- `subagents_docs/cycles/`는 각 plan의 활성 단일 working document를 둔다.
- 이 문서들은 사용자-facing `docs/guide/`, `docs/implementation/`과 분리해서 유지한다.
- 현재 run에서 선택된 언어로 문서를 작성하되, 기술적인 path literal, identifier, filename은 영어를 유지한다.
- summary, plan, change, evaluation을 포함한 `subagents_docs/` 문서는 모두 현재 실행 언어를 따른다.
- 역할 경계와 cycle 순서는 `rule/rules/subagent-orchestration.md`를 따른다.
- exact cycle 문서 형식, header, provenance, dirty-worktree 평가는 `rule/rules/cycle-document-contract.md`를 따른다.
- 문서 언어와 안정적인 filename/path 규칙은 `rule/rules/language-policy.md`를 따른다.

## cycle 규칙

- 각 plan은 `planner -> generator -> evaluator` 순서로 진행한다.
- 메인 에이전트는 orchestration-only 역할만 맡고 planner, generator, evaluator를 직접 대행하지 않는다. 실제 작업은 각 subagent 산출물에 위임한다.
- 분석, 질문, 리뷰, 설명 요청은 명시적 구현 지시가 없으면 implementation cycle로 열지 않는다.
- 평가가 실패하면 같은 plan은 pass될 때까지 다시 순환한다.
- 독립적인 plan은 병렬로 진행할 수 있고, 의존적인 plan은 순서를 지킨다.
- 각 plan은 필요한 pass 조건이 모두 충족될 때만 완료된다.

## 문서 계약

- 각 plan은 `subagents_docs/cycles/` 아래 append-only cycle 문서 하나로 관리한다.
- 상단 상태 블록은 coordinator가 관리하고, 각 역할은 자기 섹션만 append한다.
- planner/generator/evaluator section의 exact 필수 항목은 `rule/rules/cycle-document-contract.md`를 따른다.
- `docs/implementation/`을 cycle working record 대체물로 사용하지 않는다.

## 소유권

- planner는 planner 섹션만 소유한다.
- generator는 generator 섹션만 소유한다.
- evaluator는 evaluator 섹션만 소유한다.
- planner/generator/evaluator 섹션의 exact required contents는 `rule/rules/cycle-document-contract.md`를 따른다.
- 같은 cycle 문서 안에서도 다른 역할의 섹션을 덮어쓰면 안 된다.
- subagent 응답이 느려도 coordinator는 직접 구현하지 않고 대기하거나 재계획한다.
- coordinator는 completed/unused subagent thread를 정리하고 thread limit blockage를 cleanup 작업으로 처리한다.
