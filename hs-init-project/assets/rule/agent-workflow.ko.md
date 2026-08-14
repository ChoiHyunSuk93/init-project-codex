# Agent 작업 흐름 규칙

## Intent Gate

- 분석, 질문, 리뷰, 설명 요청은 구현 권한으로 해석하지 않는다.
- 사용자가 생성, 변경, 수정, 구현을 명확히 요청했을 때만 파일을 변경한다.
- 중요한 선택이 실제 결과를 바꾸고 저장소에서 답을 찾을 수 없을 때만 최소 질문을 한다.

## 작업 분류

- 작고 명확한 작업은 main agent가 직접 수행하고 집중 검증한다.
- 범위가 넓지만 명확한 작업은 짧게 계획한 뒤 main agent가 구현·통합한다.
- 큰 작업은 서로 충돌하지 않는 bounded slice로만 나눠 위임한다.
- 큰 모호성이 있으면 구현 전에 read-only 탐색으로 불확실성을 줄인다.

## 작업 기록

- 오래 유지되는 요구사항은 [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md), phase 상태는 [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md)에 둔다.
- 중간 이상 변경, 명시적 work-sharing, 여러 handoff, 감사 가능한 상태 전이는 `subagents_docs/cycles/<NN>-<slug>.md`로 기록한다.
- cycle header는 `Status`, `Current Plan Version`, `Next Handoff`를 유지한다.
- 본문은 `Planner vN`, `Generator vN`, `Evaluator vN` section을 append-only로 누적하고 main 또는 delegated 수행 provenance와 검증 근거를 남긴다.
- 작은 직접 변경은 shared handoff가 없으면 cycle을 생략할 수 있다.
- 검증 완료 결과는 [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md)에 따라 새 category 기록으로 남긴다.

## Delegation

- 독립 탐색, 병렬 가능한 slice, 위험 기반 독립 검증에 실질적 이득이 있을 때만 subagent를 사용한다.
- 범용 planner, generator, evaluator pipeline이나 custom agent 파일을 전제하지 않는다.
- 여러 agent가 같은 파일이나 공통 journal을 동시에 수정하지 않는다.
- delegated agent는 결과를 반환하고 공통 cycle header, roadmap, 최종 통합은 main agent가 소유한다.
- host에 없는 thread close 또는 lifecycle API를 요구하지 않는다.

## 완료 판단

- 정확성, acceptance criteria, 안전성, 회귀 위험, 검증 근거, 유지보수성을 우선한다.
- 실행하지 못한 검증과 남은 위험을 명확히 보고한다.
