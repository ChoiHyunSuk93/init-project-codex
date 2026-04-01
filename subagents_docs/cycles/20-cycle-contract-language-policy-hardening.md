# 20 Cycle Contract Language Policy Hardening

- Status: PASS
- Current Plan Version: Evaluator v1
- Next Handoff: complete

## Planner v1

### 목표

- cycle 문서 계약을 전용 rule로 분리해 current repo와 generated skill 구조에 함께 반영한다.
- coordinator header 상태 전이 규칙과 role section provenance 규칙을 형식화한다.
- dirty worktree에서도 cycle-scoped acceptance를 증명할 수 있는 evaluator 기준을 추가한다.
- 언어 정책을 전용 rule로 승격하고 current repo 규칙과 `hs-init-project` generated output에 함께 적용한다.

### 구조 결정

- 신규 global rule 2개를 추가한다.
  - `rule/rules/cycle-document-contract.md`
  - `rule/rules/language-policy.md`
- `cycle-document-contract.md`는 다음을 authoritative하게 정의한다.
  - `subagents_docs/cycles/<NN>-<slug>.md` 경로 규약
  - 상단 header 필드 `Status`, `Current Plan Version`, `Next Handoff`
  - coordinator의 header 갱신 시점과 상태 전이
  - `Planner vN` / `Generator vN` / `Evaluator vN` append-only 규칙
  - role section reference와 provenance 필수 항목
- `language-policy.md`는 다음을 authoritative하게 정의한다.
  - current repo의 기본 문서 언어 원칙
  - control filename/path/code literal은 영어 유지
  - 사람이 읽는 rule/doc/subagents_docs 본문 언어 규칙
  - generated skill의 selected language 적용 원칙
- 기존 `subagent-orchestration.md`, `subagents-docs.md`, `documentation-boundaries.md`는 전용 rule을 재서술하지 않고 참조 중심으로 줄인다.

### current repo 대상 파일

- `rule/index.md`
- 신규 `rule/rules/cycle-document-contract.md`
- 신규 `rule/rules/language-policy.md`
- `rule/rules/subagent-orchestration.md`
- `rule/rules/subagents-docs.md`
- 필요 시 `rule/rules/documentation-boundaries.md`
- `AGENTS.md`
- `subagents_docs/AGENTS.md`
- `docs/guide/subagent-workflow.md`
- `.codex/agents/planner.toml`
- `.codex/agents/generator.toml`
- `.codex/agents/evaluator.toml`

### generated skill 대상 파일

