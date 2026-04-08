Status: PASS
Current Plan Version: Evaluator v1
Next Handoff: complete

# 31-adaptive-subagent-harness

## Planner v1

신규 cycle: 사용자 요청으로 시작한 신규 계획이며, 선행 evaluator 섹션에서 유도된 재계획은 아니다.

### 목표

- 현재 저장소와 `hs-init-project` 생성 자산이 동일한 adaptive subagent harness를 설명하도록 정렬한다.
- 작업 규모별 기본 흐름을 `small`, `medium`, `large/ambiguous`로 나눠 작은 작업의 planning overhead를 낮추고, 큰 작업의 계획 사이클은 유지한다.
- agent reasoning 기본값을 `high`로 맞추되 작업 특성에 따라 조정 가능하다는 정책을 명시한다.

### 범위

- 현재 저장소의 하네스 설명과 제어 문서 정렬: `AGENTS.md`, `README.md`, `README.ko.md`, `rule/rules/subagent-orchestration.md`, `rule/rules/subagents-docs.md`, `subagents_docs/AGENTS.md`, `.codex/agents/*.toml`
- skill source of truth 정렬: `hs-init-project/SKILL.md`, `hs-init-project/agents/openai.yaml`, `hs-init-project/references/subagent-orchestration.md`
- 생성 자산 정렬: `hs-init-project/assets/AGENTS/root.*.md`, `hs-init-project/assets/README/root.*.md`, `hs-init-project/assets/rule/subagent-orchestration.*.md`, `hs-init-project/assets/subagents_docs/AGENTS.*.md`, `hs-init-project/assets/.codex/agents/*.toml`, `hs-init-project/assets/.codex/skills/change-analysis/*`, `hs-init-project/assets/.codex/skills/code-implementation/*`, `hs-init-project/assets/.codex/skills/quality-review/*`
- 필요한 경우 `hs-init-project/scripts/materialize_repo.sh`의 생성/inspect 안내와 baseline 출력 설명을 위 변경과 맞춘다.

### 비범위

- cycle document contract의 schema나 header 규칙 자체를 재설계하지 않는다.
- `docs/implementation/` 사용자-facing 브리핑 모델을 변경하지 않는다.
- `test-debug`, `docs-sync` starter skill, 기타 unrelated rule/template, 실제 runtime 기능을 이번 변경 범위에 포함하지 않는다.
- planner/generator/evaluator를 완전히 폐기하거나 evaluator를 main agent와 통합하지 않는다.

### 사용자 관점 결과

- 작은 변경은 main agent 또는 generator가 곧바로 구현으로 들어가고 evaluator는 별도 검증 역할로 남는다.
- 중간 규모 변경은 짧은 plan을 남긴 뒤 generator와 evaluator가 이어받는다.
- 크거나 모호한 변경은 기존처럼 `planner -> generator -> evaluator` cycle을 사용한다.
- main agent는 필요할 때 적절한 subagent를 자율적으로 선택해 호출할 수 있고, 문서 분석에서는 병렬 explorer 호출이 허용된다.
- cycle 문서를 여는 경우에는 기존 cycle document contract가 계속 authoritative이며, reasoning 기본값은 `high`로 보이되 task별 조정이 가능하다.

### Acceptance Criteria

- 현재 저장소 규칙, README, agent config와 generated template가 모두 `small`, `medium`, `large/ambiguous` 분기와 각 분기의 handoff 규칙을 같은 의미로 설명한다.
- `small` 경로에서 planner 선행 없이 main agent 또는 generator가 직접 구현을 시작할 수 있고 evaluator는 별도 유지된다는 점이 명시된다.
- `medium` 경로에서 짧은 계획 후 `generator -> evaluator`로 진행한다는 점이 명시된다.
- `large/ambiguous` 경로에서 `planner -> generator -> evaluator`가 기본이라는 점이 유지된다.
- main agent의 자율적 subagent 호출 가능성과 문서 분석용 병렬 explorer 규칙이 현재 저장소 문서와 generated asset에 모두 반영된다.
- 현재 저장소 `.codex/agents/*.toml`과 generated `.codex/agents/*.toml` 기본 reasoning이 `high`로 맞춰지고, 관련 설명 문구가 `high` 기본값 및 task별 조정 가능 정책과 일치한다.
- cycle document contract는 여전히 cycle 문서의 authoritative 규칙으로 참조되며, 다른 문서가 별도 contract를 정의하지 않는다.

