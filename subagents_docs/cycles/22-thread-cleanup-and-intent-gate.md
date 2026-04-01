Status: PASS
Current Plan Version: Evaluator v1
Next Handoff: complete

# 22. thread cleanup and intent gate

## Planner v1

### 목표

- 메인 에이전트가 orchestration-only 역할로 남으면서도 subagent thread lifecycle을 끝까지 책임지도록 규칙을 강화한다.
- 오래 기다리는 것 자체는 허용하되, 완료되거나 더 이상 필요 없는 subagent thread는 종료 후 정리해야 한다는 운영 규칙을 명시한다.
- 사용자가 명시적으로 구현/변경/materialize를 요청하지 않은 경우, 분석/질문/리뷰/설명 요청을 구현 요청으로 오인해 generator를 띄우거나 파일을 수정하지 않도록 intent gate를 명시한다.
- current repo 규칙과 `hs-init-project` generated output이 같은 기준을 따르도록 맞춘다.

### 범위

- current repo의 orchestration 관련 rule/doc에 thread cleanup 책임과 implementation intent gate를 추가한다.
- `hs-init-project/SKILL.md`, references, asset template, generated rule/doc/skill prompt에 동일한 기준을 반영한다.
- generated repository에서 main agent가 generator를 시작하기 전 user intent를 판별해야 한다는 기준을 넣는다.
- generated repository에서 coordinator가 완료된 subagent thread를 정리하고, stale session이나 thread limit blockage를 운영 작업으로 처리해야 한다는 기준을 넣는다.

### 비범위

- planner/generator/evaluator 역할 분리 자체를 완화하는 변경
- 메인 에이전트가 직접 구현하도록 허용하는 변경
- subagent platform의 실제 runtime behavior를 바꾸는 시스템 레벨 패치
- 사용자 명시 없이도 구현으로 자동 진입하는 heuristic 확대

### 사용자 관점 결과

- 사용자가 질문, 분석, 설명, 리뷰만 요청하면 저장소는 구현이나 materialize로 곧바로 넘어가지 않는다.
- 구현은 사용자 명시 요청이나 명확한 변경 지시가 있을 때만 planner -> generator -> evaluator 흐름으로 시작된다.
- coordinator는 subagent 결과를 받으면 idle/completed thread를 정리하고, thread limit으로 막히면 cleanup을 우선 수행한다.
- generated repository 문서와 starter local skill도 같은 intent gate와 thread cleanup 원칙을 설명한다.

### acceptance criteria

- current repo rule/doc에 “메인 에이전트는 오래 기다릴 수 있지만, 완료되거나 불필요해진 subagent thread는 정리해야 한다”는 기준이 명시된다.
- current repo rule/doc에 “사용자 명시 구현 요청이 없으면 분석/질문/리뷰/설명 단계에서 generator를 시작하거나 파일을 수정하지 않는다”는 기준이 명시된다.
- `hs-init-project/SKILL.md`와 references가 generated repository baseline에도 동일한 thread cleanup 및 intent gate 규칙을 요구한다.
- generated rule/template/root AGENTS/subagent workflow/local skill template이 같은 기준으로 정렬된다.
- generated starter local skill은 분석/질문 요청을 구현으로 오인하지 않도록 skill body나 description에서 intent gate를 따른다.
- static role binding 금지, main direct implementation 금지 원칙은 유지된다.

### 제약

- 현재 시스템/developer prompt가 가진 기본 구현 성향과 별개로, 저장소 규칙과 generated output 안에서는 intent gate를 더 명시적으로 적어야 한다.
- coordinator가 thread cleanup을 책임지더라도 실제 close 동작은 runtime 도구 availability에 의존한다.
- dirty worktree이므로 이번 cycle의 평가 범위는 thread cleanup 및 intent gate 관련 문구/템플릿/skill prompt 변경으로 제한해야 한다.
- skill body는 계속 얇게 유지해야 하므로 stable한 장문 규칙은 `rule/rules/*.md` 참조형으로 연결해야 한다.

### 위험 요소

- intent gate 문구가 너무 약하면 여전히 분석 요청이 구현으로 오인될 수 있다.
- intent gate 문구가 너무 강하면 사용자가 사실상 구현을 요청했을 때도 과도하게 멈출 수 있다.
- thread cleanup 책임을 여러 문서에 중복 서술하면 drift가 생길 수 있다.
- generated skill prompt와 rule 문서의 표현이 다르면 main agent와 subagent가 서로 다른 운영 모델을 따를 위험이 있다.

### 의존관계

