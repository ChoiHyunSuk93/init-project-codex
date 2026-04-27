# 프로젝트 로드맵

이 로드맵은 [`PROJECT_OVERVIEW.md`](../PROJECT_OVERVIEW.md)를 기준으로 `hs-init-project`의 phase별 작업과 완료기준을 관리한다.
의존 관계가 있는 다음 phase는 선행 phase가 `PASS`가 되기 전에는 시작하지 않는다.

## 운영 규칙

- 각 phase는 `Status`, `Goal`, `Scope`, `Non-goals`, `Required Checklist`, `Verification`, `Cycle`, `Notes`를 유지한다.
- 구현 cycle은 한 phase 또는 명확한 phase section에 연결한다.
- evaluator가 `FAIL`을 기록하면 해당 phase의 checklist와 notes를 갱신하고 같은 phase에서 다시 순환한다.
- phase가 `PASS`가 되면 검수 근거와 연결 cycle을 이 문서에 반영한 뒤 다음 phase로 넘어간다.

## Phase 1 - Overview/Roadmap Gate Baseline

- `Status`: `PASS`
- `Goal`: 생성 구조에 프로젝트 오버뷰, phase 로드맵, phase별 완료 체크리스트, 다음 phase 진입 gate를 기본 흐름으로 추가한다.
- `Scope`: skill instructions, references, rule docs, templates, starter skills, materialize script, current repo navigation docs
- `Non-goals`: release tag 생성, installed global skill 갱신, 생성 대상 프로젝트의 제품 기능 정의
- `Required Checklist`:
  - [x] root `PROJECT_OVERVIEW.md`와 `subagents_docs/roadmap.md`가 생성 대상 산출물에 포함된다.
  - [x] `rule/rules/planning-roadmap.md`가 current repo와 generated rule index에 등재된다.
  - [x] `SKILL.md`, references, root templates, rule templates, `subagents_docs` templates가 phase-gate 흐름을 설명한다.
  - [x] `scripts/materialize_repo.sh` fresh/existing generation 경로가 overview, roadmap, planning-roadmap rule을 생성한다.
  - [x] 생성된 fresh/existing smoke output에서 새 산출물과 새 rule이 확인된다.
- `Verification`: `sh -n hs-init-project/scripts/materialize_repo.sh`, fresh Korean materialize smoke, existing English materialize smoke, `git diff --check`
- `Cycle`: `subagents_docs/cycles/[NN-phase-slug].md`
- `Notes`: release와 installed skill 갱신은 사용자가 별도로 요청할 때 진행한다. Smoke output에서 `PROJECT_OVERVIEW.md`, `subagents_docs/roadmap.md`, `rule/rules/planning-roadmap.md` 생성을 확인했다.
