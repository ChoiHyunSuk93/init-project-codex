Status: in_progress
Current Plan Version: Planner v1
Next Handoff: generator

# 27. release v0.1.9

## Planner v1

### 신규 cycle 여부

- 신규 cycle이다.

### 목표

- 현재 working tree에 반영된 `hs-init-project` 관련 변경분을 검증 가능한 릴리스 후보로 확정하고 `v0.1.9`로 출하한다.
- 릴리스 전 필요한 commit/tag/push 순서와 release workflow 조건을 현재 저장소 규칙 및 GitHub workflow 기준으로 맞춘다.
- 현재 변경분이 `v0.1.9`에 포함되어야 하는 릴리스 범위인지 확인하고, 릴리스 후 GitHub release workflow가 자연스럽게 트리거될 수 있는 상태를 만든다.

### 범위

- 현재 working tree 변경분의 릴리스 포함 여부 판단
- 릴리스 전 검증 상태 확인
- 릴리스 커밋 생성
- `main` 브랜치 push
- `v0.1.9` 태그 생성 및 origin push
- `.github/workflows/release.yml`, `CONTRIBUTING.md`, README의 릴리스 관련 기준 확인
- cycle 기록 문서

### 비범위

- 현재 변경분 외 추가 기능 개발
- 방금 반영된 구조/규칙 변경의 재설계
- 새 버전 정책 도입
- GitHub release workflow 자체의 구조 변경
- 태그 푸시 이후 GitHub 웹 UI에서의 수동 편집

### 사용자 관점 결과

- 현재 반영된 구조 개선 사항이 `hs-init-project v0.1.9`로 릴리스된다.
- 저장소는 `main`의 해당 릴리스 커밋과 `v0.1.9` 태그를 가지게 된다.
- 태그 푸시만으로 GitHub release workflow가 실행될 수 있는 상태가 된다.

### acceptance criteria

- working tree 변경분이 릴리스 범위로 정리되고, 필요한 검증이 통과한 상태에서 커밋 가능해야 한다.
- 릴리스 커밋이 `main` 브랜치에 push되어 origin에 반영되어야 한다.
- `v0.1.9` 태그가 올바른 릴리스 커밋을 가리키며 origin에 push되어야 한다.
- `.github/workflows/release.yml` 기준으로 태그 푸시가 release workflow를 트리거할 수 있는 상태여야 한다.
- 릴리스 과정에서 사용한 검증, 커밋, 태그, 푸시 결과가 cycle 문서에 추적 가능하게 남아야 한다.

### 제약

- 현재 저장소의 planner / generator / evaluator 역할 분리는 유지한다.
- planner는 제품 파일이나 git 상태를 직접 바꾸지 않고, generator가 수행할 릴리스 작업과 검증 기준만 명확히 정의한다.
- 릴리스 태그는 immutable로 취급해야 하므로 기존 태그를 수정하거나 재사용하지 않는다.
- 이미 `main` 브랜치에서 작업 중이므로 generator는 현재 변경분을 의도치 않게 누락하거나 덮어쓰지 말아야 한다.

### 위험 요소

- working tree에 예상 외 변경이 섞여 있으면 릴리스 범위 판단이 흐려질 수 있다.
- 태그가 잘못된 커밋을 가리키면 release workflow는 실행되더라도 잘못된 산출물이 출하된다.
- push 과정에서 원격과 충돌이 나면 릴리스가 중단될 수 있다.
- release workflow는 태그 푸시로 시작되므로 태그 push 누락 시 릴리스가 생성되지 않는다.

### 의존관계

- `subagents_docs/cycles/26-hs-init-project-structure-runtime-and-evaluator-loop.md`
- `CONTRIBUTING.md`
- `.github/workflows/release.yml`
- 현재 `main` 브랜치의 git 상태
- origin remote 접근 가능 상태

### open questions

- 없음. 이번 cycle에서는 현재 working tree 변경분 전체를 `v0.1.9` 릴리스 대상으로 본다.

### 다음 handoff

- generator는 현재 working tree 변경분이 릴리스 범위인지 확인하고 필요한 검증을 다시 실행한 뒤, 릴리스 커밋을 만들고 `main` 및 `v0.1.9` 태그를 origin에 push한다. 이후 실제 실행 결과를 `Generator v1`에 기록한다.
