# 18 Current Repo Korean Rule Language Check

- Status: PASS
- Current Plan Version: Evaluator v1
- Next Handoff: complete

## Planner v1

### 목표

- current repo가 메인 에이전트의 orchestration-only 원칙을 충분히 명시하는지 확인한다.
- current repo의 rule/doc control file이 필요한 범위에서 한국어로 일관되게 보이도록 최소 수정 범위를 정한다.
- generated-skill 쪽 언어 정책 명시가 실제로 부족한지 다시 확인하고, 부족할 때만 변경을 계획한다.

### 확인 결과

- current repo의 orchestration-only 원칙은 `AGENTS.md`, `subagents_docs/AGENTS.md`, `rule/rules/subagent-orchestration.md`, `rule/rules/subagents-docs.md`에 이미 명시돼 있다.
- current repo는 rule 문서와 guide 다수가 한국어인데, `AGENTS.md`와 `subagents_docs/AGENTS.md`는 영어라 control file 언어 톤이 섞여 있다.
- generated-skill 쪽은 `SKILL.md`, references, assets에서 선택 언어/한국어 모드 정책을 이미 설명하고 있으므로, 현재 확인 범위에서는 추가 변경을 전제하지 않는다.

### 범위

- 필요 시 current repo의 `AGENTS.md`
- 필요 시 current repo의 `subagents_docs/AGENTS.md`
- 필요 시 current repo의 언어 정책을 가장 직접 설명하는 rule 문서 1개

### 비범위

- historical cycle 문서 일괄 수정
- generated-skill 문서 전반 재작성

### acceptance criteria

- current repo에서 메인 에이전트가 orchestration-only이며 실제 작업은 subagent에 위임한다는 점이 분명하게 유지된다.
- current repo control file 언어 일관성 보강이 필요하면 최소 파일만 수정 대상으로 잡는다.
- generated-skill 언어 정책은 실제 누락이 없으면 변경 대상으로 잡지 않는다.

### 다음 handoff

- generator가 current repo에서 필요한 최소 수정만 적용할지 판단하고, 필요 시 `AGENTS.md`, `subagents_docs/AGENTS.md`, 그리고 관련 rule 1개 이내에서만 반영한다.

## Generator v1

### planner section reference

- `Planner v1`

### 실제 반영한 범위

- current repo control file 언어 톤을 한국어로 맞추기 위해 `AGENTS.md`와 `subagents_docs/AGENTS.md`만 수정했다.
- 메인 에이전트가 orchestration-only이며 실제 계획, 구현, 평가는 planner/generator/evaluator subagent에 위임된다는 점을 두 파일에서 더 직접적으로 유지했다.
- current repo rule 문서는 이미 한국어와 orchestration-only 원칙을 충분히 담고 있어 추가 수정하지 않았다.

### 변경 파일

- `AGENTS.md`
- `subagents_docs/AGENTS.md`

### 검증

- `AGENTS.md`, `subagents_docs/AGENTS.md`, `rule/rules/subagent-orchestration.md`를 대조해 orchestration-only 문구가 유지되는지 확인
- `rg -n "language|언어|Korean|한국어|selected language|선택된 언어|rule language|문서 언어" hs-init-project/SKILL.md hs-init-project/references/language-output.md hs-init-project/references/structure-initialization.md hs-init-project/references/subagent-orchestration.md -S`로 generated-skill 언어 정책 명시 여부 확인

### 남은 위험/제약

- current repo의 다른 historical 문서나 guide는 범위대로 수정하지 않았다.
- generated-skill 쪽은 언어 정책이 이미 명시되어 있어 이번 cycle에서는 변경하지 않았다.

### 다음 handoff

- evaluator가 최소 수정 범위가 지켜졌는지와 current repo control file 언어 일관성이 보강됐는지 확인한다.

## Evaluator v1

### 결과

- PASS

### planner section reference

- `Planner v1`

### generator section reference

- `Generator v1`

### 검증 절차

- `git diff --check`
- `sed -n '1,220p' AGENTS.md`
- `sed -n '1,220p' subagents_docs/AGENTS.md`
- `sed -n '1,260p' rule/rules/subagent-orchestration.md`
- `sed -n '1,240p' rule/rules/subagents-docs.md`
- `sed -n '1,240p' hs-init-project/SKILL.md`
- `sed -n '1,240p' hs-init-project/references/language-output.md`
- `sed -n '220,320p' hs-init-project/references/structure-initialization.md`
- `sed -n '1,220p' hs-init-project/references/subagent-orchestration.md`
- `git diff -- AGENTS.md subagents_docs/AGENTS.md`
- `rg -n "language|언어|Korean|한국어|selected language|선택된 언어|rule language|문서 언어" hs-init-project/SKILL.md hs-init-project/references/language-output.md hs-init-project/references/structure-initialization.md hs-init-project/references/subagent-orchestration.md -S`

### acceptance criteria 판정

- current repo에서 메인 에이전트가 orchestration-only이며 실제 계획, 구현, 평가는 subagent에 위임된다는 점이 `AGENTS.md`, `subagents_docs/AGENTS.md`, `rule/rules/subagent-orchestration.md`, `rule/rules/subagents-docs.md`에서 모두 명시된다.
- current repo control docs in scope는 한국어로 정렬되어 있고, rule 문서도 같은 한국어 톤을 유지한다.
- generated-skill 쪽 언어 정책은 `hs-init-project/SKILL.md`, `hs-init-project/references/language-output.md`, `hs-init-project/references/structure-initialization.md`, `hs-init-project/references/subagent-orchestration.md`에 이미 명시돼 있어 이번 cycle에서 generated-skill 변경이 필요하지 않다.
- 이번 cycle의 실제 수정 diff는 `AGENTS.md`, `subagents_docs/AGENTS.md` 두 파일로 제한되어 최소 범위를 유지했다.

### findings

- 없음.

### 품질 평가

- design quality: PASS
- originality: PASS
- completeness: PASS
- functionality: PASS

### 다음 handoff

- 없음. cycle 종료.
