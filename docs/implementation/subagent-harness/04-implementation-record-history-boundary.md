# 구현 브리핑 이력 경계

## 요약

`docs/implementation/`을 현재 상태 동기화 대상이 아니라 완료된 구현 이력 저장소로 명확히 분리했다.
새 구현 변경은 기존 브리핑을 고치는 방식이 아니라 새 브리핑 문서로 남기도록 current repo 규칙과 생성 산출물을 정렬했다.

## 변경 내용

- `rule/rules/documentation-boundaries.md`, `rule/rules/implementation-records.md`, `docs/implementation/AGENTS.md`에 기존 구현 브리핑 보존 원칙을 추가했다.
- `hs-init-project/assets/` 아래 root `AGENTS`, rule, README, `docs/implementation/AGENTS`, starter `docs-sync` skill 템플릿을 같은 정책으로 갱신했다.
- `hs-init-project/scripts/materialize_repo.sh`의 existing-project direct generation 문구도 현재 상태 문서 동기화와 구현 이력 보존 경계에 맞췄다.
- root `README.md`, `README.ko.md`, `PROJECT_OVERVIEW.md`, `subagents_docs/roadmap.md`에 현재 정책을 반영했다.

## 이유

- 구현 브리핑은 완료된 변경 이력이며, 현재 변경사항에 맞춰 과거 문서를 탐색하거나 수정하는 작업은 불필요한 공수를 만든다.
- 최신화와 동기화는 README, 프로젝트 오버뷰, 로드맵, guide, rule처럼 현행 사용법과 규칙을 설명하는 문서에만 적용되어야 한다.

## 검증

- 단위 테스트: 해당 없음.
- E2E 테스트: 해당 없음.
- 수동 검증:
  - `sh -n hs-init-project/scripts/materialize_repo.sh`
  - fresh Korean materialize smoke
  - existing English materialize smoke
  - generated-output `rg` check for implementation briefing history wording
  - `git diff --check`
- 미실행 / 남은 공백: release tag 생성과 installed global skill 갱신은 사용자가 별도로 요청할 때 진행한다.

## 관련 규칙

- [`rule/rules/documentation-boundaries.md`](../../../rule/rules/documentation-boundaries.md)
- [`rule/rules/implementation-records.md`](../../../rule/rules/implementation-records.md)
- [`rule/rules/subagent-orchestration.md`](../../../rule/rules/subagent-orchestration.md)
- [`rule/rules/subagents-docs.md`](../../../rule/rules/subagents-docs.md)
