# 저장소 안내

이 저장소는 `hs-init-project` Codex skill을 개발한다.
이 파일은 얇게 유지하고, 상세 규칙 탐색의 시작점은 `rule/index.md`로 둔다.

## 범위

- root 수준 안내는 이 파일에 둔다.
- 상세한 기준 규칙은 `rule/index.md`와 `rule/rules/*.md`에 둔다.
- 사용자-facing 워크플로 문서는 `docs/guide/`에 둔다.
- evaluator 통과 뒤의 사용자-facing 최종 구현 브리핑은 `docs/implementation/`의 관심사 카테고리 아래에 둔다.
- subagent 작업 문서는 `subagents_docs/`에서 읽고 쓴다.
- skill의 source of truth는 `hs-init-project/` 아래에 둔다.

## Skill 범위

- `hs-init-project/SKILL.md`는 skill의 기본 진입점이다.
- `hs-init-project/agents/openai.yaml`은 `hs-init-project/SKILL.md`와 정렬된 상태를 유지해야 한다.
- 상세 보조 동작은 `hs-init-project/references/`에 둔다.
- 재사용 가능한 생성 템플릿은 `hs-init-project/assets/`에 둔다.
- 결정론적 helper 스크립트는 `hs-init-project/scripts/`에 둔다.
- local starter skill이 필요하면 `.codex/skills/` 아래에 두고, `SKILL.md` 설명과 `agents/openai.yaml` metadata를 명확하게 맞춘다.

## 서브에이전트 하네스

- 이 저장소는 `planner`, `generator`, `evaluator`를 분리한 워크플로를 기본으로 사용한다.
- 메인 에이전트는 orchestration-only 역할만 맡는다. 실제 계획, 구현, 평가는 각 subagent에 위임하고, 메인 에이전트는 handoff 수집, 순서 유지, 재계획 조정만 담당한다.
- 사용자가 명시적으로 구현/변경/materialize를 요청하지 않았으면 분석, 질문, 리뷰, 설명 요청을 구현으로 오인하지 말고 분석 단계에서 멈춘다.
- 기본 순서는 `planner -> generator -> evaluator`다.
- evaluator는 구현 결과를 plan과 acceptance criteria 기준으로 평가한다.
- 재계획은 evaluator가 해당 구현 결과의 실패나 blocker를 확인했을 때만 시작한다.
- subagent를 띄우거나 조정하기 전에 `rule/rules/subagent-orchestration.md`를 먼저 읽는다.
- exact cycle 문서 경로, header 상태 전이, append-only section, provenance, dirty-worktree 평가는 `rule/rules/cycle-document-contract.md`를 따른다.
- 문서 언어와 안정적인 filename/path 규칙은 `rule/rules/language-policy.md`를 따른다.
- 사용자가 명시적으로 완화하지 않는 한 planner, generator, evaluator 책임을 하나의 역할로 합치지 않는다.
- 기본적으로 메인 에이전트가 planner, generator, evaluator를 직접 겸하지 않는다.
- subagent 작업 문서를 `docs/implementation/` 아래에 두지 말고 `subagents_docs/`를 사용한다.
- subagent 응답이 느려도 메인 에이전트가 직접 구현으로 뛰어들지 말고 오래 기다릴 수 있다. 다만 완료되었거나 더 이상 필요 없는 subagent thread는 작업 종료 시 정리한다.
- stale session이나 thread limit 때문에 새 subagent를 띄우지 못하면, 메인 에이전트는 직접 구현 대신 thread cleanup을 먼저 수행한다.

## 저장소 규칙

- root 문서는 사람이 읽기 쉽고 공개 저장소에 적합한 형태로 유지한다.
- 커밋 문서에 로컬 머신 경로, 비공개 환경 정보, 유지보수자 전용 메모를 넣지 않는다.
- skill 구조나 metadata를 바꿀 때는 `skill-creator`를 사용한다.
- `SKILL.md`는 간결하게 유지하고, 안정적인 상세 내용은 `references/`로 이동한다.
- 출력 형식이나 워크플로가 충분히 안정됐을 때만 `assets/`나 `scripts/`를 추가한다.
- local skill을 만들 때는 `SKILL.md` 설명, `agents/openai.yaml` metadata, `allow_implicit_invocation` 설정을 함께 맞춘다.
- skill 변경은 마무리 전에 검증한다.
- open-source 기본값은 최소하고 유지보수 가능하게 유지한다.
- 명시적 요청 없이 프로젝트 전용 스택 선택, package 파일, CI, 기능을 임의로 만들지 않는다.
- GitHub 워크플로나 저장소 정책을 바꾸면 관찰된 결과를 함께 보고한다.
