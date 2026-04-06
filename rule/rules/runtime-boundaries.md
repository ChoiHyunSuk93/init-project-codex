# Runtime 경계 규칙

## 목적

이 저장소에서 단일 source root와 non-runtime 영역을 어떻게 나누는지 정의한다.

## Source Root 디렉토리

이 저장소에서 실제 제품 변경과 생성 로직이 모이는 단일 source root는 아래와 같다.

- `hs-init-project/`

## Non-Runtime 디렉토리

- `.codex/`
- `.github/`
- `rule/`
- `docs/`

## 모호성 처리

- 기존 저장소에서 경계가 불분명하면 구조를 바꾸기 전에 먼저 확인한다.
- 프로젝트 루트 아래에 여러 runtime 디렉토리를 직접 두는 기본 규칙은 허용하지 않는다. 구현체는 단일 source root 아래에 둔다.
- source root 후보가 여러 개로 보이면 어떤 하나를 source root로 볼지 먼저 확인한다.
- 가능하면 충돌하는 새 모델을 만들기보다, 이미 의미 있게 형성된 기존 구조에 맞춘다.
- 경계가 바뀌면 [`rule/rules/runtime-boundaries.md`](runtime-boundaries.md)와 필요한 관련 `rule/rules/*.md` 문서를 함께 갱신한다.
