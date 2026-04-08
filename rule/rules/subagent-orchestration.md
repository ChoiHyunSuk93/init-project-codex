# 서브에이전트 오케스트레이션 규칙

## 목적

이 저장소에서 메인 에이전트가 변경 크기와 모호성에 따라 하네스를 고르고, 필요한 subagent만 선택적으로 호출하는 기준을 정의한다.

`subagents_docs/`는 cycle-backed work의 working document 영역이다.
`docs/guide/`와 `docs/implementation/`은 사용자-facing 문서이며, 결과 브리핑을 제외한 에이전트 작업 문서를 넣지 않는다.
메인 에이전트(coordinator)는 분류, 계획 승인, 구현 통합, handoff 조정의 책임을 가진다.
coordinator는 필요할 때 planner, generator, evaluator, explorer 같은 subagent를 자율적으로 호출할 수 있다.
문서 분석이나 비교 독해가 필요한 경우에는 독립적인 질문 단위로 병렬 `explorer` 호출을 우선 고려한다.
evaluator는 어떤 경로를 선택하더라도 가능한 한 분리된 검증 역할로 유지한다.
coordinator는 완료되었거나 더 이상 필요 없는 subagent thread는 결과를 반영한 직후 반드시 닫는다.
stale session이나 thread limit 때문에 후속 subagent 실행이 막히면, coordinator는 thread cleanup을 우선 수행한다.
cycle 문서 형식, header 상태 전이, provenance 요구는 [`rule/rules/cycle-document-contract.md`](cycle-document-contract.md)를 기준으로 삼는다.
문서 본문 언어와 path 표기 규칙은 [`rule/rules/language-policy.md`](language-policy.md)를 기준으로 삼는다.

## Intent Gate

- 구현 경로는 사용자가 명시적으로 구현, 변경, 생성, 수정, materialize를 요청했을 때만 시작한다.
- 분석, 질문, 리뷰, 설명 요청은 구현 사이클로 넘기지 않고 analysis-only 상태로 유지한다.
- 구현 의도가 명확하지 않으면 coordinator는 clarification 또는 병렬 explorer 분석으로 멈추고 구현 subagent를 띄우지 않는다.

## 실행 모드

### small

- 변경 범위가 좁고 요구가 명확하면 `main/generator -> evaluator`로 처리한다.
- coordinator가 직접 구현하거나, 범위가 더 좁아지면 generator에 바로 구현을 맡길 수 있다.
- shared handoff가 필요 없으면 cycle 문서를 생략할 수 있다.
- evaluator는 가능한 한 분리된 검증 역할로 유지한다.

### medium

- 범위가 여러 파일이나 영역에 걸치지만 요구가 비교적 명확하면 `main(plan+implementation) -> evaluator`로 처리한다.
- coordinator가 짧은 plan을 정리하고 그대로 구현까지 수행한다.
- 중간 변경은 cycle 문서를 열고 `Planner vN`과 `Generator vN`를 같은 문서에 남긴 뒤 evaluator로 넘긴다.

### large-clear

- 큰 변경이지만 범위와 방향이 비교적 명확하면 `main-led decomposition + delegated implementation + evaluator`로 처리한다.
- coordinator가 상위 plan과 task split을 정하고, bounded implementation slice를 하나 이상의 implementation subagent에 분할 위임한다.
- coordinator가 결과를 통합하고 `Generator vN` 기준 산출물로 정리한 뒤 evaluator로 넘긴다.

### large-ambiguous

- 큰 변경이면서 모호하면 `parallel explorer analysis + planner assist if needed + main-approved plan + delegated implementation + evaluator`로 처리한다.
- coordinator가 병렬 explorer 분석으로 모호성을 줄이고, 필요하면 planner에게 plan 초안이나 대안을 받는다.
- 최종 계획 승인과 통합 책임은 coordinator가 가진다.
- 구현은 large-clear와 마찬가지로 bounded slice 단위로 위임하고, evaluator는 분리 유지한다.

## 역할 정의

### coordinator

- 관점: 통합 책임자
- 목적: 작업을 분류하고, 적절한 하네스를 고르고, 필요한 subagent를 선택적으로 호출하며, 최종 plan 승인과 구현 통합을 담당한다.
- 필수 동작:
  - small / medium / large-clear / large-ambiguous 분류
  - 병렬 explorer 분석 판단
  - cycle 문서 필요 여부 판단
  - delegated implementation slice 정의와 결과 통합
  - evaluator handoff 유지

### planner

- 관점: planning assist
- 목적: large-ambiguous 같은 경우에 coordinator가 승인할 plan 초안이나 대안을 제공한다.
- planner는 기본 강제 단계가 아니다.
- cycle 문서를 쓰는 경우 planner 산출물은 `Planner vN` 섹션으로 남긴다.

### generator

