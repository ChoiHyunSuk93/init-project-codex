Status: PASS
Current Plan Version: Evaluator v2
Next Handoff: complete

# 24. process-oriented starter skills and existing-project specificity

## Planner v1

### 신규 cycle 여부

- 신규 cycle이다.

### 목표

- generated starter local skill baseline을 역할 래퍼(`repo-planner`, `repo-generator`, `repo-evaluator`)에서 일반적인 개발 절차 중심 skill 세트로 재설계한다.
- `.codex/agents/`의 planner/generator/evaluator 하네스는 유지하고, `.codex/skills/`만 의미 있는 작업 유형 중심으로 분리한다.
- existing-project mode에서는 target repository를 inspect해서 generated output이 더 구체적인 구조, tooling, docs 신호를 반영하도록 확장한다.
- 특히 starter local skill도 existing-project mode에서는 관찰된 runtime 영역, test/tooling, docs 구조를 반영해 더 구체적으로 생성되도록 한다.

### 범위

- current repo 문서에서 generated starter local skill 설명을 role-based wrapper 기준에서 process-oriented baseline 기준으로 바꾼다.
- `hs-init-project/SKILL.md`, references, README/template, AGENTS/template, rule/template, starter skill template, materialize flow를 새 baseline으로 정렬한다.
- `assets/.codex/skills/`와 materialize 출력 경로를 새 starter skill 이름/내용 기준으로 바꾼다.
- existing-project mode inspect 결과를 활용해 generated starter skill, README, guide index, development/testing standards 등 일부 산출물을 더 구체화하는 로직을 추가한다.

### 비범위

- `.codex/agents/planner.toml`, `.codex/agents/generator.toml`, `.codex/agents/evaluator.toml` 역할 분리 자체를 제거하거나 약화하는 변경
- cycle document contract, language policy, orchestration-only, intent gate, thread cleanup 규칙의 의미 변경
- project domain을 모르는 상태에서 stack-specific starter skill을 임의로 추가하는 변경
- target repository에 domain-specific feature skill을 자동 생성하는 변경

### 사용자 관점 결과

- generated repository는 planner/generator/evaluator role과 별개로, 일반적인 개발 프로세스에서 자연스럽게 쓸 수 있는 starter local skill 세트를 가진다.
- existing-project mode에서는 generated README/rule/skill이 실제로 관찰된 runtime 영역, 테스트 신호, docs 구조를 반영해 더 구체적으로 나온다.
- fresh mode에서는 여전히 얇고 generic한 baseline을 유지하되, skill 의미는 역할명이 아니라 작업 유형으로 읽힌다.

### 제안 starter skill 세트

- `change-analysis`: 요구사항 해석, 영향 범위, acceptance criteria, non-goal, risk 정리
- `code-implementation`: 승인된 변경 계획 기준 코드/설정/스크립트 수정과 집중 검증
- `test-debug`: 재현, 원인 축소, 테스트 추가/수정, 검증
- `docs-sync`: README, guide, rule, implementation briefing 동기화
- `quality-review`: diff/결과 검토, acceptance criteria 대조, 회귀 위험 평가

### existing-project mode 구체화 원칙

- 더 구체화할 대상:
  - root `README.md`
  - `docs/guide/README.md`
  - `rule/rules/development-standards.md`
  - `rule/rules/testing-standards.md`
  - process-oriented starter local skill `SKILL.md`
- 관찰값을 반영하되 여전히 참조형으로 둘 대상:
  - `AGENTS.md`
  - `rule/index.md`
  - `rule/rules/subagent-orchestration.md`
  - `rule/rules/cycle-document-contract.md`
  - `rule/rules/language-policy.md`
- 구체화 근거로 쓸 inspect 신호:
  - top-level runtime 후보 디렉토리
  - top-level non-runtime 디렉토리
  - tooling/config 파일
  - test 디렉토리와 test tooling 파일
  - 기존 `docs/`와 `rule/` 구조
  - overwrite conflict 여부
