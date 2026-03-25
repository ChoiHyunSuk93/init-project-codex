# Runtime 경계 규칙

## 목적

이 저장소에서 runtime과 non-runtime 영역을 어떻게 나누는지 정의한다.

## Runtime 디렉토리

runtime 디렉토리를 여기에 적는다.

예시 placeholder:

- `[runtime-directory]`

## Non-Runtime 디렉토리

non-runtime 디렉토리를 여기에 적는다.

예시 placeholder:

- `rule/`
- `docs/`
- `[non-runtime-directory]`

## 모호성 처리

- 기존 저장소에서 경계가 불분명하면 구조를 바꾸기 전에 먼저 확인한다.
- 가능하면 충돌하는 새 모델을 만들기보다, 이미 의미 있게 형성된 기존 구조에 맞춘다.
- runtime과 non-runtime 경계가 실제로 드러나면 placeholder 항목을 관찰된 디렉토리로 교체한다.
- 경계가 바뀌면 `rule/runtime-boundaries.md`와 필요한 관련 rule 문서를 함께 갱신한다.
