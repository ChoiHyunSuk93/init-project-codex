Status: PASS
Current Plan Version: Evaluator v1
Next Handoff: complete

# 26. hs-init-project structure runtime and evaluator loop

## Planner v1

### 신규 cycle 여부

- 신규 cycle이다.

### 목표

- `hs-init-project` skill이 생성하는 구조 규약을 "프로젝트 루트 아래 여러 runtime 디렉토리" 모델이 아니라 "정확히 하나의 source root 디렉토리를 만들고 구현체를 그 아래에 배치하는" 모델로 바로잡는다.
- planner / generator / evaluator 하네스에서 evaluator 책임을 실제 사용자 수준 테스트까지 확장하고, evaluator가 `FAIL`을 내리면 coordinator가 사용자 질문 없이 같은 요구를 다시 planner -> generator -> evaluator로 순환하도록 기준과 템플릿을 정렬한다.
- 사용자-facing guide 기본 산출물에서 `docs/guide/subagent-workflow.md`를 제거하고, subagent 흐름 설명은 rule과 harness 설정에서만 authoritative하게 유지되도록 정리한다.

### 범위

- `hs-init-project/SKILL.md`
- `hs-init-project/agents/openai.yaml`
- `hs-init-project/references/structure-initialization.md`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/scripts/materialize_repo.sh`
- `hs-init-project/assets/` 아래 관련 템플릿
- current repo의 대응 rule / guide 문서 중 skill 계약과 생성 결과 설명을 반영하는 파일
- cycle 기록 문서

### 비범위

- `hs-init-project` 외 다른 skill의 동작 변경
- 현재 저장소에 이미 존재하는 unrelated cycle 문서 정리
- 사용자가 요청하지 않은 신규 guide 문서 추가
- runtime source root 이름을 특정 스택 명칭으로 강제하는 정책 추가

### 사용자 관점 결과

- 이 skill로 초기화된 저장소는 runtime 구현체가 프로젝트 루트의 단일 source root 아래에 모이도록 안내와 생성 규칙이 일관되게 맞춰진다.
- evaluator는 단위 검증만이 아니라 실제 사용자 수준 테스트까지 요구받고, 실패 시 coordinator가 질문 없이 다음 cycle을 자동 재시작하는 harness를 얻게 된다.
- 생성 결과에서 `docs/guide/subagent-workflow.md`가 사라지고, 사용자는 가이드 디렉토리에서 불필요한 subagent 내부 문서를 보지 않게 된다.

### acceptance criteria

- skill 설명, reference, generated rule template, 스크립트가 모두 runtime 구조를 "단일 source root" 모델로 설명하고, 기존의 "multiple runtime directories are valid" 또는 동등한 의미의 기본 규칙을 제거하거나 새 모델에 맞게 바꾼다.
- existing-project inspect / clarification 흐름도 여러 runtime 후보를 병렬 분류하는 대신 단일 source root 확인 또는 충돌 해소 질문으로 정렬된다.
- `materialize_repo.sh`가 생성하는 runtime 관련 문서와 템플릿 출력이 단일 source root 규약을 따르며, 기본 안내와 inspect output이 이 모델과 모순되지 않는다.
- subagent orchestration 관련 skill/reference/rule/template가 evaluator의 책임을 "실제 사용자 수준 테스트를 포함한 strongest feasible end-to-end validation"으로 분명히 적고, evaluator `FAIL` 시 coordinator가 질문 없이 다음 planner cycle을 시작해 `PASS`까지 반복한다는 규칙을 명시한다.
- `docs/guide/subagent-workflow.md`가 skill의 required output, assets, materialization script, generated README/guide 설명에서 제거된다.
- current repo의 관련 rule/doc도 위 변경과 모순되지 않게 정렬된다.

### 제약

- current repo의 문서 본문 언어는 한국어를 유지해야 한다.
- planner는 구현을 직접 하지 않고 generator가 수정해야 할 파일 범위와 검증 기준만 명확히 정의해야 한다.
- 기존 저장소 호환성은 유지하되, source root가 불명확할 때는 여전히 질문 흐름이 남아 있어야 한다.
- `docs/guide/README.md` 등 사용자-facing 문서에서는 rule을 복제하지 않고 필요한 수준만 요약해야 한다.

### 위험 요소

- 단일 source root 규약으로 바꾸는 과정에서 existing-project mode의 additive initialization 설명이 약해지면, 기존 다중 앱 저장소에 대한 대응 규칙이 지나치게 모호해질 수 있다.
- evaluator 자동 재시도 규칙을 과하게 일반화하면, 실제로는 사용자 입력이 필요한 blocker와 단순 구현 실패를 구분하지 못할 수 있다.
- `subagent-workflow.md` 제거 시 현재 템플릿, README, cycle contract, guide README 사이의 참조를 일부 놓치면 생성 구조가 불완전해질 수 있다.

### 의존관계

- `rule/rules/subagent-orchestration.md`
- `rule/rules/cycle-document-contract.md`
- `rule/rules/language-policy.md`
- `hs-init-project` 내 skill/reference/template/script 전반
- current repo의 `docs/guide/README.md`, `rule/index.md`, 관련 `rule/rules/*.md`

### open questions

- 없음. 이번 cycle에서는 단일 source root 규약, evaluator 사용자 수준 테스트, FAIL 시 무질문 자동 재시도를 기본 정책으로 고정한다.

### 다음 handoff

- generator는 skill 계약, reference, asset template, materialize script, current repo rule/doc를 함께 수정해 세 요구사항을 일관되게 반영하고 검증한다.

## Generator v1

### planner section reference

- `Planner v1`

### 실제 반영한 범위

- `hs-init-project` skill 계약, reference, assets, materialize script를 단일 source root 규약으로 정렬했다.
- evaluator 책임을 실제 사용자 수준 테스트까지 확장하고, `FAIL` 시 외부 입력이 정말 필요한 blocker가 아닌 한 질문 없이 다음 cycle을 다시 시작하도록 subagent 관련 rule/template/prompt를 정렬했다.
- generated guide 기본 산출물과 current repo guide에서 `docs/guide/subagent-workflow.md`를 제거하고, 관련 reference와 README/rule 설명을 정리했다.

### 변경 파일

- `hs-init-project/SKILL.md`
- `hs-init-project/agents/openai.yaml`
- `hs-init-project/references/structure-initialization.md`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/scripts/materialize_repo.sh`
- `hs-init-project/assets/AGENTS/root.en.md`
- `hs-init-project/assets/AGENTS/root.ko.md`
- `hs-init-project/assets/README/root.en.md`
- `hs-init-project/assets/README/root.ko.md`
- `hs-init-project/assets/docs/guide/README.en.md`
- `hs-init-project/assets/docs/guide/README.ko.md`
- `hs-init-project/assets/docs/guide/subagent-workflow.en.md` (삭제)
- `hs-init-project/assets/docs/guide/subagent-workflow.ko.md` (삭제)
- `hs-init-project/assets/rule/cycle-document-contract.en.md`
- `hs-init-project/assets/rule/cycle-document-contract.ko.md`
- `hs-init-project/assets/rule/index.en.md`
- `hs-init-project/assets/rule/index.ko.md`
- `hs-init-project/assets/rule/project-structure.en.md`
- `hs-init-project/assets/rule/project-structure.ko.md`
- `hs-init-project/assets/rule/runtime-boundaries.en.md`
- `hs-init-project/assets/rule/runtime-boundaries.ko.md`
- `hs-init-project/assets/rule/subagent-orchestration.en.md`
- `hs-init-project/assets/rule/subagent-orchestration.ko.md`
- `hs-init-project/assets/subagents_docs/AGENTS.en.md`
- `hs-init-project/assets/subagents_docs/AGENTS.ko.md`
- `docs/guide/README.md`
- `docs/guide/subagent-workflow.md` (삭제)
- `rule/index.md`
- `rule/rules/cycle-document-contract.md`
- `rule/rules/project-structure.md`
- `rule/rules/runtime-boundaries.md`
- `rule/rules/subagent-orchestration.md`
- `rule/rules/subagents-docs.md`
- `rule/rules/testing-standards.md`
- `subagents_docs/AGENTS.md`

### 검증에 사용한 workspace/baseline scope

- current repo의 cycle-owned 범위는 위 변경 파일과 이번 cycle 문서만으로 제한했다.
- 기존 history 성격의 `subagents_docs/cycles/` 다른 문서와 unrelated diff는 판정 범위에서 제외했다.
- 생성기 검증은 fresh temp repo 1개와 existing temp repo 1개를 만들어 현재 변경분이 실제 산출물에 반영되는지만 확인했다.

### 검증

- `git diff --check`
  - 결과: 통과
- `sh -n hs-init-project/scripts/materialize_repo.sh`
  - 결과: 통과
- `sh hs-init-project/scripts/materialize_repo.sh <fresh_tmp> --language ko --source-root-dir src`
  - 결과: 통과. fresh 생성 결과에 `docs/guide/subagent-workflow.md`가 생기지 않고 source root 관련 문구가 반영됨
- `sh hs-init-project/scripts/materialize_repo.sh <existing_tmp> --language en --readme-mode existing --inspect`
  - 결과: 통과. inspect output이 `Detected source-root candidates`와 단일 source root 확인 질문으로 출력됨
- `sh hs-init-project/scripts/materialize_repo.sh <existing_tmp> --language en --readme-mode existing --source-root-dir src --confirm-existing-docs`
  - 결과: 통과. existing mode 생성 결과에도 `docs/guide/subagent-workflow.md`가 생기지 않고 source root / evaluator 관련 문구가 반영됨
- `rg -n "Source Root|source root|single source-root|single source root" <fresh_tmp> <existing_tmp>`
  - 결과: 통과
- `rg -n "user-level|사용자 수준|FAIL" <fresh_tmp> <existing_tmp>`
  - 결과: 통과
- `rg -n "Detected source-root candidates|single directory should be treated as the source root" <existing_tmp>/inspect.txt`
  - 결과: 통과

### 남은 위험과 제약

- 기존 `subagents_docs/cycles/` 이력 문서에는 과거 `subagent-workflow.md`나 runtime 표현이 남아 있지만, 이번 cycle의 제품 산출물 범위에는 포함하지 않았다.
- `materialize_repo.sh`는 `--runtime-dirs`를 legacy alias로 여전히 받아들이지만, 공식 surface는 `--source-root-dir`로 전환했다.

### 다음 handoff

- evaluator는 현재 변경분이 planner acceptance criteria를 충족하는지, temp repo 생성 검증과 current repo 문서 정렬을 기준으로 판정한다.

## Evaluator v1

### 결과

PASS

### planner section reference

- `Planner v1`

### generator section reference

- `Generator v1`

### 검증에 사용한 dirty-worktree 비교 기준

- 이번 cycle의 판정 범위는 `Generator v1`에 적힌 cycle-owned 변경 파일과 이 cycle 문서로 제한했다.
- 기존 `subagents_docs/cycles/` 이력 문서와 unrelated diff는 PASS/FAIL 근거에서 제외했다.
- 삭제된 `docs/guide/subagent-workflow.md`와 `hs-init-project/assets/docs/guide/subagent-workflow.*`는 이번 cycle의 의도된 변경으로 포함했다.

### acceptance criteria 판정

- skill 설명, reference, generated rule template, 스크립트가 모두 runtime 구조를 "단일 source root" 모델로 설명하고, 기존의 "multiple runtime directories are valid" 또는 동등한 의미의 기본 규칙을 제거하거나 새 모델에 맞게 바꾼다.
  - 충족. `hs-init-project/SKILL.md`, `hs-init-project/references/structure-initialization.md`, `hs-init-project/assets/rule/project-structure.*`, `hs-init-project/assets/rule/runtime-boundaries.*`, current repo의 [runtime-boundaries.md](/Users/choehyeonseog/Documents/workspace/hs/projects/init-project-codex/rule/rules/runtime-boundaries.md)에서 단일 source root 규약으로 정렬됐고, 관련 grep에서 이전 다중 runtime 기본 규칙 잔존이 보이지 않았다.
- existing-project inspect / clarification 흐름도 여러 runtime 후보를 병렬 분류하는 대신 단일 source root 확인 또는 충돌 해소 질문으로 정렬된다.
  - 충족. `materialize_repo.sh --inspect` 출력이 `Detected source-root candidates`와 "which single directory should be treated as the source root" 질문으로 바뀐 것을 temp existing repo에서 확인했다.
- `materialize_repo.sh`가 생성하는 runtime 관련 문서와 템플릿 출력이 단일 source root 규약을 따르며, 기본 안내와 inspect output이 이 모델과 모순되지 않는다.
  - 충족. fresh/existing temp repo materialization 결과 `README.md`, `rule/rules/project-structure.md`, `rule/rules/runtime-boundaries.md`가 source root 용어와 규약으로 생성됐고 문구 grep도 통과했다.
- subagent orchestration 관련 skill/reference/rule/template가 evaluator의 책임을 "실제 사용자 수준 테스트를 포함한 strongest feasible end-to-end validation"으로 분명히 적고, evaluator `FAIL` 시 coordinator가 질문 없이 다음 planner cycle을 시작해 `PASS`까지 반복한다는 규칙을 명시한다.
  - 충족. `hs-init-project/agents/openai.yaml`, `hs-init-project/references/subagent-orchestration.md`, current repo의 [subagent-orchestration.md](/Users/choehyeonseog/Documents/workspace/hs/projects/init-project-codex/rule/rules/subagent-orchestration.md), [subagents-docs.md](/Users/choehyeonseog/Documents/workspace/hs/projects/init-project-codex/rule/rules/subagents-docs.md), [subagents_docs/AGENTS.md](/Users/choehyeonseog/Documents/workspace/hs/projects/init-project-codex/subagents_docs/AGENTS.md)에서 모두 확인됐다.
- `docs/guide/subagent-workflow.md`가 skill의 required output, assets, materialization script, generated README/guide 설명에서 제거된다.
  - 충족. current repo에서 해당 파일이 삭제됐고, `rg -n "subagent-workflow"`를 `hs-init-project`, `docs`, `rule`, `subagents_docs/AGENTS.md` 범위에 실행했을 때 잔존 참조가 없었다. fresh/existing temp repo에도 해당 파일이 생성되지 않았다.
- current repo의 관련 rule/doc도 위 변경과 모순되지 않게 정렬된다.
  - 충족. [docs/guide/README.md](/Users/choehyeonseog/Documents/workspace/hs/projects/init-project-codex/docs/guide/README.md), [cycle-document-contract.md](/Users/choehyeonseog/Documents/workspace/hs/projects/init-project-codex/rule/rules/cycle-document-contract.md), [project-structure.md](/Users/choehyeonseog/Documents/workspace/hs/projects/init-project-codex/rule/rules/project-structure.md), [runtime-boundaries.md](/Users/choehyeonseog/Documents/workspace/hs/projects/init-project-codex/rule/rules/runtime-boundaries.md), [subagent-orchestration.md](/Users/choehyeonseog/Documents/workspace/hs/projects/init-project-codex/rule/rules/subagent-orchestration.md)가 새 기준과 일치한다.

### 수행한 검증

- `git diff --check`
  - 결과: 통과
- `sh -n hs-init-project/scripts/materialize_repo.sh`
  - 결과: 통과
- fresh temp repo 생성:
  - 명령: `sh hs-init-project/scripts/materialize_repo.sh "$tmpdir" --language ko --source-root-dir src`
  - 결과: 통과. `docs/guide/subagent-workflow.md`는 생성되지 않았고 `docs/guide/README.md`, `rule/rules/project-structure.md`, `rule/rules/runtime-boundaries.md`가 단일 source root 규약으로 생성됐다.
- existing temp repo inspect:
  - 명령: `sh hs-init-project/scripts/materialize_repo.sh "$existing" --language en --readme-mode existing --inspect`
  - 결과: 통과. `Detected source-root candidates`와 단일 source root 확인 질문이 출력됐다.
- existing temp repo materialization:
  - 명령: `sh hs-init-project/scripts/materialize_repo.sh "$existing" --language en --readme-mode existing --source-root-dir src --confirm-existing-docs --confirm-existing-rule`
  - 결과: 통과. 기존 `docs/legacy/`, `rule/custom/`, `src/`를 유지하면서 Codex 구조가 추가됐고 `docs/guide/subagent-workflow.md`는 생성되지 않았다.
- 문구/구조 확인:
  - 명령: `rg -n "multiple runtime directories|single source root|source root|source-root|subagent-workflow|user-level|사용자 수준|PASS까지|without asking the user|질문 없이" hs-init-project rule docs subagents_docs/AGENTS.md -S`
  - 결과: 통과. 필요한 새 문구는 확인됐고, 잔존 `subagent-workflow` 참조는 없었다.

### 관찰 결과와 재현 정보

- fresh 생성 결과에는 `docs/guide/README.md`만 기본 guide 문서로 남고, subagent 흐름은 rule/subagent 문서 쪽에서만 다뤄진다.
- existing inspect는 여러 runtime 디렉토리를 모두 runtime으로 분류하는 예전 질문이 아니라 하나의 source root를 확정하는 질문으로 바뀌었다.
- evaluator 관련 문구는 current repo와 generated temp repo 모두에서 "real user-level validation" 또는 "실제 사용자 수준 테스트"를 포함하도록 정렬됐다.

### 문제 목록

- 없음.

### 품질 평가

- design quality: 4/5
- originality: 3/5
- completeness: 5/5
- functionality: 5/5
- overall judgment: PASS

### 다음 handoff

- 없음. cycle을 종료한다.
