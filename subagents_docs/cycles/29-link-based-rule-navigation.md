Status: PASS
Current Plan Version: Evaluator v1
Next Handoff: complete

# 29. link-based rule navigation

## Planner v1

### 신규 cycle 여부

- 신규 cycle이다.

### 목표

- `hs-init-project`가 생성하는 저장소에서 rule navigation 경로가 단순 code literal이 아니라 실제 클릭 가능한 Markdown 링크로 동작하도록 바꾼다.
- current repo도 같은 원칙으로 정렬해, root `AGENTS.md`와 `rule/index.md`를 포함한 주요 탐색 문서가 실제 링크 기반 참조를 제공하도록 맞춘다.
- 파일마다 링크 목적지가 상대 경로 기준으로 올바르게 계산되도록 정리해 “보이는 경로명”과 “실제 클릭 대상”이 어긋나지 않게 만든다.

### 범위

- current repo의 root `AGENTS.md`를 `rule/index.md` 링크 진입점 중심으로 갱신
- current repo의 `rule/index.md`에서 실제 starter rule `Path` 항목을 Markdown 링크로 전환
- current repo의 주요 안내 문서 중 `rule/index.md`나 rule 문서를 탐색 시작점으로 안내하는 문구를 링크 기반으로 정렬
- `hs-init-project/assets/AGENTS/root.*.md`와 `hs-init-project/assets/rule/index.*.md`를 같은 링크 규칙으로 갱신
- generated starter local skill 문서가 direct rule reference를 plain code path로 남기는 부분이 있으면 대응 asset과 `hs-init-project/scripts/materialize_repo.sh`의 existing-project path도 함께 정렬
- 필요 시 `hs-init-project/SKILL.md`와 relevant reference 문서에서 “explicit references” 기대치를 링크 기반 navigation 관점으로 더 분명하게 보강

### 비범위

- rule 문서 본문 전체를 전부 링크 스타일로 기계적으로 치환하는 작업
- 존재하지 않는 placeholder 경로까지 실제 링크로 만들어 broken navigation을 늘리는 작업
- rule 구조, slug, file naming, authority model 자체 변경
- GitHub workflow, release metadata, agent model 설정 변경
- 저장소 외부 렌더러별 링크 표시 방식 차이를 해결하려는 별도 호환성 작업

### 사용자 관점 결과

- root `AGENTS.md`를 읽는 사용자는 바로 `rule/index.md`로 이동할 수 있다.
- `rule/index.md`를 읽는 사용자는 각 starter rule의 `Path`를 눌러 바로 상세 rule 문서로 이동할 수 있다.
- nested 문서에서도 실제 클릭 대상이 현재 파일 기준 상대 경로로 맞게 연결되어 “링크를 눌렀는데 잘못된 위치로 가는” 문제가 없어진다.
- `hs-init-project`로 새 저장소를 materialize했을 때도 같은 링크 기반 탐색 경험이 재현된다.

### acceptance criteria

- current repo의 root `AGENTS.md`에서 `rule/index.md`를 가리키는 대표 진입 문구가 실제 Markdown 링크로 바뀐다.
- current repo의 `rule/index.md`에서 실제 존재하는 starter rule `Path` 항목은 표시 텍스트는 canonical repo path를 유지하되, 링크 목적지는 `rule/index.md` 기준 상대 경로로 올바르게 열린다.
- current repo의 nested 안내 문서에서 `rule/index.md`를 직접 안내하는 대표 문구는 각 파일 위치에 맞는 상대 링크를 사용한다.
- `hs-init-project/assets/AGENTS/root.en.md`, `hs-init-project/assets/AGENTS/root.ko.md`, `hs-init-project/assets/rule/index.en.md`, `hs-init-project/assets/rule/index.ko.md`가 같은 링크 규칙을 반영한다.
- generated starter local skill 문서가 direct rule reading instruction을 포함하는 경우, fresh-template asset과 existing-project materialize 경로가 모두 링크 기반 문구로 정렬된다.
- placeholder local rule 항목처럼 실제 파일이 없는 항목은 broken link를 만들지 않도록 code literal 유지 또는 명시적 예시 형식으로 남긴다.
- generator는 변경 후 실제 materialize smoke 또는 동등한 산출물 확인으로 generated output에서도 링크 목적지가 맞게 들어가는지 검증한다.

### 제약

