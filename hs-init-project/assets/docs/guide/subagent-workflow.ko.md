# subagent 워크플로우

이 저장소의 하네스는 `planner`, `generator`, `evaluator` 역할 분리 방식으로 동작한다.
메인 에이전트는 이 하네스에서 orchestration-only 역할만 맡고, 사용자가 역할 분리를 명시적으로 완화하지 않는 한 이 세 역할을 직접 겸하지 않는다.

## 문서 구분

- `subagents_docs/`는 subagent가 실제로 읽고 쓰는 작업 문서 영역이다.
- `subagents_docs/` 작업 문서는 선택된 언어 설정을 따른다.
- `docs/guide/`는 사용자-facing 안내서만 둔다.
- `docs/implementation/`은 plan pass 후 최종 결과 브리핑만 두며, 관심사 기반 카테고리 안에 짧고 읽기 쉽게 기록한다.

## 사이클

1. `planner`가 `subagents_docs/plans/`에 plan 문서를 작성한다.
   - 목표, acceptance criteria, 범위/비범위, 제약, 위험요소, 의존관계를 명시한다.
2. `generator`가 계획을 구현하고 `subagents_docs/changes/`에 변경 기록을 남긴다.
   - 코드/템플릿/스크립트 수정 및 실무상 필요한 검증 포함
3. `evaluator`가 구현 결과를 대상으로 end-to-end 점검을 수행하고 `subagents_docs/evaluations/`에 보고한다.
   - 구현 결과를 plan과 acceptance criteria에 대조
   - design quality, originality, completeness, functionality 평가
4. evaluator가 구현 결과에서 실패나 blocker를 확인했을 때만 planner가 같은 plan을 재계획하고, pass될 때까지 반복한다.
5. subagent 응답이 느리더라도 coordinator는 직접 구현하지 않고 기다리거나 재계획한다.

## 다중 plan 운영

- 서로 독립된 plan은 병렬로 실행할 수 있다.
- 의존성이 있는 plan은 선행 plan의 pass를 기다려 순차 실행한다.
- 독립/독립 아닌 plan은 `plan1`, `plan2`, `plan3` 등으로 분리해 개별 사이클로 관리한다.

## 출력 규칙

- 작업용 plan, 변경 기록, 평가 보고서를 `docs/guide`나 `docs/implementation`에 두지 않는다.
- `docs/guide`는 사용자 안내만 관리한다.
- 최종 구현 브리핑은 evaluator가 통과시킨 뒤 `docs/implementation/`에서만 공개용으로 남긴다.
