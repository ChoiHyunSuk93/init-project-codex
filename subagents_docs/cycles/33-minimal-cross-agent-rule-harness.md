# Minimal Cross-Agent Rule Harness

- `Status`: `PASS`
- `Current Plan Version`: `Evaluator v1`
- `Next Handoff`: `complete`

## Planner v1

- `Provenance`: 사용자의 최종 범위 결정과 앞선 Codex/Claude Code 비교 리뷰를 coordinator가 통합했다.
- `Roadmap Phase`: Phase 4 - Minimal Cross-Agent Rule Harness
- `Goal`: 어떤 프로젝트에도 적용할 수 있는 최소 규약 하네스를 만들고, 프로젝트 전용 agent와 skill은 생성 범위에서 제외한다.
- `Scope`:
  - 기본 custom agent/starter skill/config 제거
  - 다섯 개 공통 규칙과 Codex/Claude 진입점
  - 안전한 fresh/existing materialization
  - template source 단일화
  - 설치 문서, skill metadata, PR/release validation 정렬
- `Non-goals`:
  - 도메인별 agent/skill 생성
  - 생성 대상 프로젝트의 stack, CI, 제품 기능 결정
  - release/tag/push 및 설치된 전역 skill 변경
- `User Outcome`: 사용자는 적은 파일로 시작하고, 사용하는 agent 제품에 관계없이 같은 프로젝트 규약을 발견하며, 기존 문서를 잃지 않는다.
- `Acceptance Criteria`:
  - fresh KO/EN과 codex/claude/both 조합이 예상 최소 파일만 생성한다.
  - existing mode의 기본 동작과 README merge/preserve가 기존 내용을 보존한다.
  - 생성물에 범용 agent/skill/config 및 빈 작업 기록 계층이 없다.
  - rule index와 다섯 rule, Markdown link, metadata가 검증된다.
  - release workflow가 저장소 소유 validation suite를 실행한다.
- `Constraints`:
  - 기존 완료 cycle과 implementation briefing은 수정하지 않는다.
  - generated content는 assets template에만 둔다.
  - 프로젝트 고유 정보는 관찰 없이 추측하지 않는다.
- `Risks`:
  - 기존 CLI 옵션 사용자의 호환성 저하
  - README merge marker 처리 오류
  - current docs와 generated assets 사이의 stale reference
- `Dependencies`: 없음
- `Open Questions`: 없음
- `Next Handoff`: coordinator가 공통 계약을 통합하고 독립 slice를 분배한다.

## Generator v1

- `Implementation Basis`: `Planner v1`
- `Integration`: coordinator가 core contract와 materializer를 구현하고, delegated slice로 Claude adapter, install/metadata docs, validation workflow를 받아 통합했다.
- `Changed Scope`:
  - `hs-init-project/SKILL.md`와 세 reference를 최소 product-neutral harness 계약으로 재작성
  - generated asset을 `AGENTS.md`, `PROJECT_OVERVIEW.md`, optional `CLAUDE.md`, README와 다섯 rule로 축소
  - 범용 `.codex/agents`, `.codex/skills`, config, docs/subagents templates 제거
  - current repo의 범용 custom agent/config 제거와 현재 오케스트레이션 rule 정렬
  - materializer를 asset-only renderer, explicit target/project/readme mode, dry-run, preserve, atomic conflict, symlink guard로 재작성
  - 잘못된 installer `latest` 안내와 metadata 수정
  - PR/release E2E validation workflow 추가
- `Workspace Baseline`: 현재 branch의 `HEAD`를 기준으로 cycle-owned working-tree diff를 검증했다. 기존 완료 cycle과 implementation briefing은 과거 이력으로 수정하지 않았다.
- `Verification`:
  - `python3 hs-init-project/scripts/validate_scaffold.py`: 28 checks, 0 skipped, PASS
  - skill system `quick_validate.py`: PASS (validation suite 내부)
  - fresh KO/EN x codex/claude/both: PASS
  - existing preserve/merge KO/EN x codex/claude/both: PASS
  - unexpected overwrite, invalid merge marker, symlink external write atomic guard: PASS
  - Python compile, workflow/metadata YAML parse, `sh -n`, `git diff --check`: PASS
- `Remaining Risk`: updater network behavior와 GitHub Actions hosted execution은 이번 local run에서 실제 외부 release로 실행하지 않았다.
- `Roadmap Update`: Phase 4 checklist는 독립 evaluator 결과가 확정된 뒤 PASS로 갱신한다.
- `Next Handoff`: evaluator가 acceptance criteria와 generated user surface를 독립 검증한다.

## Evaluator v1

- `Status`: `PASS`
- `Evaluation Target`: `Planner v1`, `Generator v1`, latest cycle-owned working-tree diff
- `Provenance`: fresh read-only evaluation agent가 repository rule, Phase 4 checklist, cycle acceptance를 읽고 제품 diff와 generated surface를 독립 검증했다.
- `Dirty Worktree Basis`: `HEAD` 대비 97-file diff를 legacy baseline 삭제, skill/assets/scripts, 현재 rule/doc, PR/release workflow, cycle 33 범위로 분류했으며 unrelated diff를 찾지 못했다.
- `Verification`:
  - `python3 hs-init-project/scripts/validate_scaffold.py`: 30 checks, 0 skipped, PASS
  - `sh -n hs-init-project/scripts/materialize_repo.sh`: PASS
  - workflow/metadata YAML parse: PASS
  - `git diff --check`: PASS
  - materializer/validator executable mode: PASS
  - root `CLAUDE.md`의 `@AGENTS.md` import와 `rule/index.md` routing: PASS
  - generated content의 asset-only source와 PR/release validation 연결 정적 검토: PASS
- `Acceptance Criteria`:
  - KO/EN과 codex/claude/both 최소 inventory: PASS
  - generic custom agent/skill/config와 빈 작업 계층 미생성: PASS
  - existing README preserve/merge와 conflict atomicity: PASS
  - five-rule index, metadata, link, install-ref 정합성: PASS
  - 과거 implementation briefing와 완료 cycle 보존: PASS
- `Findings Resolved During Evaluation`:
  - materializer executable bit 회귀를 복원했다.
  - 새 하네스가 없는 `v0.3.5` 설치 예시를 현재 README와 일치하는 `main`으로 바꾸고 stale ref 재발 검증을 추가했다.
- `Remaining Gaps`: GitHub-hosted Actions와 실제 release/tag, updater network 동작은 외부 실행하지 않았다. local `actionlint`와 `shellcheck`가 없어 workflow YAML parse와 `sh -n`, E2E suite로 대체했다.
- `Roadmap Gate`: Phase 4 checklist 전체 충족. 다음 의존 phase 진입 가능.
- `Next Handoff`: complete
