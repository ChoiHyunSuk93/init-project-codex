# Subagents Docs 규칙

## 목적

`subagents_docs/`를 cycle-backed implementation work에서 메인 에이전트와 subagent가 공유하는 작업 문서 영역으로 정의한다.

## 범위

- `subagents_docs/`는 subagent working area다.
- `docs/guide/`와 `docs/implementation/`는 사람이 읽는 문서 영역이다.
- subagent 작업 기록은 `subagents_docs/`에만 둔다.
- 분석, 질문, 리뷰, 설명 전용 요청은 implementation cycle을 열지 않고 `subagents_docs/` working record를 만들지 않는다.
- 독립적인 문서 분석이나 비교 독해는 병렬 `explorer` 호출을 우선 고려하고, shared handoff가 없으면 cycle 문서를 만들지 않아도 된다.
- `subagents_docs/` 문서 언어와 path 표기 규칙은 [`rule/rules/language-policy.md`](language-policy.md)를 따른다.
- cycle 문서 경로, header, section provenance는 [`rule/rules/cycle-document-contract.md`](cycle-document-contract.md)를 따른다.

## 디렉토리 역할

- `subagents_docs/cycles/`: planner, generator, evaluator가 함께 참조하는 plan별 단일 working document

## 문서 계약

- exact cycle document contract는 [`rule/rules/cycle-document-contract.md`](cycle-document-contract.md)를 기준으로 한다.
- `subagents_docs/`의 active working record는 `subagents_docs/cycles/` 아래에만 둔다.

### 역할별 소유권

- coordinator 또는 delegated planner는 planner section을 소유한다.
- coordinator 또는 delegated generator는 generator section을 소유한다.
- evaluator는 evaluator section만 소유한다.
- section별 필수 provenance와 상태 전이는 [`rule/rules/cycle-document-contract.md`](cycle-document-contract.md)를 따른다.

## 순환 규칙

- small direct change는 cycle 문서를 생략할 수 있다.
- medium change와 large change, 또는 multi-agent handoff가 있는 구현은 cycle 문서를 사용한다.
- medium change는 `main(plan+implementation) -> evaluator`가 기본이다.
- large-clear change는 `main-led decomposition + delegated implementation + evaluator`가 기본이다.
- large-ambiguous change는 `parallel explorer analysis + planner assist if needed + main-approved plan + delegated implementation + evaluator`가 기본이다.
- evaluator는 generator가 만든 구현 결과를 해당 plan과 acceptance criteria 기준으로 대표 사용자 surface 직접 검증을 포함한 strongest feasible 검증으로 평가한다.
- evaluator가 구현 결과에서 부족한 점이나 blocker를 확인했을 때만 같은 계획을 다시 계획, 구현, 평가하고, `FAIL`이면 외부 입력이 정말 필요한 경우가 아니면 coordinator가 적절한 경로로 다음 cycle을 시작한다.
- 여러 계획이 독립이면 병렬로 돌릴 수 있지만, 의존성이 있으면 순차로 처리한다.
- 문서 분석 단계에서는 독립적인 질문을 explorer 병렬 호출로 나누고, implementation cycle 진입 전까지는 evaluation handoff를 열지 않는다.

## 문서 경계

- `subagents_docs/`에는 작업용 문서만 둔다.
- 신규 working record는 `subagents_docs/cycles/`에 쓴다.
- 사용자-facing 최종 브리핑은 evaluator pass 이후 [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md)를 기준으로 `docs/implementation/`에 요약본으로 남긴다.
- plan-only 상태나 generator-only 상태를 근거로 [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md) 아래 최종 브리핑을 만들지 않는다.
- 역할별 소유 문서를 섞어 쓰지 않는다.
- 메인 에이전트는 이 문서 흐름의 planning/implementation/integration 책임을 질 수 있고, 필요할 때만 subagent를 선택적으로 사용한다.
- coordinator는 completed/unused subagent thread를 정리하고, cleanup 없이 thread를 방치하지 않는다.
