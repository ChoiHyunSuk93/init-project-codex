# `.codex` 설정 상향 및 생성 동기화 계획

## 배경

현재 루트 `.codex/config.toml`의 값은 다음과 같다.

- `max_threads = 3`
- `max_depth = 1`
- `job_max_runtime_seconds = 1800`

로컬 CPU 가용량은 8코어로 확인됐다. 현재 `max_threads = 3`은 병렬 처리 여유가 너무 낮고, `job_max_runtime_seconds = 1800`은 긴 작업에서 재확인과 범위 축소를 유발해 품질을 떨어뜨릴 가능성이 있다.

또한 `hs-init-project`는 현재 `.codex/agents/*.toml`만 생성하고, `.codex/config.toml`은 생성하지 않는다. 즉 이 설정은 현재 저장소에는 존재하지만, `hs-init-project`로 생성되는 저장소에는 아직 동기화되지 않았다.

## 목표

1. 현재 저장소의 `.codex/config.toml` 값을 상향 조정한다.
2. `hs-init-project`가 생성하는 저장소에도 동일한 `.codex/config.toml`을 포함시킨다.
3. 새 설정이 current repo와 generated repo 모두에서 같은 의미로 유지되도록 문서와 생성 경로를 맞춘다.

## 권장 값

- `max_threads = 8`
  - 로컬 CPU 수와 일치하는 최대 병렬 상한으로 잡아, 불필요한 병목을 줄인다.
  - 현재 작업 패턴에서 3은 낮고, 8은 과도하게 높지 않으면서도 최대치에 가깝다.
- `job_max_runtime_seconds = 7200`
  - 1800초보다 충분히 길어서 장시간 작업에서 scope narrowing / reconfirmation이 반복되는 문제를 줄인다.
  - 너무 길게 두어 무제한 대기처럼 보이지 않도록 2시간 기준으로 설정한다.

## 범위

### current repo

- `.codex/config.toml`
- 필요 시 `AGENTS.md`
- 필요 시 `README.md`, `README.ko.md`
- 필요 시 `rule/rules/*.md`와 `docs/guide/*.md`

### generated skill

- `hs-init-project/scripts/materialize_repo.sh`
- `hs-init-project/assets/.codex/config.toml`
- `hs-init-project/SKILL.md`
- `hs-init-project/references/structure-initialization.md`
- `hs-init-project/agents/openai.yaml`
- 필요 시 `hs-init-project/assets/AGENTS/*`와 `hs-init-project/assets/README/*`

## 작업 분해

### Plan A: 현재 저장소 설정 상향

- `.codex/config.toml`의 `max_threads`를 8로 올린다.
- `.codex/config.toml`의 `job_max_runtime_seconds`를 7200으로 조정한다.
- 현재 저장소의 문서에서 이 설정이 현재 프로젝트 전용이 아니라, 생성 스킬로도 동기화될 예정임을 명시한다.

### Plan B: 생성 스킬 설정 추가

- `hs-init-project`가 fresh/existing repository materialization 시 `.codex/config.toml`도 함께 생성하도록 만든다.
- 생성된 파일의 값이 current repo와 동일하게 `max_threads = 8`, `job_max_runtime_seconds = 7200`이 되도록 한다.
- 기존의 `.codex/agents/*.toml` 생성 흐름은 유지한다.

### Plan C: 문서 정합성

- `hs-init-project` 본문과 reference 문서에 `.codex/config.toml` 생성이 포함된다는 사실을 반영한다.
- 생성 저장소의 루트 문서에도 `.codex/config.toml`이 포함된다는 점을 짧게 설명한다.

### Plan D: 검증

- current repo에서 `.codex/config.toml` 값이 의도대로 바뀌었는지 확인한다.
- fresh English / fresh Korean 생성 결과에 `.codex/config.toml`이 포함되는지 확인한다.
- 생성된 파일의 값이 current repo와 같은지 확인한다.
- existing-project mode에서도 `.codex/config.toml`이 예측 가능하게 생성되는지 확인한다.

## 의존 관계

- Plan A는 값 자체를 확정하는 단계라서 Plan B와 C보다 먼저다.
- Plan B는 `.codex/config.toml`을 실제로 생성하는 경로를 추가해야 하므로 구현 측면에서 핵심이다.
- Plan C는 Plan A/B의 결과를 설명하는 문서 정합성 단계다.
- Plan D는 A/B/C가 반영된 뒤에만 의미가 있다.

## 수용 기준

- current repo `.codex/config.toml`에서 `max_threads = 8`, `job_max_runtime_seconds = 7200`이 확인된다.
- `hs-init-project`로 생성되는 fresh repo에 `.codex/config.toml`이 포함된다.
- generated repo의 `.codex/config.toml` 값도 동일하게 상향된다.
- `hs-init-project`는 여전히 `.codex/agents/*.toml`을 생성하고, 기존 생성 흐름을 깨지 않는다.
- 문서상으로도 이 설정이 current repo 전용이 아니라 generated repo에도 반영된다는 점이 분명하다.

## 검증 계획

- 문서 검색으로 `.codex/config.toml` 생성 경로와 값 설명이 현재 repo / generated skill 양쪽에 반영됐는지 확인한다.
- fresh English repo 생성으로 `.codex/config.toml`의 존재와 값 일치를 확인한다.
- fresh Korean repo 생성으로 동일 검증을 반복한다.
- existing-project sample 생성으로 `.codex/config.toml`이 함께 materialize되는지 확인한다.
