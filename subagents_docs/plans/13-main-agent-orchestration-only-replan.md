# 메인 에이전트 오케스트레이션 전담 문구 정리 계획

## 배경

현재 규칙과 README에는 `coordinator`가 subagent 응답이 느릴 때 직접 구현하지 말아야 한다는 문구는 있다.
하지만 메인 에이전트가 결국 하는 일은 subagent 오케스트레이션뿐이며, planner/generator/evaluator 역할을 직접 대행하지 않는다는 점은 current repo와 `hs-init-project` 생성 구조물 전체에서 아직 충분히 선명하지 않다.

이번 변경은 그 문구를 명시적으로 정리하는 최소 범위 작업이다.

## 목표

1. 현재 프로젝트 규칙과 README에서 메인 에이전트/코디네이터의 역할이 orchestration-only임을 분명히 한다.
2. `hs-init-project`가 생성하는 규칙, README 템플릿, reference 문서에서도 같은 의미가 반복되도록 맞춘다.
3. planner/generator/evaluator 역할은 각 subagent가 맡고, 메인 에이전트는 이 역할들을 조정하고 순서를 유지하는 역할만 한다는 점을 일관되게 남긴다.

## 핵심 수정 범위

### current repo

- `AGENTS.md`
- `rule/rules/subagent-orchestration.md`
- `rule/rules/subagents-docs.md`
- `docs/guide/subagent-workflow.md`
- `README.md`
- `README.ko.md`
- 필요 시 `docs/implementation/AGENTS.md`
- 필요 시 `docs/implementation/subagent-harness/*.md`

### generated skill

- `hs-init-project/SKILL.md`
- `hs-init-project/agents/openai.yaml`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/assets/AGENTS/root.en.md`
- `hs-init-project/assets/AGENTS/root.ko.md`
- `hs-init-project/assets/docs/guide/subagent-workflow.en.md`
- `hs-init-project/assets/docs/guide/subagent-workflow.ko.md`
- `hs-init-project/assets/rule/subagent-orchestration.en.md`
- `hs-init-project/assets/rule/subagent-orchestration.ko.md`
- `hs-init-project/assets/subagents_docs/AGENTS.en.md`
- `hs-init-project/assets/subagents_docs/AGENTS.ko.md`
- 필요 시 `hs-init-project/assets/rule/documentation-boundaries.*.md`

## 변경 원칙

- 기존의 `subagents` 느림 방지 규칙은 유지한다.
- 새로 추가할 표현은 “직접 구현 금지”를 넘어서 “메인 에이전트는 오케스트레이션만 담당”이라고 분명히 적는다.
- planner/generator/evaluator의 책임은 서로 대체 가능하지 않다고 적는다.
- README와 skill 템플릿은 같은 의미를 같은 순서로 설명한다.
- 문구는 짧게 유지하고, 구조 변경은 하지 않는다.

## 수용 기준

- current repo의 핵심 규칙 문서에 메인 에이전트의 역할이 orchestration-only라고 직접 적힌다.
- generated skill의 본문, reference, template README에도 같은 의미가 반복된다.
- planner/generator/evaluator의 작업 소유권은 각 subagent에만 남고, 메인 에이전트는 그 사이를 조정하는 역할로만 설명된다.
- `subagents_docs`와 `docs/implementation`의 역할 경계는 유지된다.
- 기존 `planner -> generator -> evaluator` 순서와 재계획 규칙은 그대로 유지된다.

## 검증 계획

- 문서 검색으로 `main agent`, `coordinator`, `orchestration-only`, `planner/generator/evaluator` 표현이 current repo와 generated skill 양쪽에 일치하는지 확인한다.
- fresh English / fresh Korean 생성 결과에서 같은 문구가 반영되는지 확인한다.
- 기존 existing-repo 생성 경로에서도 설명 충돌이 없는지 확인한다.
