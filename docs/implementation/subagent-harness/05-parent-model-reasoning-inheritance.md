# 부모 모델 및 Reasoning 상속

## 요약

기본 planner, generator, evaluator 하네스가 모델과 reasoning effort를 고정하지 않도록 변경했다. 생성되는 agent TOML은 `model`과 `model_reasoning_effort`를 생략하며 두 값은 부모 agent 설정을 상속한다.

## 변경 내용

- current repo와 generated template의 `.codex/agents/*.toml` 여섯 파일에서 고정 `gpt-5.4`와 `high` override를 제거했다.
- skill 본문, metadata, harness reference, authoritative rule, English/Korean AGENTS 및 README를 부모 상속 정책으로 정렬했다.
- fresh Korean과 existing English materialize 결과에서도 세 agent 파일이 두 선택 key를 생성하지 않는지 검증했다.

## 이유

- 역할별 기본 하네스가 모델이나 reasoning effort를 고정하면 사용자가 부모 agent에서 선택한 값이 subagent에 전달되지 않는다.
- 모델 선택 정책은 역할 템플릿이 아니라 실행을 시작한 부모 agent가 소유해야 한다.

## 검증

- 단위 테스트: 별도 제품 단위 테스트 대상은 아니며, Python 3.12 TOML parser로 current/template agent 파일 여섯 개의 key 부재와 필수 역할 필드 유지를 검증했다.
- E2E 테스트: fresh Korean 및 existing English 저장소를 materialize한 뒤 생성된 agent TOML 여섯 개를 다시 파싱하고 같은 assertion을 확인했다.
- 수동 검증: skill quick validation, materialize shell syntax, Codex config load, living-source stale-policy scan, `git diff --check`를 실행했다.
- 미실행 / 남은 공백: live child thread의 선택 모델/reasoning telemetry는 직접 관찰하지 않았다. 현재 Codex custom-agent 상속 계약과 deterministic key omission을 근거로 판정했으며, installed global skill 갱신과 release/tag는 이번 범위에 포함하지 않았다.

## 관련 규칙

- [`rule/rules/subagent-orchestration.md`](../../../rule/rules/subagent-orchestration.md)
- [`rule/rules/cycle-document-contract.md`](../../../rule/rules/cycle-document-contract.md)
- [`rule/rules/planning-roadmap.md`](../../../rule/rules/planning-roadmap.md)
- [`subagents_docs/cycles/32-inherit-agent-model-reasoning.md`](../../../subagents_docs/cycles/32-inherit-agent-model-reasoning.md)
