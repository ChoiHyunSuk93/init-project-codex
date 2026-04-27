# 오버뷰-로드맵 phase gate 생성 구조

## 요약

`hs-init-project`로 생성하는 저장소 구조에 `PROJECT_OVERVIEW.md`와 `subagents_docs/roadmap.md`를 기본 산출물로 추가하고, 각 구현 phase가 필수 체크리스트를 충족해야 다음 phase로 넘어가도록 규칙과 템플릿, 생성 스크립트를 정렬했다.

## 변경 내용

- `rule/rules/planning-roadmap.md`를 추가해 project overview, phase roadmap, phase별 checklist, phase gate를 authoritative rule로 정의했다.
- fresh/existing 생성 경로에서 `PROJECT_OVERVIEW.md`, `subagents_docs/roadmap.md`, `rule/rules/planning-roadmap.md`를 생성하도록 `hs-init-project/scripts/materialize_repo.sh`를 갱신했다.
- `SKILL.md`, references, root/README/rule/subagents templates, starter local skills, `agents/openai.yaml`에 새 phase-gate 흐름을 반영했다.
- current repo에도 `PROJECT_OVERVIEW.md`와 `subagents_docs/roadmap.md`를 추가하고 Phase 1 체크리스트를 PASS 상태로 정리했다.

## 이유

- 초기 프로젝트는 요구사항 명세와 전체 로드맵이 먼저 필요하고, 기존 프로젝트는 구조 파악 후 오버뷰와 로드맵을 기준으로 구현 phase를 나눠야 한다.
- 각 phase의 완료기준이 충족되기 전 다음 phase로 넘어가지 않도록 생성 구조 수준에서 같은 작업 흐름을 강제해야 한다.

## 검증

- 단위 테스트: 해당 없음.
- E2E 테스트: 해당 없음.
- 수동 검증:
  - `sh -n hs-init-project/scripts/materialize_repo.sh`
  - fresh Korean materialize smoke
  - existing English materialize smoke with `src/`, `tests/`, `package.json`
  - `git diff --check`
- 미실행 / 남은 공백: GitHub release workflow 검증은 tag push 이후 원격 Actions에서 확인한다.

## 관련 규칙

- [`rule/rules/planning-roadmap.md`](../../../rule/rules/planning-roadmap.md)
- [`rule/rules/subagent-orchestration.md`](../../../rule/rules/subagent-orchestration.md)
- [`rule/rules/cycle-document-contract.md`](../../../rule/rules/cycle-document-contract.md)
- [`rule/rules/documentation-boundaries.md`](../../../rule/rules/documentation-boundaries.md)
