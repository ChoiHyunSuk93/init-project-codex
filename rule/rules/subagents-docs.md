# Subagents Docs 규칙

## 목적

`subagents_docs/`를 이 저장소에서 실제로 work-sharing과 장기 handoff가 필요한 경우에만 사용하는 작업 문서 영역으로 정의한다.

## 사용 조건

- 분석 전용 요청이나 shared handoff가 없는 작은 작업에는 working record를 만들지 않는다.
- 명시적 work-sharing, 여러 단계 handoff, 장기 실행, 감사 가능한 상태 전이가 필요할 때 cycle 문서를 사용한다.
- 구현 cycle은 [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md)의 관련 phase 또는 phase section에 연결한다.
- 사용자-facing guide나 최종 결과 문서 대신 사용하지 않는다.

## 소유권

- coordinator가 cycle header, 상태, 공통 journal과 roadmap 갱신의 단일 writer다.
- delegated subagent는 같은 cycle 파일을 직접 수정하지 않고 task result, 변경 범위, 검증 근거, 남은 위험을 coordinator에게 반환한다.
- coordinator는 반환 결과를 정확한 역할 section에 통합하고 provenance를 기록한다.
- 병렬 subagent끼리 같은 파일이나 작업 기록을 공유하지 않는다.

## 문서 모델

- 신규 cycle은 `subagents_docs/cycles/<NN>-<slug>.md`에 둔다.
- 같은 작업은 같은 파일을 유지하고 section version으로 반복을 추적한다.
- exact header, status, section, provenance, dirty-worktree 규칙은 [`rule/rules/cycle-document-contract.md`](cycle-document-contract.md)를 따른다.
- overview, roadmap, phase gate는 [`rule/rules/planning-roadmap.md`](planning-roadmap.md)를 따른다.
- 문서 언어와 안정적인 path는 [`rule/rules/language-policy.md`](language-policy.md)를 따른다.

## 경계

- `subagents_docs/`에는 계획, 작업 분할, 구현 handoff, 검증 근거 같은 working state만 둔다.
- `docs/implementation/`에는 검증을 통과한 사용자-facing 최종 브리핑만 새 이력으로 추가한다.
- 과거 cycle과 구현 브리핑은 현재 정책에 맞춰 다시 쓰지 않는다.
