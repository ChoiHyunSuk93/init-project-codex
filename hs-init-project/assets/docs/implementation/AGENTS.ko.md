# 구현 기록 지침

이 디렉터리는 acceptance criteria와 필요한 검증을 통과한 사용자-facing 구현 이력을 저장한다.
plan, handoff, 진행 로그는 [`subagents_docs/`](../../subagents_docs/AGENTS.md)에 둔다.

## 기록 기준

- 실질 구현 변경이 `PASS`된 뒤 가장 가까운 관심사 기반 category에 새 기록을 추가한다.
- 초기화 시 빈 category나 placeholder 구현 기록을 만들지 않는다.
- 파일명은 category 안에서 `NN-name.md` 순번을 유지한다.
- 기존 기록은 과거 이력으로 보존하고, 오기·깨진 링크·잘못된 검증 정보·명시적 요청이 아니면 현재 상태에 맞춰 다시 쓰지 않는다.
- `misc`, `general`, `notes`, `other`, `briefings` 같은 약한 catch-all category를 만들지 않는다.

## 필수 내용

- `요약`
- `변경 내용`
- `이유`
- `검증`
- `관련 규칙`

기록은 짧고 사람이 읽기 쉽게 유지하며, 정확한 검증 명령과 관찰 결과를 구분한다.
