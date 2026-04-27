# 사이클 문서 계약 규칙

## 목적

cycle 문서 경로, header 상태 전이, append-only section, provenance, dirty-worktree 평가 기준을 authoritative하게 정의한다.
작은 직접 변경은 cycle 문서를 생략할 수 있고, 이 계약은 cycle 문서를 실제로 열었을 때 적용된다.

## 범위

- `subagents_docs/cycles/`
- `.codex/agents/*.toml`
- [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md)
- cycle-aware prompts and harness references

## cycle 파일 경로

- cycle-backed plan은 `subagents_docs/cycles/<NN>-<slug>.md` 한 문서로 관리한다.
- plan, change, evaluation을 별도 working file로 분리하지 않는다.
- 각 cycle 문서는 [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md)의 특정 phase 또는 phase section에 연결되어야 한다.

## header 계약

- 모든 cycle 문서 상단에는 `Status`, `Current Plan Version`, `Next Handoff`를 둔다.
- 허용되는 `Status` 값은 `in_progress`, `PASS`, `FAIL`만 사용한다.
- header 갱신 권한은 coordinator가 가진다.
- 문서가 아직 없을 때만 coordinator 또는 delegated planner가 초기 스캐폴드를 만들 수 있다.

## coordinator 상태 전이

- planning basis가 되는 `Planner vN`을 만들거나 append한 직후
  - `Status: in_progress`
  - `Current Plan Version: Planner vN`
  - `Next Handoff`: 실제 다음 구현 주체에 맞춰 보통 `main` 또는 `generator`
- generator가 `Generator vN`을 append한 직후
  - `Status: in_progress`
  - `Current Plan Version: Generator vN`
  - `Next Handoff: evaluator`
- evaluator가 `Evaluator vN`에 `PASS`를 기록한 직후
  - `Status: PASS`
  - `Current Plan Version: Evaluator vN`
  - `Next Handoff: complete`
- evaluator가 `Evaluator vN`에 `FAIL`을 기록한 직후
  - `Status: FAIL`
  - `Current Plan Version: Evaluator vN`
  - `Next Handoff: planner`

## section 모델

- 본문은 append-only로 유지한다.
- section 이름은 `Planner v1`, `Generator v1`, `Evaluator v1`, `Planner v2`처럼 역할+버전 형식을 사용한다.
- 해당 phase를 맡은 coordinator 또는 delegated role만 자기 section을 수정한다.
- 관련 산출물은 같은 문서 안의 정확한 section 이름으로 참조한다.

## provenance 요구

### planner

- 신규 cycle인지, 특정 `Evaluator vN`을 받아 재계획하는지 명시한다.
- coordinator가 직접 쓴 계획인지, planner/explorer 보조를 받아 정리한 계획인지 남긴다.
- 목표, 범위, 비범위, 사용자 관점 결과, acceptance criteria, 제약, 위험 요소, 의존관계, open questions, 다음 handoff를 포함한다.
- 연결된 roadmap phase와 해당 phase의 필수 체크리스트를 포함한다.

### generator

- 구현 기준 planner section reference를 남긴다.
- 구현을 coordinator가 직접 했는지, delegated implementation slice를 통합했는지 남긴다.
- 실제 반영 범위, 변경 파일, 검증, 검증에 사용한 workspace 또는 baseline scope를 남긴다.
- 남은 위험/제약, 다음 handoff를 남긴다.
- 구현 후 변경된 phase checklist 또는 notes가 있으면 [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md) 갱신 필요 여부를 남긴다.

### evaluator

- 평가 대상 planner section과 generator section을 남긴다.
- 정확한 검증 명령 또는 절차, acceptance criteria 판정, findings, 다음 handoff를 남긴다.
- dirty worktree 비교 기준을 남긴다.
- 연결된 roadmap phase의 필수 체크리스트 충족 여부와 다음 phase 진입 가능 여부를 판정한다.
- `FAIL`이면 해당 phase checklist와 notes에 반영해야 할 gap을 남긴다.

## dirty worktree 평가 규칙

- unrelated diff가 있어도 evaluator는 cycle을 판정할 수 있다.
- cycle-owned 변경과 unrelated diff를 구분해서 기록한다.
- `PASS` 또는 `FAIL`은 cycle-owned 범위와 acceptance criteria만 기준으로 판단한다.
- 비교 기준을 설명할 수 없으면 soft-pass하지 않는다.