- planner는 cycle 문서 외 제품 파일을 수정하지 않는다.
- current repo 기본 문서 언어는 한국어를 유지하고, generated output은 선택된 언어 규칙을 유지해야 한다.
- 링크 목적지는 각 문서 위치 기준 상대 경로여야 하므로, 보이는 경로 문자열과 href가 반드시 같을 필요는 없다.
- skill 내부 reference 문서는 target repository 파일이 같은 상대 경로에 존재하지 않으므로, target path를 무리하게 클릭 링크로 바꾸지 않는다.

### 위험 요소

- `rule/index.md` 안에서 표시 텍스트를 그대로 링크 목적지로 쓰면 `rule/rules/...`가 아니라 `rule/rule/rules/...`로 잘못 해석될 수 있다.
- `docs/guide/README.md`, `docs/implementation/AGENTS.md`, `subagents_docs/AGENTS.md`, `.codex/skills/*/SKILL.md`처럼 중첩 경로가 다른 문서들을 일괄 치환하면 상대 링크가 틀어질 수 있다.
- current repo와 generated source-of-truth 중 한쪽만 바꾸면 이후 materialize 결과와 현재 저장소가 다시 드리프트한다.
- placeholder entry를 링크로 바꾸면 evaluator 단계에서 broken navigation을 PASS시키기 어려워진다.

### 의존관계

- `AGENTS.md`
- `rule/index.md`
- `docs/guide/README.md`
- `docs/implementation/AGENTS.md`
- `subagents_docs/AGENTS.md`
- `hs-init-project/SKILL.md`
- `hs-init-project/assets/AGENTS/root.ko.md`
- `hs-init-project/assets/AGENTS/root.en.md`
- `hs-init-project/assets/rule/index.ko.md`
- `hs-init-project/assets/rule/index.en.md`
- `hs-init-project/assets/.codex/skills/*/SKILL.*.md`
- `hs-init-project/scripts/materialize_repo.sh`
- `rule/rules/instruction-model.md`
- `rule/rules/rule-maintenance.md`
- `rule/rules/language-policy.md`
- `rule/rules/subagent-orchestration.md`
- `rule/rules/cycle-document-contract.md`

### open questions

- 없음. 이번 cycle에서는 “주요 rule navigation 문서와 generated 대응 산출물에서 실제 링크형 참조를 제공하되, 존재하지 않는 placeholder는 링크로 만들지 않는다”를 명확한 요구사항으로 본다.

### 다음 handoff

- generator는 current repo의 주요 navigation 문서와 `hs-init-project/` source of truth를 함께 갱신해 링크 기반 rule navigation을 일관되게 반영한다.
- generator는 파일별 상대 링크 목적지를 실제 위치 기준으로 계산하고, canonical path 표시는 유지할지 별도 표기 문구로 남길지 일관된 패턴을 선택해 적용한다.
- generator는 template-only 경로와 script-generated 경로를 구분해, `AGENTS.md`/`rule/index.md`는 asset 위주로 갱신하고 existing-project starter skill 문구처럼 script-generated 산출물이 있으면 `hs-init-project/scripts/materialize_repo.sh`도 함께 수정한다.
- generator는 변경 후 diff 점검과 materialize smoke 또는 동등한 산출물 확인을 수행하고 결과를 `Generator v1`에 기록한다.

## Generator v1

### planner section reference

- `Planner v1`

### 실제 반영한 범위

- current repo의 root `AGENTS.md`를 `rule/index.md` 링크 진입점과 핵심 rule direct link 기준으로 갱신했다.
- current repo의 `rule/index.md`에서 실제 starter rule `Path` 항목을 Markdown 링크로 전환하고, placeholder local rule entry는 code literal로 유지했다.
- current repo의 nested navigation 문서인 `docs/guide/README.md`, `docs/implementation/AGENTS.md`, `subagents_docs/AGENTS.md`를 각 파일 위치 기준 상대 링크로 정렬했다.
- generated source of truth인 `hs-init-project/assets/AGENTS/root.*.md`, `hs-init-project/assets/rule/index.*.md`, `hs-init-project/assets/docs/*`, `hs-init-project/assets/subagents_docs/*`, starter local skill template들을 같은 링크 규칙으로 갱신했다.
- existing-project mode에서 script가 직접 생성하는 starter local skill 문구와 `docs/guide/README.md` 문구도 `hs-init-project/scripts/materialize_repo.sh`에서 같은 링크형 참조로 맞췄다.

### 변경 파일 목록

