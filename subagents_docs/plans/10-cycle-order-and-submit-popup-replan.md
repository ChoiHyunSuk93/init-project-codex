# 사이클 순서·submit 팝업 원인 재계획

## 배경

이번 요청의 핵심은 두 가지다.

1. `planner -> generator -> evaluator` 순서가 문서상으로도 실제 실행 모델로도 명확해야 한다. evaluator는 plan 자체를 먼저 평가하는 것이 아니라, generator가 만든 구현 결과를 plan과 acceptance criteria에 비춰 평가해야 한다. 평가에서 실패가 확인된 뒤에만 planner가 재계획한다.
2. 작업 중 뜨는 불필요한 submit 요청창은 제거해야 한다. 로컬 규칙상 `language question`을 구조화된 chooser/submit UI로 처리하라는 문구가 남아 있어, 클라이언트가 이를 입력 제출 프롬프트로 해석하는 것이 원인일 가능성이 높다. 이 가설을 기준으로 current repo와 `hs-init-project` 생성 구조물 모두를 정리한다.

## 핵심 가설

- 팝업의 직접 원인은 `hs-init-project/SKILL.md`와 `hs-init-project/references/language-output.md`에 남아 있는 구조화된 두 선택지 UI/chooser 문구다.
- 같은 취지의 문구가 `agents/openai.yaml`, `references/structure-initialization.md`, `subagent-orchestration` 관련 문서와 템플릿에도 남아 있으면, 클라이언트가 language question을 일반 대화가 아니라 submit형 입력 요청으로 렌더링할 수 있다.
- 따라서 해결 방향은 `language question` 자체를 없애는 것이 아니라, 구조화된 submit/chooser UI를 요구하는 표현을 제거하고, plain text 질문 또는 session-supplied language만 쓰도록 일관되게 바꾸는 것이다.

## 범위

### current repo

- `rule/rules/subagent-orchestration.md`
- `rule/rules/subagents-docs.md`
- `docs/guide/subagent-workflow.md`
- `docs/implementation/AGENTS.md`
- `AGENTS.md`
- 필요 시 root `README.md`, `README.ko.md`

### generated skill

- `hs-init-project/SKILL.md`
- `hs-init-project/agents/openai.yaml`
- `hs-init-project/references/language-output.md`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/references/structure-initialization.md`
- `hs-init-project/assets/**`
- `hs-init-project/scripts/materialize_repo.sh`
- root `README.md`, `README.ko.md`

## 작업 분해

### Plan A: 사이클 순서 명확화

- evaluator의 역할을 `plan 평가자`처럼 보이게 만드는 표현을 제거한다.
- evaluator는 항상 generator가 만든 구현/산출물을 기준으로 평가한다고 명시한다.
- 실패 시에만 planner가 재계획한다는 순서를 current repo와 generated skill 양쪽에 고정한다.

### Plan B: submit 팝업 유발 문구 제거

- language question을 구조화된 chooser/submit UI로 요청하라는 표현을 제거한다.
- plain text 질문만 허용하도록 바꾸거나, 이미 언어가 고정된 세션에서는 재질문하지 않도록 더 강하게 정리한다.
- `dummy`, `submit`, `chooser`, `two-option selection UI` 계열의 오해 소지가 있는 표현을 정리한다.

### Plan C: generated skill 동기화

- 위 두 규칙을 `hs-init-project` 본문, reference, assets, generator script, openai metadata에 동일하게 반영한다.
- `subagents_docs`가 선택 언어를 따른다는 기존 규칙은 유지하되, 언어 선택 자체는 submit형 modal이 아니라 plain text로 처리되게 맞춘다.

### Plan D: 검증

- current repo 문서에서 evaluator가 plan이 아니라 implementation 결과를 평가하는지 확인한다.
- fresh English/Korean repo 생성 결과에서 submit 팝업 유발 문구가 더 이상 생성되지 않는지 확인한다.
- existing-repo 경로에서도 언어가 이미 정해진 상태라면 추가 submit 요청이 발생하지 않는지 확인한다.

## 의존 관계

- Plan A는 Plan B보다 먼저 기준을 확정해야 한다. 평가 순서가 흔들리면 submit prompt 수정의 범위도 흔들린다.
- Plan C는 Plan A/B의 문구 기준을 따라야 하므로 후속이다.
- Plan D는 모든 수정이 반영된 뒤에만 의미 있게 검증할 수 있다.

## 병렬 처리 가능 범위

- current repo 규칙 문서와 generated skill reference/template 수정은 각각 독립 파일 기준으로 일부 병렬 처리 가능하다.
- 다만 evaluator 순서 정의와 submit prompt 제거 문구는 같은 기준 문장을 공유해야 하므로, 최종 문안 확정은 순차적으로 맞춘다.

## 수용 기준

- 문서 어디에도 evaluator가 plan 자체를 먼저 평가한다는 오해를 남기지 않는다.
- evaluator는 generator가 만든 구현 결과를 plan과 acceptance criteria에 대조해서만 평가한다.
- 실패 시 재계획은 evaluator 실패 이후에만 발생한다고 명시된다.
- `chooser`, `submit`, `dummy` 계열의 language-selection 유도 문구가 current repo와 generated skill 모두에서 제거된다.
- `hs-init-project` 생성 결과는 language question을 plain text 또는 session-fixed 방식으로 처리하며, 불필요한 submit 요청창을 유발하지 않는다.
- `planner -> generator -> evaluator` 반복 사이클은 그대로 유지된다.

## 검증 계획

- 문서 검색:
  - evaluator가 plan 자체를 먼저 평가하는 표현이 남아 있는지 확인
  - structured chooser / submit UI 관련 문구가 남아 있는지 확인
- 생성 검증:
  - fresh English repo 생성
  - fresh Korean repo 생성
  - existing repo 생성
- 판정 기준:
  - 구현 산출물 기준의 평가 순서가 명확하면 `PASS`
  - submit popup 유발 문구가 남아 있으면 `FAIL` 후 재계획
