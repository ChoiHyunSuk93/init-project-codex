# 서브에이전트 오케스트레이션 규칙

## 목적

메인 에이전트가 변경 크기, 모호성, 병렬 이득, 위험도에 따라 필요한 경우에만 동적 subagent를 사용하도록 한다.
이 저장소는 범용 planner, generator, evaluator custom agent 파일이나 고정 파이프라인을 전제하지 않는다.

## Intent Gate

- 사용자가 구현, 변경, 생성, 수정, materialize를 명확히 요청했을 때만 파일 변경을 시작한다.
- 분석, 질문, 리뷰, 설명 요청은 구현 승인으로 해석하지 않는다.
- 중요한 선택이 결과를 바꾸고 저장소에서 답을 찾을 수 없을 때만 최소 질문을 한다.

## 작업 분류

### small

- 범위가 좁고 요구가 명확하면 메인 에이전트가 직접 구현하고 집중 검증한다.
- shared handoff가 없으면 cycle 문서를 생략한다.

### medium

- 여러 파일이나 영역에 걸치지만 요구가 명확하면 메인 에이전트가 짧은 plan을 정리하고 구현·통합한다.
- 위험과 공유 handoff가 작으면 별도 subagent나 cycle 문서를 만들지 않아도 된다.

### large-clear

- 큰 변경이지만 방향이 명확하면 메인 에이전트가 상위 plan과 경계를 정한다.
- 서로 독립적이고 같은 파일을 수정하지 않는 bounded slice에 실제 병렬 이득이 있을 때만 implementation subagent에 위임한다.
- 메인 에이전트가 결과와 문서를 최종 통합한다.

### large-ambiguous

- 큰 변경이면서 모호성이 크면 구현 전에 독립적인 read-only 탐색을 병렬화해 불확실성을 줄인다.
- 최종 계획 승인, task split, 구현 통합은 메인 에이전트가 맡는다.

## Delegation 판단

- 다음 중 하나가 성립할 때 subagent 사용을 고려한다.
  - 서로 독립적인 탐색 질문이 둘 이상이다.
  - 구현을 충돌 없는 bounded slice로 나눌 수 있다.
  - 보안, 데이터 무결성, release, 넓은 회귀 위험 때문에 독립 검증이 필요하다.
  - 전문성이 다른 검증 surface를 병렬로 확인해야 한다.
- 단순히 역할 이름이 존재하거나 작업이 여러 파일이라는 이유로 위임하지 않는다.
- 작은 수정, 순차 의존 작업, 공유 파일 중심 작업은 메인 에이전트가 직접 처리한다.

## 역할과 소유권

- coordinator는 작업 분류, 최종 plan, task split, 변경 통합, 사용자 보고를 소유한다.
- delegated analyst는 지정된 질문을 read-only로 조사한다.
- delegated implementation worker는 지정된 파일 또는 책임 범위만 수정한다.
- independent validator는 제품 파일을 수정하지 않고 acceptance criteria와 위험에 맞는 검증 근거를 반환한다.
- 역할은 작업 단위로 부여하며 범용 custom agent 파일로 고정하지 않는다.

## 병렬 안전성

- 두 agent가 같은 파일이나 같은 공통 journal을 동시에 수정하지 않는다.
- 병렬 agent는 결과와 검증 근거를 coordinator에게 반환한다.
- cycle header, roadmap 상태, 공통 작업 기록과 최종 브리핑은 coordinator가 단일 writer로 갱신한다.
- delegated work를 기다리는 동안 충돌하지 않는 local work를 계속할 수 있다.
- 완료된 실행은 host가 제공하는 lifecycle을 따르며 존재하지 않는 thread close API를 요구하지 않는다.

## Cycle 문서

- medium 이상이라고 해서 항상 cycle 문서를 만들지는 않는다.
- 명시적 work-sharing, 여러 handoff, 장시간 작업, 감사 가능한 상태 전이가 필요할 때 사용한다.
- exact 형식은 [`rule/rules/cycle-document-contract.md`](cycle-document-contract.md)를 따른다.
- cycle 문서가 있더라도 subagent가 직접 공통 문서를 수정하지 않고 coordinator가 반환 결과를 통합한다.

## 검증

- 검증 강도는 작업 위험, 사용자 surface, release 영향에 비례한다.
- 작은 작업은 메인 에이전트의 targeted verification으로 충분할 수 있다.
- 독립 검증은 고위험 변경, 넓은 diff, release gate, 보안·데이터 변경 또는 명시적 사용자 요청에서 우선한다.
- 품질 판단은 정확성, acceptance criteria, 안전성, 회귀 방지, 검증 근거, 유지보수성을 우선한다.
- originality는 명시적인 창작·디자인 탐색 과업이 아니면 기본 평가 기준으로 사용하지 않는다.
- 직접 검증하지 못한 대표 surface와 대체 검증의 한계를 명확히 기록한다.
