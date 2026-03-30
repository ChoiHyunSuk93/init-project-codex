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

- root `AGENTS.md`는 짧게 유지한다.
- 안정적이고 상세한 동작 규칙은 `rule/rules/*.md`로 옮긴다.
- local `AGENTS.md`는 local scope를 분명하게 할 때만 사용한다.
- 역할 분리 실행은 `rule/rules/subagent-orchestration.md`에서 정의하고, root `AGENTS.md`에는 그 존재만 연결한다.

## 중복 금지

- 이유 없이 같은 규칙을 여러 위치에 반복해서 쓰지 않는다.
- 상세 규칙이 바뀌면 `rule/rules/rule-maintenance.md`를 따라 원본 rule 문서와 필요한 index 참조를 갱신하고, 동일한 수정 내용을 여러 파일에 복사하지 않는다.
- 저장소 전역의 구현 품질 기대치는 여러 instruction 파일에 흩뿌리지 말고 `rule/rules/development-standards.md`나 더 좁은 local rule에 둔다.

## Skill 작성 메모

- 저장소 안에 Codex skill을 만들거나 수정할 때는 `skill-creator`를 사용한다.
- skill은 명시적 호출과 암시적 호출이 모두 가능하도록 `SKILL.md` 설명과 메타데이터를 작성한다.
- 특별한 이유가 없다면 `agents/openai.yaml`에 `policy.allow_implicit_invocation: true`를 둔다.
- 각 skill은 관련 `rule/rules/*.md` 문서를 참조형으로 연결하고, 저장소 공통 규칙을 skill 본문에 중복 작성하지 않는다.
