Status: PASS
Current Plan Version: Evaluator v1
Next Handoff: complete

# 21. implicit skill bootstrap

## Planner v1

### 목표

- `hs-init-project`가 생성하는 기본 구조에 starter local skill 세트를 포함시킨다.
- 생성되는 starter skill은 `.codex/skills/` 아래에 배치한다.
- starter skill은 planner/generator/evaluator에 정적으로 묶지 않고, `SKILL.md` 설명과 `agents/openai.yaml`의 implicit invocation metadata로 자연스럽게 호출되도록 설계한다.
- current repo 규칙과 generated structure가 같은 기준을 따르도록 맞춘다.

### 범위

- current repo의 규칙/문서에서 local skill의 implicit invocation 원칙을 명시한다.
- `hs-init-project/SKILL.md`, references, 공개 README, asset template, materializer에 starter local skill 생성 구조를 반영한다.
- generated repository baseline output에 `.codex/skills/`와 starter skill 문서를 포함시킨다.
- starter skill은 각 역할에 대응하는 local skill 세트로 설계하되, 역할 binding 규칙이 아니라 implicit invocation 대상 skill로 설명한다.

### 비범위

- planner/generator/evaluator에 skill을 정적으로 고정 배정하는 규칙 추가
- coordinator가 spawn 시 특정 skill을 강제로 attach해야 한다는 규칙 추가
- platform capability를 넘는 hard binding 또는 hidden assignment 약속
- starter skill 외의 임의 도메인 skill 대량 생성

### 사용자 관점 결과

- `hs-init-project`로 초기화된 저장소는 기본 하네스 외에 `.codex/skills/` 아래 starter local skill 세트를 함께 가진다.
- 각 starter skill은 repository rule을 복사하지 않고 참조형으로 연결한다.
- subagent나 main agent는 작업 설명이 role/task와 맞을 때 해당 starter skill을 암시적으로 사용할 수 있다.
- generated repository 문서는 “skill은 필요 시 암시적으로 호출된다”는 점을 설명하지만, 역할별 고정 배정은 주장하지 않는다.

### acceptance criteria

- `hs-init-project/SKILL.md`의 target outputs와 bundled resources에 starter local skill 구조가 명시된다.
- `hs-init-project/scripts/materialize_repo.sh`가 `.codex/skills/` 아래 starter skill 파일을 실제로 생성한다.
- starter skill template는 최소 `SKILL.md`와 `agents/openai.yaml`를 포함하고, `policy.allow_implicit_invocation: true`를 사용한다.
- starter skill 문구는 local repository rule을 참조형으로 연결하고, hard binding이나 coordinator-managed attachment를 요구하지 않는다.
- current repo rule/doc에는 “role별 skill이 있더라도 규약으로 묶지 않고 implicit invocation으로 동작한다”는 기준이 반영된다.
- generated repo 설명 문서와 template도 같은 기준으로 정렬된다.

### 제약

- current Codex agent config에는 역할별 static skill binding 필드가 드러나지 않으므로, 생성 구조는 이를 전제로 설계하면 안 된다.
- skill 본문은 얇게 유지하고, 안정적인 상세 규칙은 `rule/rules/*.md`를 참조해야 한다.
- 언어별 생성 규칙을 유지해야 하므로 starter skill template도 선택된 언어를 따라야 한다.
- dirty worktree이므로 이번 cycle 변경 범위는 skill bootstrap 관련 파일로 명확히 제한해야 한다.

### 위험 요소

- skill 이름이 너무 일반적이면 암시적 호출 범위가 과도하게 넓어질 수 있다.
- skill 설명이 너무 약하면 implicit invocation이 잘 일어나지 않을 수 있다.
- rule 내용을 skill에 중복 복사하면 future drift가 생긴다.
- generated repo에 starter skill을 기본 포함시키면 baseline이 과하게 무거워질 수 있으므로 최소 구조로 제한해야 한다.

### 의존관계

