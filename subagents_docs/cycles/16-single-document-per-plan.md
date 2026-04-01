# 16 Single Document Per Plan Transition

- Status: PASS
- Current Plan Version: Evaluator v2
- Next Handoff: complete

## Planner v1

### 목표

- 분리된 `subagents_docs/plans/`, `subagents_docs/changes/`, `subagents_docs/evaluations/` 모델을 plan별 단일 문서 모델로 전환한다.
- current repo와 `hs-init-project` generated baseline이 같은 cycle 문서 규약을 공유하도록 맞춘다.

### 범위

- current repo의 rule, `.codex/agents`, `docs/guide`, `docs/implementation`, `README`, `subagents_docs/AGENTS.md`를 새 규약에 맞춘다.
- generated skill의 `SKILL.md`, references, assets, `materialize_repo.sh`, 공개 설명 문서를 새 규약에 맞춘다.
- 신규 cycle 기본 경로를 `subagents_docs/cycles/<NN>-<slug>.md`로 고정한다.

### 비범위

- legacy `subagents_docs/plans/`, `changes/`, `evaluations/`의 과거 기록을 일괄 마이그레이션하지 않는다.
- 기존 history 문서의 본문을 새 형식으로 재작성하지 않는다.

### 사용자 관점 결과

- planner, generator, evaluator는 같은 cycle 문서를 공유하되 자기 섹션만 append한다.
- 문서 상단만 봐도 현재 상태와 다음 handoff를 알 수 있다.
- 생성된 저장소도 처음부터 같은 단일 문서 규약을 사용한다.

### acceptance criteria

- 신규 규칙 문서는 `subagents_docs/cycles/`를 기준 작업 영역으로 정의한다.
- planner/generator/evaluator 규정은 같은 문서 안의 섹션 reference와 append-only 버전 규칙을 명시한다.
- `docs/implementation/` 최종 브리핑은 evaluator `PASS` 이후에만 허용된다는 규칙이 유지된다.
- `hs-init-project` materialization 결과가 `subagents_docs/cycles/`를 생성하고 기존 분리 디렉토리를 신규 baseline으로 만들지 않는다.

### 제약

- 메인 에이전트는 orchestration-only 원칙을 유지해야 한다.
- 기존 legacy 기록은 보존해야 하므로 파괴적 정리는 하지 않는다.

### 위험 요소

- current repo의 과거 평가 문서들이 기존 경로를 계속 참조하므로 신규 규칙과 legacy history의 경계를 분명히 적어야 한다.
- generated docs, templates, script 중 일부만 바뀌면 materialized repo와 설명 문서가 어긋날 수 있다.

### 의존관계

- `rule/rules/subagent-orchestration.md`
- `rule/rules/subagents-docs.md`
- `.codex/agents/*.toml`
- `hs-init-project/SKILL.md`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/scripts/materialize_repo.sh`

### open questions

- 없음. 사용자가 단일 문서 per plan, append-only, 상단 상태 블록 유지, evaluator `PASS` 전 최종 브리핑 금지를 명시했다.

### 다음 handoff

- generator가 current repo와 generated skill을 함께 전환하고, 같은 문서에 `Generator v1` 섹션을 append한다.

## Generator v1

### planner section reference

- `Planner v1`

### 실제 반영한 범위

- generated baseline에서 신규 plan cycle의 기본 working artifact를 `subagents_docs/cycles/<NN>-<slug>.md` 단일 문서 모델로 전환했다.
- skill/reference/template/script가 새 cycle 문서 규약을 기준으로 planner/generator/evaluator의 append-only section 모델을 설명하도록 맞췄다.
- `materialize_repo.sh`가 신규 baseline에서 `subagents_docs/cycles/`만 생성하도록 바꿨다.

### 변경 파일

- `hs-init-project/SKILL.md`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/references/structure-initialization.md`
- `hs-init-project/assets/.codex/agents/planner.toml`
- `hs-init-project/assets/.codex/agents/generator.toml`
- `hs-init-project/assets/.codex/agents/evaluator.toml`
- `hs-init-project/assets/rule/subagent-orchestration.en.md`
- `hs-init-project/assets/rule/subagent-orchestration.ko.md`
- `hs-init-project/assets/subagents_docs/AGENTS.en.md`
- `hs-init-project/assets/subagents_docs/AGENTS.ko.md`
- `hs-init-project/assets/docs/guide/subagent-workflow.en.md`
- `hs-init-project/assets/docs/guide/subagent-workflow.ko.md`
- `hs-init-project/scripts/materialize_repo.sh`

