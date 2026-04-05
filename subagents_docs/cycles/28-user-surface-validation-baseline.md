Status: PASS
Current Plan Version: Evaluator v1
Next Handoff: complete

# 28. user surface validation baseline

## Planner v1

### 신규 cycle 여부

- 신규 cycle이다.

### 목표

- evaluator 기준을 단순한 "실제 화면확인" 표현보다 넓은 "실제 사용자 surface 검증" 기준으로 상향한다.
- 웹, 앱, 게임, CLI, API처럼 서로 다른 사용자 접점을 한 규칙 안에서 포괄하도록 authoritative rule과 evaluator prompt를 정렬한다.
- user surface가 존재하는 변경에서 evaluator가 가능한 가장 현실적인 실행 surface를 직접 검증하도록 기준을 더 명확히 한다.

### 범위

- current repo의 authoritative rule 문서 중 evaluator 검증수준과 직접 연결된 문구 갱신
- current repo의 `.codex/agents/evaluator.toml` prompt 갱신
- `hs-init-project/` 아래 generated output source of truth 중 evaluator 관련 규칙, reference, template, skill 설명 갱신
- generated `.codex/agents/evaluator.toml` template 갱신
- 필요 시 `subagents_docs/AGENTS.md` 또는 generated 대응 문서의 surface-oriented wording 정렬

### 비범위

- evaluator의 scoring 축 자체 변경
- planner/generator 책임 재정의
- 특정 프로젝트 타입 전용 실행 명령, 툴, framework 강제
- 실제 앱/웹/게임 프로젝트를 추가로 materialize하거나 demo surface를 만드는 작업

### 사용자 관점 결과

- 이 저장소와 이 skill이 생성하는 저장소 모두에서 evaluator 기준이 "실제 사용자 surface를 가능한 한 직접 실행해 검증한다"는 방향으로 더 분명해진다.
- 웹만이 아니라 앱, 게임, CLI/API도 같은 평가 프레임 안에서 다룰 수 있다.
- surface 실행이 불가능한 경우 evaluator가 남겨야 할 근거와 제한도 더 분명해진다.

### acceptance criteria

- authoritative rule에 evaluator가 UI 여부와 무관하게 변경의 대표 사용자 surface를 기준으로 strongest feasible 검증을 수행한다는 문구가 들어간다.
- user-facing surface가 있는 변경에서는 evaluator가 브라우저, 시뮬레이터, 런타임, CLI, API 호출 등 해당 surface에 맞는 직접 실행 검증을 우선한다는 기준이 current repo와 generated output source 모두에 반영된다.
- surface 실행이 불가능할 때 evaluator가 이유, 누락된 환경 조건, 남은 검증 공백을 기록해야 한다는 기준이 current repo와 generated output source 모두에 반영된다.
- acceptance criteria 미충족 또는 핵심 user surface 미검증 상태를 soft-pass하지 않는 방향이 current repo와 generated output source 모두에서 유지되거나 강화된다.
- 변경 후 current repo와 generated output source 사이에 evaluator 기준 표현이 의미상 충돌하지 않는다.

### 제약

- planner는 제품 파일이나 prompt 파일을 직접 수정하지 않고 계획만 남긴다.
- 기존 cycle-document-contract의 provenance, PASS/FAIL, dirty worktree 기준과 충돌하면 안 된다.
- 규칙은 범용성을 유지해야 하므로 특정 UI 프레임워크나 게임 엔진을 전제하면 안 된다.
- 화면이 없는 프로젝트에도 적용 가능해야 하므로 "화면"만을 유일한 기준으로 삼으면 안 된다.

### 위험 요소

- "user surface" 정의가 너무 넓으면 evaluator가 다시 추상적으로 해석해 실제 실행 검증을 회피할 수 있다.
- 반대로 너무 강하게 쓰면 문서/정적 변경처럼 실행 surface가 없는 작업에도 과도한 의무를 줄 수 있다.
- current repo용 evaluator prompt와 generated template prompt가 어긋나면 같은 기준을 말하면서도 실행 강도가 달라질 수 있다.
- docs/rule/skill/reference 여러 계층에 같은 의미를 반영하면서 drift가 생길 수 있다.

### 의존관계

