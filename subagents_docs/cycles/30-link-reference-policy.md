Status: PASS
Current Plan Version: Evaluator v1
Next Handoff: complete

# 30. link-reference policy

## Planner v1

### 신규 cycle 여부

- 신규 cycle이다.

### 목표

- 진입점 문서와 제어문서 참조를 Markdown 링크로 유지해야 한다는 기준을 기존 rule 체계에 명시한다.
- current repo와 `hs-init-project`가 생성하는 구조 전반에서, 실제로 열어야 하는 entrypoint/control-document 참조가 이 기준과 일치하도록 정렬한다.
- 이미 반영된 cycle 29의 링크 네비게이션 변경을 전제로, 이후에도 같은 기준이 유지되도록 rule과 source-of-truth를 보강한다.

### 범위

- current repo의 기존 rule 문서 중 링크형 참조 정책을 정의하거나 유지해야 하는 문서 갱신
- current repo의 entrypoint/control-document 참조가 남아 있는 대표 문서 갱신
- `hs-init-project/assets/` 아래 rule, README, AGENTS, nested control-document 템플릿 갱신
- `hs-init-project/scripts/materialize_repo.sh`의 direct text generation 경로 중 같은 정책이 필요한 출력 갱신
- cycle 29에서 이미 바뀐 링크 네비게이션과 충돌하지 않도록 dirty-worktree baseline을 그대로 존중한 상태에서 후속 보강

### 비범위

- placeholder, 예시 경로, 아직 생성되지 않는 경로까지 전부 링크로 바꾸는 작업
- cycle 문서 과거 기록 전체를 새 링크 정책으로 기계적으로 치환하는 작업
- rule 구조, category 구조, source-root 정책, subagent harness 모델 자체 변경
- GitHub workflow, release metadata, 설치 방식 변경

### 사용자 관점 결과

- 어떤 문서가 entrypoint/control-document인지 rule에서 명시적으로 드러난다.
- current repo의 주요 탐색 문서와 generated output이 같은 링크형 참조 규칙을 따른다.
- 이후 새 문서를 추가하거나 경로를 바꿀 때도 링크 참조를 같은 변경에서 맞춰야 한다는 유지 규칙이 생긴다.

### acceptance criteria

- current repo의 기존 rule 문서에 “실제 entrypoint/control-document 참조는 Markdown 링크를 우선하고, placeholder/example은 링크로 만들지 않는다”는 정책이 명시된다.
- current repo의 rule 문서 중 이 정책을 설명하거나 유지하는 핵심 문서들이 서로 링크형 참조 기준으로 정렬된다.
- current repo의 root/nested entrypoint 문서에서 실제 열어야 하는 control-document 참조가 링크형으로 유지된다.
- `hs-init-project/assets/`의 대응 rule/template 문서들이 같은 정책을 반영한다.
- `hs-init-project/scripts/materialize_repo.sh`가 fresh mode와 existing-project mode 생성물에서 같은 링크형 참조 정책을 내보낸다.
- cycle 29에서 의도적으로 non-link로 둔 placeholder local rule entry 같은 예외는 broken link 없이 유지된다.
- generator는 current repo diff 점검과 fresh/existing materialize smoke로 generated output 반영까지 확인한다.

### 제약

- existing dirty worktree는 cycle 29의 cycle-owned 변경을 포함한 상태로 취급하고, unrelated change처럼 재해석하거나 되돌리지 않는다.
- 새 정책은 가능하면 기존 rule 문서를 확장하는 방식으로 반영하고, 새 rule 파일은 만들지 않는다.
- 링크 목적지는 각 문서 위치 기준 상대 경로여야 하며, 표시 문자열과 href가 다를 수 있다.
- 아직 만들어지지 않는 control file, placeholder path, 예시 path는 링크로 바꾸지 않는다.

### 위험 요소

