# Runtime 경계 규칙

## 목적

이 저장소에서 runtime과 non-runtime 영역을 어떻게 나누는지 정의한다.

## Runtime 디렉토리

이 저장소에서 실제 제품 변경과 생성 로직이 모이는 주 runtime 영역은 아래와 같다.

- `hs-init-project/`

## Non-Runtime 디렉토리

- `.codex/`
- `.github/`
- `rule/`
- `docs/`

## 모호성 처리

- 기존 저장소에서 경계가 불분명하면 구조를 바꾸기 전에 먼저 확인한다.
- runtime으로 보이는 디렉토리가 여러 개면 하나로 억지로 합치지 말고, 모두 runtime으로 볼지 먼저 확인한다.
- 가능하면 충돌하는 새 모델을 만들기보다, 이미 의미 있게 형성된 기존 구조에 맞춘다.
- 경계가 바뀌면 `rule/rules/runtime-boundaries.md`와 필요한 관련 `rule/rules/*.md` 문서를 함께 갱신한다.
