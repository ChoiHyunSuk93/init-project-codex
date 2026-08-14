# Documentation And Existing-Project Semantic Retrofit

- `Status`: `PASS`
- `Current Plan Version`: `Evaluator v1`
- `Next Handoff`: `complete`

## Planner v1

- `Provenance`: 사용자의 회귀 지적과 수정 요청을 coordinator가 현재 `v1.0.0` 생성 계약, assets, materializer, validation suite와 대조해 직접 작성했다.
- `Roadmap Phase`: Phase 5 - Documentation And Existing-Project Semantic Retrofit
- `Goal`: 기본 `docs/` 진입점과 adaptive work record를 복구하고 existing-project 초기화를 실제 코드 분석과 의미 있는 문서 반영까지 이어지는 완료 가능한 workflow로 만든다.
- `Scope`:
  - `docs/guide/README.md`, `docs/implementation/AGENTS.md` KO/EN asset과 materialization
  - `subagents_docs/AGENTS.md`, `subagents_docs/roadmap.md`와 필요 시 생성하는 append-only cycle 계약
  - existing-project 실제 source/config/test/docs 분석 절차
  - unresolved semantic marker와 필수 산출물을 검사하는 completion validator
  - fresh/existing, KO/EN, codex/claude/both E2E와 대표 semantic retrofit fixture
  - skill metadata 및 current user-facing 문서 정렬
- `Non-goals`:
  - 범용 custom agent, starter skill, `.codex/config.toml` 복구
  - 모든 작은 직접 변경에 cycle 문서 강제
  - shell script가 임의 코드베이스의 제품 의미를 자동 추측하도록 구현
  - release/tag/push 또는 설치된 skill 변경
- `User Outcome`: 사용자는 초기화 직후 실제 문서와 작업 기록 진입점을 얻고, 기존 코드 프로젝트에서는 placeholder가 아니라 관찰된 구조·흐름·명령이 반영된 기준 문서와 추적 가능한 작업 이력을 받는다.
- `Acceptance Criteria`:
  - 모든 생성 matrix에 두 `docs/` control document가 존재하고 링크가 유효하다.
  - generated roadmap은 프로젝트 요구사항에서 phase를 파생하고, 중간 이상 변경이나 work-sharing은 main-owned append-only cycle에 provenance를 남기며, 검증 완료 결과는 category 기반 implementation briefing으로 누적한다.
  - existing-project 지침은 디렉터리 나열을 분석으로 간주하지 않고 source entrypoint, 주요 module 책임, manifest/config, 실행·빌드·테스트 진입점과 기존 문서를 근거로 요구한다.
  - raw template scaffold는 semantic completion 검사에 실패한다.
  - 대표 existing fixture는 관찰된 path와 명령을 반영한 뒤 semantic completion 검사에 통과한다.
  - 기존 README/source 보존, atomic conflict, symlink guard와 다섯-rule 계약은 회귀하지 않는다.
- `Constraints`:
  - generated prose의 source of truth는 `assets/`에 둔다.
  - 기존 의미 있는 `PROJECT_OVERVIEW.md`와 user-owned docs는 명시적 승인 없이 덮어쓰지 않는다.
  - 관찰되지 않은 stack, 명령, 사용자 흐름은 문서에 확정하지 않는다.
- `Risks`:
  - 형식 검증만 통과시키고 실제 분석이 부실할 수 있으므로 skill workflow에 evidence 요구를 명시해야 한다.
  - 기존 `docs/`와 새 control path의 충돌을 materializer가 원자적으로 처리해야 한다.
  - README preserve mode에서도 새 docs entrypoint가 발견 가능해야 한다.
- `Dependencies`: Phase 4 `PASS`; current five-rule harness와 atomic materializer를 기반으로 확장한다.
- `Open Questions`: 없음.
- `Next Handoff`: coordinator가 assets와 completion contract를 구현하고 전체 E2E를 검증한다.

## Generator v1

- `Implementation Basis`: `Planner v1`과 사용자의 추가 work-record 질문을 기준으로 coordinator가 직접 구현했다. 이번 cycle에서는 delegated agent를 실행하지 않았다.
- `Changed Scope`:
  - `SKILL.md`와 `existing-project-analysis.md`에 materialization 이후 실제 source/config/test/docs 분석과 semantic completion gate를 추가했다.
  - KO/EN `docs/guide/README.md`, `docs/implementation/AGENTS.md`, `subagents_docs/AGENTS.md`, `subagents_docs/roadmap.md` assets를 복구했다.
  - generated five-rule harness에 관찰된 구조·관례·검증·문서 map marker와 main/subagent provenance, append-only cycle, implementation history 계약을 반영했다.
  - materializer가 docs/work-record files와 `subagents_docs/cycles/`를 안전하게 생성하고 conflict/dry-run inventory에 포함하도록 확장했다.
  - `validate_materialized_repo.py`를 추가해 필수 경로, unresolved marker, roadmap phase, Markdown link와 existing-project repository-relative evidence를 검사한다.
  - validation fixture에 실제 source/config/test script를 두고 raw template 실패와 evidence-based retrofit 통과를 검증했다.
  - root README/overview/guide/rule과 `agents/openai.yaml`을 새 계약에 맞췄다.