- `hs-init-project/SKILL.md`
- `hs-init-project/references/language-output.md`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/references/structure-initialization.md`
- 신규 asset rule template 4개
  - `hs-init-project/assets/rule/cycle-document-contract.en.md`
  - `hs-init-project/assets/rule/cycle-document-contract.ko.md`
  - `hs-init-project/assets/rule/language-policy.en.md`
  - `hs-init-project/assets/rule/language-policy.ko.md`
- `hs-init-project/assets/rule/index.en.md`
- `hs-init-project/assets/rule/index.ko.md`
- `hs-init-project/assets/rule/subagent-orchestration.en.md`
- `hs-init-project/assets/rule/subagent-orchestration.ko.md`
- 필요 시 `hs-init-project/assets/rule/documentation-boundaries.en.md`
- 필요 시 `hs-init-project/assets/rule/documentation-boundaries.ko.md`
- `hs-init-project/assets/subagents_docs/AGENTS.en.md`
- `hs-init-project/assets/subagents_docs/AGENTS.ko.md`
- `hs-init-project/assets/docs/guide/subagent-workflow.en.md`
- `hs-init-project/assets/docs/guide/subagent-workflow.ko.md`
- `hs-init-project/assets/AGENTS/root.en.md`
- `hs-init-project/assets/AGENTS/root.ko.md`
- `hs-init-project/assets/.codex/agents/planner.toml`
- `hs-init-project/assets/.codex/agents/generator.toml`
- `hs-init-project/assets/.codex/agents/evaluator.toml`
- `hs-init-project/scripts/materialize_repo.sh`

### 계약 보강 항목

- coordinator header 상태 전이
  - planner 문서 생성 직후: `Status: in_progress`, `Current Plan Version: Planner vN`, `Next Handoff: generator`
  - generator 완료 후: `Status: in_progress`, `Current Plan Version: Generator vN`, `Next Handoff: evaluator`
  - evaluator `PASS` 후: `Status: PASS`, `Current Plan Version: Evaluator vN`, `Next Handoff: complete`
  - evaluator `FAIL` 후: `Status: FAIL`, `Current Plan Version: Evaluator vN`, `Next Handoff: planner`
- provenance
  - planner: 신규 cycle인지, 또는 어떤 `Evaluator vN`을 받아 재계획했는지 명시
  - generator: 구현 기준 planner section과 검증 기준 workspace 범위를 명시
  - evaluator: 평가 대상 planner/generator section, 실제 검증 명령, dirty worktree에서 제외한 범위 또는 비교 기준을 명시
- dirty worktree evaluator 규칙
  - unrelated diff가 있어도 cycle acceptance는 가능해야 한다.
  - evaluator는 이번 cycle 변경 범위와 무관한 diff를 구분해 기록해야 한다.
  - PASS/FAIL 판정은 cycle-owned 변경과 acceptance criteria 기준으로만 내린다.

### migration 제약

- 기존 cycle history 문서를 전면 rewrite하지 않는다.
- 새 rule 추가 후 기존 rule은 중복 서술을 줄이는 방향으로 최소 수정한다.
- generated skill output도 같은 authority 구조를 따르도록 template/script를 같이 갱신한다.
- `materialize_repo.sh`는 새 rule 파일 생성과 index 반영까지 포함해야 한다.

### acceptance criteria

- current repo `rule/index.md`에 신규 rule 2개가 authoritative 항목으로 등재된다.
- current repo에 `cycle-document-contract.md`와 `language-policy.md`가 추가되고, 관련 기존 rule/doc/prompt가 이를 참조하도록 정리된다.
- `.codex/agents/evaluator.toml`에 dirty worktree 판정 규칙과 provenance 요구가 분명히 들어간다.
- planner/generator prompt도 필요 범위에서 header transition/provenance 요구를 강화한다.
- `hs-init-project` generated baseline이 신규 rule 2개를 생성하고, generated docs/prompts가 같은 계약을 따른다.
- generated skill의 language policy는 selected language, control filename, Korean/English 본문 정책을 분명히 드러낸다.

### 위험 요소

- cycle 계약과 orchestration 규칙이 중복 상태로 남으면 새 전용 rule의 authority가 약해질 수 있다.
- language policy를 여러 문서에 다시 길게 풀어 쓰면 분리 효과가 줄어든다.
- dirty worktree 규칙이 evaluator prompt에만 있고 rule 문서에 없으면 generated output과 current repo가 다시 어긋날 수 있다.

### 다음 handoff

- generator가 current repo와 generated skill에 신규 rule 2개를 추가하고, 관련 rule/doc/prompt/script를 authority 구조에 맞춰 최소 일관 변경한다.

## Generator v1

### planner section reference

- `Planner v1`

### 실제 반영한 범위

- current repo에 `rule/rules/cycle-document-contract.md`, `rule/rules/language-policy.md`를 추가했다.
- current repo `rule/index.md`, `rule/rules/subagent-orchestration.md`, `rule/rules/subagents-docs.md`, `.codex/agents/*.toml`을 새 authoritative rule 기준으로 보강했다.
- generated skill에 matching asset rule template 4개를 추가했다.
- generated skill index template, reference, asset prompt, `materialize_repo.sh`를 새 rule 파일 생성과 authority 경로에 맞게 보강했다.

### 변경 파일

- `rule/index.md`
- `rule/rules/cycle-document-contract.md`
- `rule/rules/language-policy.md`
- `rule/rules/subagent-orchestration.md`
- `rule/rules/subagents-docs.md`
- `.codex/agents/planner.toml`
- `.codex/agents/generator.toml`
- `.codex/agents/evaluator.toml`
- `hs-init-project/SKILL.md`
- `hs-init-project/references/language-output.md`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/references/structure-initialization.md`
- `hs-init-project/assets/rule/cycle-document-contract.en.md`
- `hs-init-project/assets/rule/cycle-document-contract.ko.md`
- `hs-init-project/assets/rule/language-policy.en.md`
- `hs-init-project/assets/rule/language-policy.ko.md`
- `hs-init-project/assets/rule/index.en.md`
- `hs-init-project/assets/rule/index.ko.md`
- `hs-init-project/assets/.codex/agents/planner.toml`
- `hs-init-project/assets/.codex/agents/generator.toml`
- `hs-init-project/assets/.codex/agents/evaluator.toml`
- `hs-init-project/scripts/materialize_repo.sh`

### 검증

- 새 rule 이름과 usage에 대해 targeted `rg`
- `git diff --check`
- `sh -n hs-init-project/scripts/materialize_repo.sh`

### 남은 위험/제약

- current repo의 `AGENTS.md`, `subagents_docs/AGENTS.md`, `docs/guide/subagent-workflow.md`, 그리고 generated skill의 일부 guide/AGENTS/rule template는 아직 새 authoritative rule을 직접 참조하도록 정리하지 않았다.
- 이번 패스는 user가 지정한 must-have rule/prompt/materializer 경로를 우선 완료하는 범위로 마감한다.

### 다음 handoff

- evaluator가 must-have deliverable과 propagation 상태를 검증하고 남은 문서 중복 정리 필요 여부를 판정한다.

## Generator v2

### planner section reference

- `Planner v1`

### 실제 반영한 범위

- generated skill의 root/local guide template가 `cycle-document-contract`와 `language-policy`를 직접 참조하도록 정리했다.
- `subagent-orchestration`과 `documentation-boundaries` template에서 중복 계약 서술을 줄이고 authoritative rule 참조 중심으로 맞췄다.
- `SKILL.md`, `references/language-output.md`, `references/subagent-orchestration.md`, `references/structure-initialization.md`에서 언어/사이클 계약의 상세 서술을 rule 참조형으로 재정리했다.

### 변경 파일

- `hs-init-project/assets/AGENTS/root.en.md`
- `hs-init-project/assets/AGENTS/root.ko.md`
- `hs-init-project/assets/subagents_docs/AGENTS.en.md`
- `hs-init-project/assets/subagents_docs/AGENTS.ko.md`
- `hs-init-project/assets/docs/guide/subagent-workflow.en.md`
- `hs-init-project/assets/docs/guide/subagent-workflow.ko.md`
- `hs-init-project/assets/rule/documentation-boundaries.en.md`
- `hs-init-project/assets/rule/documentation-boundaries.ko.md`
- `hs-init-project/assets/rule/subagent-orchestration.en.md`
- `hs-init-project/assets/rule/subagent-orchestration.ko.md`
- `hs-init-project/SKILL.md`
- `hs-init-project/references/language-output.md`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/references/structure-initialization.md`
- `subagents_docs/cycles/20-cycle-contract-language-policy-hardening.md`

### workspace 또는 baseline scope

- existing dirty worktree를 유지한 채, 이번 패스는 위 파일들의 새 diff와 cycle 20 요구 범위만 기준으로 확인했다.
- 이미 반영돼 있던 신규 rule template, asset index, agent prompt, materializer rule-copy 경로는 재확인만 하고 되돌리지 않았다.

### 검증

- targeted `rg`로 generated docs/reference가 `cycle-document-contract`와 `language-policy`를 참조하는지 확인
- `git diff --check`
- `sh -n hs-init-project/scripts/materialize_repo.sh`

### 남은 위험/제약

- `materialize_repo.sh`는 신규 rule 파일 생성과 관련 rule inline 문구를 이미 반영하고 있어 이번 패스에서 추가 수정하지 않았다.
- fresh materialize 실행까지는 이 generator 패스 범위에서 수행하지 않았다.

### 다음 handoff

- evaluator가 지정 범위 파일의 참조 정리와 script 검증 결과를 확인하고 PASS/FAIL을 판정한다.

## Evaluator v1

### 결과

- PASS

### planner section reference

- `Planner v1`

### generator section reference

- `Generator v2`

### dirty-worktree 비교 기준

- 현재 워크트리는 이미 다른 cycle에서 생긴 수정도 포함한 dirty 상태다.
- 이번 평가는 `Planner v1`의 대상 파일과 `Generator v1`/`Generator v2`가 명시한 변경 파일 집합을 cycle-owned scope로 보고 판정했다.
- unrelated diff 존재 여부와 무관하게, acceptance criteria는 위 cycle-owned scope와 fresh materialize 결과만 기준으로 판정했다.

### 검증 절차

- `git diff --check`
- `sh -n hs-init-project/scripts/materialize_repo.sh`
- `sed -n '1,320p' subagents_docs/cycles/20-cycle-contract-language-policy-hardening.md`
- `nl -ba rule/index.md | sed -n '1,260p'`
- `nl -ba rule/rules/cycle-document-contract.md | sed -n '1,260p'`
- `nl -ba rule/rules/language-policy.md | sed -n '1,260p'`
- `nl -ba rule/rules/subagent-orchestration.md | sed -n '1,240p'`
- `nl -ba rule/rules/subagents-docs.md | sed -n '1,220p'`
- `nl -ba .codex/agents/planner.toml | sed -n '1,220p'`
- `nl -ba .codex/agents/generator.toml | sed -n '1,220p'`
- `nl -ba .codex/agents/evaluator.toml | sed -n '1,240p'`
- `nl -ba hs-init-project/references/subagent-orchestration.md | sed -n '1,240p'`
- `nl -ba hs-init-project/references/language-output.md | sed -n '1,240p'`
- `nl -ba hs-init-project/references/structure-initialization.md | sed -n '1,260p'`
- `nl -ba hs-init-project/assets/rule/index.en.md | sed -n '1,260p'`
- `nl -ba hs-init-project/assets/rule/index.ko.md | sed -n '1,260p'`
- `nl -ba hs-init-project/assets/rule/cycle-document-contract.en.md | sed -n '1,240p'`
- `nl -ba hs-init-project/assets/rule/language-policy.en.md | sed -n '1,240p'`
- `nl -ba hs-init-project/assets/.codex/agents/evaluator.toml | sed -n '1,220p'`
- `rg -n "cycle-document-contract|language-policy" AGENTS.md subagents_docs/AGENTS.md docs/guide/subagent-workflow.md docs/implementation/AGENTS.md rule/rules/documentation-boundaries.md .codex/agents/*.toml -S`
- `rg -n "cycle-document-contract|language-policy" hs-init-project/scripts/materialize_repo.sh hs-init-project/SKILL.md hs-init-project/assets/AGENTS/root.en.md hs-init-project/assets/AGENTS/root.ko.md hs-init-project/assets/subagents_docs/AGENTS.en.md hs-init-project/assets/subagents_docs/AGENTS.ko.md hs-init-project/assets/docs/guide/subagent-workflow.en.md hs-init-project/assets/docs/guide/subagent-workflow.ko.md hs-init-project/assets/rule/documentation-boundaries.en.md hs-init-project/assets/rule/documentation-boundaries.ko.md hs-init-project/assets/rule/subagent-orchestration.en.md hs-init-project/assets/rule/subagent-orchestration.ko.md hs-init-project/assets/.codex/agents/*.toml -S`
- fresh materialize:
  - `sh hs-init-project/scripts/materialize_repo.sh <tmp>/repo --language ko --readme-mode fresh`
  - `find <tmp>/repo/rule/rules -maxdepth 1 -type f | sort`
  - `rg -n "cycle-document-contract|language-policy" <tmp>/repo/rule/index.md <tmp>/repo/rule/rules/cycle-document-contract.md <tmp>/repo/rule/rules/language-policy.md <tmp>/repo/.codex/agents <tmp>/repo/subagents_docs/AGENTS.md <tmp>/repo/docs/guide/subagent-workflow.md <tmp>/repo/AGENTS.md -S`

### acceptance criteria 판정

- current repo에는 authoritative rule인 `rule/rules/cycle-document-contract.md`와 `rule/rules/language-policy.md`가 추가돼 있다.
- `rule/index.md`는 두 rule을 authoritative global rule로 인덱싱한다.
- current repo의 `subagent-orchestration`, `subagents-docs`, `AGENTS.md`, `docs/guide/subagent-workflow.md`, `.codex/agents/*.toml`은 새 rule을 정확한 기준으로 직접 참조하며, exact 계약은 전용 rule로 위임하는 구조를 따른다.
- coordinator header 상태 전이, provenance 요구, dirty worktree evaluator 기준은 `rule/rules/cycle-document-contract.md`와 `.codex/agents/evaluator.toml`에서 명시적이고 서로 정합적이다.
- generated skill에는 matching rule template 4개, index template 갱신, reference/prompt 정렬, `materialize_repo.sh`의 rule 생성 지원이 모두 반영돼 있다.
- fresh materialize 결과는 generated repo에 `rule/rules/cycle-document-contract.md`, `rule/rules/language-policy.md`, 해당 index entry, 그리고 두 rule을 참조하는 generated prompts/docs를 실제로 생성한다.

### findings

- 없음.

### 품질 평가

- design quality: PASS
- originality: PASS
- completeness: PASS
- functionality: PASS

### 다음 handoff

- 없음. cycle 종료.
