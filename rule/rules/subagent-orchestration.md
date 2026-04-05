# 서브에이전트 오케스트레이션 규칙

## 목적

이 저장소에서 planner, generator, evaluator를 분리된 역할로 운영하는 기준을 정의한다.
역할 분리는 문서화와 검증 품질을 높이기 위한 기본 실행 모델이며, 사용자가 명시적으로 완화하지 않는 한 유지한다.

`subagents_docs/`는 planner/generator/evaluator가 실제로 읽고 쓰는 작업 문서 영역이다.
`docs/guide/`와 `docs/implementation/`은 사용자-facing 문서이며, 결과 브리핑을 제외한 에이전트 작업 문서를 넣지 않는다.
메인 에이전트(coordinator)는 이 하네스에서 오케스트레이션만 담당한다.
coordinator는 planner/generator/evaluator 역할을 직접 대행하지 않으며, 사용자가 역할 분리를 명시적으로 완화하지 않는 한 handoff 정리, 대기, 재계획만 수행한다.
coordinator는 subagents가 느리다고 해서 직접 구현에 개입할 수 없다. 반드시 기다리거나 재계획만 수행한다.
coordinator는 오래 기다릴 수 있지만, 완료되었거나 더 이상 필요 없는 subagent thread는 결과를 반영한 직후 반드시 닫는다.
stale session이나 thread limit 때문에 후속 subagent 실행이 막히면, coordinator는 직접 구현 대신 thread cleanup을 우선 수행한다.
cycle 문서 형식, header 상태 전이, provenance 요구는 `rule/rules/cycle-document-contract.md`를 기준으로 삼는다.
문서 본문 언어와 path 표기 규칙은 `rule/rules/language-policy.md`를 기준으로 삼는다.

## Intent Gate

- planner/generator/evaluator 사이클은 사용자가 명시적으로 구현, 변경, 생성, 수정, materialize를 요청했을 때만 시작한다.
- 분석, 질문, 리뷰, 설명 요청은 구현 사이클로 넘기지 않고 analysis-only 상태로 유지한다.
- 구현 의도가 명확하지 않으면 coordinator는 clarification 또는 분석으로 멈추고 generator를 띄우지 않는다.

## 역할 정의

### planner

- 관점: 기획자
- 목적: 무엇을 만들지 정의하고 범위와 acceptance criteria를 정리한다.
- 소유 산출물: `subagents_docs/cycles/` 아래 cycle 문서의 planner 섹션
- 금지 사항:
  - `hs-init-project/` 아래의 제품 파일 수정 금지
  - unit test, e2e test, 스크립트, template 구현 금지
  - generator/evaluator 섹션 수정 금지
  - coordinator 상태 블록 덮어쓰기 금지
- 필수 내용:
  - 목표
  - 범위
  - 비범위
  - 사용자 관점 결과
  - acceptance criteria
  - 제약
  - 위험 요소
  - 의존관계
  - open questions
  - 이전 evaluator 섹션 reference 또는 신규 cycle 명시
  - 다음 handoff 대상 또는 차단 조건

### generator

- 관점: 개발자
- 목적: planner 문서를 바탕으로 구현하고 단위 수준 검증을 맞춘다.
- 소유 산출물:
  - `hs-init-project/` 아래의 제품 파일
  - 구현과 직접 연결된 root 문서
  - `subagents_docs/cycles/` 아래 cycle 문서의 generator 섹션
- 금지 사항:
  - planner 문서의 제품 의도를 임의로 재정의하지 않는다.
  - planner/evaluator 섹션이나 coordinator 상태 블록을 수정하지 않는다.
- 필수 내용:
  - planner section reference
  - 실제 반영한 범위
  - 변경 파일 목록
  - 검증에 사용한 workspace/baseline scope
  - 필요한 단위 테스트 또는 집중된 자동화 검증
  - 미해결 위험과 제약의 명시
  - 다음 handoff 대상
- 추가 규칙:
  - evaluator가 pass를 내리기 전에는 `docs/implementation/`의 최종 브리핑을 working record 대용으로 만들거나 갱신하지 않는다.

### evaluator

- 관점: 평가자
- 목적: generator가 만든 구현 결과를 plan과 acceptance criteria에 대조해 대표 사용자 surface를 가능한 한 직접 실행하는 strongest feasible 검증과 품질 평가를 남긴다.
- 소유 산출물: `subagents_docs/cycles/` 아래 cycle 문서의 evaluator 섹션
- 금지 사항:
  - 제품 코드 수정 금지
  - planner/generator 섹션 수정 금지
  - coordinator 상태 블록 덮어쓰기 금지
- 필수 내용:
  - `PASS` 또는 `FAIL` 결과
  - planner section reference
  - generator section reference
  - plan과 acceptance criteria 대비 판정
  - 실제 검증 절차
  - dirty worktree 비교 기준
  - 관찰 결과와 재현 정보
  - 문제 목록
  - 점수 또는 등급
  - design quality, originality, completeness, functionality 평가
  - 다음 handoff 대상 또는 종료 판정
