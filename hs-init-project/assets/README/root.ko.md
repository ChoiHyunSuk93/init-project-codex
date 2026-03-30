# PROJECT_NAME

짧은 설명 placeholder. 이 문장을 프로젝트 한 줄 소개로 교체한다.
이 template은 기본 Codex 구조 위에 `planner` / `generator` / `evaluator` 역할 분리 하네스를 얹는 경우에도 사용할 수 있다.

## 목적

이 저장소가 무엇을 위한 것인지 적는다.

## 상태

이 저장소는 Codex 작업 구조를 갖춘 초기 상태로 만들어졌다.
프로젝트의 실제 목적, 구조, 사용 방법이 구체화되면 이 README를 함께 갱신한다.

## 구조

- `AGENTS.md`: 저장소 전역 Codex 지침
- `.codex/config.toml`: `.codex/agents/*.toml`과 함께 생성되는 프로젝트 스코프 agent 런타임 설정
- `.codex/agents/*.toml`: 하네스가 활성화되면 쓰는 프로젝트 스코프 subagent 정의
- `subagents_docs/`: 하네스가 활성화되면 planner, generator, evaluator 작업 문서를 두는 공간
- `rule/`: 기준 Codex 규칙
- `docs/guide/`: 사람이 읽는 사용자 가이드 문서
- `docs/guide/subagent-workflow.md`: 하네스가 활성화되면 쓰는 워크플로 가이드
- `docs/implementation/`: evaluator가 통과시킨 plan cycle 뒤의 사용자-facing 최종 브리핑 문서
- `rule/rules/subagent-orchestration.md`: 역할 분리와 handoff 규칙

하네스가 활성화되면 각 plan은 `planner -> generator -> evaluator` 순서로 실행한다. 메인 에이전트는 orchestration-only 역할로 남아 이 세 역할의 순서와 handoff만 조정하며, 사용자가 역할 분리를 명시적으로 풀지 않는 한 planner/generator/evaluator를 직접 겸하지 않는다. evaluator는 generator가 만든 구현 결과를 plan과 acceptance criteria에 대조해 평가하고, 그 구현 결과에서 실패나 blocker를 확인했을 때만 planner가 재계획한다. 생성된 저장소에는 `.codex/config.toml`이 `.codex/agents/*.toml`과 함께 포함된다.

## 사용 방법

실제 동작이나 설정 방법이 생기면 여기에 구체적인 사용 방법을 추가한다.
