# Subagents Docs

이 디렉터리는 실제 work-sharing이나 장기 handoff가 필요한 작업의 working document를 저장한다.

## 기준

- roadmap은 [`subagents_docs/roadmap.md`](roadmap.md)에서 관리한다.
- cycle 문서는 `subagents_docs/cycles/<NN>-<slug>.md`에 둔다.
- 작업 분류와 delegation 판단은 [`rule/rules/subagent-orchestration.md`](../rule/rules/subagent-orchestration.md)를 따른다.
- exact cycle 형식은 [`rule/rules/cycle-document-contract.md`](../rule/rules/cycle-document-contract.md)를 따른다.
- 문서 언어와 path는 [`rule/rules/language-policy.md`](../rule/rules/language-policy.md)를 따른다.

## Writer 규칙

- coordinator가 cycle header, roadmap 상태, 공통 journal의 단일 writer다.
- delegated subagent는 이 디렉터리의 공통 문서를 직접 수정하지 않고 task result와 검증 근거를 coordinator에게 반환한다.
- coordinator가 반환 결과를 role section에 통합하고 provenance를 남긴다.
- 병렬 작업자는 같은 파일을 동시에 수정하지 않는다.

## 사용 범위

- shared handoff가 없는 small work는 cycle 문서를 생략한다.
- medium 이상이라도 단일 agent가 짧게 끝낼 수 있으면 cycle을 강제하지 않는다.
- 분석 전용 요청은 implementation cycle을 열지 않는다.
- 사용자-facing 문서는 `docs/guide/`와 `docs/implementation/`에 두고 working record와 섞지 않는다.
- 과거 완료 문서는 이력으로 보존한다.
