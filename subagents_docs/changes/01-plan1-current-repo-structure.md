# Plan 1 Change Note (Generator)

- `rule/rules/subagent-orchestration.md`를 최신 요구사항에 맞게 정리했다.
- 핵심 반영 내용은 planner/generator/evaluator 작업 영역을 `subagents_docs/`로 고정하고, `docs/guide`/`docs/implementation`은 사용자용 문서로 분리한 점이다.
- 실행 규칙에 plan 단위 반복 루프(PLAN 실패 시 재기획→재구현→재평가)와 다중 계획의 독립 병렬/의존 순차 처리를 추가했다.
- 문서 위치 규칙을 user-facing/agent-working 경계로 명확화해 역할별 소유 디렉토리를 강화했다.
- 현재 Plan 1은 문서 규칙 정합성 반영 단계이며, 추가 구현 변경은 없음.

- `planner/generator/evaluator` 에이전트 정의(`.codex/agents/*.toml`)의 소유 산출물을 `docs/implementation/*`에서 `subagents_docs/*`로 변경했다.
  - 이제 계획은 `subagents_docs/plans`, 구현 변경기는 `subagents_docs/changes`, 평가는 `subagents_docs/evaluations`에 남긴다.
  - `docs/guide`/`docs/implementation`은 사용자 공개용/요약용 문서로만 취급한다.

- `docs/implementation/plans/01-skill-subagent-harness-redesign.md`와 `docs/implementation/changes/01-skill-subagent-harness-implementation.md`의 서브에이전트 작업 본문을 각각
  `subagents_docs/plans/01-skill-subagent-harness-redesign.md`, `subagents_docs/changes/01-skill-subagent-harness-implementation.md`로 이관해 사용자-facing 영역을 정리했다.

- current repo의 `.codex/agents/generator.toml`에서 generator 소유 범위를 active plan 기준으로 해석하도록 넓혀,
  Plan 1 같은 현재 저장소 구조 개편도 같은 하네스 안에서 완결할 수 있게 했다.
- `docs/implementation/`의 사용자-facing 요약은 `briefings/` 카테고리로 옮겨 `plans/`, `changes/` 같은 작업용 인상을 제거했다.