- 관점: implementation assist
- 목적: bounded implementation slice 또는 coordinator가 넘긴 명확한 구현 범위를 수행한다.
- cycle 문서를 쓰는 경우 generator 산출물은 `Generator vN` 섹션으로 남긴다.
- generator는 plan이 모호하면 추측으로 확장하지 말고 coordinator에 되돌린다.

### explorer

- 관점: read-only analyst
- 목적: 문서, 규칙, 구조, 영향 범위를 병렬로 읽어 ambiguity를 줄인다.
- explorer는 제품 파일이나 cycle header를 수정하지 않는다.
- 독립적인 질문이 둘 이상이면 explorer 병렬 호출을 우선 고려한다.

### evaluator

- 관점: 평가자
- 목적: 구현 결과를 plan과 acceptance criteria에 대조해 대표 사용자 surface를 가능한 한 직접 실행하는 strongest feasible 검증과 품질 평가를 남긴다.
- evaluator는 제품 코드 수정 없이 검증과 판정에 집중한다.
- design quality와 originality를 completeness와 functionality보다 더 무겁게 본다.

## 다중 계획 실행

- 여러 개의 대안 계획이 필요하면 각 계획마다 plan1, plan2, plan3 단위로 분리해 독립적으로 관리한다.
- 독립적인 계획은 병렬 순회가 가능하다.
- 영향도가 있는 계획은 앞선 계획의 pass 여부에 따라 순차적으로 처리한다.

## handoff 규칙

- coordinator는 cycle-backed work에서 자신이 승인한 planning basis를 명시해야 한다.
- small direct change는 shared handoff가 없으면 cycle 문서를 생략할 수 있다.
- medium 이상 또는 multi-agent handoff가 있는 구현은 cycle 문서를 사용한다.
- generator는 자신이 구현 기준으로 삼은 planner 섹션 또는 coordinator task reference를 generator 섹션에 명시한다.
- generator는 검증에 사용한 workspace/baseline scope를 generator 섹션에 남긴다.
- evaluator는 generator 결과와 검증 대상이 고정되기 전에는 최종 평가를 확정하지 않으며, 구현이 나오기 전 plan 단독 상태를 cycle 판정으로 평가하지 않는다.
- evaluator는 자신이 평가한 planner 섹션과 generator 섹션 이름을 evaluator 섹션에 함께 남기고, 섹션 시작부에서 `PASS` 또는 `FAIL`을 명시한다.
- evaluator는 dirty worktree에서 이번 cycle 변경과 unrelated diff를 구분한 비교 기준을 함께 남기고, PASS/FAIL은 cycle-owned 변경 기준으로만 판단한다.
- coordinator는 각 역할의 산출물을 반영한 뒤 완료되었거나 더 이상 필요 없는 subagent thread를 즉시 닫는다.
- planner 문서나 coordinator plan이 모호하면 generator가 추측으로 보정하지 말고 planning revision을 요청한다.
- 같은 cycle 문서는 같은 번호 또는 slug를 유지하고, 섹션 이름으로 버전을 추적한다.
- [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md) 아래의 최종 브리핑은 evaluator가 `PASS`로 판정한 cycle만 요약하며, planner/generator/evaluator working docs를 대체하지 않는다.
- coordinator는 handoff가 바뀔 때 cycle 문서 상단의 `Status`, `Current Plan Version`, `Next Handoff`를 함께 갱신한다.

## 문서화 규칙

- 신규 cycle working document는 `subagents_docs/cycles/` 아래에 둔다.
- 같은 cycle 문서 안에서는 해당 phase를 실제로 담당한 coordinator 또는 delegated role만 자기 섹션을 수정한다.
- 사용자-facing 문서는 `docs/guide/`와 `docs/implementation/`으로 한정한다.

## 검증 규칙

- generator는 단위 수준 또는 가장 가까운 자동화 검증을 우선한다.
- evaluator는 plan과 acceptance criteria를 기준으로 가능한 가장 실제적인 대표 사용자 surface 검증을 우선한다.
- 웹, 앱, 게임처럼 UI나 런타임 surface가 있으면 브라우저 화면, 시뮬레이터, 앱 런타임, 게임 런타임/scene 같은 실제 surface 직접 실행을 우선한다.
- CLI나 API가 대표 사용자 surface인 변경이면 실제 command entrypoint, request/response flow, integration endpoint 같은 진입점을 직접 검증하는 방식을 우선한다.
- surface 직접 실행이 불가능하면 evaluator는 그 이유, 누락된 환경 조건, 대체 검증 방식의 한계를 남기고 핵심 surface가 비검증 상태인 변경을 soft-pass하지 않는다.
- 완전한 자동화가 불가능하면 evaluator는 남은 공백을 문서로 남긴다.
- evaluator가 구현 결과에서 실패나 blocker를 확인하면 coordinator는 작업 규모와 모호성을 다시 판단해 같은 경로를 반복하거나 상위 경로로 승격한다.
