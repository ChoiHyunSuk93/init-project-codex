# 작업 기록 지침

이 디렉터리는 main agent와 delegated agent의 plan, handoff, 구현 근거와 검증 working state를 관리한다.
사용자-facing guide나 검증 완료 구현 이력을 대신하지 않는다.

## 사용 조건

- 작은 직접 변경은 shared handoff나 감사 가능한 상태 전이가 없으면 cycle을 생략할 수 있다.
- 중간 이상 변경, 명시적 work-sharing, 여러 handoff, 장기 작업, 독립 검증이 있으면 `cycles/<NN>-<slug>.md`를 만든다.
- 각 cycle은 [`roadmap.md`](roadmap.md)의 한 phase 또는 명확한 phase section에 연결한다.

## 소유권

- main agent 또는 coordinator가 roadmap 상태, cycle header, 공통 journal과 최종 통합의 단일 writer다.
- delegated agent는 공통 문서를 직접 수정하지 않고 결과, 변경 범위, 검증 근거와 남은 위험을 반환한다.
- 병렬 agent는 같은 파일이나 공통 record를 동시에 수정하지 않는다.

## Cycle 계약

- header에는 `Status`, `Current Plan Version`, `Next Handoff`를 둔다.
- 허용 상태는 `in_progress`, `BLOCKED`, `PASS`, `FAIL`이다.
- 본문은 `Planner vN`, `Generator vN`, `Evaluator vN` section을 append-only로 유지한다.
- 각 section에는 main 또는 delegated 수행 provenance, 기준 section, 실제 변경 또는 평가 범위, 검증, 남은 위험과 다음 handoff를 기록한다.
- `Evaluator vN`이 acceptance criteria와 roadmap checklist를 모두 통과시킨 뒤에만 header와 phase를 `PASS`로 갱신한다.

검증 완료 사용자-facing 결과는 [`docs/implementation/AGENTS.md`](../docs/implementation/AGENTS.md)에 따라 별도 이력으로 남긴다.