### 제약

- planner는 planning 문서만 만들고 구현 세부 단계나 코드 수준 해법을 확정하지 않는다.
- 작업 기록과 사용자-facing 문서의 경계를 유지한다.
- 한국어와 영어 asset 쌍은 의미상 동기화돼야 한다.
- 사용자 요청에 포함된 파일군 안에서만 변경 범위를 설계한다.
- adaptive harness 설명은 기존 append-only cycle 문서 모델과 충돌하지 않아야 한다.

### 위험

- 현재의 orchestration-only 서술과 `small` 경로의 direct implementation 허용 문구가 충돌할 수 있다.
- cycle 문서를 언제 여는지 기준이 문서마다 다르면 generated repo 사용자에게 혼란을 줄 수 있다.
- `high` reasoning 기본값 변경이 현재 repo agent 설정, skill metadata, template 설명 중 일부에만 반영되면 drift가 생긴다.
- 병렬 explorer 규칙이 analysis-only 상황과 implementation cycle 진입 조건을 흐릴 수 있다.

### 의존관계

- 현재 저장소 문서, skill source of truth, generated asset, starter local skill 설명이 같은 adaptive harness 모델을 공유해야 한다.
- `rule/rules/subagent-orchestration.md`와 `subagents_docs/AGENTS.md` 계열 문구가 기준이 되어 나머지 README와 asset 문구가 이에 맞춰 정렬돼야 한다.
- `hs-init-project/scripts/materialize_repo.sh`는 template 복사 및 inspect 안내가 바뀐 baseline과 충돌하지 않아야 한다.

### Open Questions

- 없음. 이번 계획은 `small` 경로에서는 cycle 문서를 열지 않아도 되며, 작업이 커지거나 모호해지면 `medium` 또는 `large/ambiguous` 경로로 승격해 cycle document contract를 적용하는 방향을 기준으로 한다.

### 다음 Handoff

- `generator`: 현재 저장소 문서, agent config, skill source, generated template, starter local skill, 필요 시 materialize script를 위 adaptive harness 기준으로 정렬한다.

## Planner v2

이전 `Planner v1`은 사용자 후속 clarification 이전의 초안이었다.
이번 섹션은 사용자가 확정한 실행 모델을 기준으로 `Planner v1`을 supersede한다.

### 목표

- 현재 저장소 규칙과 `hs-init-project` 생성물이 아래의 실제 운영 모델을 동일하게 설명하도록 정렬한다.
- 메인 에이전트가 큰 변경일수록 더 많은 통합 책임을 갖는다는 원칙을 규칙과 생성물에 반영한다.
- reasoning 기본값을 `high`로 맞추고 task별 조정 가능 정책을 현재 repo와 generated template에 함께 반영한다.

### 범위

- 현재 저장소: `AGENTS.md`, `README.md`, `README.ko.md`, `rule/index.md`, `rule/rules/subagent-orchestration.md`, `rule/rules/subagents-docs.md`, `rule/rules/cycle-document-contract.md`, `rule/rules/instruction-model.md`, `subagents_docs/AGENTS.md`, `.codex/agents/*.toml`
- skill source: `hs-init-project/SKILL.md`, `hs-init-project/agents/openai.yaml`, `hs-init-project/references/subagent-orchestration.md`
- 생성 템플릿: `hs-init-project/assets/AGENTS/root.*.md`, `hs-init-project/assets/README/root.*.md`, `hs-init-project/assets/rule/index.*.md`, `hs-init-project/assets/rule/cycle-document-contract.*.md`, `hs-init-project/assets/rule/subagent-orchestration.*.md`, `hs-init-project/assets/subagents_docs/AGENTS.*.md`, `hs-init-project/assets/.codex/agents/*.toml`, `hs-init-project/assets/.codex/skills/change-analysis/*`
- 생성 스크립트: `hs-init-project/scripts/materialize_repo.sh`

### 비범위

- `docs/implementation/` 브리핑 모델 변경
- `test-debug`, `docs-sync`, `code-implementation`, `quality-review` starter skill의 의미 변경
- runtime 구조, README 설치 방식, GitHub workflow 정책 변경

