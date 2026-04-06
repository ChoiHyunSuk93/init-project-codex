# 구현 기록 지침

이 디렉토리는 사람이 읽는 구현 기록을 저장하는 공간이다.

## 범위

- 구현 기록은 관심사 기반 카테고리 디렉토리로 정리한다.
- 카테고리 디렉토리는 해당 관심사의 첫 구현 기록을 작성할 때 생성한다.
- 새 기록은 가장 가까운 기존 카테고리에 배치한다.
- 현재 카테고리로 더 이상 작업을 설명하기 어렵게 되었을 때만 새 카테고리를 추가한다.
- 이 디렉토리는 사용자-facing 최종 구현 브리핑의 기록 공간이며, planner/generator/evaluator의 작업 문서는 두지 않는다.

## 파일 규칙

- 초기화 단계에서 빈 카테고리 디렉토리나 placeholder 기록 문서를 미리 만들지 않는다.
- 구현 변경이 있을 때마다 해당 카테고리에 기록 문서를 생성하거나 수정한다.
- 각 카테고리 안에서는 `NN-name.md` 형식을 사용해 짧고 읽기 쉬운 브리핑 기록을 남긴다.
- 각 카테고리 안의 번호는 순서에 맞게 유지한다.
- flat layout을 명시적으로 요청하지 않았다면 기록을 `docs/implementation/` 루트에 평평하게 쌓지 않는다.
- 서브에이전트 하네스 작업의 작업용 문서는 `subagents_docs/`에 두고, 이 디렉토리에는 최종 요약만 둔다.
- 최종 요약은 evaluator가 cycle 문서 안에서 구현 결과를 pass로 판정한 뒤 concern-based category directory에 두고, 브리핑 형식으로 작성한다.
- plan 문서나 generator change record만 있는 상태에서는 최종 요약을 만들거나 갱신하지 않는다.
- `briefings/`라는 별도 상위 디렉토리는 만들지 않는다.
- category 예시는 `subagent-harness/`처럼 결과의 관심사를 드러내는 이름을 사용한다.

## 기록 양식

- 각 구현 기록은 최소한 `요약`, `변경 내용`, `이유`, `검증`, `관련 규칙` 섹션을 포함한다.
- 새 기록을 만들 때는 이 최소 구조를 유지한 상태에서 실제 변경 내용으로 채운다.
- 구분이 의미 있을 때는 `검증` 섹션 안에서 단위 테스트, E2E 테스트, 수동 검증을 분리해서 적는다.
- planner/generator/evaluator 작업 문서의 형식은 `subagents_docs/cycles/` 중심 규칙을 따른다.

## 연계 규칙

- 변경이 실제 사용자 워크플로를 바꾸면 `docs/guide/`의 관련 가이드를 함께 생성하거나 수정한다.
- 구현 메모, 저장소 구조 요약, 규칙 복사본을 `docs/guide/`로 옮기지 않는다.
- 규칙에 새로운 명시 사항이 추가되거나 기존 규칙이 바뀌면 [`rule/rules/rule-maintenance.md`](../../rule/rules/rule-maintenance.md)를 따라 관련 규칙 문서와 [`rule/index.md`](../../rule/index.md)를 함께 갱신한다.
- 테스트나 검증 관례가 더 구체화되면 구현 기록도 [`rule/rules/testing-standards.md`](../../rule/rules/testing-standards.md)와 맞춰서 유지한다.

## 권한 범위

- 이 디렉토리는 사람이 검토하는 작업 이력을 위한 공간이다.
- Codex 실행 규칙의 기준 권한은 root [`AGENTS.md`](../../AGENTS.md), [`rule/index.md`](../../rule/index.md), 그리고 `rule/rules/` 아래의 문서에 있다.

## 언어 규칙

- 사람이 읽는 기록 문서는 [`rule/rules/language-policy.md`](../../rule/rules/language-policy.md) 기준 활성 언어 규칙을 따른다.
- 이 제어 파일의 이름은 `AGENTS.md`로 유지한다.
- Korean 모드에서는 제어 파일이 아닌 기록 문서의 사람이 읽는 파일명 부분을 한글로 써도 된다.
- 코드, 명령어, 설정 키, 슬러그, 경로 표기는 영어로 유지한다.
