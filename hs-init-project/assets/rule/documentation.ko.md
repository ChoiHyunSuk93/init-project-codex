# 문서와 언어 규칙

## 관찰된 문서 지도

- `HS_INIT_SEMANTIC_TODO`: 기존 문서 영역, 실제 독자, authoritative 문서와 갱신 책임을 저장소 상대 경로로 기록한다.

## 권한과 역할

- [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md)는 목적, 범위, 요구사항, 구조와 제약의 기준 문서다.
- [`rule/index.md`](../index.md)는 실행 규칙의 탐색 시작점이고 `rule/rules/*.md`가 상세 기준이다.
- `README.md`는 사람이 읽는 현재 상태와 사용 진입점을 설명한다.
- [`docs/guide/README.md`](../../docs/guide/README.md)는 실제 사용·운영 guide의 진입점이다.
- [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md)는 현재 phase 상태와 완료 gate를 관리한다.
- [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md)는 plan, handoff, 검증 working record 규칙을 정의한다.
- [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md)는 검증 완료 후 추가하는 사용자-facing 구현 이력 규칙을 정의한다.

## 작성 원칙

- 현재 저장소와 사용자에게 확인한 사실만 적는다.
- 실제 파일은 Markdown link로 연결하고 placeholder와 아직 없는 경로는 literal로 둔다.
- 같은 규칙을 여러 문서에 복제하지 않고 authoritative 문서를 연결한다.
- 사용자-facing 문서는 선택된 언어로 작성하되 filename, directory, command, config key와 code identifier는 안정적인 영어 형태를 유지한다.
- 규칙을 추가, 삭제, 이름 변경, 이동할 때 [`rule/index.md`](../index.md)를 같은 변경에서 갱신한다.

## 현재 상태와 이력

- 동작, 진입점, 구조 또는 운영 사실이 바뀌면 overview, README, guide, roadmap과 관련 rule을 갱신한다.
- cycle 문서는 진행 중 provenance를 append-only section으로 누적한다.
- acceptance criteria와 필요한 검증이 `PASS`된 실질 변경은 가장 가까운 `docs/implementation/<category>/`에 새 순번 문서로 기록한다.
- 과거 cycle과 implementation briefing은 오기, 깨진 링크, 잘못된 검증 정보 또는 명시적 요청이 아니면 다시 쓰지 않는다.