### 검증

- generator 단계에서 대상 파일들을 새 cycle 문서 모델로 맞춘 뒤, old baseline 경로가 남아 있는지 `rg`로 재확인할 예정이다.

### 남은 위험/제약

- 실제 materialize 실행과 end-to-end 판정은 evaluator가 확인해야 한다.
- legacy history 디렉토리는 규칙상 historical record로만 남겨야 하므로, 문구가 그 의도로만 남아 있는지 evaluator가 한 번 더 확인해야 한다.

### 다음 handoff

- evaluator가 generated baseline과 스크립트에서 old separated-doc baseline이 제거되었는지 검증한다.

## Evaluator v1

### 결과

- PASS

### planner section reference

- `Planner v1`

### generator section reference

- `Generator v1`

### 검증 절차

- `git diff --check`
- `sh -n hs-init-project/scripts/materialize_repo.sh`
- 임시 디렉토리에서 `sh hs-init-project/scripts/materialize_repo.sh <tmp>/repo --language ko --readme-mode fresh`
- 생성 결과에서 `find <tmp>/repo/subagents_docs -maxdepth 1 -type d`
- current repo와 generated baseline 대상 파일에 대해 `rg -n "subagents_docs/(cycles|plans|changes|evaluations)" ... -S`

### acceptance criteria 판정

- `subagents_docs/cycles/`를 신규 working area로 정의하는 규칙이 current repo와 generated baseline 모두에 반영되어 있다.
- planner/generator/evaluator가 같은 문서 안의 section reference와 append-only 버전 규칙을 사용한다는 설명이 rule, prompt, guide, asset에 일관되게 들어갔다.
- evaluator `PASS` 전에는 `docs/implementation/` 최종 브리핑을 만들지 않는 규칙이 유지된다.
- `materialize_repo.sh`는 신규 baseline에서 `subagents_docs/cycles/`만 생성하고 `subagents_docs/plans`, `changes`, `evaluations`를 기본 디렉토리로 만들지 않는다.

### 문제 목록

- 없음.

### 품질 평가

- design quality: PASS
- originality: PASS
- completeness: PASS
- functionality: PASS

### 관찰 결과

- `git diff --check` 통과.
- `sh -n hs-init-project/scripts/materialize_repo.sh` 통과.
- 임시 materialize 결과에서 `subagents_docs/cycles/` 디렉토리만 생성되었고, legacy `plans/changes/evaluations` 디렉토리는 생성되지 않았다.
- generated baseline 안의 기존 `subagents_docs/plans|changes|evaluations` 표기는 legacy historical record 문맥으로만 남아 있고, 신규 baseline 지시문은 `subagents_docs/cycles/`로 일관된다.

### 다음 handoff

- 없음. cycle 종료.

## Evaluator v2

### 결과

- PASS

### planner section reference

- `Planner v1`

### generator section reference

- `Generator v1`

### 기록 정합성

- 기존 `Evaluator v1` 섹션은 실제 evaluator-owned append provenance가 불명확하다.
- 이 `Evaluator v2`를 이번 cycle의 authoritative evaluator-owned record로 간주한다.

### 검증 절차

- `git diff --check`
- `sh -n hs-init-project/scripts/materialize_repo.sh`
- 임시 디렉토리에서 `sh hs-init-project/scripts/materialize_repo.sh <tmp>/repo --language ko --readme-mode fresh`
- 생성 결과에서 `find <tmp>/repo/subagents_docs -maxdepth 2 -type d`
- current repo와 generated baseline 대상 파일에 대해 `rg -n "subagents_docs/(cycles|plans|changes|evaluations)" README.md README.ko.md .codex rule docs hs-init-project -S`

### findings

- 없음.
- current repo와 generated baseline은 신규 cycle working area를 `subagents_docs/cycles/`로 일관되게 가리킨다.
- legacy `subagents_docs/plans/`, `changes/`, `evaluations/` 표기는 historical record 문맥으로만 남아 있다.
- fresh materialize 결과는 `subagents_docs/cycles/`만 생성했고 legacy 분리 디렉토리는 baseline으로 만들지 않았다.

### 품질 평가

- design quality: PASS
- originality: PASS
- completeness: PASS
- functionality: PASS

### 다음 handoff

- 없음. 이 `Evaluator v2`를 기준 평가 기록으로 cycle을 종료한다.