- `AGENTS.md`
- `rule/index.md`
- `docs/guide/README.md`
- `docs/implementation/AGENTS.md`
- `subagents_docs/AGENTS.md`
- `hs-init-project/assets/AGENTS/root.en.md`
- `hs-init-project/assets/AGENTS/root.ko.md`
- `hs-init-project/assets/rule/index.en.md`
- `hs-init-project/assets/rule/index.ko.md`
- `hs-init-project/assets/docs/guide/README.en.md`
- `hs-init-project/assets/docs/guide/README.ko.md`
- `hs-init-project/assets/docs/implementation/AGENTS.en.md`
- `hs-init-project/assets/docs/implementation/AGENTS.ko.md`
- `hs-init-project/assets/subagents_docs/AGENTS.en.md`
- `hs-init-project/assets/subagents_docs/AGENTS.ko.md`
- `hs-init-project/assets/.codex/skills/change-analysis/SKILL.en.md`
- `hs-init-project/assets/.codex/skills/change-analysis/SKILL.ko.md`
- `hs-init-project/assets/.codex/skills/code-implementation/SKILL.en.md`
- `hs-init-project/assets/.codex/skills/code-implementation/SKILL.ko.md`
- `hs-init-project/assets/.codex/skills/test-debug/SKILL.en.md`
- `hs-init-project/assets/.codex/skills/test-debug/SKILL.ko.md`
- `hs-init-project/assets/.codex/skills/docs-sync/SKILL.en.md`
- `hs-init-project/assets/.codex/skills/docs-sync/SKILL.ko.md`
- `hs-init-project/assets/.codex/skills/quality-review/SKILL.en.md`
- `hs-init-project/assets/.codex/skills/quality-review/SKILL.ko.md`
- `hs-init-project/scripts/materialize_repo.sh`

### 검증에 사용한 workspace/baseline scope

- 구현 시작 기준 baseline은 product 파일 기준 clean worktree였고, cycle 문서 `subagents_docs/cycles/29-link-based-rule-navigation.md`만 untracked 상태였다.
- generator 변경은 위 baseline 이후 생긴 cycle-owned diff만 대상으로 했고, unrelated modified product files는 없는 상태에서 작업했다.

### 검증 명령

- `sh -n hs-init-project/scripts/materialize_repo.sh`
- `git diff --check`
- fresh materialize smoke
```sh
fresh_dir=$(mktemp -d)
sh hs-init-project/scripts/materialize_repo.sh "$fresh_dir" --language ko
rg -n --fixed-strings '[`rule/index.md`](rule/index.md)' "$fresh_dir/AGENTS.md"
rg -n --fixed-strings '[`rule/rules/project-structure.md`](rules/project-structure.md)' "$fresh_dir/rule/index.md"
rg -n --fixed-strings '[`rule/index.md`](../../../rule/index.md)' "$fresh_dir/.codex/skills/code-implementation/SKILL.md"
rm -rf "$fresh_dir"
```
- existing-project materialize smoke
```sh
existing_dir=$(mktemp -d)
mkdir -p "$existing_dir/src"
sh hs-init-project/scripts/materialize_repo.sh "$existing_dir" --language en --readme-mode existing --source-root-dir src
rg -n --fixed-strings '[`rule/index.md`](../../../rule/index.md)' "$existing_dir/.codex/skills/code-implementation/SKILL.md"
rg -n --fixed-strings '[`rule/index.md`](../../rule/index.md)' "$existing_dir/docs/guide/README.md"
rm -rf "$existing_dir"
```

### 검증 결과

- shell syntax check와 whitespace/diff check가 통과했다.
- fresh mode 생성물에서 root `AGENTS.md`, `rule/index.md`, starter local skill `SKILL.md`에 링크형 rule navigation이 들어가는 것을 확인했다.
- existing-project mode 생성물에서도 script-generated starter local skill과 `docs/guide/README.md`에 상대 링크가 들어가는 것을 확인했다.

### 남은 위험과 제약

- 이번 cycle은 navigation entrypoint와 canonical generated outputs를 중심으로 링크형 참조를 정렬했다. 규칙 내용을 설명하는 모든 rule/reference 문서 본문을 전면 링크화한 것은 아니다.
- `rule/index.md`의 local placeholder 항목은 broken link를 피하려고 의도적으로 literal path로 남겼다.
- materialize smoke는 representative output 확인 기준이며, 모든 generated document의 모든 inline path를 exhaustive하게 클릭 검증한 것은 아니다.

### 다음 handoff