- rule 문서 본문까지 폭넓게 만지면서 링크 범위를 과하게 넓히면 문서 가독성이 떨어질 수 있다.
- current repo만 갱신하고 generated source-of-truth를 놓치면 이후 materialize 결과와 다시 드리프트한다.
- script-generated existing-project output과 asset-based fresh output이 따로 놀면 policy가 부분 적용 상태로 남는다.
- existing dirty worktree를 잘못 다루면 cycle 29 변경과 cycle 30 변경의 경계가 흐려질 수 있다.

### 의존관계

- `rule/rules/instruction-model.md`
- `rule/rules/documentation-boundaries.md`
- `rule/rules/rule-maintenance.md`
- `rule/rules/readme-maintenance.md`
- 필요 시 현재 repo의 related `rule/rules/*.md`
- `AGENTS.md`
- `README.md`
- `README.ko.md`
- `docs/guide/README.md`
- `docs/implementation/AGENTS.md`
- `subagents_docs/AGENTS.md`
- `hs-init-project/assets/AGENTS/`
- `hs-init-project/assets/README/`
- `hs-init-project/assets/docs/`
- `hs-init-project/assets/subagents_docs/`
- `hs-init-project/assets/rule/`
- `hs-init-project/assets/.codex/skills/*/SKILL.*.md`
- `hs-init-project/scripts/materialize_repo.sh`

### open questions

- 없음. 이번 cycle은 “entrypoint/control-document 참조만 링크형으로 강제하고, placeholder/example은 예외로 둔다”는 기준이 충분히 명확하다.

### 다음 handoff

- generator는 existing dirty worktree를 cycle 29 포함 baseline으로 인정하고, 그 위에 link-reference policy를 current repo와 `hs-init-project` source-of-truth에 반영한다.
- generator는 새 rule 파일을 만들지 말고 기존 rule 문서를 우선 확장한다.
- generator는 current repo와 generated output 모두에서 실제 열어야 하는 entrypoint/control-document 참조만 선별적으로 링크화하고, placeholder/example 경로는 non-link 예외로 유지한다.
- generator는 `git diff --check`, `sh -n hs-init-project/scripts/materialize_repo.sh`, fresh/existing materialize smoke로 결과를 확인하고 기록한다.

## Generator v1

### planner section reference

- `Planner v1`

### 실제 반영한 범위

- current repo의 [`rule/rules/instruction-model.md`](../../rule/rules/instruction-model.md), [`rule/rules/rule-maintenance.md`](../../rule/rules/rule-maintenance.md), [`rule/rules/documentation-boundaries.md`](../../rule/rules/documentation-boundaries.md), [`rule/rules/readme-maintenance.md`](../../rule/rules/readme-maintenance.md), [`rule/rules/language-policy.md`](../../rule/rules/language-policy.md)에 링크형 참조 원칙과 예외를 더 명시적으로 보강했다.
- current repo의 root [`README.md`](../../README.md)와 [`README.ko.md`](../../README.ko.md)에 실제 진입점/제어문서 참조는 링크, placeholder/wildcard/미생성 경로는 literal로 둔다는 기준을 추가했다.
- `hs-init-project/assets/rule/` 아래 대응 템플릿들에 같은 정책을 반영해 fresh mode source-of-truth를 정렬했다.
- [`hs-init-project/assets/README/root.en.md`](../../hs-init-project/assets/README/root.en.md)와 [`hs-init-project/assets/README/root.ko.md`](../../hs-init-project/assets/README/root.ko.md)에 README-level 링크 정책 문구를 추가했다.
- [`hs-init-project/references/structure-initialization.md`](../../hs-init-project/references/structure-initialization.md)에 rule system 요구사항으로 같은 기준을 보강했다.
- existing-project mode에서 직접 root README를 생성하는 [`hs-init-project/scripts/materialize_repo.sh`](../../hs-init-project/scripts/materialize_repo.sh)에 같은 정책 문구를 추가해 asset-based fresh output과 script-generated existing output이 일치하도록 맞췄다.

### 변경 파일 목록

