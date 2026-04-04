# Runtime 경계 규칙

## 목적

이 저장소에서 단일 source root와 non-runtime 영역을 어떻게 나누는지 정의한다.

## Source Root 디렉토리

프로젝트 루트 아래에서 구현체를 모으는 단일 source root 디렉토리를 여기에 적는다.

예시 placeholder:

- `[source-root-directory]`

## Non-Runtime 디렉토리

non-runtime 디렉토리를 여기에 적는다.

예시 placeholder:

- `rule/`
- `docs/`
- `[non-runtime-directory]`

## 모호성 처리

- 기존 저장소에서 경계가 불분명하면 구조를 바꾸기 전에 먼저 확인한다.
- source root로 보이는 후보가 여러 개면 어떤 하나를 source root로 볼지 먼저 확인한다.
- 가능하면 충돌하는 새 모델을 만들기보다, 이미 의미 있게 형성된 기존 구조에 맞춘다.
- source root와 non-runtime 경계가 실제로 드러나면 placeholder 항목을 관찰된 디렉토리로 교체한다.
- 경계가 바뀌면 `rule/rules/runtime-boundaries.md`와 필요한 관련 `rule/rules/*.md` 문서를 함께 갱신한다.