- starter skill 구체화 방향:
  - `change-analysis`: 관찰된 runtime 영역과 문서/경계 신호를 반영해 영향 범위 파악 대상을 명시
  - `code-implementation`: 주 수정 대상 runtime 영역과 verification 신호를 반영
  - `test-debug`: 관찰된 test 디렉토리, test tooling, verification 명령 후보를 반영
  - `docs-sync`: 기존 README/docs/rule 구조와 generated 문서 경계를 반영
  - `quality-review`: acceptance 확인에 필요한 runtime/test/docs 관찰 신호를 반영

### acceptance criteria

- generated baseline에서 `repo-planner`, `repo-generator`, `repo-evaluator` starter skill 이름과 관련 출력이 제거된다.
- generated baseline은 `change-analysis`, `code-implementation`, `test-debug`, `docs-sync`, `quality-review` starter local skill을 `.codex/skills/` 아래에 생성한다.
- 새 starter skill의 `SKILL.md`와 `agents/openai.yaml` metadata는 작업 유형 중심 설명을 사용하고, planner/generator/evaluator 역할명 재복제를 하지 않는다.
- current repo README/rule/skill source/template는 `.codex/agents/`와 `.codex/skills/`의 축을 분리해 설명한다.
- existing-project mode에서 inspect 결과를 바탕으로 generated starter skill 내용이 fresh mode보다 더 구체적이게 생성된다.
- existing-project mode에서 generated README, guide index, development/testing standards도 관찰된 구조/tooling을 반영해 더 구체적으로 생성된다.
- orchestration-only, role split, intent gate, cycle document contract, language policy, thread cleanup 규칙은 유지된다.
- generated starter skill은 계속 `allow_implicit_invocation`을 유지한다.

### 제약

- starter skill은 generic baseline이어야 하며, 특정 framework나 domain을 추측해 단정적으로 쓰면 안 된다.
- skill-creator 원칙에 맞게 skill body는 얇게 유지하고, 안정 규칙은 `rule/rules/*.md` 참조형으로 남긴다.
- existing-project mode 구체화는 관찰된 신호에 기반해야 하며, 미관찰 정보는 발명하지 않는다.
- current repo의 사람이 읽는 문서는 한국어 기본값을 유지하고, generated ko/en template는 함께 정렬한다.

### 위험 요소

- starter skill 수가 늘어나면 baseline이 무거워질 수 있다.
- 기존 role-based naming이 사라지면서 기존 설명/스크립트/문서 중 일부가 누락되면 drift가 생길 수 있다.
- existing-project 구체화 로직이 과도하면 관찰되지 않은 세부사항을 암시할 위험이 있다.
- skill taxonomy 변경으로 materialize script, README, template, references 사이 정합성이 깨질 수 있다.

### 의존관계

