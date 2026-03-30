# .codex 설정 상향 및 생성 동기화 구현 기록

## 요약

현재 저장소의 `.codex/config.toml`을 상향 조정했고, `hs-init-project`가 생성하는 저장소에도 같은 설정 파일이 포함되도록 연결했다. 기존 `hs-init-project`는 `.codex/agents/*.toml`만 생성하고 `.codex/config.toml`은 생성하지 않았으므로, 이번 변경으로 current repo와 generated repo의 설정 구성이 일치하게 됐다.

## 변경 내용

- `/home/iotree/dev/init-project-codex/.codex/config.toml`을 `max_threads = 8`, `max_depth = 1`, `job_max_runtime_seconds = 7200`으로 수정했다.
- `hs-init-project/assets/.codex/config.toml`을 추가해 generated repo에 동일한 설정 파일이 들어가도록 했다.
- `hs-init-project/scripts/materialize_repo.sh`의 planned outputs 목록과 copy flow에 `.codex/config.toml`을 추가했다.

## 결과

- current repo와 generated repo가 같은 `.codex/config.toml` 구성을 사용한다.
- `hs-init-project`는 이제 `.codex/agents/*.toml`뿐 아니라 `.codex/config.toml`도 materialize한다.
- 이 설정은 current repo 전용이 아니라 skill 생성 결과에도 적용된다.

## 검증

- 단위 테스트: 없음
- E2E 검증: fresh generated repo 확인 예정
- 수동 검증: 현재 설정 파일 값 확인 및 `materialize_repo.sh` 생성 결과 확인 예정

## 관련 규칙

- `planner -> generator -> evaluator` 분리 규칙을 따른다.
- generated repo의 설정은 current repo와 동일하게 유지한다.
