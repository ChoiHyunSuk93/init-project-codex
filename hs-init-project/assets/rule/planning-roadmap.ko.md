# 프로젝트 오버뷰와 로드맵 규칙

## 목적

작업 시작 전에 프로젝트 전체 흐름을 관통하는 요구사항 기준과 phase 기반 실행 로드맵을 먼저 만들고, 각 phase의 완료기준을 충족한 뒤 다음 phase로 넘어가도록 강제한다.

## 기준 문서

- [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md): 프로젝트 목적, 대상 사용자, 핵심 흐름, 요구사항, 제약, 비범위, 미해결 질문을 정리하는 최상위 요구사항 명세서다.
- [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md): `PROJECT_OVERVIEW.md`를 기준으로 구현 작업을 phase로 나누고, 각 phase의 완료 체크리스트와 상태를 관리하는 작업 로드맵이다.
- `subagents_docs/cycles/`: `subagents_docs/roadmap.md`의 특정 phase 또는 phase section을 구현하는 cycle working document를 둔다.

## 생성 기준

- 신규 프로젝트에서는 초기 사용자 요구사항을 바탕으로 먼저 `PROJECT_OVERVIEW.md`를 만든다.
- 신규 프로젝트에서 요구사항이 부족하면 안전한 placeholder와 open question을 남기고, 없는 기능이나 스택을 지어내지 않는다.
- 기존 프로젝트에서는 source root, 주요 모듈, 기존 문서, 테스트/빌드 자동화, 현재 사용자 요청을 먼저 검토한 뒤 `PROJECT_OVERVIEW.md`를 관찰된 사실 기준으로 작성하거나 보강한다.
- 기존 프로젝트의 기존 `PROJECT_OVERVIEW.md`가 의미 있으면 무작정 교체하지 말고 현재 구조와 요청에 맞게 정리한다.
- `subagents_docs/roadmap.md`는 항상 `PROJECT_OVERVIEW.md`의 요구사항과 제약에서 phase를 파생해야 한다.

## 로드맵 구조

`subagents_docs/roadmap.md`의 각 phase는 최소한 다음 항목을 가진다.

- `Status`: `pending`, `in_progress`, `blocked`, `PASS` 중 하나
- `Goal`: phase가 달성해야 하는 사용자 관점 결과
- `Scope`: 포함 범위
- `Non-goals`: 제외 범위
- `Required Checklist`: 다음 phase로 넘어가기 전에 반드시 충족해야 하는 체크리스트
- `Verification`: 완료기준을 판정하는 테스트, 실행, 수동 검수, 문서 확인 방법
- `Cycle`: 연결된 `subagents_docs/cycles/<NN>-<slug>.md` 문서
- `Notes`: blocker, 결정, 남은 위험

## Phase Gate

- 구현 cycle은 `subagents_docs/roadmap.md`의 한 phase 또는 명확한 phase section에 연결해야 한다.
- 의존 관계가 있는 후속 phase는 선행 phase의 `Required Checklist`가 충족되고 `Status`가 `PASS`가 되기 전에는 시작하지 않는다.
- 독립 phase만 병렬로 진행할 수 있다.
- evaluator가 `FAIL`을 기록하면 해당 phase의 체크리스트와 notes를 최신화하고, 같은 phase에서 재계획과 재구현을 반복한다.
- phase가 `PASS`가 되면 검수 근거와 연결 cycle을 `subagents_docs/roadmap.md`에 반영한 뒤 다음 phase로 넘어간다.
- 로드맵이 실제 요구사항이나 구현 결과와 어긋나면 다음 구현을 시작하기 전에 `PROJECT_OVERVIEW.md` 또는 `subagents_docs/roadmap.md`를 먼저 갱신한다.

## 문서 경계

- `PROJECT_OVERVIEW.md`는 오래 유지되는 요구사항 명세이며, 짧은 작업 메모나 cycle 진행 로그를 담지 않는다.
- `subagents_docs/roadmap.md`는 phase 상태와 완료 체크리스트를 관리하는 작업 문서이며, 사용자-facing 최종 브리핑을 대체하지 않는다.
- cycle별 계획, 구현, 평가는 `subagents_docs/cycles/`에 둔다.
- evaluator `PASS` 이후의 사용자-facing 요약은 [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md)를 기준으로 `docs/implementation/` 아래 concern-based category에 둔다.
