# 서브에이전트 오케스트레이션 규칙

## 목적

메인 에이전트가 작업 크기와 모호성에 따라 planning과 delegation의 깊이를 고르는 adaptive harness를 정의한다.

`subagents_docs/`는 cycle-backed work의 실제 작업 문서 영역이다.
이 작업 문서의 exact 언어 규칙은 [`rule/rules/language-policy.md`](language-policy.md)를 따른다.
`docs/guide/`와 `docs/implementation/`은 사용자-facing 문서이다.
`docs/implementation/`에는 관심사 기반 카테고리 안에 plan이 통과된 최종 브리핑만 둔다.
메인 에이전트는 작업 분류, 계획 승인, 구현 통합, handoff 결정을 담당한다.
메인 에이전트는 필요하면 subagent를 자율적으로 호출할 수 있다.
문서 분석은 독립적인 질문 단위라면 병렬 `explorer` 호출을 우선 고려한다.
coordinator는 subagent 응답을 오래 기다릴 수 있지만, 반영이 끝난 completed/unused thread는 즉시 닫아야 한다.
stale session이나 thread limit으로 delegation이 막히면 cleanup을 먼저 수행한다.
프로젝트 요구사항과 phase gate는 [`rule/rules/planning-roadmap.md`](planning-roadmap.md)를 기준으로 삼는다.

## Intent Gate

- 분석, 질문, 리뷰, 설명 요청은 구현 사이클로 시작하지 않는다.
- 구현 경로는 사용자가 명시적으로 구현, 변경, 생성, 수정, materialize를 요청했을 때만 시작한다.
- 구현 의도가 모호하면 추측으로 진행하지 말고 분석으로 멈추거나 clarification을 요청한다.

## Overview And Roadmap Gate

- 구현 cycle을 시작하기 전에 [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md)가 현재 요구사항 또는 관찰된 프로젝트 구조를 설명하는지 확인한다.
- [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md)는 `PROJECT_OVERVIEW.md`를 기준으로 phase, 완료 체크리스트, 검증 방법, 의존 관계를 가져야 한다.
- 구현 cycle은 roadmap의 특정 phase 또는 phase section에 연결한다.
- 의존 관계가 있는 다음 phase는 선행 phase가 `PASS`가 되고 필수 체크리스트가 충족되기 전에는 시작하지 않는다.
- evaluator가 `FAIL`을 기록하면 다음 phase로 넘어가지 말고 해당 phase checklist와 notes를 최신화한 뒤 같은 phase에서 재계획한다.

## 실행 모드

### small

- 기본 경로는 `main/generator -> evaluator`다.
- 범위가 좁고 요구가 명확할 때 사용한다.
- shared working record가 필요 없으면 cycle 문서를 생략할 수 있다.

### medium

- 기본 경로는 `main(plan+implementation) -> evaluator`다.
- 짧은 plan은 필요하지만 full delegated planning loop는 과한 경우에 사용한다.
- cycle을 열면 `Planner vN`과 `Generator vN`를 같은 문서에 남긴다.

### large-clear

- 기본 경로는 `main-led decomposition + delegated implementation + evaluator`다.
- 큰 변경이지만 bounded implementation slice로 나눌 수 있을 만큼 명확할 때 사용한다.

### large-ambiguous

- 기본 경로는 `parallel explorer analysis + planner assist if needed + main-approved plan + delegated implementation + evaluator`다.
- 큰 변경이면서 모호성이 아직 큰 경우에 사용한다.

## cycle 문서 모델

exact cycle 문서 경로, header 상태 전이, append-only section, provenance, dirty-worktree 평가는 [`rule/rules/cycle-document-contract.md`](cycle-document-contract.md)를 authoritative 기준으로 사용한다.

- 신규 cycle은 `subagents_docs/cycles/<NN>-<slug>.md` 아래 plan별 단일 working document를 사용한다.
- planning, implementation, evaluation 산출물은 같은 문서 안의 append-only 섹션으로 누적한다.
- 작은 직접 변경은 shared working record가 없으면 cycle 문서를 생략할 수 있다.

## 역할 경계