### 사용자 관점 결과

- 작은 변경은 `main/generator -> evaluator`로 처리한다.
- 중간 변경은 `main(plan+implementation) -> evaluator`로 처리한다.
- 큰 변경이지만 비교적 명확하면 `main-led decomposition + delegated implementation + evaluator`로 처리한다.
- 큰 변경이면서 모호하면 `parallel explorer analysis + planner assist if needed + main-approved plan + delegated implementation + evaluator`로 처리한다.
- 문서 분석은 독립적인 질문 단위로 병렬 `explorer`를 우선 사용한다.
- cycle working document가 필요한 경우 기존의 append-only cycle 형식은 유지한다.

### Acceptance Criteria

- 현재 저장소와 generated template가 모두 네 가지 실행 모드를 같은 의미로 설명한다.
- main agent의 자율적 subagent 호출 가능성과 병렬 explorer 분석 규칙이 현재 저장소와 generated output source-of-truth에 모두 반영된다.
- medium 경로가 `main(plan+implementation) -> evaluator`로, large-clear 경로가 `main-led decomposition + delegated implementation + evaluator`로, large-ambiguous 경로가 `parallel explorer analysis + planner assist if needed + main-approved plan + delegated implementation + evaluator`로 명시된다.
- cycle document contract는 cycle-backed work에 계속 authoritative하게 적용되며, small direct change는 cycle 문서를 생략할 수 있다는 점이 명시된다.
- 현재 저장소 `.codex/agents/*.toml`과 generated `.codex/agents/*.toml`의 reasoning 기본값이 `high`로 정렬된다.

### 제약

- append-only cycle 모델은 유지한다.
- 한국어와 영어 자산 쌍은 의미상 동기화돼야 한다.
- generated output의 fresh path와 existing-project script path가 drift 없이 같은 정책을 생성해야 한다.

### 위험

- current repo와 generated template 중 한쪽만 갱신하면 하네스 설명이 drift 날 수 있다.
- existing-project mode script 경로에서 fresh template와 다른 wording이 남을 수 있다.
- cycle 문서 적용 범위와 small direct change 예외가 불명확하면 운영자가 혼동할 수 있다.

### 의존관계

- `rule/rules/subagent-orchestration.md`
- `rule/rules/subagents-docs.md`
- `rule/rules/cycle-document-contract.md`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/scripts/materialize_repo.sh`

### Open Questions

- 없음. 사용자 clarification으로 실행 모델이 확정됐다.

### 다음 Handoff

- `generator`: 확정된 네 가지 실행 모드, main integration 책임, parallel explorer 분석 규칙, `high` reasoning 기본값을 current repo와 generated source-of-truth 전체에 반영한다.

## Generator v1

### planner section reference

- `Planner v2`

### 실제 반영한 범위

- current repo의 root guidance, rule, README, local agent prompt를 adaptive harness 기준으로 갱신했다.
- cycle contract를 cycle-backed work에 적용되는 계약으로 좁히고, coordinator 또는 delegated role이 phase section을 남길 수 있게 정리했다.
- `hs-init-project` source-of-truth와 generated template를 같은 adaptive model, `high` reasoning 기본값, parallel explorer analysis 규칙으로 맞췄다.
- existing-project mode에서 직접 생성하는 `subagents-docs` rule과 `change-analysis` skill 본문이 fresh template와 같은 의미를 출력하도록 `materialize_repo.sh`를 갱신했다.

### 변경 파일 목록

- `AGENTS.md`
- `README.md`
- `README.ko.md`
- `rule/index.md`
- `rule/rules/cycle-document-contract.md`
- `rule/rules/instruction-model.md`
- `rule/rules/subagent-orchestration.md`
- `rule/rules/subagents-docs.md`
- `subagents_docs/AGENTS.md`
- `.codex/agents/planner.toml`
- `.codex/agents/generator.toml`
- `.codex/agents/evaluator.toml`
- `hs-init-project/SKILL.md`
- `hs-init-project/agents/openai.yaml`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/assets/AGENTS/root.en.md`
- `hs-init-project/assets/AGENTS/root.ko.md`
- `hs-init-project/assets/README/root.en.md`
- `hs-init-project/assets/README/root.ko.md`
- `hs-init-project/assets/rule/index.en.md`
- `hs-init-project/assets/rule/index.ko.md`
- `hs-init-project/assets/rule/cycle-document-contract.en.md`
- `hs-init-project/assets/rule/cycle-document-contract.ko.md`
- `hs-init-project/assets/rule/subagent-orchestration.en.md`
- `hs-init-project/assets/rule/subagent-orchestration.ko.md`
- `hs-init-project/assets/subagents_docs/AGENTS.en.md`
- `hs-init-project/assets/subagents_docs/AGENTS.ko.md`
- `hs-init-project/assets/.codex/agents/planner.toml`
- `hs-init-project/assets/.codex/agents/generator.toml`
- `hs-init-project/assets/.codex/agents/evaluator.toml`
- `hs-init-project/assets/.codex/skills/change-analysis/SKILL.en.md`
- `hs-init-project/assets/.codex/skills/change-analysis/SKILL.ko.md`
- `hs-init-project/assets/.codex/skills/change-analysis/agents/openai.en.yaml`
- `hs-init-project/assets/.codex/skills/change-analysis/agents/openai.ko.yaml`
- `hs-init-project/scripts/materialize_repo.sh`