- `rule/rules/instruction-model.md`
- `rule/rules/subagent-orchestration.md`
- `rule/rules/project-structure.md`
- `hs-init-project/SKILL.md`
- `hs-init-project/references/structure-initialization.md`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/scripts/materialize_repo.sh`

### open questions

- starter skill의 이름을 `planner-default`/`generator-default`/`evaluator-default`로 둘지, 더 repository-neutral한 slug로 둘지는 generator가 최소 충돌 기준으로 정해야 한다.
- starter skill에 별도 `references/`를 둘지, `SKILL.md` + `agents/openai.yaml`만 둘지는 최소 baseline 관점에서 판단이 필요하다.

### 다음 handoff

- generator는 implicit invocation 중심 모델을 유지한 채 current repo 규칙/문서, `hs-init-project` template/reference/script, starter skill asset을 구현한다.

## Generator v1

### planner section reference

- `Planner v1`

### 실제 반영한 범위

- current repo의 root/rule/guide/subagents 문서에 local starter skill은 역할 고정 배정이 아니라 암시적 호출 모델이라는 기준을 추가했다.
- `hs-init-project`의 public README, `SKILL.md`, references, asset template, materializer를 `.codex/skills/repo-planner|repo-generator|repo-evaluator` baseline에 맞게 확장했다.
- starter local skill asset 3종을 추가하고, 각 skill이 thin `SKILL.md`와 `agents/openai.yaml`만 가지며 repository rule을 참조형으로 읽도록 만들었다.
- 선택 언어 규칙이 starter local skill의 `SKILL.md` 본문에도 적용되도록 language reference/rule 문구를 보강했다.

### 변경 파일 목록

- `AGENTS.md`
- `README.md`
- `README.ko.md`
- `rule/rules/instruction-model.md`
- `rule/rules/subagent-orchestration.md`
- `rule/rules/language-policy.md`
- `docs/guide/subagent-workflow.md`
- `subagents_docs/AGENTS.md`
- `hs-init-project/SKILL.md`
- `hs-init-project/agents/openai.yaml`
- `hs-init-project/references/structure-initialization.md`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/references/language-output.md`
- `hs-init-project/assets/AGENTS/root.en.md`
- `hs-init-project/assets/AGENTS/root.ko.md`
- `hs-init-project/assets/README/root.en.md`
- `hs-init-project/assets/README/root.ko.md`
- `hs-init-project/assets/rule/instruction-model.en.md`
- `hs-init-project/assets/rule/instruction-model.ko.md`
- `hs-init-project/assets/rule/project-structure.en.md`
- `hs-init-project/assets/rule/project-structure.ko.md`
- `hs-init-project/assets/rule/language-policy.en.md`
- `hs-init-project/assets/rule/language-policy.ko.md`
- `hs-init-project/assets/docs/guide/subagent-workflow.en.md`
- `hs-init-project/assets/docs/guide/subagent-workflow.ko.md`
- `hs-init-project/assets/subagents_docs/AGENTS.en.md`
- `hs-init-project/assets/subagents_docs/AGENTS.ko.md`
- `hs-init-project/assets/.codex/skills/repo-planner/SKILL.en.md`
- `hs-init-project/assets/.codex/skills/repo-planner/SKILL.ko.md`
- `hs-init-project/assets/.codex/skills/repo-planner/agents/openai.en.yaml`
- `hs-init-project/assets/.codex/skills/repo-planner/agents/openai.ko.yaml`
- `hs-init-project/assets/.codex/skills/repo-generator/SKILL.en.md`
- `hs-init-project/assets/.codex/skills/repo-generator/SKILL.ko.md`
- `hs-init-project/assets/.codex/skills/repo-generator/agents/openai.en.yaml`
- `hs-init-project/assets/.codex/skills/repo-generator/agents/openai.ko.yaml`
- `hs-init-project/assets/.codex/skills/repo-evaluator/SKILL.en.md`
- `hs-init-project/assets/.codex/skills/repo-evaluator/SKILL.ko.md`
- `hs-init-project/assets/.codex/skills/repo-evaluator/agents/openai.en.yaml`
- `hs-init-project/assets/.codex/skills/repo-evaluator/agents/openai.ko.yaml`
- `hs-init-project/scripts/materialize_repo.sh`

### 검증에 사용한 workspace/baseline scope

- dirty worktree 전체가 아니라 cycle 21 범위의 규칙/문서/skill template/materializer 변경만 기준으로 검증했다.
- baseline scope는 current repo의 implicit skill 원칙 문구와 `hs-init-project`의 starter local skill 생성 구조다.

### 검증

- `rg -n "repo-planner|repo-generator|repo-evaluator|\\.codex/skills|implicit invocation|암시적 호출|hard binding|고정 배정" ...`로 current repo와 generated-skill 문구 정렬 확인
- `git diff --check`
- `sh -n hs-init-project/scripts/materialize_repo.sh`
- `mktemp -d`로 만든 임시 디렉토리에 `sh hs-init-project/scripts/materialize_repo.sh "$tmpdir" --language ko --overwrite` 실행
- 생성 결과에서 `.codex/skills/repo-planner|repo-generator|repo-evaluator`와 각 `SKILL.md`, `agents/openai.yaml` 생성 확인
- 생성된 `repo-planner/agents/openai.yaml`에서 `policy.allow_implicit_invocation: true` 확인

