# 메인 에이전트 오케스트레이션 전담 문구 동기화 구현 기록

## 요약

메인 에이전트가 `planner/generator/evaluator`를 직접 겸하지 않고 서브에이전트 오케스트레이션만 담당한다는 점을 current repo 규칙, `hs-init-project` 생성 규칙, README 설명 전반에 명시적으로 추가했다.

## 변경 내용

- current repo의 `AGENTS.md`, `rule/rules/subagent-orchestration.md`, `rule/rules/subagents-docs.md`, `docs/guide/subagent-workflow.md`, `README.md`, `README.ko.md`에 메인 에이전트의 orchestration-only 역할을 같은 의미로 반영했다.
- `hs-init-project/SKILL.md`, `hs-init-project/agents/openai.yaml`, `hs-init-project/references/subagent-orchestration.md`에 메인 에이전트가 기본적으로 planner/generator/evaluator를 직접 대행하지 않는다고 명시했다.
- generated repo 템플릿인 `assets/AGENTS/*`, `assets/README/*`, `assets/rule/subagent-orchestration.*`, `assets/subagents_docs/AGENTS.*`, `assets/docs/guide/subagent-workflow.*`에도 같은 문구를 추가했다.
- `hs-init-project/scripts/materialize_repo.sh`의 inline `subagents-docs` rule text에도 같은 규칙을 넣어 fresh/existing 생성 결과가 빠지지 않도록 맞췄다.

## 결과

- current repo 규칙과 generated repo 규칙 모두에서 메인 에이전트는 orchestration-only 역할로 설명된다.
- planner/generator/evaluator의 소유권은 각 subagent에만 남고, 메인 에이전트는 순서 유지, handoff 정리, 대기, 재계획만 담당한다.
- 사용자가 역할 분리를 명시적으로 완화하지 않는 한 메인 에이전트가 이 세 역할을 직접 겸하지 않는다는 점이 README와 규칙 문서 전반에서 일치한다.

## 검증

- 수동 검색:
  - `rg -n "orchestration-only|직접 겸하지|직접 become|main agent|메인 에이전트|coordinator" AGENTS.md README.md README.ko.md rule docs hs-init-project -S`
  - `rg -n "planner -> generator -> evaluator|implemented result|acceptance criteria" AGENTS.md README.md README.ko.md rule docs hs-init-project -S`
- 생성 검증:
  - fresh repo 생성 후 generated `AGENTS.md`, `rule/rules/subagent-orchestration.md`, `rule/rules/subagents-docs.md`, `docs/guide/subagent-workflow.md`의 문구 확인 예정
