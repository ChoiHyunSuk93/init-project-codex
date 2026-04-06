# PROJECT_NAME

짧은 설명 placeholder. 이 문장을 프로젝트 한 줄 소개로 교체한다.
이 저장소는 기본 Codex 구조와 함께 필수 `planner` / `generator` / `evaluator` 역할 분리 하네스를 사용한다.

## 목적

이 저장소가 무엇을 위한 것인지 적는다.

## 상태

이 저장소는 Codex 작업 구조를 갖춘 초기 상태로 만들어졌다.
프로젝트의 실제 목적, 구조, 사용 방법이 구체화되면 이 README를 함께 갱신한다.

## 구조

- [`AGENTS.md`](AGENTS.md): 저장소 전역 Codex 지침
- `.codex/config.toml`: `.codex/agents/*.toml`과 함께 생성되는 프로젝트 스코프 agent 런타임 설정
- `.codex/agents/*.toml`: 프로젝트 스코프 planner, generator, evaluator 정의
- `.codex/skills/`: 변경 분석, 구현, 테스트/디버깅, 문서 동기화, 품질 검토를 위한 starter local skill 세트
- `subagents_docs/`: planner, generator, evaluator 작업 문서를 두는 공간이며 기본 진입점은 [`subagents_docs/AGENTS.md`](subagents_docs/AGENTS.md)다
- `rule/`: 기준 Codex 규칙이며 탐색 시작점은 [`rule/index.md`](rule/index.md)다
- `docs/guide/`: 사람이 읽는 사용자 가이드 문서이며 기본 진입점은 [`docs/guide/README.md`](docs/guide/README.md)다
- `docs/implementation/`: evaluator가 통과시킨 plan cycle 뒤의 사용자-facing 최종 브리핑 문서이며 배치 기준은 [`docs/implementation/AGENTS.md`](docs/implementation/AGENTS.md)다
- [`rule/rules/subagent-orchestration.md`](rule/rules/subagent-orchestration.md): 역할 분리와 handoff 규칙

이 README에서 실제 진입점 문서나 제어문서를 가리킬 때는 Markdown 링크를 사용한다.
placeholder, wildcard, 아직 생성되지 않은 경로는 path literal로 남긴다.

각 plan은 `planner -> generator -> evaluator` 순서로 실행한다. 메인 에이전트는 orchestration-only 역할로 남아 이 세 역할의 순서와 handoff만 조정하며, 사용자가 역할 분리를 명시적으로 풀지 않는 한 planner/generator/evaluator를 직접 겸하지 않는다. evaluator는 generator가 만든 구현 결과를 plan과 acceptance criteria에 대조해 대표 사용자 surface를 가능한 한 직접 실행하는 가장 강한 검증을 수행한다. 웹이면 브라우저 화면, 앱이면 시뮬레이터나 런타임, 게임이면 runtime/scene, CLI/API면 실제 진입점을 우선 확인하고, 핵심 surface를 직접 검증하지 못하면 그 이유와 남은 공백을 기록한 채 soft-pass하지 않는다. `FAIL`이면 외부 입력이 정말 필요한 blocker가 아닌 한 질문 없이 다음 cycle을 다시 시작한다. 생성된 저장소에는 `.codex/config.toml`, `.codex/agents/*.toml`, 그리고 `.codex/skills/` 아래의 개발 절차 중심 starter local skill 세트가 함께 포함된다. 기존 프로젝트 모드에서는 inspect 결과를 바탕으로 starter skill과 일부 README/rule/guide 산출물이 관찰된 구조 신호를 반영해 더 구체적으로 생성된다.

## 사용 방법

실제 동작이나 설정 방법이 생기면 여기에 구체적인 사용 방법을 추가한다.
