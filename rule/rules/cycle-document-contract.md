# 사이클 문서 계약 규칙

## 목적

`subagents_docs/cycles/` 아래의 cycle 문서 형식, header 상태 전이, append-only section 규칙, provenance 요구를 authoritative하게 정의한다.
작은 직접 변경처럼 shared working document가 필요 없는 경우에는 cycle 문서를 생략할 수 있고, 이 계약은 cycle 문서를 실제로 열었을 때 적용된다.

## 적용 범위

- `subagents_docs/cycles/`
- `.codex/agents/*.toml`
- [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md)
- cycle-aware prompt와 harness reference
- cycle 문서를 참조하거나 생성하는 rule/doc/prompt

## 파일 경로 규약

- cycle 문서를 쓰는 각 plan은 `subagents_docs/cycles/<NN>-<slug>.md` 한 문서로 관리한다.
- 이 문서는 plan별 단일 working document이며, 전역 공용 로그가 아니다.
- 같은 cycle은 같은 번호 또는 slug를 유지한다.

## header 계약

- 문서 맨 위에는 항상 다음 세 필드를 둔다.
  - `Status`
  - `Current Plan Version`
  - `Next Handoff`
- 허용되는 `Status` 값은 `in_progress`, `PASS`, `FAIL`만 사용한다.
- coordinator가 header를 authoritative하게 갱신한다.
- cycle 문서가 아직 없을 때만 coordinator 또는 delegated planner가 초기 스캐폴드를 만들 수 있다.

## coordinator 상태 전이

- planning basis가 되는 `Planner vN`을 append한 직후
  - `Status: in_progress`
  - `Current Plan Version: Planner vN`
  - `Next Handoff`: 실제 다음 구현 주체를 반영해 `main` 또는 `generator`
- 구현 기준이 되는 `Generator vN`을 append한 직후
  - `Status: in_progress`
  - `Current Plan Version: Generator vN`
  - `Next Handoff: evaluator`
- evaluator가 `PASS`를 기록한 직후
  - `Status: PASS`
  - `Current Plan Version: Evaluator vN`
  - `Next Handoff: complete`
- evaluator가 `FAIL`을 기록한 직후
  - `Status: FAIL`
  - `Current Plan Version: Evaluator vN`
  - `Next Handoff`: 다음 planning owner를 반영해 `main` 또는 `planner`

## section 모델

- 본문은 append-only로 유지한다.
- section 이름은 `Planner vN`, `Generator vN`, `Evaluator vN` 형식을 사용한다.
- 각 section은 해당 phase를 실제로 담당한 coordinator 또는 delegated role만 수정한다.
- 다른 phase section이나 coordinator header를 덮어쓰지 않는다.
- 역할 간 참조는 같은 문서 안의 정확한 section 이름으로 남긴다.

## provenance 요구

### planner

- 신규 cycle인지, 또는 어떤 `Evaluator vN` 결과를 받아 재계획하는지 명시한다.
- plan을 coordinator가 직접 작성했는지, planner assist나 explorer 분석을 받아 정리했는지 남긴다.
- 목표, 범위, 비범위, 사용자 관점 결과, acceptance criteria, 제약, 위험 요소, 의존관계, open questions, 다음 handoff를 포함한다.

### generator

- 구현 기준 planner section을 명시한다.
- 구현을 coordinator가 직접 했는지, generator 또는 다른 delegated implementation slice를 통합했는지 남긴다.
- 실제 반영 범위와 변경 파일을 남긴다.
- 검증 시 사용한 workspace/baseline scope를 명시한다.
- 검증, 남은 위험/제약, 다음 handoff를 남긴다.

### evaluator

- 평가 대상 planner/generator section을 명시한다.
- 정확한 검증 명령, 수동 절차, 관찰 결과를 남긴다.
- dirty worktree에서 어떤 비교 기준을 사용했는지 명시한다.
- acceptance criteria 판정, findings, 품질 평가, 다음 handoff를 남긴다.

## dirty worktree 평가 규칙

- unrelated diff가 있어도 evaluator는 cycle-scoped acceptance를 판정할 수 있다.
- evaluator는 이번 cycle 변경과 무관한 diff를 cycle-owned 변경과 구분해서 기록한다.
- `PASS` 또는 `FAIL` 판정은 cycle-owned 변경과 해당 acceptance criteria 기준으로만 내린다.
- dirty worktree 비교 기준을 설명할 수 없으면 soft-pass하지 않는다.

## 문서 경계

- cycle working record는 `subagents_docs/cycles/`에만 둔다.
- [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md) 아래의 `docs/implementation/`은 evaluator `PASS` 이후의 최종 브리핑 계층이며 working record를 대체하지 않는다.