- `README.md`
- `README.ko.md`
- `rule/rules/instruction-model.md`
- `rule/rules/rule-maintenance.md`
- `rule/rules/documentation-boundaries.md`
- `rule/rules/readme-maintenance.md`
- `rule/rules/language-policy.md`
- `hs-init-project/assets/README/root.en.md`
- `hs-init-project/assets/README/root.ko.md`
- `hs-init-project/assets/rule/instruction-model.en.md`
- `hs-init-project/assets/rule/instruction-model.ko.md`
- `hs-init-project/assets/rule/rule-maintenance.en.md`
- `hs-init-project/assets/rule/rule-maintenance.ko.md`
- `hs-init-project/assets/rule/documentation-boundaries.en.md`
- `hs-init-project/assets/rule/documentation-boundaries.ko.md`
- `hs-init-project/assets/rule/readme-maintenance.en.md`
- `hs-init-project/assets/rule/readme-maintenance.ko.md`
- `hs-init-project/assets/rule/language-policy.en.md`
- `hs-init-project/assets/rule/language-policy.ko.md`
- `hs-init-project/references/structure-initialization.md`
- `hs-init-project/scripts/materialize_repo.sh`

### 검증에 사용한 workspace/baseline scope

- generator baseline은 cycle 29가 남긴 dirty worktree를 그대로 존중한 상태였다.
- baseline에는 cycle 29에서 수정된 navigation 관련 문서/템플릿/스크립트 diff와 `subagents_docs/cycles/29-link-based-rule-navigation.md`가 포함돼 있었다.
- 이번 cycle 판단은 그 baseline 위에 추가된 cycle 30 변경만 기준으로 기록했다.

### 검증 명령

- `git diff --check`
- `sh -n hs-init-project/scripts/materialize_repo.sh`
- fresh materialize smoke
```sh
tmpdir=$(mktemp -d)
sh hs-init-project/scripts/materialize_repo.sh "$tmpdir" --language en >/dev/null
rg -n --fixed-strings 'Use Markdown links in this README when pointing to real entrypoint or control documents.' "$tmpdir/README.md"
rg -n --fixed-strings 'Apply this rule consistently across current-repository docs, generated-repository docs, and the template or script source-of-truth that produces them.' "$tmpdir/rule/rules/instruction-model.md"
rg -n --fixed-strings 'Prefer Markdown links for real entrypoint or control-document references, and leave placeholder or example paths as plain literals.' "$tmpdir/rule/rules/language-policy.md"
rm -rf "$tmpdir"
```
- existing-project materialize smoke
```sh
tmpdir=$(mktemp -d)
mkdir -p "$tmpdir/src"
sh hs-init-project/scripts/materialize_repo.sh "$tmpdir" --language ko --readme-mode existing --source-root-dir src >/dev/null
rg -n --fixed-strings '실제 진입점 문서나 제어문서를 가리킬 때는 Markdown 링크를 사용하고, placeholder나 아직 생성되지 않은 경로는 path literal로 남긴다.' "$tmpdir/README.md"
rg -n --fixed-strings '이 기준은 current repo 문서, generated repository 문서, 그리고 이를 만드는 template/script source-of-truth에 함께 적용한다.' "$tmpdir/rule/rules/instruction-model.md"
rg -n --fixed-strings '실제로 열 수 있는 진입점 문서와 제어문서 참조는 Markdown 링크를 우선하고, placeholder/example path는 path literal로 남긴다.' "$tmpdir/rule/rules/language-policy.md"
rm -rf "$tmpdir"
```

### 검증 결과

- whitespace/diff check가 통과했다.
- `materialize_repo.sh` shell syntax check가 통과했다.
- fresh mode 생성물의 root README, `instruction-model.md`, `language-policy.md`에서 새 링크 정책 문구가 실제 생성되는 것을 확인했다.
- existing-project mode 생성물의 root README, `instruction-model.md`, `language-policy.md`에서도 같은 정책이 실제 생성되는 것을 확인했다.

### 남은 위험과 제약

