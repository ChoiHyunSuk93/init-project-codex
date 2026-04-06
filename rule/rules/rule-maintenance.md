# 규칙 유지 규칙

## 목적

authoritative rule 문서를 어떻게 만들고, 인덱싱하고, 바꾸고, 계속 정렬 상태로 유지하는지 정의한다.

## 기준 모델

- [`rule/index.md`](../index.md)는 authoritative rule 문서를 찾는 기준 문서다.
- 인덱싱된 rule 문서는 특별한 요청이 없다면 `rule/rules/` 아래에 둔다.
- rule 문서는 [`rule/index.md`](../index.md)에 등재되기 전까지 authoritative하지 않다.

## 규칙 수명주기

- 새로운 명시 규칙이 필요하면 여러 instruction 파일에 흩뿌리지 말고 `rule/rules/` 아래의 가장 관련 있는 문서를 생성하거나 수정한다.
- rule 문서를 추가, 삭제, 이름 변경, 이동할 때는 같은 변경에서 [`rule/index.md`](../index.md)도 함께 갱신한다.
- 인덱스 항목의 `Path`, `Scope`, `Applies to`, `Authority`, `Summary`는 실제 rule 문서와 맞춘다.
- 요구사항이 기존 규칙 경계에 속하면 새 파일을 늘리기보다 기존 rule 문서를 확장하는 쪽을 우선한다.

## 정합성 요구사항

- 제어 파일 이름은 [`rule/index.md`](../index.md)로 유지한다.
- 인덱싱된 rule 경로는 안정적이고 예측 가능하게 유지한다.
- 하나의 변경이 여러 규칙에 영향을 주면 관련 rule 문서를 같은 변경에서 함께 갱신한다.
- 규칙 구조가 바뀌면 stale 참조, 고아 요약, 오래된 경로를 남기지 않는다.
- 진입점 문서나 제어문서 참조를 링크형으로 운영하는 위치에서는 관련 경로 변경 시 Markdown 링크도 같은 변경에서 함께 갱신한다.
- 실제 파일을 가리키는 링크는 현재 문서 위치 기준 상대 경로로 열려야 하며, broken link를 남기지 않는다.
- 새 진입점 문서나 제어문서를 추가할 때는 관련 README, AGENTS, guide, skill, script-generated output의 참조도 같은 변경에서 함께 정렬한다.

## Starter Rule 유지

- 신규 저장소에서는 starter rule에 placeholder가 있을 수 있지만, 실제 구조나 관례가 분명해지면 관찰된 값으로 교체한다.
- 기준 문서가 있는 규칙은 [`AGENTS.md`](../../AGENTS.md), guide 문서, 구현 기록에 복사본처럼 흩어 두지 않는다.
- local scope 규칙을 도입하면 [`rule/index.md`](../index.md)에 local 항목으로 추가하고, 특별한 요청이 없다면 `rule/rules/` 아래에 둔다.
