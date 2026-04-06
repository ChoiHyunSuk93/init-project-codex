# Instruction Model 규칙

## 목적

root instruction, local instruction, rule 문서가 어떻게 함께 작동하는지 정의한다.

## Authority 순서

1. 관련 있는 task-specific 사용자 지시
2. 적용 범위 안의 local `AGENTS.md`
3. 적용 범위 안의 `rule/index.md`와 `rule/rules/` 참조 문서
4. root `AGENTS.md`

이 순서는 scope를 해석하기 위한 것이며, 중복 작성을 정당화하기 위한 것이 아니다.

## Thin Root 원칙

- root [`AGENTS.md`](../../AGENTS.md)는 짧게 유지한다.
- 안정적이고 상세한 동작 규칙은 `rule/rules/*.md`로 옮긴다.
- local `AGENTS.md`는 local scope를 분명하게 할 때만 사용한다.

## 참조 링크 원칙

- 실제로 열 수 있는 진입점 문서와 제어문서를 가리키는 참조는 가능한 한 Markdown 링크로 작성한다.
- 대표 대상에는 root/local [`AGENTS.md`](../../AGENTS.md), [`README.md`](../../README.md), [`rule/index.md`](../index.md), [`docs/guide/README.md`](../../docs/guide/README.md), [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md), [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md), starter local skill의 `SKILL.md`가 포함된다.
- 링크 대상은 현재 문서 위치 기준 상대 경로로 정확하게 열려야 한다.
- 이 기준은 current repo 문서, generated repository 문서, 그리고 이를 만드는 template/script source-of-truth에 함께 적용한다.
- placeholder, 예시 경로, 아직 생성되지 않은 경로, 단순 path literal 설명은 링크로 만들지 않는다.

## 중복 금지

- 이유 없이 같은 규칙을 여러 위치에 반복해서 쓰지 않는다.
- 상세 규칙이 바뀌면 [`rule/rules/rule-maintenance.md`](rule-maintenance.md)를 따라 원본 rule 문서와 필요한 index 참조를 갱신하고, 동일한 수정 내용을 여러 파일에 복사하지 않는다.
- 저장소 전역의 구현 품질 기대치는 여러 instruction 파일에 흩뿌리지 말고 [`rule/rules/development-standards.md`](development-standards.md)나 더 좁은 local rule에 둔다.

## Intent Gate

- 분석, 질문, 리뷰, 설명 요청을 구현 요청으로 오인하지 않는다.
- 사용자가 명시적으로 구현, 변경, 생성, 수정, materialize를 요청하기 전에는 분석 단계에 머물고 파일을 수정하지 않는다.
- 구현 의도가 모호하면 추측으로 편집하지 말고 clarification을 먼저 한다.

## Skill 작성 메모

- 저장소 안에 Codex skill을 만들거나 수정할 때는 `skill-creator`를 사용한다.
- skill은 명확한 `SKILL.md` 설명과 정렬된 메타데이터를 갖추도록 작성한다.
- 특별한 이유가 없다면 `agents/openai.yaml`에 `policy.allow_implicit_invocation: true`를 둔다.
- 저장소가 `.codex/skills/` 아래 starter local skill을 함께 가지면 `SKILL.md` 설명, metadata, `allow_implicit_invocation` 설정을 서로 맞춘다.
- 각 skill은 관련 `rule/rules/*.md` 문서를 참조형으로 연결하고, 저장소 공통 규칙을 skill 본문에 중복 작성하지 않는다.