- 이번 cycle은 링크 정책을 “실제 진입점/제어문서 참조”에만 강제하고, wildcard/placeholder/example path는 intentionally non-link로 유지했다.
- cycle 29에서 이미 반영된 링크 네비게이션 diff는 baseline으로 존중했기 때문에, 이번 cycle 문서는 그 위에 얹힌 policy hardening 범위만 다룬다.
- 모든 문서의 모든 file/path literal을 기계적으로 링크화하지는 않았다.

### 다음 handoff

- evaluator는 `Planner v1`과 `Generator v1` 기준으로 current repo rule 문서, current repo README, fresh/existing generated output에서 link-reference policy가 일관되게 반영됐는지 점검한다.
- evaluator는 cycle 29 baseline diff와 cycle 30 추가 diff를 구분해 cycle-owned acceptance만 판정한다.

## Evaluator v1

### 판정

- PASS

### planner section reference

- `Planner v1`

### generator section reference

- `Generator v1`

### acceptance criteria 판정

- 충족. current repo의 [`rule/rules/instruction-model.md`](../../rule/rules/instruction-model.md), [`rule/rules/rule-maintenance.md`](../../rule/rules/rule-maintenance.md), [`rule/rules/documentation-boundaries.md`](../../rule/rules/documentation-boundaries.md), [`rule/rules/readme-maintenance.md`](../../rule/rules/readme-maintenance.md), [`rule/rules/language-policy.md`](../../rule/rules/language-policy.md)에 “실제 entrypoint/control-document 참조는 Markdown 링크 우선, placeholder/example은 non-link” 정책이 명시돼 있다.
- 충족. current repo의 핵심 rule 문서들은 서로 링크형 참조 기준으로 정렬돼 있고, [`rule/index.md`](../../rule/index.md)는 실제 rule `Path`를 링크로 유지하면서 placeholder local rule entry는 literal로 유지한다.
- 충족. current repo의 대표 entrypoint/control-document 문서인 [`AGENTS.md`](../../AGENTS.md), [`README.md`](../../README.md), [`README.ko.md`](../../README.ko.md), [`docs/guide/README.md`](../../docs/guide/README.md), [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md), [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md)가 링크형 참조를 유지한다.
- 충족. `hs-init-project/assets/`의 대응 rule/README 템플릿과 starter skill 템플릿이 같은 정책을 반영한다.
- 충족. [`hs-init-project/scripts/materialize_repo.sh`](../../hs-init-project/scripts/materialize_repo.sh)는 fresh mode와 existing-project mode 생성물에서 동일한 링크형 참조 정책 문구를 내보낸다.
- 충족. cycle 29에서 intentional non-link 예외로 둔 local placeholder `Path`는 current repo, template, fresh/existing generated output 모두에서 literal로 유지돼 broken link를 만들지 않는다.
- 충족. `git diff --check`, `sh -n hs-init-project/scripts/materialize_repo.sh`, fresh/existing materialize smoke로 current repo와 generated output 반영이 직접 확인됐다.

### 실제 검증 절차

