# 사이클 순서·언어 팝업 문구 정비 구현 기록

## 요약

이번 generator 사이클에서는 current repo 문서와 `hs-init-project` 생성 스킬 전반을 함께 정리했다. 핵심 변경은 세 가지다. 첫째, 모든 하네스 문서에서 실행 순서를 `planner -> generator -> evaluator`로 고정했다. 둘째, evaluator는 plan 자체가 아니라 generator가 만든 구현 결과를 plan과 acceptance criteria에 대조해 평가하도록 명시했고, 실패나 blocker가 확인된 뒤에만 planner가 재계획하도록 정렬했다. 셋째, 언어 선택 문구에서 chooser/submit/dummy UI를 유도할 수 있는 표현을 제거하고, 언어가 아직 고정되지 않았을 때만 plain text 질문을 한 번 묻도록 통일했다.

## 변경 내용

- current repo의 `AGENTS.md`, `README.md`, `README.ko.md`, `docs/guide/subagent-workflow.md`, `docs/implementation/AGENTS.md`, `rule/rules/subagent-orchestration.md`, `rule/rules/subagents-docs.md`를 수정해 evaluator의 평가 대상과 재계획 조건을 명확히 했다.
- `hs-init-project/SKILL.md`, `hs-init-project/agents/openai.yaml`, `hs-init-project/references/language-output.md`, `hs-init-project/references/structure-initialization.md`, `hs-init-project/references/subagent-orchestration.md`에 같은 기준 문구를 반영했다.
- generated-skill 템플릿인 `hs-init-project/assets/AGENTS/*`, `assets/README/*`, `assets/docs/guide/*`, `assets/docs/implementation/*`, `assets/rule/*`, `assets/subagents_docs/*`, `assets/.codex/agents/*`를 수정해 생성 결과도 동일한 순서와 언어 정책을 따르도록 맞췄다.
- `hs-init-project/scripts/materialize_repo.sh`에서 생성하는 `rule/rules/subagents-docs.md` 내용도 동일 기준으로 갱신했다.
- generated docs와 `subagents_docs/`가 선택 언어를 따른다는 기존 정책은 유지했다. 다만 언어가 이미 request/session에 고정되어 있으면 다시 묻지 않도록 정리했다.

## 팝업 원인 결론

- 불필요한 submit 팝업의 직접 원인은 language question을 일반 plain-text 질문이 아니라 구조화된 chooser/submit 입력처럼 해석하게 만드는 문구였다.
- 특히 기존 `hs-init-project/SKILL.md`와 `hs-init-project/references/language-output.md`에 있던 two-option chooser/structured selection 계열 표현이 가장 강한 트리거였다.
- 같은 취지의 문구가 metadata와 템플릿에 남아 있으면 생성 결과에서도 같은 오해가 반복될 수 있으므로, current repo와 generated skill 양쪽에서 모두 제거하거나 plain-text-only 금지 규칙으로 뒤집었다.
- 최종 결론은 "언어 질문 자체"가 문제가 아니라 "chooser/submit UI를 요구하거나 암시하는 wording"이 팝업의 root cause였다는 것이다.

## 검증

- 문서 검색:
  - `rg -n "chooser|submit|dummy|two-option|selection UI|submit popup|submit형|chooser UI|structured selection|structured two-option|modal" AGENTS.md README.md README.ko.md docs rule hs-init-project`
  - 위 검색은 repo 내부에서 "금지한다"는 guardrail 문구만 남고, 기존 trigger 표현은 제거된 상태를 확인하는 데 사용했다.
  - `rg -n "evaluates? the plan|evaluate.*plan itself|plan-only evaluation|계획 평가|plan 단독 상태를 cycle pass/fail 평가로 간주" AGENTS.md README.md README.ko.md docs rule hs-init-project`
  - 위 검색은 evaluator가 plan-only 상태를 판정 대상으로 삼지 않는다는 금지 문구만 남았는지 확인하는 데 사용했다.
- 생성 검증:
  - `./hs-init-project/scripts/materialize_repo.sh /tmp/hs-init-en3-XXwKRe --language en`
  - `./hs-init-project/scripts/materialize_repo.sh /tmp/hs-init-ko3-bYmIio --language ko`
  - `rg -n "chooser|submit|dummy|two-option|selection UI|modal|structured selection" /tmp/hs-init-en3-XXwKRe /tmp/hs-init-ko3-bYmIio`
  - `rg -n "completed plan cycle|plan cycle이 완료|completed plan cycles|완료된 plan cycle|implemented result|구현 결과|acceptance criteria|plan 단독|before implementation exists|재계획" /tmp/hs-init-en3-XXwKRe /tmp/hs-init-ko3-bYmIio`
- 확인 결과:
  - fresh English/Korean 생성 결과에서 chooser/submit/dummy wording은 발견되지 않았다.
  - 생성된 `AGENTS.md`, `docs/guide/subagent-workflow.md`, `docs/implementation/AGENTS.md`, `rule/rules/subagent-orchestration.md`, `rule/rules/subagents-docs.md`, `rule/rules/implementation-records.md` 모두 evaluator가 구현 결과를 평가하고 실패 시에만 재계획하는 흐름으로 정렬됐다.

## 남은 공백

- fresh English/Korean 생성은 다시 확인했지만, existing-project mode 전체 흐름은 이번 사이클에서 별도 재실행하지 않았다.