### 미해결 위험과 제약

- starter skill 이름을 `repo-*`로 정해 과도하게 일반적인 `planner-default`보다 충돌 가능성을 낮췄지만, 실제 암시적 호출 민감도는 런타임 매칭 품질에 의존한다.
- 이번 cycle에서는 current repo 자체에 `.codex/skills/`를 실제 도입하지 않았고, generated baseline과 규칙/문서 정렬까지만 반영했다.

### 다음 handoff

- evaluator는 cycle-owned 변경 범위만 기준으로 starter local skill 생성과 implicit invocation-only 모델이 plan acceptance를 만족하는지 검증한다.

## Evaluator v1

PASS

### planner section reference

- `Planner v1`

### generator section reference

- `Generator v1`

### acceptance criteria 판정

- `hs-init-project/SKILL.md`에 `.codex/skills/repo-planner`, `repo-generator`, `repo-evaluator` target output과 bundled resource가 명시돼 있다.
- `hs-init-project/scripts/materialize_repo.sh`가 `.codex/skills/` 아래 starter local skill 파일을 실제로 생성한다.
- starter local skill template는 `SKILL.md`와 `agents/openai.yaml`만 가지며, `policy.allow_implicit_invocation: true`를 사용한다.
- starter local skill 문구는 repository rule을 참조형으로 연결하고, static role binding이나 coordinator-managed attachment를 요구하지 않는다.
- current repo 규칙/문서는 local skill을 planner/generator/evaluator에 고정 배정하지 않고 암시적 호출 모델로 설명한다.
- generated repo 설명 문서와 template도 같은 기준으로 정렬돼 있다.

### 실제 검증 절차

- `git diff --check`
- `sh -n hs-init-project/scripts/materialize_repo.sh`
- `rg -n "\\.codex/skills|implicit invocation|암시적 호출|hard binding|고정 배정|repo-planner|repo-generator|repo-evaluator|allow_implicit_invocation" ...`
- `mktemp -d`로 만든 임시 디렉토리에 `sh hs-init-project/scripts/materialize_repo.sh "$tmpdir" --language ko --overwrite` 실행
- 생성 결과에서 `.codex/skills/repo-planner|repo-generator|repo-evaluator`와 각 `SKILL.md`, `agents/openai.yaml` 생성 확인
- 생성된 `repo-planner/agents/openai.yaml`의 `policy.allow_implicit_invocation: true`와 `repo-planner/SKILL.md`의 implicit invocation 문구 확인

### dirty worktree 비교 기준

- 비교 기준은 dirty worktree 전체가 아니라 cycle 21의 owned scope로 한정했다.
- owned scope는 current repo의 implicit skill 원칙 관련 문서 변경, `hs-init-project`의 starter local skill template/reference/script 변경, cycle 21 문서다.
- unrelated historical diff와 prior cycle 흔적은 PASS/FAIL 판단에서 제외했다.

### 관찰 결과와 재현 정보

- current repo의 `AGENTS.md`, `rule/rules/instruction-model.md`, `rule/rules/subagent-orchestration.md`, `rule/rules/subagents-docs.md`, `docs/guide/subagent-workflow.md`, `subagents_docs/AGENTS.md`에서 local skill이 hard binding이 아니라 implicit invocation 모델로 정리돼 있다.
- `hs-init-project/SKILL.md`, `hs-init-project/agents/openai.yaml`, references, asset template, public README가 `.codex/skills/` starter local skill baseline과 implicit invocation-only 모델을 일관되게 설명한다.
- materialize 결과에서 `.codex/skills/repo-planner`, `repo-generator`, `repo-evaluator`가 실제 생성되고, 선택 언어인 Korean 모드에서 `SKILL.md` 본문이 한국어로 materialize된다.
- 확인한 범위 안에서는 coordinator-managed attachment 규칙이나 static role binding 문구가 발견되지 않았다.

### 문제 목록

- blocker 없음
- cycle acceptance를 깨는 구현 누락 없음

### 점수 또는 등급

- overall: PASS
- design quality: 4.4/5
- originality: 4.1/5
- completeness: 4.5/5
- functionality: 4.6/5

### 다음 handoff

- coordinator는 cycle header를 `PASS` / `Evaluator v1` / `complete`로 갱신한다.