- evaluator는 `Planner v1`의 acceptance criteria 기준으로 current repo와 generated outputs가 실제 링크형 navigation 요구를 충족하는지 검토한다.
- evaluator는 cycle-owned diff만 기준으로 PASS/FAIL을 판정하고, placeholder local rule entry가 non-link로 남은 것이 의도된 예외인지 함께 확인한다.

## Evaluator v1

### 판정

- PASS

### planner section reference

- `Planner v1`

### generator section reference

- `Generator v1`

### acceptance criteria 판정

- 충족. current repo의 root `AGENTS.md`는 [`rule/index.md`](../../rule/index.md)를 직접 링크하는 진입 문구를 가진다.
- 충족. current repo의 `rule/index.md`는 실제 starter rule `Path` 항목을 모두 Markdown 링크로 두고, 링크 목적지를 `rules/*.md` 상대 경로로 맞췄다.
- 충족. current repo의 nested 안내 문서인 `docs/guide/README.md`, `docs/implementation/AGENTS.md`, `subagents_docs/AGENTS.md`는 각 파일 위치 기준 상대 링크를 사용한다.
- 충족. `hs-init-project/assets/AGENTS/root.en.md`, `hs-init-project/assets/AGENTS/root.ko.md`, `hs-init-project/assets/rule/index.en.md`, `hs-init-project/assets/rule/index.ko.md`가 같은 링크 규칙을 반영한다.
- 충족. starter local skill 템플릿과 `hs-init-project/scripts/materialize_repo.sh`의 existing-project 생성 경로가 모두 링크형 rule reading 문구를 출력한다.
- 충족. placeholder local rule 항목은 `rule/index.md`와 template index들에서 code literal로 유지돼 broken link를 만들지 않는다.
- 충족. fresh/existing materialize smoke에서 생성물에도 링크형 navigation이 실제로 들어가는 것을 확인했다.

### 실제 검증 절차

- `git diff --check`
- `sh -n hs-init-project/scripts/materialize_repo.sh`
- `sed -n '1,120p' rule/index.md`
- `sed -n '1,80p' docs/guide/README.md`
- fresh materialize smoke
```sh
tmpdir=$(mktemp -d)
sh hs-init-project/scripts/materialize_repo.sh "$tmpdir" --language ko >/dev/null
rg -n --fixed-strings '[`rule/index.md`](rule/index.md)' "$tmpdir/AGENTS.md"
rg -n --fixed-strings '[`rule/rules/project-structure.md`](rules/project-structure.md)' "$tmpdir/rule/index.md"
rm -rf "$tmpdir"
```
- existing-project materialize smoke
```sh
tmpdir=$(mktemp -d)
mkdir -p "$tmpdir/src"
sh hs-init-project/scripts/materialize_repo.sh "$tmpdir" --language en --readme-mode existing --source-root-dir src >/dev/null
rg -n --fixed-strings '[`rule/index.md`](../../../rule/index.md)' "$tmpdir/.codex/skills/code-implementation/SKILL.md"
rg -n --fixed-strings '[`rule/index.md`](../../rule/index.md)' "$tmpdir/docs/guide/README.md"
rm -rf "$tmpdir"
```

### dirty worktree 비교 기준

- evaluator 시점의 dirty worktree는 cycle-owned 변경만 포함했다.
- tracked 변경은 root/current repo navigation 문서, `hs-init-project/` templates, 그리고 `hs-init-project/scripts/materialize_repo.sh`로 한정됐고, unrelated tracked diff는 관찰되지 않았다.
- untracked 파일은 이 cycle working document `subagents_docs/cycles/29-link-based-rule-navigation.md` 하나였다.
- PASS 판정은 위 cycle-owned diff와 acceptance criteria만 기준으로 내렸다.

### 관찰 결과

- current repo에서 링크형 rule navigation이 실제로 동작하는 구조로 정렬됐다.
- generated source of truth와 existing-project script-generated output이 같은 규칙으로 맞춰져 drift 위험이 줄었다.
- `rule/index.md`의 placeholder local rule entry는 의도된 non-link 예외로 남아 broken navigation을 피했다.

### 문제 목록

- 없음.

### 품질 평가

- Design quality: 4/5. root -> index -> detailed rules 흐름이 더 명확해졌다.
- Originality: 3/5. 구조 변경은 보수적이지만 목적에 맞게 일관되다.
- Completeness: 5/5. current repo, canonical templates, script-generated existing-project path까지 함께 정렬됐다.
- Functionality: 5/5. current repo와 representative generated outputs에서 링크형 navigation을 직접 확인했다.

### 다음 handoff

- complete