- `rule/rules/subagent-orchestration.md`
- `rule/rules/cycle-document-contract.md`
- `rule/rules/testing-standards.md`
- `.codex/agents/evaluator.toml`
- `hs-init-project/SKILL.md`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/assets/.codex/agents/evaluator.toml`
- `hs-init-project/assets/rule/subagent-orchestration.ko.md`
- `hs-init-project/assets/rule/subagent-orchestration.en.md`
- 필요 시 `hs-init-project/assets/subagents_docs/AGENTS.*`

### open questions

- 없음. 이번 cycle에서는 "실제 화면확인"을 더 일반적인 "대표 사용자 surface 직접 검증" 기준으로 상향하는 방향을 명확한 요구사항으로 본다.

### 다음 handoff

- generator는 current repo와 `hs-init-project/` source of truth 전반에서 evaluator 검증 기준을 user-surface 중심으로 상향 정렬한다.
- generator는 최소한 authoritative rule, current evaluator prompt, generated evaluator template, 관련 reference/skill 문구를 함께 갱신하고, 변경 이유가 서로 충돌하지 않도록 검증한다.
- generator는 변경 후 관련 파일 diff와 검증 결과를 `Generator v1`에 기록한다.

## Generator v1

### planner section reference

- `Planner v1`

### 실제 반영한 범위

- current repo의 authoritative evaluator 기준을 `실제 사용자 수준 테스트` 중심 표현에서 `대표 사용자 surface 직접 검증` 중심 표현으로 상향 정렬했다.
- UI surface가 있으면 브라우저, 시뮬레이터, 앱/게임 런타임 같은 실제 화면 또는 런타임 확인을 우선하고, CLI/API가 대표 surface면 실제 진입점 호출을 우선하도록 명시했다.
- 직접 surface 검증이 불가능할 때 이유, 누락된 환경/접근, 대체 검증, 남은 공백을 기록하고 핵심 surface 비검증 상태를 soft-pass하지 않도록 current repo와 generated output source of truth 모두에 반영했다.
- generated 저장소의 일부 rule이 template 파일이 아니라 `hs-init-project/scripts/materialize_repo.sh`에서 직접 생성되므로, source-of-truth drift를 막기 위해 해당 스크립트도 함께 갱신했다.

### 변경 파일 목록

- `rule/rules/subagent-orchestration.md`
- `rule/rules/testing-standards.md`
- `rule/rules/subagents-docs.md`
- `.codex/agents/evaluator.toml`
- `subagents_docs/AGENTS.md`
- `hs-init-project/SKILL.md`
- `hs-init-project/agents/openai.yaml`
- `hs-init-project/references/subagent-orchestration.md`
- `hs-init-project/assets/.codex/agents/evaluator.toml`
- `hs-init-project/assets/rule/subagent-orchestration.ko.md`
- `hs-init-project/assets/rule/subagent-orchestration.en.md`
- `hs-init-project/assets/subagents_docs/AGENTS.ko.md`
- `hs-init-project/assets/subagents_docs/AGENTS.en.md`
- `hs-init-project/assets/README/root.ko.md`
- `hs-init-project/assets/README/root.en.md`
- `hs-init-project/assets/rule/testing-standards.ko.md`
- `hs-init-project/assets/rule/testing-standards.en.md`
- `hs-init-project/scripts/materialize_repo.sh`

### 검증에 사용한 workspace/baseline scope

- baseline은 현재 workspace의 수정 대상 18개 파일로 한정했다.
- cycle-owned 변경 범위는 evaluator 기준 상향과 generated source-of-truth 정렬에 직접 연결된 rule, prompt, reference, asset, script 파일만 포함했다.
- unrelated diff나 다른 cycle 문서는 검증 범위에 포함하지 않았다.

### 검증

- `rg -n "대표 사용자 surface|user surface|real user-level|soft-pass|browser UI|simulator/runtime|CLI|API request/response|critical user surface|핵심 surface" rule/rules/subagent-orchestration.md rule/rules/testing-standards.md rule/rules/subagents-docs.md .codex/agents/evaluator.toml subagents_docs/AGENTS.md hs-init-project/SKILL.md hs-init-project/agents/openai.yaml hs-init-project/references/subagent-orchestration.md hs-init-project/assets/.codex/agents/evaluator.toml hs-init-project/assets/rule/subagent-orchestration.ko.md hs-init-project/assets/rule/subagent-orchestration.en.md hs-init-project/assets/subagents_docs/AGENTS.ko.md hs-init-project/assets/subagents_docs/AGENTS.en.md hs-init-project/assets/README/root.ko.md hs-init-project/assets/README/root.en.md hs-init-project/assets/rule/testing-standards.ko.md hs-init-project/assets/rule/testing-standards.en.md hs-init-project/scripts/materialize_repo.sh`
- 결과: current repo rule/prompt와 generated source-of-truth 전반에 `대표 사용자 surface 직접 검증`, surface별 예시, soft-pass 금지 문구가 일관되게 반영된 것을 확인했다.
- `git diff --stat -- rule/rules/subagent-orchestration.md rule/rules/testing-standards.md rule/rules/subagents-docs.md .codex/agents/evaluator.toml subagents_docs/AGENTS.md hs-init-project/SKILL.md hs-init-project/agents/openai.yaml hs-init-project/references/subagent-orchestration.md hs-init-project/assets/.codex/agents/evaluator.toml hs-init-project/assets/rule/subagent-orchestration.ko.md hs-init-project/assets/rule/subagent-orchestration.en.md hs-init-project/assets/subagents_docs/AGENTS.ko.md hs-init-project/assets/subagents_docs/AGENTS.en.md hs-init-project/assets/README/root.ko.md hs-init-project/assets/README/root.en.md hs-init-project/assets/rule/testing-standards.ko.md hs-init-project/assets/rule/testing-standards.en.md hs-init-project/scripts/materialize_repo.sh`
- 결과: 이번 cycle 범위에서 18개 파일 변경, 49 insertions / 19 deletions로 정리됐고 변경 범위가 planner가 지정한 evaluator 기준 상향과 generated source-of-truth 정렬 안에 머무는 것을 확인했다.

### 미해결 위험과 제약

- 이번 generator 패스에서는 materialize 스크립트를 실제 임시 저장소에 실행해 generated output을 end-to-end smoke 검증하지는 않았다.
- 따라서 `hs-init-project/scripts/materialize_repo.sh`에 반영한 문구가 실제 산출물에 기대대로 떨어지는지는 evaluator가 필요 시 추가로 확인해야 한다.
- 이번 변경은 규칙/프롬프트/템플릿 정렬이 중심이므로, 실제 앱/웹/게임/CLI/API 런타임에서의 live validation capability 자체를 추가한 것은 아니다.

### 다음 handoff

- `evaluator`

## Evaluator v1

### 결과

PASS

### planner section reference

- `Planner v1`

### generator section reference

- `Generator v1`

### acceptance criteria 대비 판정

- current repo authoritative rule은 evaluator 목적과 검증 규칙을 `대표 사용자 surface 직접 검증` 기준으로 상향했다. `rule/rules/subagent-orchestration.md`, `rule/rules/testing-standards.md`, `rule/rules/subagents-docs.md`, `subagents_docs/AGENTS.md`, `.codex/agents/evaluator.toml`에서 같은 의미가 유지된다.
- 웹, 앱, 게임, CLI/API를 포괄하는 직접 검증 예시가 current repo와 generated source of truth 양쪽에 반영됐다. 브라우저 UI, 앱 시뮬레이터/런타임, 게임 런타임/scene, CLI entrypoint, API request/response flow가 모두 확인된다.
- 직접 surface 검증 불가 시 이유, 누락 환경/접근, 대체 검증, 남은 공백 기록 요구와 핵심 surface soft-pass 금지 기준이 current repo와 generated source of truth 양쪽에 반영됐다.
- generated source-of-truth 수준뿐 아니라 `hs-init-project/scripts/materialize_repo.sh`를 통한 fresh materialize smoke 결과에서도 동일 문구가 실제 산출물에 떨어지는 것을 확인했다.
- cycle-owned 변경 범위 안에서 current repo 규칙, current evaluator prompt, generated evaluator template, reference, README, script 사이의 의미 충돌은 발견하지 못했다.

### 실제 검증 절차

- `git diff -- rule/rules/subagent-orchestration.md rule/rules/testing-standards.md rule/rules/subagents-docs.md .codex/agents/evaluator.toml subagents_docs/AGENTS.md hs-init-project/SKILL.md hs-init-project/agents/openai.yaml hs-init-project/references/subagent-orchestration.md hs-init-project/assets/.codex/agents/evaluator.toml hs-init-project/assets/rule/subagent-orchestration.ko.md hs-init-project/assets/rule/subagent-orchestration.en.md hs-init-project/assets/subagents_docs/AGENTS.ko.md hs-init-project/assets/subagents_docs/AGENTS.en.md hs-init-project/assets/README/root.ko.md hs-init-project/assets/README/root.en.md hs-init-project/assets/rule/testing-standards.ko.md hs-init-project/assets/rule/testing-standards.en.md hs-init-project/scripts/materialize_repo.sh`
- `rg -n "대표 사용자 surface|user surface|browser UI|브라우저|simulator|시뮬레이터|game runtime|runtime/scene|CLI entrypoints|API request/response|soft-pass|soft pass|누락된 환경|missing environment|remaining gap|대체 검증|substitute validation|critical user surface|핵심 surface" rule/rules/subagent-orchestration.md rule/rules/testing-standards.md rule/rules/subagents-docs.md .codex/agents/evaluator.toml subagents_docs/AGENTS.md hs-init-project/SKILL.md hs-init-project/agents/openai.yaml hs-init-project/references/subagent-orchestration.md hs-init-project/assets/.codex/agents/evaluator.toml hs-init-project/assets/rule/subagent-orchestration.ko.md hs-init-project/assets/rule/subagent-orchestration.en.md hs-init-project/assets/subagents_docs/AGENTS.ko.md hs-init-project/assets/subagents_docs/AGENTS.en.md hs-init-project/assets/README/root.ko.md hs-init-project/assets/README/root.en.md hs-init-project/assets/rule/testing-standards.ko.md hs-init-project/assets/rule/testing-standards.en.md hs-init-project/scripts/materialize_repo.sh`
- `hs-init-project/scripts/materialize_repo.sh --help`
- `hs-init-project/scripts/materialize_repo.sh /var/folders/kb/2pb5zjlx3sl0_tqplq3tsfhm0000gn/T/tmp.woV0OnGylh --language ko --readme-mode fresh --source-root-dir src --non-runtime-dirs docs,.codex,rule,subagents_docs`
- `rg -n "대표 사용자 surface|브라우저|시뮬레이터|CLI|API|soft-pass|누락된 환경|핵심 surface" /var/folders/kb/2pb5zjlx3sl0_tqplq3tsfhm0000gn/T/tmp.woV0OnGylh`
- `sed -n '1,220p' /var/folders/kb/2pb5zjlx3sl0_tqplq3tsfhm0000gn/T/tmp.woV0OnGylh/rule/rules/subagent-orchestration.md`
- `sed -n '1,160p' /var/folders/kb/2pb5zjlx3sl0_tqplq3tsfhm0000gn/T/tmp.woV0OnGylh/.codex/agents/evaluator.toml`
- `sed -n '1,120p' /var/folders/kb/2pb5zjlx3sl0_tqplq3tsfhm0000gn/T/tmp.woV0OnGylh/rule/rules/testing-standards.md`

### dirty worktree 비교 기준

- dirty worktree 전체가 아니라 cycle 28에서 지정한 evaluator 기준 상향 관련 변경 파일과 신규 cycle 문서만 cycle-owned 범위로 봤다.
- PASS/FAIL 판정은 위 diff 범위와 materialize smoke로 생성된 임시 산출물에만 근거했다.
- 다른 cycle 문서나 unrelated 변경은 판정 근거에서 제외했다.

### 관찰 결과와 재현 정보

- current repo의 evaluator prompt는 `대표 사용자 surface` 직접 검증, surface 유형별 우선 경로, 직접 검증 불가 시 설명 의무, critical surface soft-pass 금지를 모두 포함한다.
- generated template evaluator prompt와 orchestration/testing/subagents rules도 같은 기준으로 정렬됐다.
- fresh materialize 결과의 `README.md`, `rule/rules/subagent-orchestration.md`, `rule/rules/testing-standards.md`, `rule/rules/subagents-docs.md`, `.codex/agents/evaluator.toml`, `subagents_docs/AGENTS.md`에 동일 의미 문구가 실제로 생성됐다.
- fresh materialize 실행은 `[OK] Materialized live Codex scaffold files`로 종료됐다.

### 문제 목록

- 없음.

### 점수 또는 등급

- PASS
- design quality: high
- originality: high
- completeness: high
- functionality: high

### residual risk

- 이번 평가는 문구 정합성과 generated output materialize smoke까지 포함했지만, 실제 웹/앱/게임/CLI/API 프로젝트에서 evaluator가 이 기준을 어떻게 적용할지는 개별 저장소의 실행 환경 가용성에 계속 의존한다.
- 다만 이번 cycle acceptance criteria는 기준 상향과 source-of-truth 정렬이므로, 위 residual risk는 범위 밖 운영 이슈로 본다.

### 다음 handoff 대상 또는 종료 판정

- `PASS`
