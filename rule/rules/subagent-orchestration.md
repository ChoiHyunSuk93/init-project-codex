# 서브에이전트 오케스트레이션 규칙

## 목적

이 저장소에서 planner, generator, evaluator를 분리된 역할로 운영하는 기준을 정의한다.
역할 분리는 문서화와 검증 품질을 높이기 위한 기본 실행 모델이며, 사용자가 명시적으로 완화하지 않는 한 유지한다.

`subagents_docs/`는 planner/generator/evaluator가 실제로 읽고 쓰는 작업 문서 영역이다.
`docs/guide/`와 `docs/implementation/`은 사용자-facing 문서이며, 결과 브리핑을 제외한 에이전트 작업 문서를 넣지 않는다.
`subagents_docs/` 문서는 사용자가 선택한 언어(예: `en`, `ko`)를 우선하며, 그 언어로 작성한다.
메인 에이전트(coordinator)는 이 하네스에서 오케스트레이션만 담당한다.
coordinator는 planner/generator/evaluator 역할을 직접 대행하지 않으며, 사용자가 역할 분리를 명시적으로 완화하지 않는 한 handoff 정리, 대기, 재계획만 수행한다.
coordinator는 subagents가 느리다고 해서 직접 구현에 개입할 수 없다. 반드시 기다리거나 재계획만 수행한다.

## 역할 정의

### planner

- 관점: 기획자
- 목적: 무엇을 만들지 정의하고 범위와 acceptance criteria를 정리한다.
- 소유 산출물: `subagents_docs/plans/` 아래의 planning 문서
- 금지 사항:
  - `hs-init-project/` 아래의 제품 파일 수정 금지
  - unit test, e2e test, 스크립트, template 구현 금지
  - evaluator 보고서 수정 금지
- 필수 내용:
  - 목표
  - 범위
  - 비범위
  - 사용자 관점 결과
  - acceptance criteria
  - open questions

### generator

- 관점: 개발자
- 목적: planner 문서를 바탕으로 구현하고 단위 수준 검증을 맞춘다.
- 소유 산출물:
  - `hs-init-project/` 아래의 제품 파일
  - 구현과 직접 연결된 root 문서
  - `subagents_docs/changes/` 아래의 구현 기록
- 금지 사항:
  - planner 문서의 제품 의도를 임의로 재정의하지 않는다.
  - evaluator 보고서나 점수 결과를 수정하지 않는다.
- 필수 내용:
  - 구현 파일 변경
  - 필요한 단위 테스트 또는 집중된 자동화 검증
  - 미해결 위험과 제약의 명시

### evaluator

- 관점: 평가자
- 목적: generator가 만든 구현 결과를 plan과 acceptance criteria에 대조해 end-to-end 점검하고 품질 평가를 남긴다.
- 소유 산출물: `subagents_docs/evaluations/` 아래의 평가 문서
- 금지 사항:
  - 제품 코드 수정 금지
  - planner 문서 수정 금지
  - generator 구현 기록 수정 금지
- 필수 내용:
  - plan과 acceptance criteria 대비 판정
  - 실제 검증 절차
  - 관찰 결과와 재현 정보
  - 문제 목록
  - 점수 또는 등급
  - design quality, originality, completeness, functionality 평가
- 가중치:
  - design quality와 originality를 completeness와 functionality보다 더 무겁게 본다.

## 실행 순서

1. planner가 plan 문서를 `subagents_docs/plans/`에 먼저 남긴다.
2. generator는 해당 plan 문서를 읽고 구현/기록을 `hs-init-project/`와 `subagents_docs/changes/`에 남긴다.
3. evaluator는 generator가 만든 구현 결과를 plan과 acceptance criteria 기준으로 `subagents_docs/evaluations/`에 점검한다.
4. evaluator가 구현 결과에서 실패나 blocker를 확인했을 때만 동일 plan에서 planner가 재계획을 남기고, generator와 evaluator를 다시 순환한다.
5. 모든 plan이 `pass` 판정될 때까지 단계 1~4를 반복한다.

제품 구조 변경, skill 동작 변경, 문서 생성 흐름 변경처럼 의미 있는 작업은 이 세 단계를 모두 거친다.

## 다중 계획 실행

- 여러 개의 대안 계획이 필요하면 각 계획마다 plan1, plan2, plan3 단위로 분리해 독립적으로 관리한다.
- 독립적인 계획은 병렬 순회가 가능하다.
- 영향도가 있는 계획은 앞선 계획의 pass 여부에 따라 순차적으로 처리한다.

## handoff 규칙

- generator는 planner 산출물이 없으면 구현을 시작하지 않는다.
- evaluator는 generator 결과와 검증 대상이 고정되기 전에는 최종 평가를 확정하지 않으며, 구현이 나오기 전 plan 단독 상태를 cycle 판정으로 평가하지 않는다.
- 상위 조정자는 세 역할의 결과를 모을 수 있지만, 각 역할이 소유한 판단을 다른 역할의 이름으로 덮어쓰지 않는다.
- 상위 조정자는 오케스트레이션 전담이며, 사용자 명시적 완화 없이는 planner/generator/evaluator 중 어느 역할도 직접 수행하지 않는다.
- planner 문서가 모호하면 generator가 추측으로 보정하지 말고 planner 재작성을 요청한다.

## 문서화 규칙

- planning 문서는 `subagents_docs/plans/` 아래에 둔다.
- 구현 기록은 `subagents_docs/changes/` 아래에 둔다.
- 평가 보고서는 `subagents_docs/evaluations/` 아래에 둔다.
- 각 역할은 자신이 소유한 디렉토리만 직접 수정한다.
- 사용자-facing 문서는 `docs/guide/`와 `docs/implementation/`으로 한정한다.

## 검증 규칙

- generator는 단위 수준 또는 가장 가까운 자동화 검증을 우선한다.
- evaluator는 plan과 acceptance criteria를 기준으로 가능한 가장 실제적인 end-to-end 검증을 우선한다.
- 완전한 자동화가 불가능하면 evaluator는 남은 공백을 문서로 남긴다.
- evaluator가 구현 결과에서 실패나 blocker를 확인하면 같은 plan을 다시 planner -> generator -> evaluator로 순환시킨다.