### planner

- large-ambiguous work에서 planner assist로 사용한다.
- cycle을 여는 경우 `subagents_docs/cycles/` 안의 planner 섹션을 append한다.
- exact section contents와 provenance는 [`rule/rules/cycle-document-contract.md`](cycle-document-contract.md)를 따른다.
- 제품 구현 파일, 스크립트, 템플릿, 평가 산출물을 수정하지 않는다.

### generator

- bounded delegated implementation이나 작은 직접 구현 보조에 사용한다.
- cycle을 여는 경우 `subagents_docs/cycles/` 안의 generator 섹션에 구현 기록을 남긴다.
- exact section contents와 verification-basis 요구는 [`rule/rules/cycle-document-contract.md`](cycle-document-contract.md)를 따른다.
- 필요 시 단위 수준 점검을 함께 정리한다.
- evaluator가 pass를 내리기 전에는 `docs/implementation/` 최종 브리핑을 발행하지 않는다.

### evaluator

- 구현 결과를 plan과 acceptance criteria에 대조해 대표 사용자 surface를 가능한 한 직접 실행하는 strongest feasible 검증으로 점검하고, cycle을 여는 경우 `subagents_docs/cycles/` 안의 evaluator 섹션에 판정한다.
- 기능, 구조, 실행 규칙 준수도를 함께 점검한다.
- exact PASS/FAIL 기록, provenance, dirty-worktree 비교 기준은 [`rule/rules/cycle-document-contract.md`](cycle-document-contract.md)를 따른다.
- 구현 파일이나 계획 산출물을 수정하지 않는다.

## 오케스트레이션 사이클

1. 메인 에이전트가 작업을 `small`, `medium`, `large-clear`, `large-ambiguous`로 분류한다.
2. 먼저 분석이 필요하면 explorer를 병렬 호출해 ambiguity를 줄인다.
3. cycle 문서를 여는 경우 선택한 모드에 맞춰 `Planner vN`, `Generator vN`를 남기고 evaluator로 넘긴다.
4. evaluator가 구현 결과에서 실패나 blocker를 확인하면 해당 모드에 맞는 planning depth로 돌아가 다시 반복한다.
5. evaluator가 `FAIL`을 기록하면 coordinator는 외부 입력이 정말 필요한 blocker가 아닌 한 사용자 질문 없이 다음 cycle을 다시 시작한다.
6. plan이 pass될 때까지 순환한다.

## 다중 계획 실행

- 여러 요구사항이 필요하면 `plan1`, `plan2`, `plan3`처럼 분리 관리한다.
- 서로 독립이면 병렬로 진행하되 각 계획은 roadmap phase 또는 phase section과 연결한다.
- 선행 plan의 결과가 후속 plan 입력에 영향을 주면 선행 phase의 `PASS`와 필수 체크리스트 충족 뒤에 순차로 진행한다.

## 가드레일

- 같은 문서를 공유하더라도 planning, implementation, evaluation 산출물은 각 섹션에만 둔다.
- `docs/implementation/`에 planning/implementation/evaluation 기록을 넣지 않는다.
- subagent 산출물을 반영하고 더 이상 필요 없는 thread는 coordinator가 즉시 닫는다.
- 대표 사용자 surface가 있으면 evaluator는 브라우저 화면, 앱 시뮬레이터/런타임, 게임 런타임/scene, CLI command, API request/response 같은 실제 진입점을 직접 검증하는 방식을 우선한다.
- 직접 surface 검증이 불가능하면 evaluator는 이유, 누락된 환경이나 접근 권한, 대체 검증 방식의 한계를 남기고 핵심 surface가 비검증 상태인 변경을 soft-pass하지 않는다.
- 계획 범위가 불명확하면 generator가 임의 추측으로 진행하지 말고 explorer 분석이나 planner assist를 통해 planning revision을 요구한다.
- 구현이 나오기 전 plan 단독 상태를 cycle pass/fail 평가로 간주하지 않는다.
- plan-only 상태나 generator-only 상태를 근거로 `docs/implementation/` 최종 브리핑을 만들거나 갱신하지 않는다.