- 가중치:
  - design quality와 originality를 completeness와 functionality보다 더 무겁게 본다.

## 실행 순서

1. planner가 cycle 문서를 만들거나 기존 cycle 문서에 최신 planner 섹션을 append한다.
2. generator는 같은 cycle 문서의 최신 planner 섹션을 읽고 구현/기록을 `hs-init-project/`와 cycle 문서의 generator 섹션에 남긴다.
3. evaluator는 같은 cycle 문서에서 planner/generator 섹션을 참조하며 구현 결과를 점검한다.
4. evaluator가 구현 결과에서 실패나 blocker를 확인했을 때만 동일 plan에서 planner가 재계획을 남기고, generator와 evaluator를 다시 순환한다.
5. evaluator가 `FAIL`을 기록하면 coordinator는 외부 입력이 정말 필요한 blocker가 아닌 한 사용자 질문 없이 다음 planner cycle을 즉시 시작한다.
6. 모든 plan이 `pass` 판정될 때까지 단계 1~5를 반복한다.

제품 구조 변경, skill 동작 변경, 문서 생성 흐름 변경처럼 의미 있는 작업은 이 세 단계를 모두 거친다.

## 다중 계획 실행

- 여러 개의 대안 계획이 필요하면 각 계획마다 plan1, plan2, plan3 단위로 분리해 독립적으로 관리한다.
- 독립적인 계획은 병렬 순회가 가능하다.
- 영향도가 있는 계획은 앞선 계획의 pass 여부에 따라 순차적으로 처리한다.

## handoff 규칙

- generator는 planner 산출물이 없으면 구현을 시작하지 않는다.
- generator는 자신이 구현 기준으로 삼은 planner 섹션 이름을 generator 섹션에 명시한다.
- generator는 검증에 사용한 workspace/baseline scope를 generator 섹션에 남긴다.
- evaluator는 generator 결과와 검증 대상이 고정되기 전에는 최종 평가를 확정하지 않으며, 구현이 나오기 전 plan 단독 상태를 cycle 판정으로 평가하지 않는다.
- evaluator는 자신이 평가한 planner 섹션과 generator 섹션 이름을 evaluator 섹션에 함께 남기고, 섹션 시작부에서 `PASS` 또는 `FAIL`을 명시한다.
- evaluator는 dirty worktree에서 이번 cycle 변경과 unrelated diff를 구분한 비교 기준을 함께 남기고, PASS/FAIL은 cycle-owned 변경 기준으로만 판단한다.
- 상위 조정자는 세 역할의 결과를 모을 수 있지만, 각 역할이 소유한 판단을 다른 역할의 이름으로 덮어쓰지 않는다.
- 상위 조정자는 오케스트레이션 전담이며, 사용자 명시적 완화 없이는 planner/generator/evaluator 중 어느 역할도 직접 수행하지 않는다.
- 상위 조정자는 각 역할의 산출물을 반영한 뒤 완료되었거나 더 이상 필요 없는 subagent thread를 즉시 닫는다.
- planner 문서가 모호하면 generator가 추측으로 보정하지 말고 planner 재작성을 요청한다.
- 같은 cycle 문서는 같은 번호 또는 slug를 유지하고, 섹션 이름으로 버전을 추적한다.
- `docs/implementation/`의 최종 브리핑은 evaluator가 `PASS`로 판정한 cycle만 요약하며, planner/generator/evaluator working docs를 대체하지 않는다.
- coordinator는 handoff가 바뀔 때 cycle 문서 상단의 `Status`, `Current Plan Version`, `Next Handoff`를 함께 갱신한다.

## 문서화 규칙

- 신규 cycle working document는 `subagents_docs/cycles/` 아래에 둔다.
- 각 역할은 같은 cycle 문서 안에서도 자신이 소유한 섹션만 직접 수정한다.
- 사용자-facing 문서는 `docs/guide/`와 `docs/implementation/`으로 한정한다.

## 검증 규칙

- generator는 단위 수준 또는 가장 가까운 자동화 검증을 우선한다.
- evaluator는 plan과 acceptance criteria를 기준으로 가능한 가장 실제적인 대표 사용자 surface 검증을 우선한다.
- 웹, 앱, 게임처럼 UI나 런타임 surface가 있으면 브라우저 화면, 시뮬레이터, 앱 런타임, 게임 런타임/scene 같은 실제 surface 직접 실행을 우선한다.
- CLI나 API가 대표 사용자 surface인 변경이면 실제 command entrypoint, request/response flow, integration endpoint 같은 진입점을 직접 검증하는 방식을 우선한다.
- surface 직접 실행이 불가능하면 evaluator는 그 이유, 누락된 환경 조건, 대체 검증 방식의 한계를 남기고 핵심 surface가 비검증 상태인 변경을 soft-pass하지 않는다.
- 완전한 자동화가 불가능하면 evaluator는 남은 공백을 문서로 남긴다.
- evaluator가 구현 결과에서 실패나 blocker를 확인하면 같은 plan을 다시 planner -> generator -> evaluator로 순환시킨다.