- `README.md`
- `README.ko.md`
- `AGENTS.md`
- `rule/rules/instruction-model.md`
- `hs-init-project/SKILL.md`
- `hs-init-project/references/structure-initialization.md`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/references/language-output.md`
- `hs-init-project/assets/.codex/skills/`
- `hs-init-project/assets/README/`
- `hs-init-project/assets/AGENTS/`
- `hs-init-project/assets/rule/`
- `hs-init-project/assets/docs/guide/`
- `hs-init-project/scripts/materialize_repo.sh`

### open questions

- 없음. 새 starter skill 세트는 이번 cycle에서 baseline으로 고정하고, 추가 optional skill은 후속 cycle에서 다룬다.

### 다음 handoff

- generator는 role-based starter skill baseline을 process-oriented starter skill baseline으로 교체하고, existing-project inspect 신호를 사용해 generated starter skill과 관련 산출물이 더 구체적으로 생성되도록 source/template/script를 함께 수정한다.

## Generator v1

### planner section reference

- `Planner v1`

### 실제 반영한 범위

- generated starter local skill baseline을 `repo-planner`/`repo-generator`/`repo-evaluator`에서 `change-analysis`/`code-implementation`/`test-debug`/`docs-sync`/`quality-review`로 교체했다.
- current repo README/rule/guide 설명과 `hs-init-project` source, reference, asset template, materialize flow를 새 process-oriented skill baseline에 맞춰 정렬했다.
- existing-project mode에서는 observed runtime, test, tooling, docs 신호를 사용해 generated starter skill `SKILL.md` 내용이 fresh mode보다 더 구체적으로 나오도록 `materialize_repo.sh`를 확장했다.
- existing-project mode의 overwrite/inspect 안전성을 위해 starter skill 산출물도 planned output/overwrite 대상에 포함되도록 materialize 흐름을 보강했다.
- orchestration-only, role split, intent gate, cycle-document-contract, language policy, thread cleanup 규칙은 유지했다.

### 변경 파일

- `README.md`
- `README.ko.md`
- `AGENTS.md`
- `rule/index.md`
- `rule/rules/instruction-model.md`
- `rule/rules/project-structure.md`
- `rule/rules/documentation-boundaries.md`
- `rule/rules/subagent-orchestration.md`
- `rule/rules/subagents-docs.md`
- `docs/guide/subagent-workflow.md`
- `docs/implementation/AGENTS.md`
- `subagents_docs/AGENTS.md`
- `hs-init-project/SKILL.md`
- `hs-init-project/agents/openai.yaml`
- `hs-init-project/references/structure-initialization.md`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/references/language-output.md`
- `hs-init-project/assets/.codex/skills/`
- `hs-init-project/assets/AGENTS/`
- `hs-init-project/assets/README/`
- `hs-init-project/assets/docs/guide/`
- `hs-init-project/assets/docs/implementation/`
- `hs-init-project/assets/rule/`
- `hs-init-project/assets/subagents_docs/`
- `hs-init-project/scripts/materialize_repo.sh`

### 검증에 사용한 workspace/baseline scope

- dirty worktree에는 이번 cycle 범위 밖의 legacy `subagents_docs/plans|changes|evaluations` 삭제와 기타 선행 변경이 이미 포함돼 있었다.
- 이번 cycle 판정은 starter skill taxonomy, existing-project specificity, 관련 README/rule/template/materialize 파일, 그리고 fresh/existing materialize 결과만 cycle-owned 범위로 잡았다.
- unrelated dirty diff와 historical cycle 문서는 이번 acceptance 판단에서 제외했다.

### 검증

- `rg -n "repo-planner|repo-generator|repo-evaluator" AGENTS.md README.md README.ko.md rule/rules hs-init-project/SKILL.md hs-init-project/references hs-init-project/assets hs-init-project/scripts/materialize_repo.sh /tmp/cycle24-fresh.GyPeo2 /tmp/cycle24-existing.wpD2pp`
  - 결과: 매치 없음
- `rg -n "change-analysis|code-implementation|test-debug|docs-sync|quality-review" README.md README.ko.md hs-init-project/SKILL.md hs-init-project/assets hs-init-project/scripts/materialize_repo.sh /tmp/cycle24-fresh.GyPeo2 /tmp/cycle24-existing.wpD2pp`
  - 결과: current repo, source/template, fresh/existing generated output에서 새 starter skill 세트 확인
- `git diff --check`
  - 결과: 통과
- `sh -n hs-init-project/scripts/materialize_repo.sh`
  - 결과: 통과
- `sh hs-init-project/scripts/materialize_repo.sh /tmp/cycle24-fresh.GyPeo2 --language ko --overwrite`
  - 결과: fresh mode에서 새 starter skill 5종 생성 확인
- `sh hs-init-project/scripts/materialize_repo.sh /tmp/cycle24-existing.wpD2pp --language ko --readme-mode existing --runtime-dirs src --confirm-existing-docs --overwrite`
  - 결과: existing-project mode에서 `src/`, `tests/`, `docs/api`, `package.json`, `vitest.config.ts` 관찰값을 반영한 README/rule/skill 생성 확인
- `sed -n '1,220p' /tmp/cycle24-existing.wpD2pp/.codex/skills/change-analysis/SKILL.md`
  - 결과: observed runtime/docs/top-level 구조 반영 확인
- `sed -n '1,240p' /tmp/cycle24-existing.wpD2pp/.codex/skills/test-debug/SKILL.md`
  - 결과: observed test directory와 test tooling 반영 확인
