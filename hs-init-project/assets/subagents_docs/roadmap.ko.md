# 프로젝트 로드맵

이 로드맵은 [`PROJECT_OVERVIEW.md`](../PROJECT_OVERVIEW.md)를 기준으로 phase를 나누고, 각 phase의 완료기준을 추적한다.
의존 관계가 있는 다음 phase는 선행 phase가 `PASS`가 되기 전에는 시작하지 않는다.

## 운영 규칙

- 각 phase는 `Status`, `Goal`, `Scope`, `Non-goals`, `Required Checklist`, `Verification`, `Cycle`, `Notes`를 유지한다.
- 구현 cycle은 한 phase 또는 명확한 phase section에 연결한다.
- evaluator가 `FAIL`을 기록하면 해당 phase의 checklist와 notes를 갱신하고 같은 phase에서 다시 순환한다.
- phase가 `PASS`가 되면 검수 근거와 연결 cycle을 이 문서에 반영한 뒤 다음 phase로 넘어간다.
- 요구사항이나 구현 결과가 바뀌면 다음 구현 전에 [`PROJECT_OVERVIEW.md`](../PROJECT_OVERVIEW.md)와 이 로드맵을 먼저 동기화한다.

## Phase 0 - Requirements And Roadmap Baseline

- `Status`: `pending`
- `Goal`: 초기 요구사항을 `PROJECT_OVERVIEW.md`에 정리하고, 누락 없는 phase 로드맵을 수립한다.
- `Scope`: 요구사항 정리, phase 분해, 완료 체크리스트 정의
- `Non-goals`: 실제 제품 구현
- `Required Checklist`:
  - [ ] `PROJECT_OVERVIEW.md`가 초기 요구사항 또는 관찰된 프로젝트 구조를 반영한다.
  - [ ] 각 phase가 사용자 관점 목표와 포함/제외 범위를 가진다.
  - [ ] 각 phase가 완료 판단용 필수 체크리스트와 검증 방법을 가진다.
  - [ ] phase 간 의존 관계와 병렬 가능 여부가 드러난다.
- `Verification`: 문서 검토, 요구사항 누락 확인, phase gate 확인
- `Cycle`: `subagents_docs/cycles/[NN-phase-slug].md`
- `Notes`: 실제 프로젝트 요구사항이 구체화되면 Phase 1 이후 항목을 추가한다.
