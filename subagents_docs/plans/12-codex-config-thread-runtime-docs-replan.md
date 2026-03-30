# `.codex` 설정 문서 정합성 재계획

## 배경

이전 plan 11의 구현은 성공했다.

- current repo의 `.codex/config.toml`은 `max_threads = 8`, `max_depth = 1`, `job_max_runtime_seconds = 7200`으로 반영됐다.
- `hs-init-project`는 이제 fresh/existing materialization 시 동일한 `.codex/config.toml`을 생성한다.

평가에서 실패한 유일한 지점은 문서 정합성이다. 현재 `README.md`와 `hs-init-project`의 README 템플릿이 새로 생성되는 `.codex/config.toml`을 설명하지 않아서, generated repo가 실제로 포함하는 구조와 설명이 어긋난다.

## 목표

1. current repo README와 `hs-init-project` README 템플릿이 `.codex/config.toml` 생성 사실을 설명하도록 맞춘다.
2. generated repo 설명에서 `.codex/agents/*.toml`만 언급하고 `.codex/config.toml`을 빠뜨리는 부분을 제거한다.
3. 이번 변경은 문서 정합성에만 한정하고, 이미 통과한 config 값과 생성 경로는 유지한다.

## 범위

### current repo

- `README.md`
- `README.ko.md`
- 필요 시 `AGENTS.md`

### generated skill

- `hs-init-project/README.md` 관련 문서 진입점
- `hs-init-project/assets/README/root.en.md`
- `hs-init-project/assets/README/root.ko.md`
- 필요 시 `hs-init-project/SKILL.md`
- 필요 시 `hs-init-project/agents/openai.yaml`
- 필요 시 `hs-init-project/references/structure-initialization.md`

## 작업 분해

### Plan A: current repo README 정합성

- root README의 생성 구조 설명에 `.codex/config.toml`이 포함된다는 점을 추가한다.
- 한국어 README도 같은 의미를 반영한다.
- current repo가 generated repo와 같은 설정 구성을 사용한다는 점을 짧게 명시한다.

### Plan B: generated-skill README 템플릿 정합성

- `assets/README/root.en.md`와 `assets/README/root.ko.md`에 `.codex/config.toml`을 추가한다.
- 현재는 `.codex/agents/*.toml`만 만들거나 언급하는 표현이 있으면 함께 정리한다.
- generated repo의 구조 설명이 실제 materialize 결과와 일치하도록 맞춘다.

### Plan C: 필요 시 주변 문구 정리

- `SKILL.md`, `agents/openai.yaml`, `references/structure-initialization.md`에 `.codex/config.toml`이 generated repo에도 포함된다는 사실을 최소 문장으로 반영한다.
- 다만 이번 rework의 중심은 README 정합성이므로, 불필요한 범위 확장은 피한다.

## 의존 관계

- Plan B가 핵심이다. generated repo README 템플릿이 실제로 사용자에게 보이는 구조 설명이기 때문이다.
- Plan A는 current repo 설명을 generated repo와 맞추는 후속이다.
- Plan C는 README 설명과 skill 본문 사이의 잔여 불일치가 있을 때만 보완한다.

## 수용 기준

- `README.md`와 `README.ko.md`가 `.codex/config.toml` 생성/포함 사실을 설명한다.
- `hs-init-project/assets/README/root.en.md`와 `root.ko.md`가 generated repo 구조에 `.codex/config.toml`을 포함한다.
- generated repo 설명은 더 이상 `.codex/agents/*.toml`만 생성된다는 인상을 주지 않는다.
- 기존 config 값(`max_threads = 8`, `max_depth = 1`, `job_max_runtime_seconds = 7200`)과 materialize 경로는 변경하지 않는다.
- `planner -> generator -> evaluator` 사이클은 유지되고, 이번 재계획은 evaluator fail 이후에만 발생한 것이다.

## 검증 계획

- 문서 검색으로 README와 템플릿에서 `.codex/config.toml` 설명이 반영됐는지 확인한다.
- fresh English / fresh Korean materialization 결과에서 README 설명과 실제 구조가 일치하는지 확인한다.
- 기존 설정 파일 값과 `.codex/config.toml` 생성 경로는 그대로 유지되는지 재확인한다.
