# 규칙 인덱스

이 인덱스는 `rule/rules/` 아래의 상세 규칙 문서를 찾는 기준 문서다.

규칙을 추가, 삭제, 이름 변경, 이동할 때는 같은 변경에서 이 파일도 함께 갱신한다.
여기에 등재되지 않은 규칙 문서는 인덱스에 추가되기 전까지 authoritative하지 않다.

## 인덱스 읽는 방법

- `Path`: 규칙 문서의 기준 경로
- `Scope`: 규칙이 적용되는 수준
- `Applies to`: 규칙이 적용되는 디렉토리 또는 파일
- `Authority`: 규칙의 효력 범위가 global인지 local인지
- `Summary`: 규칙이 통제하는 내용을 짧게 설명한 요약

## 전역 규칙

### project-structure
- Path: `rule/rules/project-structure.md`
- Scope: repository-wide
- Applies to: all directories
- Authority: global
- Summary: 최상위 구조, 디렉토리 역할, root와 local instruction 경계를 정의한다.

### instruction-model
- Path: `rule/rules/instruction-model.md`
- Scope: repository-wide
- Applies to: `AGENTS.md`, local `AGENTS.md`, `rule/`
- Authority: global
- Summary: 얇은 root orchestration, local scope 규칙, 중복 금지 원칙을 정의한다.

### rule-maintenance
- Path: `rule/rules/rule-maintenance.md`
- Scope: repository-wide
- Applies to: `rule/index.md`, `rule/rules/`
- Authority: global
- Summary: rule 문서를 어떻게 추가, 인덱싱, 갱신, 이동하고 authoritative 상태로 유지하는지 정의한다.

### documentation-boundaries
- Path: `rule/rules/documentation-boundaries.md`
- Scope: documentation
- Applies to: `docs/guide/`, `docs/implementation/`, `rule/`
- Authority: global
- Summary: 사람이 읽는 문서, 구현 이력, authoritative rule 문서의 차이를 정의한다.

### readme-maintenance
- Path: `rule/rules/readme-maintenance.md`
- Scope: documentation
- Applies to: `README.md`
- Authority: global
- Summary: root README를 어떻게 만들고 분석하며 저장소 대표 요약 문서로 유지하는지 정의한다.

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
- Applies to: unit tests, end-to-end tests, verification notes, and related test docs
- Authority: global
- Summary: 단위 테스트, E2E 테스트, 검증 기대치를 어떻게 선택하고 갱신하며 기록하는지 정의한다.

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

## 로컬 규칙

디렉토리별 규칙 문서가 생기면 여기에 local scope 규칙 항목을 추가한다.
첫 실제 local rule이 생기면 아래 placeholder 항목은 삭제한다.
local rule 문서도 특별한 요청이 없다면 `rule/rules/` 아래에 둔다.

### [local-rule-slug]
- Path: `rule/rules/[local-rule-file].md`
- Scope: local
- Applies to: `[directory-or-area]`
- Authority: local
- Summary: `[이 local rule의 역할을 짧게 설명한다.]`
