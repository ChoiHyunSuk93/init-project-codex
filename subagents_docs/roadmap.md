# 프로젝트 로드맵

이 로드맵은 [`PROJECT_OVERVIEW.md`](../PROJECT_OVERVIEW.md)를 기준으로 `hs-init-project`의 phase별 작업과 완료기준을 관리한다.
의존 관계가 있는 다음 phase는 선행 phase가 `PASS`가 되기 전에는 시작하지 않는다.

## 운영 규칙

- 각 phase는 `Status`, `Goal`, `Scope`, `Non-goals`, `Required Checklist`, `Verification`, `Cycle`, `Notes`를 유지한다.
- 구현 cycle은 한 phase 또는 명확한 phase section에 연결한다.
- 필요한 검증이 `FAIL`이면 해당 phase의 checklist와 notes를 갱신하고 같은 phase에서 다시 순환한다.
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

## Phase 2 - Implementation Briefing History Boundary

- `Status`: `PASS`
- `Goal`: 구현 브리핑은 과거 구현 이력으로 보존하고, 새 변경은 새 브리핑 문서로 남기며, 현재 상태 동기화 대상은 README, 오버뷰, 로드맵, guide, rule로 제한한다.
- `Scope`: current repo rule docs, generated templates, starter docs-sync skill metadata, materialize script, current README/overview/roadmap docs
- `Non-goals`: 기존 구현 브리핑 본문 재작성, release tag 생성, installed global skill 갱신
- `Required Checklist`:
  - [x] `docs/implementation/` 기존 브리핑을 current-state sync 대상으로 보지 않도록 rule과 control docs가 명시한다.
  - [x] 새 evaluator-passed 변경은 새 implementation record로 남기도록 current repo와 generated templates가 정렬된다.
  - [x] docs-sync starter skill은 README, guide, rule, roadmap 같은 현재 상태 문서 동기화로 범위가 좁혀진다.
  - [x] `scripts/materialize_repo.sh` fresh/existing generation 경로가 같은 문구를 생성한다.
- `Verification`: `sh -n hs-init-project/scripts/materialize_repo.sh`, fresh Korean materialize smoke, existing English materialize smoke, generated-output `rg` check, `git diff --check`
- `Cycle`: small direct policy change; shared cycle document omitted
- `Notes`: 기존 `docs/implementation/subagent-harness/01-*`부터 `03-*`까지의 과거 브리핑은 현재 변경사항에 맞춰 수정하지 않았다.

## Phase 3 - Parent Model And Reasoning Inheritance

- `Status`: `PASS`
- `Goal`: 기본 subagent 하네스가 모델과 reasoning effort를 고정하지 않고 부모 agent 설정을 그대로 상속한다.
- `Scope`: current/generated agent TOML, skill instructions/reference/metadata, current/generated AGENTS 및 README 문구, 검증 smoke
- `Non-goals`: agent 역할 지침 또는 sandbox 정책 변경, 과거 cycle/implementation 기록 수정, release/tag 생성, installed global skill 갱신
- `Required Checklist`:
  - [x] current repo와 generated planner/generator/evaluator TOML에서 `model`과 `model_reasoning_effort`가 모두 제거된다.
  - [x] current-state rule/doc와 skill metadata가 부모 설정 상속 정책으로 정렬된다.
  - [x] fresh/existing materialize 결과의 세 agent TOML이 모델과 reasoning effort를 명시하지 않는다.
  - [x] skill 구조 검증, shell syntax, TOML parse, generated-output assertion, diff 검사에 통과한다.
- `Verification`: skill quick validation, `sh -n`, current/template TOML parse, fresh Korean materialize smoke, existing English materialize smoke, living-source `rg` assertion, `git diff --check`
- `Cycle`: [`subagents_docs/cycles/32-inherit-agent-model-reasoning.md`](cycles/32-inherit-agent-model-reasoning.md)
- `Notes`: [`Evaluator v1`](cycles/32-inherit-agent-model-reasoning.md)이 current/template TOML, fresh Korean, existing English, living-source drift, diff scope를 재검증해 `PASS`했다. 현재 Codex manual은 custom agent 파일에서 생략한 `model`과 `model_reasoning_effort`가 부모 session에서 상속된다고 명시한다. 기존 구현 브리핑과 완료 cycle은 과거 기록으로 유지한다.

## Phase 4 - Minimal Cross-Agent Rule Harness

- `Status`: `PASS`
- `Goal`: 범용 custom agent와 starter skill을 제거하고 Codex와 Claude Code가 공유할 수 있는 최소 규약 하네스와 안전한 materializer를 제공한다.
- `Scope`: skill instructions/metadata, generated assets, materializer, install docs, validation suite, release workflow
- `Non-goals`: 생성 대상 프로젝트의 도메인 agent/skill, 제품 기능, package/stack, 실제 release/tag 생성, installed global skill 갱신
- `Required Checklist`:
  - [x] 기본 생성물에 custom agent, starter skill, `.codex/config.toml`, 빈 roadmap/cycle/implementation 계층이 없다.
  - [x] generated rule은 project structure, development, testing, documentation, agent workflow의 다섯 관심사로 제한된다.
  - [x] `codex`, `claude`, `both` target이 공통 규약과 얇은 진입점을 생성한다.
  - [x] existing-project mode가 기존 README와 충돌 파일을 명시적 정책 없이 덮어쓰지 않는다.
  - [x] materializer의 문서 본문 source가 assets template로 단일화된다.
  - [x] KO/EN, fresh/existing, target matrix와 metadata/link/index 검증이 PR/release CI에 연결된다.
- `Verification`: skill validation, shell syntax, validation suite, fresh/existing target matrix, generated-output assertions, `git diff --check`
- `Cycle`: [`subagents_docs/cycles/33-minimal-cross-agent-rule-harness.md`](cycles/33-minimal-cross-agent-rule-harness.md)
- `Notes`: [`cycle 33`](cycles/33-minimal-cross-agent-rule-harness.md)의 독립 평가가 최신 working tree와 30개 E2E check를 재검증해 `PASS`했다. 과거 phase와 implementation briefing은 당시 설계 이력으로 보존하며, 새 기본 생성 계약은 Phase 4와 cycle 33을 기준으로 한다.
