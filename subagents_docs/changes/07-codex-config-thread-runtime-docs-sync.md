# .codex 설정 문서 정합성 동기화 구현 기록

## 요약

현재 저장소와 `hs-init-project` 생성 템플릿이 모두 `.codex/config.toml`을 생성하도록 바뀐 뒤, README 문서도 같은 구조를 설명하도록 맞췄다. 이제 generated repo 설명에는 `.codex/config.toml`이 `.codex/agents/*.toml`과 함께 포함된다고 짧게 명시한다.

## 변경 내용

- `/home/iotree/dev/init-project-codex/README.md`와 `/home/iotree/dev/init-project-codex/README.ko.md`의 generated structure 설명에 `.codex/config.toml`을 추가했다.
- `hs-init-project/assets/README/root.en.md`와 `hs-init-project/assets/README/root.ko.md`의 구조 설명에 동일한 `.codex/config.toml` 문구를 추가했다.
- 기존 설정값과 `materialize_repo.sh`의 생성 흐름은 변경하지 않았다.

## 결과

- 문서상으로도 generated repositories가 `.codex/config.toml`과 `.codex/agents/*.toml`을 함께 포함한다는 점이 분명해졌다.
- current repo 전용 설정처럼 보이던 설명이 generated repo 설명과 맞춰졌다.

## 검증

- 수동 검색: `.codex/config.toml`과 `.codex/agents` 문구가 README와 skill template에 모두 반영됐는지 확인했다.

## 관련 규칙

- generated repo 설명은 실제 materialize 결과와 일치해야 한다.
- 설정 값과 생성 흐름은 이번 문서 정합성 수정에서 바꾸지 않는다.
