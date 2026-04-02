# 규칙 인덱스

이 인덱스는 `rule/rules/` 아래의 상세 규칙 문서를 찾는 기준 문서다.

## 전역 규칙

### project-structure
- Path: `rule/rules/project-structure.md`
- Scope: repository-wide
- Applies to: all directories
- Authority: global
- Summary: 최상위 구조, 디렉토리 역할, OMX-managed 영역과 저장소 소유 영역의 경계를 정의한다.

### instruction-model
- Path: `rule/rules/instruction-model.md`
- Scope: repository-wide
- Applies to: `AGENTS.md`, local `AGENTS.md`, `rule/`
- Authority: global
- Summary: root overlay 동작, local scope 규칙, 중복 금지 원칙을 정의한다.

### rule-maintenance
- Path: `rule/rules/rule-maintenance.md`
- Scope: repository-wide
- Applies to: `rule/index.md`, `rule/rules/`
- Authority: global
- Summary: rule 문서를 어떻게 추가, 인덱싱, 갱신, 이동하고 authoritative 상태로 유지하는지 정의한다.

### documentation-boundaries
- Path: `rule/rules/documentation-boundaries.md`
- Scope: documentation
- Applies to: `docs/guide/`, `docs/implementation/`, `.omx/`, `rule/`
- Authority: global
- Summary: 사람이 읽는 문서, OMX runtime state, authoritative rule 문서의 차이를 정의한다.

### language-policy
- Path: `rule/rules/language-policy.md`
- Scope: repository-wide documentation
- Applies to: `AGENTS.md`, `rule/`, `docs/guide/`, `docs/implementation/`
- Authority: global
- Summary: 생성 문서 언어 규칙, 한글 magic keyword alias, 안정적인 filename/path 불변 조건을 정의한다.

### readme-maintenance
- Path: `rule/rules/readme-maintenance.md`
- Scope: documentation
- Applies to: `README.md`
- Authority: global
- Summary: root README를 어떻게 만들고 분석하며 저장소 대표 요약 문서로 유지하는지 정의한다.

### subagent-orchestration
- Path: `rule/rules/subagent-orchestration.md`
- Scope: repository-wide workflow
- Applies to: `AGENTS.md`, `.omx/`, root coordination
- Authority: global
- Summary: team-first workflow, leader ownership, dirty-workspace gate, Ralph-style completion loop를 정의한다.

## 품질 규칙

### development-standards
- Path: `rule/rules/development-standards.md`
- Scope: repository-wide
- Applies to: code, tests, schemas, public interfaces, and related docs
- Authority: global
- Summary: 기본 구현 품질, 관례 준수, 검증 기대치를 정의한다.

### testing-standards
- Path: `rule/rules/testing-standards.md`
- Scope: repository-wide
- Applies to: tests, verification notes, and related test docs
- Authority: global
- Summary: 검증 기대치를 어떻게 선택하고 갱신하며 기록하는지 정의한다.

## 구조 규칙

### runtime-boundaries
- Path: `rule/rules/runtime-boundaries.md`
- Scope: structural
- Applies to: runtime and non-runtime directories
- Authority: global
- Summary: runtime과 non-runtime 영역을 어떻게 구분하고 모호한 경계를 어떻게 해소하는지 정의한다.

### implementation-records
- Path: `rule/rules/implementation-records.md`
- Scope: implementation history
- Applies to: `docs/implementation/`
- Authority: global
- Summary: concern-based category 디렉토리, 순번형 기록 이름 규칙, flat 금지 원칙을 정의한다.