### 검증에 사용한 workspace/baseline scope

- baseline은 clean worktree였다.
- 검증 범위는 current repo diff와 fresh/en + existing/ko materialize smoke까지 포함했다.

### 검증 명령

- `git diff --check`
- `sh -n hs-init-project/scripts/materialize_repo.sh`
- fresh English materialize smoke
```sh
tmpdir=$(mktemp -d)
sh hs-init-project/scripts/materialize_repo.sh "$tmpdir" --language en >/dev/null
rg -n --fixed-strings 'Generated repositories use an adaptive harness rather than one fixed pipeline.' "$tmpdir/README.md"
rg -n --fixed-strings 'Default path: `main/generator -> evaluator`' "$tmpdir/rule/rules/subagent-orchestration.md"
rg -n --fixed-strings 'model_reasoning_effort = "high"' "$tmpdir/.codex/agents/planner.toml"
rg -n --fixed-strings 'Prefer parallel `explorer` calls for independent document-analysis questions.' "$tmpdir/.codex/skills/change-analysis/SKILL.md"
rm -rf "$tmpdir"
```
- existing-project Korean materialize smoke
```sh
tmpdir=$(mktemp -d)
mkdir -p "$tmpdir/src"
sh hs-init-project/scripts/materialize_repo.sh "$tmpdir" --language ko --readme-mode existing --source-root-dir src >/dev/null
rg -n --fixed-strings '`main(plan+implementation) -> evaluator`' "$tmpdir/rule/rules/subagents-docs.md"
rg -n --fixed-strings '작업을 `small`, `medium`, `large-clear`, `large-ambiguous`로 분류한 뒤 하네스 경로를 고른다.' "$tmpdir/.codex/skills/change-analysis/SKILL.md"
rg -n --fixed-strings '병렬 `explorer` 호출을 우선 고려한다.' "$tmpdir/.codex/skills/change-analysis/SKILL.md"
rg -n --fixed-strings 'model_reasoning_effort = "high"' "$tmpdir/.codex/agents/generator.toml"
rm -rf "$tmpdir"
```

### 검증 결과

- `git diff --check` 통과
- `materialize_repo.sh` shell syntax check 통과
- fresh English generated output에서 adaptive harness, `main/generator -> evaluator`, `high` reasoning 기본값, parallel explorer analysis wording을 확인했다.
- existing-project Korean generated output에서 medium path wording, change-analysis 분류/parallel explorer wording, `high` reasoning 기본값을 확인했다.

### 남은 위험과 제약

- 이번 cycle은 starter skill 중 `change-analysis`만 의미 변경을 반영했고, `code-implementation`과 `quality-review`는 기존 의미가 새 모델과 충돌하지 않는 범위에서 유지했다.
- historical cycle 문서들은 과거 wording을 그대로 유지한다.

### 다음 Handoff

- `evaluator`: `Planner v2`와 `Generator v1` 기준으로 current repo 규칙/README/.codex와 fresh/existing generated output이 같은 adaptive harness를 설명하는지 판정한다.

## Evaluator v1

### 판정

- PASS

### planner section reference

- `Planner v2`

### generator section reference

- `Generator v1`

### acceptance criteria 판정

