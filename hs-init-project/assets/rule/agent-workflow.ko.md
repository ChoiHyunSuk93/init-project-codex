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

## Delegation

- 독립 탐색, 병렬 가능한 slice, 위험 기반 독립 검증에 실질적 이득이 있을 때만 subagent를 사용한다.
- 범용 planner, generator, evaluator pipeline이나 custom agent 파일을 전제하지 않는다.
- 여러 agent가 같은 파일이나 공통 journal을 동시에 수정하지 않는다.
- 공통 작업 기록과 최종 통합은 coordinator 한 명이 소유한다.
- 위임 작업 중에도 충돌하지 않는 local work를 계속할 수 있다.
- host에 없는 thread close 또는 lifecycle API를 요구하지 않는다.

## 완료 판단

- 정확성, acceptance criteria, 안전성, 회귀 위험, 검증 근거, 유지보수성을 우선한다.
- originality는 명시적인 창작·설계 과업이 아니면 품질 기준으로 사용하지 않는다.
- 실행하지 못한 검증과 남은 위험을 명확히 보고한다.
