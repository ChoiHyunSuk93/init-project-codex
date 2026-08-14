# 규칙 인덱스

이 문서는 `rule/rules/` 아래 기준 규칙의 탐색 시작점이다.
규칙을 추가, 삭제, 이름 변경, 이동할 때 같은 변경에서 이 인덱스도 갱신한다.

## 전역 규칙

### project-structure
- Path: [`rule/rules/project-structure.md`](rules/project-structure.md)
- Scope: repository-wide
- Summary: 관찰된 저장소 구조와 runtime/non-runtime 경계를 보존한다.

### development-standards
- Path: [`rule/rules/development-standards.md`](rules/development-standards.md)
- Scope: repository-wide
- Summary: 최소 변경, 재사용, 책임 분리, 실패 처리와 관찰 가능성 기준을 정의한다.

### testing-standards
- Path: [`rule/rules/testing-standards.md`](rules/testing-standards.md)
- Scope: repository-wide
- Summary: 위험에 맞는 테스트와 실제 검증 근거를 선택한다.

### documentation
- Path: [`rule/rules/documentation.md`](rules/documentation.md)
- Scope: repository-wide documentation
- Summary: 문서 권한, 언어, 경로, 현재 상태와 이력의 경계를 정의한다.

### agent-workflow
- Path: [`rule/rules/agent-workflow.md`](rules/agent-workflow.md)
- Scope: repository-wide workflow
- Summary: intent gate, 작업 분류, 선택적 delegation과 통합 책임을 정의한다.

## 로컬 규칙

디렉터리별로 더 좁은 규칙이 실제로 필요할 때만 추가하고 여기에 등재한다.
