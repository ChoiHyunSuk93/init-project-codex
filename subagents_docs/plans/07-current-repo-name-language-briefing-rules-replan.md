# current-repo 이름·언어·브리핑 규칙 재계획

## 목표

현재 저장소 규칙과 문서 구조를 다시 정리해, 남아 있는 `hschoi-init-project` 참조를 제거하고 `subagents_docs` 언어 정책을 이번 cycle의 선택 언어와 일치시키며, `docs/implementation`의 작업문서형 잔재를 정리한다.

## 계획 분리

- Plan 1: current-repo 규칙과 안내 문서에서 남은 옛 스킬명 참조와 언어 혼재를 제거한다.
- Plan 2: `docs/implementation`의 잔존 작업문서형 디렉토리를 정리하고, 카테고리 기반의 짧은 브리핑 구조만 남긴다.
- Plan 2는 Plan 1의 정리 결과를 전제로 하므로 기본적으로 순차 처리한다.

## 순차/병렬 규칙

- 서로 의존하는 수정은 순서대로 처리한다.
- `subagents_docs` 언어 규칙과 current-repo 이름 규칙은 먼저 일관되게 맞춘다.
- 각 plan은 `planner -> generator -> evaluator` 순서로 반복한다.
- 평가에서 실패하면 같은 plan에서 재계획, 재구현, 재평가를 반복하고, 모두 pass될 때까지 멈추지 않는다.
- subagent가 느리다는 이유로 coordinator가 직접 구현하지 않는다.

## 변경 요구사항

- current-repo rules/docs에 남은 `hschoi-init-project` 참조를 제거하고 `hs-init-project` 기준으로 맞춘다.
- `subagents_docs` 문서는 이번 cycle의 선택 언어를 따라 작성되도록 current-repo 규칙과 generated-skill 규칙 둘 다에 반영한다.
- `docs/implementation`은 category 기반 구조를 유지하되, `briefings/`, `plans/`, `changes/`처럼 작업문서형 잔재가 남지 않게 정리한다.
- 구현 결과는 짧고 읽기 쉬운 브리핑 문서로 유지하되, 기존 category 구조 안에 배치한다.
- 위 문서 경계와 이름 규칙은 current-repo 규칙과 generated-skill 규칙 둘 다에 반영한다.

## 인수 기준

- current-repo 규칙과 안내 문서에서 남은 `hschoi-init-project` 참조가 정리된다.
- `subagents_docs` 언어 정책이 이번 cycle의 선택 언어와 일치한다.
- coordinator의 직접 개입 금지 원칙이 명시되고 유지된다.
- `docs/implementation`은 category 기반 구조만 남기고 작업문서형 잔재 디렉토리를 사용하지 않는다.
- 다음 current-repo generator/evaluator cycle에서 위 항목이 모두 pass로 확인된다.
