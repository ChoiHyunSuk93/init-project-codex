# 서브에이전트 오케스트레이션 규칙

## 목적

planner / generator / evaluator 역할 분리를 애드혹하지 않는 방식으로 유지한다.

`subagents_docs/`는 실제 작업 문서 영역이다.
이 작업 문서의 exact 언어 규칙은 `rule/rules/language-policy.md`를 따른다.
`docs/guide/`와 `docs/implementation/`은 사용자-facing 문서이다.
`docs/implementation/`에는 관심사 기반 카테고리 안에 plan이 통과된 최종 브리핑만 둔다.
메인 에이전트는 오케스트레이션만 담당하며, 사용자가 역할 분리를 명시적으로 완화하지 않는 한 planner/generator/evaluator를 직접 겸하지 않는다.
coordinator는 subagent 응답을 오래 기다릴 수 있지만, 반영이 끝난 completed/unused thread는 즉시 닫아야 한다.
stale session이나 thread limit으로 delegation이 막히면 cleanup을 먼저 수행한다.

## Intent Gate

- 분석, 질문, 리뷰, 설명 요청은 구현 사이클로 시작하지 않는다.
- planner -> generator -> evaluator는 사용자가 명시적으로 구현, 변경, 생성, 수정, materialize를 요청했을 때만 시작한다.
- 구현 의도가 모호하면 추측으로 진행하지 말고 분석으로 멈추거나 clarification을 요청한다.

## cycle 문서 모델

exact cycle 문서 경로, header 상태 전이, append-only section, provenance, dirty-worktree 평가는 `rule/rules/cycle-document-contract.md`를 authoritative 기준으로 사용한다.

- 신규 cycle은 `subagents_docs/cycles/<NN>-<slug>.md` 아래 plan별 단일 working document를 사용한다.
- 역할 산출물은 같은 문서 안의 역할별 섹션으로 누적한다.

## 역할 경계

### planner

- 무엇을 만들지 정의하고 `subagents_docs/cycles/` 안의 planner 섹션을 append한다.
- exact section contents와 provenance는 `rule/rules/cycle-document-contract.md`를 따른다.
- 제품 구현 파일, 스크립트, 템플릿, 평가 산출물을 수정하지 않는다.

### generator

- 승인된 계획을 구현하고 `subagents_docs/cycles/` 안의 generator 섹션에 구현 기록을 남긴다.
- exact section contents와 verification-basis 요구는 `rule/rules/cycle-document-contract.md`를 따른다.
- 필요 시 단위 수준 점검을 함께 정리한다.
- evaluator가 pass를 내리기 전에는 `docs/implementation/` 최종 브리핑을 발행하지 않는다.
- 계획 의도 변경이나 평가 결과를 임의로 덮어쓰지 않는다.

### evaluator

- generator가 만든 구현 결과를 plan과 acceptance criteria에 대조해 대표 사용자 surface를 가능한 한 직접 실행하는 strongest feasible 검증으로 점검하고 `subagents_docs/cycles/` 안의 evaluator 섹션에 판정한다.
- 기능, 구조, 실행 규칙 준수도를 함께 점검한다.
- exact PASS/FAIL 기록, provenance, dirty-worktree 비교 기준은 `rule/rules/cycle-document-contract.md`를 따른다.
- 구현 파일이나 계획 산출물을 수정하지 않는다.

## 산출물 계약

- 같은 cycle은 한 문서로 유지하고, 파일 이름은 plan 번호 또는 slug와 맞춘다.
- exact section 요구와 coordinator-owned header 동작은 `rule/rules/cycle-document-contract.md`를 따른다.
- `docs/implementation/`은 사람을 위한 요약 계층이며 working record를 대체하지 않는다.

## 오케스트레이션 사이클

1. planner가 필요하면 cycle 문서를 만들고 최신 planner 섹션을 append한다.
2. generator가 최신 planner 섹션을 기준으로 구현한다.
3. evaluator가 구현 결과 점검 결과를 같은 문서에 append한다.
4. evaluator가 구현 결과에서 실패나 blocker를 확인했을 때만 planner가 원인을 반영해 재계획하고 generator/evaluator가 다시 반복한다.
5. evaluator가 `FAIL`을 기록하면 coordinator는 외부 입력이 정말 필요한 blocker가 아닌 한 사용자 질문 없이 다음 cycle을 다시 시작한다.
6. plan이 pass될 때까지 순환한다.

## 다중 계획 실행

- 여러 요구사항이 필요하면 `plan1`, `plan2`, `plan3`처럼 분리 관리한다.
- 서로 독립이면 병렬로 진행한다.
- 선행 plan의 결과가 후속 plan 입력에 영향을 주면 순차로 진행한다.

## 평가 기준

- 매 구현 결과를 다음 항목으로 평가한다.
  - design quality
  - originality
  - completeness
  - functionality
- `design quality`와 `originality`의 가중치를 `completeness`, `functionality`보다 높게 둔다.
- 실패 항목은 근거와 재현 조건을 명시한다.

## 가드레일

- 같은 문서를 공유하더라도 역할별 산출물은 각 역할 섹션에만 둔다.
- `docs/implementation/`에 planning/implementation/evaluation 기록을 넣지 않는다.
- subagent 응답이 느리더라도 coordinator는 직접 구현하지 않고 기다리거나 재계획한다.
- subagent 산출물을 반영하고 더 이상 필요 없는 thread는 coordinator가 즉시 닫는다.
- 대표 사용자 surface가 있으면 evaluator는 브라우저 화면, 앱 시뮬레이터/런타임, 게임 런타임/scene, CLI command, API request/response 같은 실제 진입점을 직접 검증하는 방식을 우선한다.
- 직접 surface 검증이 불가능하면 evaluator는 이유, 누락된 환경이나 접근 권한, 대체 검증 방식의 한계를 남기고 핵심 surface가 비검증 상태인 변경을 soft-pass하지 않는다.
- 메인 에이전트가 기본값으로 planner/generator/evaluator 소유권을 직접 흡수하지 않는다.
- 계획 범위가 불명확하면 generator가 임의 추측으로 진행하지 말고 planner 재계획을 요구한다.
- 구현이 나오기 전 plan 단독 상태를 cycle pass/fail 평가로 간주하지 않는다.
- plan-only 상태나 generator-only 상태를 근거로 `docs/implementation/` 최종 브리핑을 만들거나 갱신하지 않는다.
