# 현재 저장소 이름·언어·브리핑 규칙 재검증

## 판정

- `FAIL`

현재-repo recheck에서 대부분의 요구사항은 충족됐지만, current-repo 문서가 가리키는 skill 디렉터리명과 실제 저장소 구조가 아직 일치하지 않는다. 이 항목 때문에 current-repo part를 `pass`로 닫을 수 없다.

## 핵심 이슈

1. `hs-init-project` 참조가 current-repo rules/docs 내부에서는 통일됐지만, 실제 current-repo 구조와 충돌한다.
   - 문서상 기준:
     - `AGENTS.md`
     - `rule/rules/project-structure.md`
     - `rule/rules/runtime-boundaries.md`
     - `rule/rules/subagent-orchestration.md`
     - `docs/guide/subagent-workflow.md`
   - 위 문서들은 모두 runtime 제품 디렉터리를 `hs-init-project/`로 정의한다.
   - 그러나 실제 최상위 디렉터리에는 `./hschoi-init-project`만 존재한다.
   - 이번 recheck의 체크 항목이 "current-repo rules/docs에서 `hs-init-project` 참조가 일관적인가"에 그치지 않고 current-repo part의 통과 여부를 묻는 이상, 문서 모델이 실제 저장소 표면과 어긋난 상태는 blocker다.

## 통과한 항목

1. `subagents_docs` 언어 정책은 이번 cycle의 선택 언어 기준으로 문서화됐고, 이번 cycle 산출물도 그 기준을 따른다.
   - `subagents_docs/plans/06-skill-name-language-briefing-rules-plan.md`
   - `subagents_docs/plans/07-current-repo-name-language-briefing-rules-replan.md`
   - `subagents_docs/changes/03-current-repo-name-language-briefing-rules.md`
   - 위 세 문서는 한국어로 작성됐다.
   - `rule/rules/subagent-orchestration.md`, `rule/rules/subagents-docs.md`, `subagents_docs/AGENTS.md`는 선택 언어 강제 규칙을 명시한다.

2. subagent 응답 지연을 이유로 coordinator가 직접 구현하지 않는 규칙이 명시돼 있다.
   - `AGENTS.md`
   - `rule/rules/subagent-orchestration.md`
   - `rule/rules/subagents-docs.md`
   - `subagents_docs/AGENTS.md`

3. `docs/implementation/`은 category-based user-facing 구현 기록만 남기고, `briefings/`, `plans/`, `changes/` 디렉터리를 제거했다.
   - 현재 디렉터리:
     - `docs/implementation/`
     - `docs/implementation/subagent-harness/`
   - 현재 파일:
     - `docs/implementation/AGENTS.md`
     - `docs/implementation/subagent-harness/01-subagent-harness-redesign.md`
     - `docs/implementation/subagent-harness/02-subagent-harness-implementation.md`
   - `docs/implementation/AGENTS.md`는 별도 `briefings/` 상위 디렉터리 금지와 category 기반 짧은 브리핑 원칙을 명시한다.

4. `planner -> generator -> evaluator` 반복과 pass-until-pass 구조는 유지된다.
   - `subagents_docs/plans/06-skill-name-language-briefing-rules-plan.md`
   - `subagents_docs/plans/07-current-repo-name-language-briefing-rules-replan.md`
   - `rule/rules/subagent-orchestration.md`
   - `rule/rules/subagents-docs.md`
   - `subagents_docs/AGENTS.md`

## 품질 평가

- Design quality: `2/5`
  - 문서 간 정합성은 개선됐지만, 실제 current-repo 구조와 authoritative 문서가 다른 디렉터리명을 가리킨다. 이번 평가에서 더 높은 가중치를 두는 design quality 기준에서는 치명적 불일치다.

- Originality: `4/5`
  - language binding, no-direct-implementation, category-based briefing 유지라는 구조적 방향은 분명하고 이전 모델보다 설계 의도가 더 선명하다.

- Completeness: `4/5`
  - 언어 규칙, 문서 경계, implementation 구조 정리는 거의 닫혔다. 다만 실제 runtime 디렉터리 rename 또는 문서 경계 재정합이 남아 있다.

- Functionality: `3/5`
  - 규칙 자체는 실행 가능하지만, 현재 문서가 가리키는 runtime 경로가 실제와 다르기 때문에 운영 관점에서는 혼선을 유발한다.

## 검증 근거

- 읽은 문서:
  - `subagents_docs/plans/06-skill-name-language-briefing-rules-plan.md`
  - `subagents_docs/plans/07-current-repo-name-language-briefing-rules-replan.md`
  - `subagents_docs/changes/03-current-repo-name-language-briefing-rules.md`
  - `subagents_docs/evaluations/06-current-repo-name-language-briefing-rules.md`
  - `AGENTS.md`
  - `rule/rules/subagent-orchestration.md`
  - `rule/rules/subagents-docs.md`
  - `rule/rules/project-structure.md`
  - `rule/rules/runtime-boundaries.md`
  - `docs/guide/subagent-workflow.md`
  - `docs/implementation/AGENTS.md`
  - `docs/implementation/subagent-harness/01-subagent-harness-redesign.md`
  - `docs/implementation/subagent-harness/02-subagent-harness-implementation.md`
  - `subagents_docs/AGENTS.md`

- 수행한 검증:
  - `find docs/implementation -maxdepth 3 -type d | sort`
  - `find docs/implementation -maxdepth 3 -type f | sort`
  - `find . -maxdepth 1 -mindepth 1 -type d | sort`
  - `rg -n "hs-init-project/|hschoi-init-project/|planner -> generator -> evaluator|subagent 응답 지연|직접 구현" rule docs/guide docs/implementation AGENTS.md subagents_docs/AGENTS.md subagents_docs/plans/06-skill-name-language-briefing-rules-plan.md subagents_docs/plans/07-current-repo-name-language-briefing-rules-replan.md subagents_docs/changes/03-current-repo-name-language-briefing-rules.md`

- 관찰 결과:
  - `docs/implementation/briefings`, `docs/implementation/plans`, `docs/implementation/changes`는 존재하지 않는다.
  - current cycle의 `subagents_docs` 산출물은 한국어다.
  - current-repo authoritative docs는 `hs-init-project/`를 runtime 디렉터리로 규정한다.
  - 실제 최상위 디렉터리에는 `./hschoi-init-project`가 존재하고 `./hs-init-project`는 없다.

## 결론

- current-repo part는 아직 `pass`가 아니다.
- 다음 cycle에서는 아래 둘 중 하나가 current-repo 표면에서 실제로 닫혀야 한다.
  - 실제 skill 디렉터리를 `hs-init-project/`로 rename해 문서와 구조를 맞춘다.
  - 또는 current-repo에서 의도한 rename 범위를 재정의하고, authoritative 문서를 그 범위에 맞게 다시 정리한다.