- `sed -n '1,220p' /tmp/cycle24-existing.wpD2pp/.codex/skills/docs-sync/SKILL.md`
  - 결과: observed docs/top-level file 신호 반영 확인
- `sed -n '1,220p' /tmp/cycle24-existing.wpD2pp/.codex/skills/quality-review/SKILL.md`
  - 결과: observed runtime/test/docs 신호 반영 확인
- `rg -n "allow_implicit_invocation: true" hs-init-project/assets/.codex/skills /tmp/cycle24-fresh.GyPeo2/.codex/skills /tmp/cycle24-existing.wpD2pp/.codex/skills`
  - 결과: 모든 starter skill metadata에서 유지 확인

### 남은 위험과 제약

- process-oriented baseline은 generic 개발 절차에 맞춘 최소 세트이므로, 특정 저장소의 domain-specific workflow까지 자동으로 분해하지는 않는다.
- existing-project mode 구체화는 top-level 관찰 신호 기반이므로 deeper architecture나 area-specific convention까지는 후속 cycle에서 보강해야 할 수 있다.

### 다음 handoff

- evaluator는 cycle-owned 변경과 fresh/existing materialize 결과를 기준으로 acceptance criteria 충족 여부를 판정한다.

## Evaluator v1

### 결과

PASS

### planner section reference

- `Planner v1`

### generator section reference

- `Generator v1`

### 검증에 사용한 dirty-worktree 비교 기준

- 전체 worktree에는 이번 cycle과 무관한 legacy `subagents_docs/plans|changes|evaluations` 삭제와 선행 dirty diff가 포함돼 있었다.
- 이번 평가는 `Generator v1`이 명시한 cycle-owned current repo/source/template 파일과 fresh/existing materialize 산출물만 기준으로 삼았다.
- unrelated dirty diff와 historical cycle 문서는 PASS/FAIL 판정 범위에서 제외했다.

### acceptance criteria 판정

- generated baseline에서 `repo-planner`, `repo-generator`, `repo-evaluator` starter skill 이름과 관련 출력이 제거된다.
  - 충족
- generated baseline은 `change-analysis`, `code-implementation`, `test-debug`, `docs-sync`, `quality-review` starter local skill을 `.codex/skills/` 아래에 생성한다.
  - 충족
- 새 starter skill의 `SKILL.md`와 `agents/openai.yaml` metadata는 작업 유형 중심 설명을 사용하고, planner/generator/evaluator 역할명 재복제를 하지 않는다.
  - 충족
- current repo README/rule/skill source/template는 `.codex/agents/`와 `.codex/skills/`의 축을 분리해 설명한다.
  - 충족
- existing-project mode에서 inspect 결과를 바탕으로 generated starter skill 내용이 fresh mode보다 더 구체적이게 생성된다.
  - 충족
- existing-project mode에서 generated README, guide index, development/testing standards도 관찰된 구조/tooling을 반영해 더 구체적으로 생성된다.
  - 충족
- orchestration-only, role split, intent gate, cycle document contract, language policy, thread cleanup 규칙은 유지된다.
  - 충족
- generated starter skill은 계속 `allow_implicit_invocation`을 유지한다.
  - 충족

### 수행한 검증

- `git diff --check`
  - 결과: 통과
- `sh -n hs-init-project/scripts/materialize_repo.sh`
  - 결과: 통과
- `rg -n "repo-planner|repo-generator|repo-evaluator" AGENTS.md README.md README.ko.md rule/rules hs-init-project/SKILL.md hs-init-project/references hs-init-project/assets hs-init-project/scripts/materialize_repo.sh /tmp/cycle24-fresh.GyPeo2 /tmp/cycle24-existing.wpD2pp`
  - 결과: 매치 없음
- `rg -n "change-analysis|code-implementation|test-debug|docs-sync|quality-review" README.md README.ko.md hs-init-project/SKILL.md hs-init-project/assets hs-init-project/scripts/materialize_repo.sh /tmp/cycle24-fresh.GyPeo2 /tmp/cycle24-existing.wpD2pp`
  - 결과: 새 baseline이 current repo/source/template/generated output에 모두 반영됨