- 충족. current repo와 generated source-of-truth가 모두 `small`, `medium`, `large-clear`, `large-ambiguous` 네 가지 실행 모드를 같은 의미로 설명한다.
- 충족. main agent의 자율 subagent 호출 가능성과 병렬 `explorer` 분석 규칙이 current repo와 generated source-of-truth에 반영됐다.
- 충족. current repo와 generated `.codex/agents/*.toml`의 reasoning 기본값이 `high`로 정렬됐다.
- 충족. cycle document contract는 cycle-backed work에 적용되는 authoritative 규칙으로 남았고, small direct change는 cycle 문서를 생략할 수 있다는 범위가 명시됐다.
- 충족. fresh English materialize와 existing-project Korean materialize에서 핵심 wording이 실제 생성물로 확인됐다.

### 실제 검증 절차

- `git diff --check`
- `sh -n hs-init-project/scripts/materialize_repo.sh`
- `git status --short`
- `rg -n --fixed-strings 'main(plan+implementation) -> evaluator' AGENTS.md README.md README.ko.md rule/rules/subagent-orchestration.md rule/rules/subagents-docs.md subagents_docs/AGENTS.md hs-init-project/SKILL.md hs-init-project/references/subagent-orchestration.md hs-init-project/assets/AGENTS/root.en.md hs-init-project/assets/AGENTS/root.ko.md hs-init-project/assets/README/root.en.md hs-init-project/assets/README/root.ko.md hs-init-project/assets/rule/subagent-orchestration.en.md hs-init-project/assets/rule/subagent-orchestration.ko.md hs-init-project/assets/subagents_docs/AGENTS.en.md hs-init-project/assets/subagents_docs/AGENTS.ko.md`
- `rg -n --fixed-strings 'parallel \`explorer\`' AGENTS.md README.md README.ko.md rule/rules/subagent-orchestration.md rule/rules/subagents-docs.md subagents_docs/AGENTS.md hs-init-project/SKILL.md hs-init-project/references/subagent-orchestration.md hs-init-project/assets/AGENTS/root.en.md hs-init-project/assets/AGENTS/root.ko.md hs-init-project/assets/README/root.en.md hs-init-project/assets/README/root.ko.md hs-init-project/assets/rule/subagent-orchestration.en.md hs-init-project/assets/rule/subagent-orchestration.ko.md hs-init-project/assets/subagents_docs/AGENTS.en.md hs-init-project/assets/subagents_docs/AGENTS.ko.md hs-init-project/assets/.codex/skills/change-analysis/SKILL.en.md hs-init-project/assets/.codex/skills/change-analysis/SKILL.ko.md`
- `rg -n --fixed-strings 'model_reasoning_effort = "high"' .codex/agents hs-init-project/assets/.codex/agents`
- fresh English materialize smoke
- existing-project Korean materialize smoke

### 관찰 결과

- whitespace/diff check가 통과했다.
- `materialize_repo.sh` shell syntax check가 통과했다.
- current repo의 rule/README/.codex와 generated asset들이 모두 same adaptive harness vocabulary를 사용한다.
- fresh English generated output에서 adaptive harness, `main/generator -> evaluator`, `high` reasoning 기본값, parallel explorer wording이 실제로 생성됐다.
- existing-project Korean generated output에서 `main(plan+implementation) -> evaluator`, change-analysis 분류 규칙, parallel explorer wording, `high` reasoning 기본값이 실제로 생성됐다.
- 검증 중 생긴 stray empty file `evaluator`, `generator`는 cycle-owned 산출물이 아니어서 제거했다.

### dirty worktree 비교 기준

- baseline은 clean worktree였다.
- 현재 dirty worktree는 cycle 31이 소유한 규칙/README/.codex/source-of-truth 수정과 신규 cycle 문서만 포함한다.
- stray empty file `evaluator`, `generator`는 검증 과정에서 생긴 비의도 산출물이라 제거했고, PASS/FAIL 기준에서는 제외했다.
- unrelated tracked diff는 관찰하지 않았다.

### 문제 목록

- 없음. acceptance criteria를 깨는 residual finding은 관찰하지 않았다.

### 품질 평가

- design quality: high
- originality: medium-high
- completeness: high
- functionality: high
- overall: PASS

### 다음 Handoff

- complete
