# 17 Remove Legacy Mentions

- Status: PASS
- Current Plan Version: Evaluator v2
- Next Handoff: complete

## Planner v1

### 목표

- active rule/guide/template/script에서 legacy 관련 언급을 제거한다.

### 범위

- current repo의 active rule, guide, `subagents_docs/AGENTS.md`
- `hs-init-project`의 active reference, assets, `materialize_repo.sh`

### 비범위

- 기존 historical cycle 문서는 수정하지 않는다.

### acceptance criteria

- active 문서는 `subagents_docs/cycles/<NN>-<slug>.md` 현재 모델만 설명한다.
- legacy `plans/changes/evaluations` 관련 설명은 active baseline에서 제거한다.
- `materialize_repo.sh`는 계속 `subagents_docs/cycles/`만 baseline으로 생성한다.

### 다음 handoff

- generator가 active 문서와 생성 템플릿/스크립트에서 legacy 언급을 제거한다.

## Generator v1

### planner section reference

- `Planner v1`

### 실제 반영한 범위

- active baseline rule/guide/template/script에서 legacy 관련 문구를 제거했다.
- current repo와 `hs-init-project` generated baseline이 현재 `subagents_docs/cycles/<NN>-<slug>.md` 모델만 설명하도록 정리했다.

### 변경 파일

- `rule/rules/subagent-orchestration.md`
- `rule/rules/subagents-docs.md`
- `docs/guide/subagent-workflow.md`
- `subagents_docs/AGENTS.md`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/assets/rule/subagent-orchestration.en.md`
- `hs-init-project/assets/rule/subagent-orchestration.ko.md`
- `hs-init-project/assets/subagents_docs/AGENTS.en.md`
- `hs-init-project/assets/subagents_docs/AGENTS.ko.md`
- `hs-init-project/assets/docs/guide/subagent-workflow.en.md`
- `hs-init-project/assets/docs/guide/subagent-workflow.ko.md`
- `hs-init-project/scripts/materialize_repo.sh`

### 검증

- active baseline 대상 파일에 대해 legacy 관련 `rg` 재확인
- `sh -n hs-init-project/scripts/materialize_repo.sh`

### 남은 위험/제약

- historical cycle 문서는 비범위로 남아 있으므로, 과거 기록 안의 legacy 표기는 유지된다.

### 다음 handoff

- evaluator가 active baseline에서 legacy 언급이 제거됐는지와 materialize 결과를 검증한다.

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
- active baseline 대상 파일에 대해 `rg -n "legacy|historical records|과거 cycle|과거 기록|신규 cycle에는 쓰지 않는다|not part of the new baseline|subagents_docs/(plans|changes|evaluations)" ... -S`
- 임시 디렉토리에서 `sh hs-init-project/scripts/materialize_repo.sh <tmp>/repo --language ko --readme-mode fresh`
- 생성 결과에서 `find <tmp>/repo/subagents_docs -maxdepth 2 -type d`

### acceptance criteria 판정

- active 문서는 `subagents_docs/cycles/<NN>-<slug>.md` 현재 모델만 설명한다.
- active baseline 범위에서 legacy `plans/changes/evaluations` 설명은 제거됐다.
- `materialize_repo.sh`는 계속 `subagents_docs/cycles/`만 baseline으로 생성한다.

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
- active baseline 대상 파일에서 legacy 관련 `rg` 결과가 0건이다.
- fresh materialize 결과에서 `subagents_docs/cycles/`만 생성됐다.

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

- 이 `Evaluator v2`를 이번 cycle의 authoritative evaluator-owned record로 간주한다.

### 검증 절차

- `git diff --check`
- `sh -n hs-init-project/scripts/materialize_repo.sh`
- active baseline 대상 파일에 대해 `rg -n "legacy|historical records|과거 cycle|과거 기록|신규 cycle에는 쓰지 않는다|not part of the new baseline" ... -S`
- active baseline 대상 파일에 대해 `rg -n "subagents_docs/(plans|changes|evaluations)" ... -S`
- 임시 디렉토리에서 `sh hs-init-project/scripts/materialize_repo.sh <tmp>/repo --language ko --readme-mode fresh`
- 생성 결과에서 `find <tmp>/repo/subagents_docs -maxdepth 2 -type d`

### findings

- 없음.
- active baseline 범위에서 legacy 관련 설명과 `subagents_docs/plans|changes|evaluations` 경로 설명은 0건이었다.
- fresh materialize 결과는 `subagents_docs/cycles/`만 생성했다.

### 품질 평가

- design quality: PASS
- originality: PASS
- completeness: PASS
- functionality: PASS

### 다음 handoff

- 없음. cycle 종료.
