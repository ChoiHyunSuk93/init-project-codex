# 저장소 지침

이 파일은 저장소 전역의 얇은 agent 진입점이다.
상세 규칙의 탐색 시작점은 [`rule/index.md`](rule/index.md)다.

## 기본 동작

- 작업 전에 [`PROJECT_OVERVIEW.md`](PROJECT_OVERVIEW.md)와 관련 rule을 읽는다.
- 현재 phase와 handoff가 있으면 [`subagents_docs/roadmap.md`](subagents_docs/roadmap.md)와 관련 cycle을 읽는다.
- 분석·질문·리뷰 요청을 구현 승인으로 해석하지 않는다.
- 기존 구조와 관례를 우선하고 필요한 범위만 변경한다.
- 관찰하지 않은 기술 스택, 명령, 경로, 제품 동작을 지어내지 않는다.
- 관련 위험에 비례해 가장 가까운 검증을 실행하고 실제 결과를 보고한다.

## 규칙 탐색

- 프로젝트 구조: [`rule/rules/project-structure.md`](rule/rules/project-structure.md)
- 개발 기준: [`rule/rules/development-standards.md`](rule/rules/development-standards.md)
- 테스트와 검증: [`rule/rules/testing-standards.md`](rule/rules/testing-standards.md)
- 문서와 언어: [`rule/rules/documentation.md`](rule/rules/documentation.md)
- agent 작업 흐름: [`rule/rules/agent-workflow.md`](rule/rules/agent-workflow.md)

## 문서와 작업 기록

- 사용자 가이드: [`docs/guide/README.md`](docs/guide/README.md)
- 검증 완료 구현 이력: [`docs/implementation/AGENTS.md`](docs/implementation/AGENTS.md)
- plan, handoff, 검증 working record: [`subagents_docs/AGENTS.md`](subagents_docs/AGENTS.md)

규칙을 추가·삭제·이동할 때는 같은 변경에서 [`rule/index.md`](rule/index.md)를 갱신한다.
더 좁은 디렉터리 규칙이 필요할 때만 local instruction 파일을 추가한다.
