# 저장소 안내

이 저장소는 `hs-init-project` Codex skill을 개발한다.
이 파일은 얇게 유지하고, 상세 규칙 탐색의 시작점은 [`rule/index.md`](rule/index.md)로 둔다.

## 범위

- root 수준 안내는 이 파일에 둔다.
- 상세한 기준 규칙은 [`rule/index.md`](rule/index.md)와 `rule/rules/*.md`에 둔다.
- 사용자-facing 워크플로 문서는 `docs/guide/`에 둔다.
- evaluator 통과 뒤의 사용자-facing 최종 구현 브리핑은 `docs/implementation/`의 관심사 카테고리 아래에 둔다.
- subagent 작업 문서는 `subagents_docs/`에서 읽고 쓴다.
- skill의 source of truth는 `hs-init-project/` 아래에 둔다.

## Skill 범위

- [`hs-init-project/SKILL.md`](hs-init-project/SKILL.md)는 skill의 기본 진입점이다.
- [`hs-init-project/agents/openai.yaml`](hs-init-project/agents/openai.yaml)은 [`hs-init-project/SKILL.md`](hs-init-project/SKILL.md)와 정렬된 상태를 유지해야 한다.
- 상세 보조 동작은 `hs-init-project/references/`에 둔다.
- 재사용 가능한 생성 템플릿은 `hs-init-project/assets/`에 둔다.
- 결정론적 helper 스크립트는 `hs-init-project/scripts/`에 둔다.
- local starter skill이 필요하면 `.codex/skills/` 아래에 두고, `SKILL.md` 설명과 `agents/openai.yaml` metadata를 명확하게 맞춘다.

## 서브에이전트 하네스

- 이 저장소는 변경 크기와 모호성에 따라 하네스를 고르는 adaptive subagent workflow를 기본으로 사용한다.
- 메인 에이전트는 작업 분류, 계획 승인, 구현 통합, handoff 조정의 책임을 가진다.
- 메인 에이전트는 필요할 때 subagent를 자율적으로 호출할 수 있고, 문서 분석이나 비교 독해가 필요하면 병렬 `explorer` 호출을 우선 고려한다.
- 사용자가 명시적으로 구현/변경/materialize를 요청하지 않았으면 분석, 질문, 리뷰, 설명 요청을 구현으로 오인하지 말고 분석 단계에서 멈춘다.
- 작은 변경은 `main/generator -> evaluator`로 처리한다.
- 중간 변경은 `main(plan+implementation) -> evaluator`로 처리한다.
- 큰 변경이지만 비교적 명확하면 `main-led decomposition + delegated implementation + evaluator`로 처리한다.
- 큰 변경이면서 모호하면 `parallel explorer analysis + planner assist if needed + main-approved plan + delegated implementation + evaluator`로 처리한다.
- evaluator는 구현 결과를 plan과 acceptance criteria 기준으로 평가한다.
- 재계획이나 경로 승격은 evaluator가 실패나 blocker를 확인했거나, 메인 에이전트가 작업 규모/모호성이 커졌다고 판단했을 때 시작한다.
- subagent를 띄우거나 조정하기 전에 [`rule/rules/subagent-orchestration.md`](rule/rules/subagent-orchestration.md)를 먼저 읽는다.
- exact cycle 문서 경로, header 상태 전이, append-only section, provenance, dirty-worktree 평가는 [`rule/rules/cycle-document-contract.md`](rule/rules/cycle-document-contract.md)를 따른다.
- 문서 언어와 안정적인 filename/path 규칙은 [`rule/rules/language-policy.md`](rule/rules/language-policy.md)를 따른다.
- cycle working document가 필요한 경우 `Planner vN` / `Generator vN` / `Evaluator vN` append-only 형태를 유지한다.
- 작은 직접 변경은 shared handoff가 없으면 cycle 문서를 생략할 수 있고, 중간 이상 변경이나 명시적 work-sharing이 있으면 cycle 문서를 사용한다.
- subagent 작업 문서를 `docs/implementation/` 아래에 두지 말고 `subagents_docs/`를 사용한다.
- `.codex/agents/*.toml`의 reasoning 기본값은 `high`로 두고, 작업 난이도와 리스크에 따라 조정할 수 있게 유지한다.
- subagent 응답이 느리더라도 메인 에이전트는 우선 기존 handoff와 통합 책임을 유지하고, 완료되었거나 더 이상 필요 없는 subagent thread는 작업 종료 전에 정리한다.
- stale session이나 thread limit 때문에 새 subagent를 띄우지 못하면, 메인 에이전트는 thread cleanup을 먼저 수행한다.

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
