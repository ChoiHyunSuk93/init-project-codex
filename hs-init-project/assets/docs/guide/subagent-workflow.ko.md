# subagent 워크플로우

이 저장소의 하네스는 `planner`, `generator`, `evaluator` 역할 분리 방식으로 동작한다.
메인 에이전트는 이 하네스에서 orchestration-only 역할만 맡고, 사용자가 역할 분리를 명시적으로 완화하지 않는 한 이 세 역할을 직접 겸하지 않는다.
역할/워크플로의 authoritative 기준은 `rule/rules/subagent-orchestration.md`다.
exact cycle 문서 형식, header, provenance, dirty-worktree 평가는 `rule/rules/cycle-document-contract.md`를 따른다.
문서 언어와 안정적인 filename/path 규칙은 `rule/rules/language-policy.md`를 따른다.
분석, 질문, 리뷰, 설명 요청은 사용자가 명시적으로 변경이나 materialize를 지시하기 전에는 구현 사이클로 시작하지 않는다.

## 문서 구분

- `subagents_docs/`는 subagent가 실제로 읽고 쓰는 작업 문서 영역이다.
- `subagents_docs/` 작업 문서는 선택된 언어 설정을 따른다.
- `docs/guide/`는 사용자-facing 안내서만 둔다.
- `docs/implementation/`은 plan pass 후 최종 결과 브리핑만 두며, 관심사 기반 카테고리 안에 짧고 읽기 쉽게 기록한다.

## 사이클

1. `planner`가 필요하면 cycle 문서를 만들고 `subagents_docs/cycles/` 아래 같은 문서에 planner 섹션을 append한다.
   - planner 섹션의 exact required contents는 `rule/rules/cycle-document-contract.md`를 따른다.
2. `generator`가 계획을 구현하고 같은 cycle 문서에 generator 섹션을 append한다.
   - generator 섹션의 exact required contents는 `rule/rules/cycle-document-contract.md`를 따른다.
3. `evaluator`가 구현 결과를 대상으로 end-to-end 점검을 수행하고 같은 cycle 문서에 evaluator 섹션을 append한다.
   - evaluator 섹션의 exact required contents와 dirty-worktree 비교 기준은 `rule/rules/cycle-document-contract.md`를 따른다.
4. evaluator가 구현 결과에서 실패나 blocker를 확인했을 때만 planner가 같은 plan을 재계획하고, pass될 때까지 반복한다.
5. subagent 응답이 느리더라도 coordinator는 직접 구현하지 않고 기다리거나 재계획한다.
6. coordinator는 결과를 반영한 completed/unused thread를 정리한다.

## 다중 plan 운영

- 서로 독립된 plan은 병렬로 실행할 수 있다.
- 의존성이 있는 plan은 선행 plan의 pass를 기다려 순차 실행한다.
- 독립/독립 아닌 plan은 `plan1`, `plan2`, `plan3` 등으로 분리해 개별 사이클로 관리한다.

## 출력 규칙

- 작업용 plan, 변경 기록, 평가 보고서를 `docs/guide`나 `docs/implementation`에 두지 않는다.
- `docs/guide`는 사용자 안내만 관리한다.
- 최종 구현 브리핑은 evaluator가 통과시킨 뒤 `docs/implementation/`에서만 공개용으로 남긴다.
- plan-only 상태나 generator-only 상태를 근거로 최종 구현 브리핑을 발행하지 않는다.
## cycle 문서

- 신규 작업은 기본적으로 `subagents_docs/cycles/NN-slug.md` 한 파일로 관리한다.
- 상단 상태 블록은 coordinator가 관리하고, 역할 산출물은 append-only로 누적한다.
- 섹션 이름은 `Planner v1`, `Generator v1`, `Evaluator v1`, `Planner v2`처럼 역할과 버전을 함께 쓴다.
- exact header 상태 전이와 provenance 요구는 `rule/rules/cycle-document-contract.md`를 따른다.