- `Workspace Baseline`: `HEAD`(`f102d01`) 대비 cycle-owned working-tree diff를 기준으로 구현했다. 작업 시작 시 unrelated diff는 없었다.
- `Verification`:
  - skill-creator `quick_validate.py hs-init-project`: PASS
  - `sh -n hs-init-project/scripts/materialize_repo.sh`: PASS
  - `python3 -m py_compile ...validate_materialized_repo.py ...validate_scaffold.py`: PASS
  - `python3 hs-init-project/scripts/validate_scaffold.py`: 34 checks, 0 skipped, PASS
  - `git diff --check`: PASS
- `Remaining Risk`: deterministic validator는 factual quality의 하한선이며, 실제 초기화에서는 invoking agent가 읽은 source/config/test/docs와 문서 내용을 대조해야 한다.
- `Roadmap Update`: Phase 5 checklist는 `Evaluator v1` 판정에 따라 `PASS`로 갱신한다.
- `Next Handoff`: coordinator가 evaluator 역할로 acceptance criteria와 전체 생성 surface를 검증한다.

## Evaluator v1

- `Status`: `PASS`
- `Evaluation Target`: `Planner v1`, `Generator v1`, `HEAD` 대비 cycle-owned working-tree diff
- `Provenance`: coordinator가 main-agent evaluator 역할로 최신 파일과 실행 결과를 직접 검토했다. 독립 subagent 평가는 이번 실행 범위에 포함하지 않았다.
- `Dirty Worktree Basis`: 작업 시작 시 clean `HEAD`였으며 현재 변경을 skill contract, KO/EN assets, scripts/tests, current docs/rules, roadmap/cycle로 분류했다. unrelated 사용자 변경은 발견하지 못했다.
- `Verification`:
  - `/Users/choehyeonseog/.codex/skills/.system/skill-creator/scripts/quick_validate.py hs-init-project`: PASS
  - `sh -n hs-init-project/scripts/materialize_repo.sh`: PASS
  - 두 Python validator `py_compile`: PASS
  - `python3 hs-init-project/scripts/validate_scaffold.py`: 34 checks, 0 skipped, PASS
  - fresh/existing, KO/EN, codex/claude/both inventory와 Markdown link/index: PASS
  - raw existing scaffold semantic gate 실패 assertion: PASS
  - 실제 `src/keep.txt`, `pyproject.toml`, `scripts/test.sh`, `tests/test_keep.py` 근거와 실행 가능한 test script를 반영한 completion fixture: PASS
  - README preserve/merge, unexpected overwrite atomicity, invalid marker, symlink guard, explicit preserve: PASS
  - `git diff --check`: PASS
- `Acceptance Criteria`:
  - 모든 생성 matrix의 docs와 work-record entrypoint: PASS
  - main/subagent provenance, append-only cycle, verified implementation history 계약: PASS
  - existing-project actual source/config/test/docs 분석 지침: PASS
  - placeholder-only 완료 차단과 real path evidence gate: PASS
  - metadata, reference, README, validator 정렬: PASS
- `Findings Resolved During Evaluation`:
  - 사용자의 추가 질문을 반영해 `docs/`뿐 아니라 roadmap/cycle/implementation history 계층을 baseline에 복구했다.
  - legacy README placeholder 두 곳도 공통 semantic marker로 통일해 completion validator가 누락을 잡도록 했다.
  - validation fixture의 검증 명령을 추측하지 않고 실제 `scripts/test.sh` 정의와 실행 결과에 연결했다.
- `Remaining Gaps`: 실제 외부 GitHub 설치, hosted Actions, release/tag는 이번 요청 범위가 아니어서 실행하지 않았다. 독립 agent forward-test도 수행하지 않았으며, E2E fixture와 main-agent 검토로 현재 gate를 판정했다.
- `Roadmap Gate`: Phase 5 checklist 전체 충족. 다음 의존 phase 진입 가능.
- `Next Handoff`: complete
