# current-repo 스킬 디렉터리 이름 최종 재계획

## 목표

현재 저장소의 실제 top-level skill 디렉터리를 renamed skill identity와 일치시키고, 그에 따라 current-repo 규칙과 generated-skill 규칙의 경로 참조를 모두 실제 디렉터리 기준으로 맞춘다.
이 재계획의 목적은 문서가 가리키는 runtime skill 디렉터리와 실제 저장소 표면을 더 이상 어긋나지 않게 만드는 것이다.

## 계획 분리

- Plan 1: current-repo의 실제 top-level skill 디렉터리 이름과 authoritative 문서의 path reference를 일치시킨다.
- Plan 2: 같은 변경 기준을 `hs-init-project` 생성 규칙과 템플릿에도 반영해, 생성 결과가 동일한 directory identity를 따르도록 맞춘다.
- Plan 2는 Plan 1의 실제 rename 결과를 전제로 하므로 순차 처리한다.

## 순차/병렬 규칙

- 서로 의존하는 path rename과 reference update는 순서대로 처리한다.
- 실제 디렉터리 rename이 먼저 끝난 뒤, 그 경로를 읽는 rules/docs/templates를 갱신한다.
- 각 plan은 `planner -> generator -> evaluator` 순서로 반복한다.
- 평가에서 실패하면 같은 plan에서 재계획, 재구현, 재평가를 반복하고, 모두 pass될 때까지 멈추지 않는다.
- subagent가 느리다는 이유로 coordinator가 직접 구현하지 않는다.

## 변경 요구사항

- 실제 top-level skill 디렉터리를 renamed skill identity와 맞춘다.
- current-repo rules/docs의 path reference는 rename 이후의 실제 디렉터리를 기준으로 일치시킨다.
- generated-skill rules/templates도 동일한 directory identity를 사용하도록 맞춘다.
- `subagents_docs`는 이번 cycle의 선택 언어 규칙을 계속 따라야 한다.
- `docs/implementation`은 category 기반 짧은 브리핑 구조만 유지하고, 작업문서형 잔재를 다시 만들지 않는다.
- 위 경계와 path 규칙은 current-repo 규칙과 generated-skill 규칙 둘 다에 반영한다.

## 인수 기준

- 실제 top-level skill 디렉터리와 authoritative 문서가 동일한 이름과 경로를 가리킨다.
- current-repo rules/docs에서 rename 이후의 실제 디렉터리 참조가 일관된다.
- generated-skill rules/templates도 같은 rename 기준을 따른다.
- `subagents_docs` 언어 정책, coordinator 직접 개입 금지, `docs/implementation` category 기반 브리핑 유지가 그대로 보존된다.
- 다음 current-repo generator/evaluator cycle에서 위 항목이 모두 pass로 확인된다.
