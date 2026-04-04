# Subagents Docs 규칙

## 목적

`subagents_docs/`를 planner, generator, evaluator가 실제로 읽고 쓰는 작업 문서 영역으로 정의한다.

## 범위

- `subagents_docs/`는 subagent working area다.
- `docs/guide/`와 `docs/implementation/`는 사람이 읽는 문서 영역이다.
- subagent 작업 기록은 `subagents_docs/`에만 둔다.
- 분석, 질문, 리뷰, 설명 전용 요청은 implementation cycle을 열지 않고 `subagents_docs/` working record를 만들지 않는다.
- `subagents_docs/` 문서 언어와 path 표기 규칙은 `rule/rules/language-policy.md`를 따른다.
- cycle 문서 경로, header, section provenance는 `rule/rules/cycle-document-contract.md`를 따른다.

## 디렉토리 역할

- `subagents_docs/cycles/`: planner, generator, evaluator가 함께 참조하는 plan별 단일 working document

## 문서 계약

- exact cycle document contract는 `rule/rules/cycle-document-contract.md`를 기준으로 한다.
- `subagents_docs/`의 active working record는 `subagents_docs/cycles/` 아래에만 둔다.

### 역할별 소유권

- planner는 planner section만 소유한다.
- generator는 generator section만 소유한다.
- evaluator는 evaluator section만 소유한다.
- section별 필수 provenance와 상태 전이는 `rule/rules/cycle-document-contract.md`를 따른다.

## 순환 규칙

- 각 계획은 `planner -> generator -> evaluator` 순서로 실행한다.
- evaluator는 generator가 만든 구현 결과를 해당 plan과 acceptance criteria 기준으로 실제 사용자 수준 테스트를 포함한 strongest feasible 검증으로 평가한다.
- evaluator가 구현 결과에서 부족한 점이나 blocker를 확인했을 때만 같은 계획을 다시 계획, 구현, 평가하고, `FAIL`이면 외부 입력이 정말 필요한 경우가 아니면 질문 없이 다음 cycle을 시작한다.
- 여러 계획이 독립이면 병렬로 돌릴 수 있지만, 의존성이 있으면 순차로 처리한다.
- 각 계획은 모든 하위 평가가 통과할 때까지 planner -> generator -> evaluator 반복으로만 완결된다.

## 문서 경계

- `subagents_docs/`에는 작업용 문서만 둔다.
- 신규 working record는 `subagents_docs/cycles/`에 쓴다.
- 사용자-facing 최종 브리핑은 evaluator pass 이후 `docs/implementation/`에 요약본으로 남긴다.
- plan-only 상태나 generator-only 상태를 근거로 `docs/implementation/` 최종 브리핑을 만들지 않는다.
- 역할별 소유 문서를 섞어 쓰지 않는다.
- 메인 에이전트는 이 문서 흐름을 조정하는 orchestration-only 역할이며, planner/generator/evaluator 산출물을 직접 대신 작성하지 않는다.
- coordinator는 subagent 응답이 느리다는 이유로 직접 구현하지 않는다.
- coordinator는 subagent 응답 지연이 있어도 직접 구현으로 대체할 수 없고, 대기 또는 재계획만 수행한다.
- coordinator는 completed/unused subagent thread를 정리하고, cleanup 없이 thread를 방치하지 않는다.