- `git diff --check`
- `sh -n hs-init-project/scripts/materialize_repo.sh`
- `sed -n '1,220p' rule/rules/instruction-model.md`
- `sed -n '1,220p' rule/rules/rule-maintenance.md`
- `sed -n '1,220p' rule/rules/documentation-boundaries.md`
- `sed -n '1,220p' rule/rules/readme-maintenance.md`
- `sed -n '1,220p' rule/rules/language-policy.md`
- `sed -n '1,220p' README.md`
- `sed -n '1,220p' README.ko.md`
- `sed -n '1,120p' AGENTS.md`
- `sed -n '1,120p' docs/guide/README.md`
- `sed -n '1,120p' docs/implementation/AGENTS.md`
- `sed -n '1,120p' subagents_docs/AGENTS.md`
- `rg -n --fixed-strings -- '- Path: \`rule/rules/[local-rule-file].md\`' rule/index.md hs-init-project/assets/rule/index.en.md hs-init-project/assets/rule/index.ko.md`
- fresh materialize smoke
```sh
tmpdir=$(mktemp -d)
sh hs-init-project/scripts/materialize_repo.sh "$tmpdir" --language en >/dev/null
rg -n --fixed-strings 'Use Markdown links in this README when pointing to real entrypoint or control documents.' "$tmpdir/README.md"
rg -n --fixed-strings 'Apply this rule consistently across current-repository docs, generated-repository docs, and the template or script source-of-truth that produces them.' "$tmpdir/rule/rules/instruction-model.md"
rg -n --fixed-strings 'Prefer Markdown links for real entrypoint or control-document references, and leave placeholder or example paths as plain literals.' "$tmpdir/rule/rules/language-policy.md"
rg -n --fixed-strings -- '- Path: `rule/rules/[local-rule-file].md`' "$tmpdir/rule/index.md"
rm -rf "$tmpdir"
```
- existing-project materialize smoke
```sh
tmpdir=$(mktemp -d)
mkdir -p "$tmpdir/src"
sh hs-init-project/scripts/materialize_repo.sh "$tmpdir" --language ko --readme-mode existing --source-root-dir src >/dev/null
rg -n --fixed-strings '실제 진입점 문서나 제어문서를 가리킬 때는 Markdown 링크를 사용하고, placeholder나 아직 생성되지 않은 경로는 path literal로 남긴다.' "$tmpdir/README.md"
rg -n --fixed-strings '이 기준은 current repo 문서, generated repository 문서, 그리고 이를 만드는 template/script source-of-truth에 함께 적용한다.' "$tmpdir/rule/rules/instruction-model.md"
rg -n --fixed-strings '실제로 열 수 있는 진입점 문서와 제어문서 참조는 Markdown 링크를 우선하고, placeholder/example path는 path literal로 남긴다.' "$tmpdir/rule/rules/language-policy.md"
rg -n --fixed-strings -- '- Path: `rule/rules/[local-rule-file].md`' "$tmpdir/rule/index.md"
rm -rf "$tmpdir"
```

### dirty worktree 비교 기준

- evaluator 시점 worktree는 cycle 29가 남긴 링크 네비게이션 변경 위에 cycle 30의 policy hardening diff가 누적된 상태였다.
- cycle 29 baseline에는 current repo navigation 문서, `hs-init-project` template, `materialize_repo.sh`, 그리고 `subagents_docs/cycles/29-link-based-rule-navigation.md`가 포함돼 있었다.
- cycle 30 판정은 그 baseline 이후 추가된 rule policy 문구, README policy 문구, 대응 template/source-of-truth 확장, 그리고 `subagents_docs/cycles/30-link-reference-policy.md`만 기준으로 내렸다.
- unrelated tracked diff는 관찰하지 않았고, untracked cycle 문서는 `subagents_docs/cycles/29-link-based-rule-navigation.md`, `subagents_docs/cycles/30-link-reference-policy.md`였다.

### 관찰 결과

- 링크형 참조 정책이 기존 rule 체계 안에 자연스럽게 편입돼 이후 유지 기준이 명시됐다.
- current repo의 대표 entrypoint/control-document 문서와 generated source-of-truth가 같은 정책으로 정렬돼 drift 가능성이 낮아졌다.
- placeholder/example/nonexistent path는 의도적으로 non-link로 유지돼 링크 소음과 broken link를 피했다.

### 문제 목록

- 없음.

### 품질 평가

- Design quality: 4/5. 기존 rule 문서를 확장하는 방식으로 정책을 넣어 구조를 늘리지 않고 유지보수성을 높였다.
- Originality: 3/5. 정책 hardening 작업이라 보수적이지만 current repo와 generated output을 함께 묶어 일관성을 강화했다.
- Completeness: 5/5. current repo, template source-of-truth, existing-project direct generation path, placeholder 예외까지 함께 반영했다.
- Functionality: 5/5. representative current docs와 fresh/existing generated outputs에서 정책 문구와 non-link 예외를 직접 확인했다.

### 다음 handoff

- complete