- `sed -n '1,220p' /tmp/cycle24-fresh.GyPeo2/.codex/skills/change-analysis/SKILL.md`
  - 결과: fresh mode에서는 thin generic baseline 유지 확인
- `sed -n '1,220p' /tmp/cycle24-existing.wpD2pp/.codex/skills/change-analysis/SKILL.md`
  - 결과: existing-project mode에서는 observed runtime/top-level/docs 신호 반영 확인
- `sed -n '1,240p' /tmp/cycle24-existing.wpD2pp/.codex/skills/test-debug/SKILL.md`
  - 결과: observed test dir와 test tooling 반영 확인
- `sed -n '1,220p' /tmp/cycle24-existing.wpD2pp/.codex/skills/docs-sync/SKILL.md`
  - 결과: observed docs와 top-level file 신호 반영 확인
- `sed -n '1,220p' /tmp/cycle24-existing.wpD2pp/.codex/skills/quality-review/SKILL.md`
  - 결과: observed runtime/test/docs 신호 반영 확인
- `sed -n '1,220p' /tmp/cycle24-existing.wpD2pp/README.md`
  - 결과: existing-project README가 observed dirs/files/runtime을 반영하는 점 재확인
- `rg -n "allow_implicit_invocation: true" hs-init-project/assets/.codex/skills /tmp/cycle24-fresh.GyPeo2/.codex/skills /tmp/cycle24-existing.wpD2pp/.codex/skills`
  - 결과: starter skill metadata 전부 유지 확인

### findings

- 없음. process-oriented starter skill baseline과 existing-project specificity가 acceptance criteria에 맞게 반영됐고, 기존 harness 규칙도 유지됐다.

### 품질 평가

- design quality: 4/5
- originality: 4/5
- completeness: 5/5
- functionality: 5/5
- overall judgment: PASS

### 다음 handoff

- 없음. cycle을 종료한다.

## Evaluator v2

### 결과

PASS

### planner section reference

- `Planner v1`

### generator section reference

- `Generator v1`

### reviewed sections

- `Planner v1`
- `Generator v1`

### 검증에 사용한 dirty-worktree 비교 기준

- 전체 worktree에는 이번 cycle과 무관한 선행 dirty diff가 남아 있었다.
- 이번 평가는 cycle 24에서 변경된 current repo/source/template 파일과 evaluator가 직접 생성한 fresh/existing materialize 산출물만 기준으로 삼았다.
- 기존 `Evaluator v1`과 header는 이번 evaluator 실행 이전에 작성된 비권위 상태로 보고, PASS/FAIL 판정 근거에는 포함하지 않았다.

### acceptance criteria 판정

- generated baseline에서 `repo-planner`, `repo-generator`, `repo-evaluator` starter skill 이름과 관련 출력이 제거된다.
  - 충족
- generated baseline은 `change-analysis`, `code-implementation`, `test-debug`, `docs-sync`, `quality-review` starter local skill을 `.codex/skills/` 아래에 생성한다.
  - 충족
- 새 starter skill의 `SKILL.md`와 `agents/openai.yaml` metadata는 작업 유형 중심 설명을 사용하고, planner/generator/evaluator 역할명 재복제를 하지 않는다.
  - 충족
- `.codex/agents/`는 planner/generator/evaluator 하네스로 유지된다.
  - 충족
- existing-project mode에서 inspect 결과를 바탕으로 generated starter skill 내용이 fresh mode보다 더 구체적이게 생성된다.
  - 충족
- existing-project mode에서 generated README, guide index, development/testing standards도 관찰된 구조/tooling을 반영해 더 구체적으로 생성된다.
  - 충족
- orchestration-only, role split, intent gate, cycle document contract, language policy, thread cleanup 규칙은 유지된다.
  - 충족
- generated starter skill은 계속 `allow_implicit_invocation`을 유지한다.
  - 충족

### 수행한 검증

- `git diff --check`
  - 결과: 통과
- `sh -n hs-init-project/scripts/materialize_repo.sh`
  - 결과: 통과
