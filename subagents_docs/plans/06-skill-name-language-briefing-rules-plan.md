# 스킬명·언어·브리핑 규칙 계획

## 목표

현재 저장소 규칙과 `hs-init-project`로 생성되는 스킬 규칙을 함께 개편한다.
스킬명은 `hs-init-project`로 변경하고, `subagents_docs`의 문서 언어는 선택된 언어 설정을 따라가게 만든다.
또한 subagent 응답이 느리더라도 coordinator가 직접 개입해 구현하지 않도록 막고, `docs/implementation`은 기존 카테고리 구조를 유지한 채 짧고 읽기 쉬운 브리핑 문서로만 쓰이게 만든다.

## 계획 분리

- Plan 1: 현재 저장소의 규칙, 문서 경계, 하네스 정의를 먼저 갱신한다.
- Plan 2: `hs-init-project`가 생성하는 규칙과 템플릿을 같은 기준으로 맞춘다.
- Plan 2는 Plan 1의 경계 정의를 전제로 하므로 기본적으로 순차 처리한다.
- 독립적인 보조 수정이 확인되면 같은 plan 내부에서만 병렬 처리할 수 있다.

## 순차/병렬 규칙

- 서로 의존하는 수정은 순서대로 처리한다.
- 현재 저장소 규칙을 먼저 확정한 뒤, 그 규칙을 생성 스킬에 반영한다.
- 각 plan은 `planner -> generator -> evaluator` 순서로 반복한다.
- 평가에서 실패하면 같은 plan에서 재계획, 재구현, 재평가를 반복하고, 모두 pass될 때까지 멈추지 않는다.
- subagent가 느리다는 이유로 coordinator가 직접 구현으로 넘어가서는 안 된다.

## 변경 요구사항

- 스킬명은 `hs-init-project`로 바꾼다.
- `subagents_docs`의 문서 언어는 선택된 언어 설정을 따라가도록 current-repo 규칙과 generated-skill 규칙 둘 다에 명시한다.
- coordinator는 subagent 응답 지연을 이유로 직접 구현하지 않도록 current-repo 규칙과 generated-skill 규칙 둘 다에 명시한다.
- `docs/implementation`은 category 기반 구조를 유지한다.
- `docs/implementation` 아래에 `briefings/` 디렉토리를 새로 만들지 않는다.
- 대신 기존 카테고리 체계를 유지한 채, 각 구현 결과를 짧고 읽기 쉬운 브리핑 문서로 작성한다.
- 위 문서 경계와 이름 규칙은 current-repo 규칙과 generated-skill 규칙 둘 다에 반영한다.

## 인수 기준

- current-repo 규칙과 generated-skill 규칙 모두에 스킬명 변경이 반영된다.
- `subagents_docs`의 언어 정책이 선택된 언어 설정과 일치한다.
- coordinator의 직접 개입 금지 원칙이 명시된다.
- `docs/implementation`은 기존 category 구조를 유지하고, `briefings/` 디렉토리를 사용하지 않는다.
- 생성 결과는 기존 category 체계 안에서 짧은 브리핑 문서로만 제공된다.
- 모든 변경은 `planner -> generator -> evaluator` 반복 사이클을 통해 검증된다.
