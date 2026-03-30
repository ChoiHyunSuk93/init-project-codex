# 서브에이전트 오케스트레이션 규칙

## 목적

planner / generator / evaluator 역할 분리를 애드혹하지 않는 방식으로 유지한다.

`subagents_docs/`는 실제 작업 문서 영역이다.
이 작업 문서는 활성 run의 선택 언어를 따른다.
`docs/guide/`와 `docs/implementation/`은 사용자-facing 문서이다.
`docs/implementation/`에는 관심사 기반 카테고리 안에 plan이 통과된 최종 브리핑만 둔다.
메인 에이전트는 오케스트레이션만 담당하며, 사용자가 역할 분리를 명시적으로 완화하지 않는 한 planner/generator/evaluator를 직접 겸하지 않는다.

## 역할 경계

### planner

- 무엇을 만들지 정의하고 `subagents_docs/plans/`에 계획서를 작성한다.
- 범위, acceptance criteria, 제약 조건, 미해결 질문을 명시한다.
- 제품 구현 파일, 스크립트, 템플릿, 평가 산출물을 수정하지 않는다.

### generator

- 승인된 계획을 구현하고 `subagents_docs/changes/`에 구현 기록을 남긴다.
- 필요 시 단위 수준 점검을 함께 정리한다.
- 계획 의도 변경이나 평가 결과를 임의로 덮어쓰지 않는다.

### evaluator

- generator가 만든 구현 결과를 plan과 acceptance criteria에 대조해 end-to-end로 점검하고 `subagents_docs/evaluations/`에 판정한다.
- 기능, 구조, 실행 규칙 준수도를 함께 점검한다.
- 구현 파일이나 계획 산출물을 수정하지 않는다.

## 오케스트레이션 사이클

1. planner가 plan을 작성/갱신한다.
2. generator가 plan을 실행해 구현한다.
3. evaluator가 구현 결과 점검 결과를 남긴다.
4. evaluator가 구현 결과에서 실패나 blocker를 확인했을 때만 planner가 원인을 반영해 재계획하고 generator/evaluator가 다시 반복한다.
5. plan이 pass될 때까지 순환한다.

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

- 역할별 산출물은 각 영역에만 둔다.
- `docs/implementation/`에 planning/implementation/evaluation 기록을 넣지 않는다.
- subagent 응답이 느리더라도 coordinator는 직접 구현하지 않고 기다리거나 재계획한다.
- 메인 에이전트가 기본값으로 planner/generator/evaluator 소유권을 직접 흡수하지 않는다.
- 계획 범위가 불명확하면 generator가 임의 추측으로 진행하지 말고 planner 재계획을 요구한다.
- 구현이 나오기 전 plan 단독 상태를 cycle pass/fail 평가로 간주하지 않는다.
