# 메인 에이전트 오케스트레이션 전담 문구 재평가

## 판정

PASS

blocker는 발견하지 못했다.

## 평가 범위

- 계획 문서: `subagents_docs/plans/13-main-agent-orchestration-only-replan.md`
- 구현 기록: `subagents_docs/changes/08-main-agent-orchestration-only-sync.md`
- current repo 확인 범위:
  - `AGENTS.md`
  - `rule/rules/subagent-orchestration.md`
  - `rule/rules/subagents-docs.md`
  - `docs/guide/subagent-workflow.md`
  - `README.md`
  - `README.ko.md`
- generated skill 확인 범위:
  - `hs-init-project/SKILL.md`
  - `hs-init-project/agents/openai.yaml`
  - `hs-init-project/references/subagent-orchestration.md`
  - `hs-init-project/assets/AGENTS/root.en.md`
  - `hs-init-project/assets/AGENTS/root.ko.md`
  - `hs-init-project/assets/README/root.en.md`
  - `hs-init-project/assets/README/root.ko.md`
  - `hs-init-project/assets/rule/subagent-orchestration.en.md`
  - `hs-init-project/assets/rule/subagent-orchestration.ko.md`
  - `hs-init-project/assets/subagents_docs/AGENTS.en.md`
  - `hs-init-project/assets/subagents_docs/AGENTS.ko.md`
  - `hs-init-project/assets/docs/guide/subagent-workflow.en.md`
  - `hs-init-project/assets/docs/guide/subagent-workflow.ko.md`
  - `hs-init-project/scripts/materialize_repo.sh`
- fresh generated output:
  - `/tmp/hs-init-main-agent-eval-6Y5hu6`

## 주요 판정 근거

### 1. current repo 규칙에서 메인 에이전트가 orchestration-only임이 직접 명시된다

- `AGENTS.md:26-32`는 메인 에이전트가 orchestration-only이며 handoff 조정과 순서 유지 역할만 맡는다고 명시한다.
- `rule/rules/subagent-orchestration.md:11-13`은 메인 에이전트(coordinator)가 오케스트레이션만 담당하고 `planner/generator/evaluator`를 직접 대행하지 않는다고 못 박는다.
- `rule/rules/subagents-docs.md:33-35`도 메인 에이전트는 문서 흐름 조정만 담당하며 역할 산출물을 직접 대신 작성하지 않는다고 반복한다.
- `docs/guide/subagent-workflow.md:5`, `:33`은 사용자-facing 가이드에서도 같은 의미를 유지한다.

### 2. current repo README도 같은 의미를 반영한다

- `README.md:190`은 메인 에이전트가 orchestration-only로 남아 세 역할을 직접 겸하지 않는다고 적는다.
- `README.ko.md:190`도 같은 뜻으로 메인 에이전트는 순서 조정과 handoff만 맡고, 사용자가 명시적으로 완화하지 않는 한 `planner/generator/evaluator`를 직접 겸하지 않는다고 설명한다.

### 3. generated skill 본문, metadata, reference, template도 같은 기준으로 정렬돼 있다

- `hs-init-project/SKILL.md:105-109`는 메인 에이전트가 orchestration-only이며 `planner/generator/evaluator`를 직접 대행하지 않는다고 규정한다.
- `hs-init-project/agents/openai.yaml:4`는 default prompt에 같은 의미를 포함한다.
- `hs-init-project/references/subagent-orchestration.md:8`, `:62`는 generated repo 기준 문서에서도 메인 에이전트가 역할 소유권을 직접 흡수하지 않는다고 적는다.
- `hs-init-project/assets/AGENTS/root.en.md:56-60`, `root.ko.md:56-60`, `assets/rule/subagent-orchestration.en.md:11`, `assets/rule/subagent-orchestration.ko.md:11`, `assets/subagents_docs/AGENTS.en.md:17`, `assets/subagents_docs/AGENTS.ko.md:17`, `assets/docs/guide/subagent-workflow.en.md:4`, `assets/docs/guide/subagent-workflow.ko.md:4`가 모두 같은 문구를 유지한다.
- `hs-init-project/scripts/materialize_repo.sh:1234`, `:1273`도 inline generated rule 본문에 같은 의미를 넣어 생성 결과에서 누락되지 않게 한다.

### 4. fresh generated output에도 orchestration-only 문구가 실제로 생성된다

- `/tmp/hs-init-main-agent-eval-6Y5hu6/README.md:27`은 메인 에이전트가 orchestration-only이며 세 역할을 직접 겸하지 않는다고 적는다.
- `/tmp/hs-init-main-agent-eval-6Y5hu6/AGENTS.md:56-61`은 root guidance에서 같은 원칙을 유지한다.
- `/tmp/hs-init-main-agent-eval-6Y5hu6/rule/rules/subagent-orchestration.md:11`, `:61-62`는 rule 레벨에서 메인 에이전트의 비대행 원칙을 명시한다.
- `/tmp/hs-init-main-agent-eval-6Y5hu6/rule/rules/subagents-docs.md:10`, `:18-21`과 `/tmp/hs-init-main-agent-eval-6Y5hu6/docs/guide/subagent-workflow.md:4-5`도 같은 의미를 반복한다.

## 수용 기준 대조

1. current project rules explicitly say the main agent/coordinator is orchestration-only.
   - 충족
2. current project rules make clear the main agent does not directly become `planner/generator/evaluator` by default.
   - 충족
3. `README.md` and `README.ko.md` reflect the same meaning.
   - 충족
4. `hs-init-project` skill rules/templates/references/metadata generate the same meaning in new repos.
   - 충족
5. fresh generated output contains the same explicit orchestration-only wording.
   - 충족

## 점수

- design quality: 9/10
- originality: 8/10
- completeness: 9/10
- functionality: 9/10
- weighted overall: 8.8/10

## 총평

이번 변경은 current repo 규칙, README, generated skill 본문/metadata/reference/template, fresh generated output까지 같은 메시지로 수렴했다.

메인 에이전트는 오케스트레이션만 담당하고, `planner/generator/evaluator`의 역할 소유권은 각 subagent에 남는다는 점이 문서 전반에서 충분히 명시적이다.

이번 판정은 PASS다.

## 실행한 핵심 검증 명령

```sh
sed -n '1,260p' subagents_docs/plans/13-main-agent-orchestration-only-replan.md
sed -n '1,260p' subagents_docs/changes/08-main-agent-orchestration-only-sync.md
rg -n "orchestration-only|메인 에이전트|main agent|직접 겸하지|does not directly become planner|coordinator|planner -> generator -> evaluator|implemented result|acceptance criteria" AGENTS.md README.md README.ko.md rule docs hs-init-project -S
sh hs-init-project/scripts/materialize_repo.sh /tmp/hs-init-main-agent-eval-6Y5hu6 --language en
sed -n '20,40p' /tmp/hs-init-main-agent-eval-6Y5hu6/README.md
sed -n '1,120p' /tmp/hs-init-main-agent-eval-6Y5hu6/AGENTS.md
sed -n '1,140p' /tmp/hs-init-main-agent-eval-6Y5hu6/rule/rules/subagent-orchestration.md
sed -n '1,120p' /tmp/hs-init-main-agent-eval-6Y5hu6/rule/rules/subagents-docs.md
sed -n '1,120p' /tmp/hs-init-main-agent-eval-6Y5hu6/docs/guide/subagent-workflow.md
```