- `rule/rules/instruction-model.md`
- `rule/rules/subagent-orchestration.md`
- `rule/rules/subagents-docs.md`
- `docs/guide/subagent-workflow.md`
- `AGENTS.md`
- `hs-init-project/SKILL.md`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/references/structure-initialization.md`
- `hs-init-project/references/language-output.md`
- `hs-init-project/assets/AGENTS/`
- `hs-init-project/assets/rule/`
- `hs-init-project/assets/docs/guide/`
- `hs-init-project/assets/subagents_docs/`
- `hs-init-project/assets/.codex/skills/`

### open questions

- intent gate 기준을 root `AGENTS.md`와 subagent rule 양쪽에 두되, generated local skill body에도 직접 한 줄로 넣을지 generator가 최소 중복 기준으로 판단해야 한다.
- thread cleanup 규칙을 cycle 문서 계약까지 내릴지, orchestration rule과 user-facing workflow 문서 수준에서 유지할지는 generator가 범위 대비 효과를 보고 결정해야 한다.

### 다음 handoff

- generator는 main direct implementation 금지 원칙을 유지한 채 current repo와 `hs-init-project` generated output에 thread cleanup 및 implementation intent gate 규칙을 반영한다.

## Generator v1

### planner section reference

- `Planner v1`

### 실제 반영한 범위

- current repo 규칙/문서에 coordinator의 thread cleanup 책임과 implementation intent gate를 추가했다.
- current repo의 planner/generator/evaluator prompt에 analysis-only 요청과 explicit implementation intent 부재 시의 금지 규칙을 보강했다.
- `hs-init-project`의 `SKILL.md`, references, generated root/rule/guide/subagents templates, `.codex/agents/*.toml`, starter local skill template와 openai metadata에 동일한 기준을 반영했다.
- main direct implementation 금지와 역할 분리 원칙은 유지했다.

### 변경 파일 목록

- `AGENTS.md`
- `rule/rules/instruction-model.md`
- `rule/rules/subagent-orchestration.md`
- `rule/rules/subagents-docs.md`
- `docs/guide/subagent-workflow.md`
- `subagents_docs/AGENTS.md`
- `.codex/agents/planner.toml`
- `.codex/agents/generator.toml`
- `.codex/agents/evaluator.toml`
- `hs-init-project/SKILL.md`
- `hs-init-project/agents/openai.yaml`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/references/structure-initialization.md`
- `hs-init-project/assets/AGENTS/root.en.md`
- `hs-init-project/assets/AGENTS/root.ko.md`
- `hs-init-project/assets/rule/instruction-model.en.md`
- `hs-init-project/assets/rule/instruction-model.ko.md`
- `hs-init-project/assets/rule/subagent-orchestration.en.md`
- `hs-init-project/assets/rule/subagent-orchestration.ko.md`
- `hs-init-project/assets/docs/guide/subagent-workflow.en.md`
- `hs-init-project/assets/docs/guide/subagent-workflow.ko.md`
- `hs-init-project/assets/subagents_docs/AGENTS.en.md`
- `hs-init-project/assets/subagents_docs/AGENTS.ko.md`
- `hs-init-project/assets/.codex/agents/planner.toml`
- `hs-init-project/assets/.codex/agents/generator.toml`
- `hs-init-project/assets/.codex/agents/evaluator.toml`
- `hs-init-project/assets/.codex/skills/repo-planner/SKILL.en.md`
- `hs-init-project/assets/.codex/skills/repo-planner/SKILL.ko.md`
- `hs-init-project/assets/.codex/skills/repo-generator/SKILL.en.md`
- `hs-init-project/assets/.codex/skills/repo-generator/SKILL.ko.md`
- `hs-init-project/assets/.codex/skills/repo-evaluator/SKILL.en.md`
- `hs-init-project/assets/.codex/skills/repo-evaluator/SKILL.ko.md`
- `hs-init-project/assets/.codex/skills/repo-planner/agents/openai.en.yaml`
- `hs-init-project/assets/.codex/skills/repo-planner/agents/openai.ko.yaml`
- `hs-init-project/assets/.codex/skills/repo-generator/agents/openai.en.yaml`
- `hs-init-project/assets/.codex/skills/repo-generator/agents/openai.ko.yaml`
- `hs-init-project/assets/.codex/skills/repo-evaluator/agents/openai.en.yaml`
- `hs-init-project/assets/.codex/skills/repo-evaluator/agents/openai.ko.yaml`

### 검증에 사용한 workspace/baseline scope

- dirty worktree 전체가 아니라 cycle 22의 intent gate 및 thread cleanup 관련 rule/doc/template/prompt 변경만 기준으로 검증했다.
- baseline scope는 current repo의 orchestration/intent 관련 문구와 generated output의 동일 항목이다.

### 검증

- `git diff --check`
- `rg -n "analysis-only|질문, 리뷰, 설명|completed/unused|thread limit|cleanup|명시적으로 구현|stale sessions" ...`
- `mktemp -d`로 만든 임시 디렉토리에 `sh hs-init-project/scripts/materialize_repo.sh "$tmpdir" --language ko --overwrite` 실행
- 생성 결과에서 generated `AGENTS.md`, `rule/rules/instruction-model.md`, `rule/rules/subagent-orchestration.md`, `subagents_docs/AGENTS.md`, `docs/guide/subagent-workflow.md`에 intent gate와 thread cleanup 문구가 materialize되는지 확인

### 미해결 위험과 제약

- intent gate는 explicit request 기준으로 강화됐지만, 실제 런타임에서 사용자의 표현이 모호하면 여전히 coordinator의 해석이 필요하다.
- thread cleanup 책임은 규칙과 prompt에 명시됐지만, 실제 close 동작은 런타임 도구 availability에 의존한다.

### 다음 handoff

- evaluator는 cycle-owned 변경 범위만 기준으로 thread cleanup 책임과 implementation intent gate가 current repo와 generated output에 일관되게 반영됐는지 검증한다.

## Evaluator v1

PASS

### planner section reference

- `Planner v1`

### generator section reference

- `Generator v1`

### acceptance criteria 판정

- current repo의 `AGENTS.md`, `rule/rules/instruction-model.md`, `rule/rules/subagent-orchestration.md`, `rule/rules/subagents-docs.md`, `docs/guide/subagent-workflow.md`, `subagents_docs/AGENTS.md`, `.codex/agents/*.toml`에 coordinator thread cleanup 책임과 implementation intent gate가 반영돼 있다.
- `hs-init-project/SKILL.md`, `hs-init-project/agents/openai.yaml`, references, generated root/rule/guide/subagents templates, `.codex/agents/*.toml`, starter local skill template가 generated repository baseline에도 같은 기준을 요구한다.
- generated starter local skill은 분석/질문 요청을 구현으로 오인하지 않도록 `SKILL.md`/`openai.yaml`에 intent gate를 가진다.
- stale session, thread limit blockage 시 cleanup 우선 원칙이 명시돼 있다.
- main direct implementation 금지와 planner/generator/evaluator 역할 분리 원칙은 유지된다.

### 실제 검증 절차

- `git diff --check`
- `rg -n "completed/unused|thread cleanup|thread limit|stale session|analysis-only|명시적으로 구현|분석, 질문, 리뷰, 설명|generator를 띄우지|generator를 시작|직접 구현 대신 cleanup|orchestration-only" AGENTS.md rule/rules docs/guide/subagent-workflow.md subagents_docs/AGENTS.md .codex/agents/*.toml hs-init-project/SKILL.md hs-init-project/agents/openai.yaml hs-init-project/references/*.md hs-init-project/assets/AGENTS/*.md hs-init-project/assets/rule/*.md hs-init-project/assets/docs/guide/*.md hs-init-project/assets/subagents_docs/*.md hs-init-project/assets/.codex/agents/*.toml hs-init-project/assets/.codex/skills/*/SKILL.* hs-init-project/assets/.codex/skills/*/agents/openai.*`
- `mktemp -d`로 만든 임시 디렉토리에 `sh hs-init-project/scripts/materialize_repo.sh "$tmpdir" --language ko --overwrite` 실행
- 생성 결과에서 `AGENTS.md`, `rule/rules/instruction-model.md`, `rule/rules/subagent-orchestration.md`, `subagents_docs/AGENTS.md`, `docs/guide/subagent-workflow.md`, `.codex/agents/*.toml`, `.codex/skills/repo-planner|repo-generator|repo-evaluator`에 intent gate와 thread cleanup 문구가 materialize되는지 확인

### dirty worktree 비교 기준

- dirty worktree 전체가 아니라 cycle 22에서 변경된 orchestration/intent gate 관련 rule, doc, template, prompt, cycle 문서만 평가 기준으로 삼았다.
- 이전 cycle에서 누적된 unrelated diff와 historical change는 PASS/FAIL 판정에서 제외했다.
- cycle-owned scope는 `AGENTS.md`, `rule/rules/instruction-model.md`, `rule/rules/subagent-orchestration.md`, `rule/rules/subagents-docs.md`, `docs/guide/subagent-workflow.md`, `subagents_docs/AGENTS.md`, `.codex/agents/*.toml`, `hs-init-project/SKILL.md`, `hs-init-project/agents/openai.yaml`, `hs-init-project/references/*.md`, generated asset templates, starter local skill templates, cycle 22 문서다.

### 관찰 결과와 재현 정보

- current repo에서는 메인 에이전트가 구현 의도가 없는 요청에서 멈춰야 한다는 기준과 completed/unused subagent thread 정리 책임이 root/rule/guide/subagents/.codex prompt에 일관되게 들어가 있다.
- generated output에서도 root `AGENTS.md`, `rule/rules/instruction-model.md`, `rule/rules/subagent-orchestration.md`, `subagents_docs/AGENTS.md`, `docs/guide/subagent-workflow.md`, `.codex/agents/*.toml`, starter local skills가 같은 기준으로 materialize된다.
- generated starter local skill 중 `repo-planner`, `repo-generator`, `repo-evaluator`는 analysis-only 상태를 implementation trigger로 사용하지 않도록 intent gate를 가진다.
- 확인한 범위 안에서 main direct implementation 허용이나 역할 분리 완화 문구는 발견되지 않았다.

### 문제 목록

- blocker 없음
- acceptance criteria 위반 없음

### 점수 또는 등급

- overall: PASS
- design quality: 4.5/5
- originality: 4.2/5
- completeness: 4.7/5
- functionality: 4.6/5

### 다음 handoff

- coordinator는 cycle header를 `PASS` / `Evaluator v1` / `complete`로 갱신하고, 완료된 evaluator thread를 정리한다.