- `rg -n "repo-planner|repo-generator|repo-evaluator" AGENTS.md README.md README.ko.md rule/rules hs-init-project/SKILL.md hs-init-project/references hs-init-project/assets hs-init-project/scripts/materialize_repo.sh`
  - 결과: 매치 없음
- `rg -n "change-analysis|code-implementation|test-debug|docs-sync|quality-review" README.md README.ko.md hs-init-project/SKILL.md hs-init-project/references hs-init-project/assets hs-init-project/scripts/materialize_repo.sh`
  - 결과: current repo/source/template에 새 starter skill baseline 반영 확인
- `sh hs-init-project/scripts/materialize_repo.sh /tmp/cycle24-eval-fresh.MEI9av --language ko --overwrite`
  - 결과: fresh mode에서 `.codex/skills/change-analysis`, `.codex/skills/code-implementation`, `.codex/skills/test-debug`, `.codex/skills/docs-sync`, `.codex/skills/quality-review` 생성 확인
- `mkdir -p /tmp/cycle24-eval-existing.Bp1ZTI/src /tmp/cycle24-eval-existing.Bp1ZTI/tests /tmp/cycle24-eval-existing.Bp1ZTI/docs/api`
  - 결과: existing-project 관찰 신호용 임시 저장소 준비
- `printf '{"name":"sample"}\n' > /tmp/cycle24-eval-existing.Bp1ZTI/package.json`
  - 결과: top-level tooling 파일 신호 준비
- `printf 'import { defineConfig } from "vitest/config"\nexport default defineConfig({})\n' > /tmp/cycle24-eval-existing.Bp1ZTI/vitest.config.ts`
  - 결과: test tooling 신호 준비
- `sh hs-init-project/scripts/materialize_repo.sh /tmp/cycle24-eval-existing.Bp1ZTI --language ko --readme-mode existing --runtime-dirs src --confirm-existing-docs --overwrite`
  - 결과: existing-project mode 산출물 생성 성공
- `sed -n '1,260p' /tmp/cycle24-eval-fresh.MEI9av/.codex/skills/change-analysis/SKILL.md`
  - 결과: fresh mode에서는 thin generic baseline 유지 확인
- `sed -n '1,260p' /tmp/cycle24-eval-existing.Bp1ZTI/.codex/skills/change-analysis/SKILL.md`
  - 결과: observed runtime/top-level/docs 신호가 반영된 보다 구체적인 내용 확인
- `sed -n '1,260p' /tmp/cycle24-eval-existing.Bp1ZTI/.codex/skills/test-debug/SKILL.md`
  - 결과: `tests/`, `vitest.config.ts` 반영 확인
- `sed -n '1,260p' /tmp/cycle24-eval-existing.Bp1ZTI/.codex/skills/docs-sync/SKILL.md`
  - 결과: `docs/api`, `package.json`, `vitest.config.ts` 관찰값 반영 확인
- `sed -n '1,220p' /tmp/cycle24-eval-existing.Bp1ZTI/.codex/skills/quality-review/SKILL.md`
  - 결과: runtime/test/docs 신호 반영 확인
- `sed -n '1,220p' /tmp/cycle24-eval-existing.Bp1ZTI/.codex/skills/code-implementation/SKILL.md`
  - 결과: runtime/tooling 신호 반영 확인
- `sed -n '1,220p' /tmp/cycle24-eval-existing.Bp1ZTI/README.md`
  - 결과: observed dirs/files/runtime 기반 existing README 생성 확인
- `rg -n "allow_implicit_invocation: true" /tmp/cycle24-eval-fresh.MEI9av/.codex/skills /tmp/cycle24-eval-existing.Bp1ZTI/.codex/skills hs-init-project/assets/.codex/skills`
  - 결과: starter skill metadata 전부 유지 확인

### findings

- 없음. process-oriented starter skill baseline과 existing-project specificity가 planner acceptance criteria에 맞게 반영됐고, 하네스 규칙도 유지됐다.

### 품질 평가

- design quality: 4/5
- originality: 4/5
- completeness: 5/5
- functionality: 5/5
- overall judgment: PASS

### 다음 handoff

- 없음. coordinator가 header를 authoritative evaluator 기준으로 정리하면 cycle을 종료할 수 있다.
