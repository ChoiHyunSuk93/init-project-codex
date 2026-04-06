# hs-init-project

[English](README.md) | [한국어](README.ko.md)

`hs-init-project`는 저장소에 Codex 지향 작업 구조를 초기화하거나 덧붙이는 오픈소스 Codex 스킬입니다.

## 목적

이 스킬은 두 가지 경우를 대상으로 합니다.

1. 거의 비어 있는 저장소를 초기화하는 경우
2. 기존 프로젝트 파일을 임의로 재구성하지 않고 Codex 작업 구조를 추가하는 경우

기본적으로 아래의 작은 기준 구조를 만듭니다.

- root [`AGENTS.md`](AGENTS.md)
- [`rule/index.md`](rule/index.md)와 `rule/rules/*.md` 규칙 문서를 포함한 root `rule/`
- planner / generator / evaluator 작업 문서를 위한 [`subagents_docs/AGENTS.md`](subagents_docs/AGENTS.md)와 `subagents_docs/`
- [`docs/guide/README.md`](docs/guide/README.md)
- [`docs/implementation/AGENTS.md`](docs/implementation/AGENTS.md)와 사용자-facing 최종 브리핑
- 언어 인식 문서 생성

## 저장소 구조

- [`hs-init-project/SKILL.md`](hs-init-project/SKILL.md): 스킬 동작과 워크플로
- [`hs-init-project/agents/openai.yaml`](hs-init-project/agents/openai.yaml): 스킬 메타데이터
- [`hs-init-project/references/`](hs-init-project/references/): 스킬을 보조하는 상세 규칙 문서
- [`hs-init-project/assets/`](hs-init-project/assets/): 스킬 내부 템플릿
- [`hs-init-project/scripts/`](hs-init-project/scripts/): 결정론적 helper 스크립트

이 README가 실제 진입점 문서나 제어문서를 가리킬 때는 Markdown 링크를 사용한다.
placeholder, wildcard, 아직 생성되지 않은 경로는 path literal로 남긴다.

## 설치

내장 `skill-installer` helper로 설치합니다.
이후 업데이트를 안정적으로 하려면 `main` 대신 태그 릴리스를 기준으로 설치하는 편이 좋습니다.
direct installer 스크립트는 `--ref latest`를 지원하며, 설치 시 저장소의 최신 버전 태그를 해석합니다.

### 프로젝트 스코프 설치 (권장)

현재 프로젝트에서만 이 스킬을 쓰고 싶을 때 사용합니다.
`<project-root>/.codex/skills/` 아래에 설치합니다.

Codex에서 설치:

```text
$skill-installer
GitHub repo ChoiHyunSuk93/init-project-codex 의 hs-init-project 경로에 있는 스킬을 최신 버전으로 <project-root>/.codex/skills 에 설치해줘.
```

직접 installer 스크립트를 실행하는 방법:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

mkdir -p .codex/skills

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo ChoiHyunSuk93/init-project-codex \
  --path hs-init-project \
  --ref latest \
  --dest "$PWD/.codex/skills"
```

특정 릴리스를 고정하고 싶다면 `latest` 대신 `vX.Y.Z` 같은 태그를 넣으면 됩니다.

설치 결과는 아래와 같습니다.

```text
<project-root>/.codex/skills/hs-init-project/
```

### 전역 설치

여러 저장소에서 공통으로 쓰고 싶을 때 사용합니다.

Codex에서 설치:

```text
$skill-installer
GitHub repo ChoiHyunSuk93/init-project-codex 의 hs-init-project 경로에 있는 스킬을 최신 버전으로 설치해줘.
```

직접 installer 스크립트를 실행하는 방법:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo ChoiHyunSuk93/init-project-codex \
  --path hs-init-project \
  --ref latest
```

URL로도 설치할 수 있습니다.

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --url https://github.com/ChoiHyunSuk93/init-project-codex/tree/latest/hs-init-project
```

Codex가 이미 실행 중이면 설치 후 재시작해야 새 스킬이 인식됩니다.

### 기존 설치 업데이트

번들된 updater 스크립트로 현재 설치 디렉터리를 제자리에서 교체할 수 있습니다.
updater의 `--ref latest`는 `main`이 아니라 GitHub의 최신 릴리스 태그를 해석합니다.
이 의미는 direct installer의 `--ref latest`가 저장소의 최신 버전 태그를 해석하는 것과 다릅니다.
이미 설치된 복사본이 이 updater 추가 이전 버전이라면, 태그 릴리스로 한 번 재설치한 뒤부터 updater를 사용할 수 있습니다.

프로젝트 스코프 설치:

```bash
python3 ./.codex/skills/hs-init-project/scripts/update-skill-release.py --ref latest
python3 ./.codex/skills/hs-init-project/scripts/update-skill-release.py --ref vX.Y.Z
```

전역 설치:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/hs-init-project/scripts/update-skill-release.py" --ref latest
python3 "$CODEX_HOME/skills/hs-init-project/scripts/update-skill-release.py" --ref vX.Y.Z
```

Updater는 설치 소스 정보를 기록하므로, 이후 업데이트도 같은 repo/path 기준으로 이어갈 수 있습니다. Codex가 이미 실행 중이면 업데이트 후 재시작하세요.

### 유지보수자 릴리스 절차

의도한 릴리스에 맞는 다음 semantic version 태그를 푸시합니다.

```bash
git tag vX.Y.Z
git push origin vX.Y.Z
```

저장소에는 `.github/workflows/release.yml`이 포함되어 있으며, `v*` 태그에 대해 스킬 번들을 검증하고 GitHub Release를 생성합니다.
`--ref latest` 경로가 정상적으로 동작하려면 GitHub 릴리스 태그가 최소 하나는 있어야 합니다.
상세 버전 관리 기준은 [CONTRIBUTING.md](CONTRIBUTING.md)에 둡니다.

## 생성 구조

이 스킬은 기본적으로 아래 구조를 생성하거나 갱신합니다.

```text
AGENTS.md
README.md
.codex/
  config.toml
  agents/
    planner.toml
    generator.toml
    evaluator.toml
  skills/
    change-analysis/
      SKILL.md
      agents/
        openai.yaml
    code-implementation/
      SKILL.md
      agents/
        openai.yaml
    test-debug/
      SKILL.md
      agents/
        openai.yaml
    docs-sync/
      SKILL.md
      agents/
        openai.yaml
    quality-review/
      SKILL.md
      agents/
        openai.yaml
rule/
  index.md
  rules/
    project-structure.md         # 최상위 구조와 디렉토리 역할
    instruction-model.md         # 권한 순서, thin root, 중복 금지 원칙
    rule-maintenance.md          # rule 문서 수명주기와 rule index 정합성 유지
    documentation-boundaries.md  # rule, guide, implementation 문서 경계
    readme-maintenance.md        # root README 작성 및 유지 규칙
    development-standards.md     # 기본 구현 품질과 관례 규칙
    testing-standards.md         # 테스트 계층 선택과 검증 기대치
    runtime-boundaries.md        # runtime과 non-runtime 경계 규칙
    implementation-records.md    # 구현 기록 배치와 이름 규칙
    subagent-orchestration.md    # planner/generator/evaluator 경계와 반복 규칙
    subagents-docs.md            # subagents_docs 작업 문서 소유권 규칙
subagents_docs/
  AGENTS.md
  cycles/
    [NN-plan-slug].md
docs/
  guide/
    README.md
    [추가 guide 문서]       # 기존 프로젝트 모드에서 실제 사용자 워크플로가 확인될 때 생성
  implementation/
    AGENTS.md
    [category]/
      [짧은 최종 사이클 브리핑]
```

- [`AGENTS.md`](AGENTS.md): 저장소 전역의 얇은 Codex 지침
- root [`README.md`](README.md): 사람이 읽는 대표 요약 문서
- `.codex/config.toml`: `.codex/agents/*.toml`과 함께 생성되는 프로젝트 스코프 agent 런타임 설정
- `.codex/agents/`: 프로젝트 스코프 planner / generator / evaluator 정의
- `.codex/skills/`: 변경 분석, 구현, 테스트/디버깅, 문서 동기화, 품질 검토 같은 일반적인 개발 절차를 위한 starter local skill 세트
- `rule/`: [`rule/index.md`](rule/index.md)를 인덱스로 두고 `rule/rules/*.md`에 상세 규칙을 두는 Codex 실행 기준 문서
- `subagents_docs/`: planner, generator, evaluator가 읽고 쓰는 작업 문서이며, [`subagents_docs/AGENTS.md`](subagents_docs/AGENTS.md)를 제어 파일로 두고 신규 plan cycle은 `subagents_docs/cycles/` 아래의 append-only 단일 문서로 관리
- `docs/guide/`: 사람이 읽는 안내와 탐색 문서이며 기본 진입점은 [`docs/guide/README.md`](docs/guide/README.md)다
- `docs/implementation/`: plan cycle이 통과된 뒤 관심사 카테고리 안에 남기는 사용자-facing 짧은 최종 브리핑 문서이며 배치 기준은 [`docs/implementation/AGENTS.md`](docs/implementation/AGENTS.md)다
- 기존 프로젝트 모드에서는 실제 사용자 워크플로가 확인될 때만 추가 guide 문서를 생성합니다.

생성된 저장소는 기본 구조 자체로 각 plan을 `planner -> generator -> evaluator` 순서로 실행합니다. 메인 에이전트는 orchestration-only 역할로 남아 이 세 역할의 순서를 조정하고 handoff를 모으기만 하며, 사용자가 역할 분리를 명시적으로 풀지 않는 한 planner/generator/evaluator를 직접 겸하지 않습니다. 신규 작업은 plan마다 `subagents_docs/cycles/` 아래의 append-only 단일 문서로 관리하고, 문서 상단에는 `Status`, `Current Plan Version`, `Next Handoff`를 두며, 본문에는 `Planner vN` / `Generator vN` / `Evaluator vN` 섹션을 순서대로 쌓습니다. evaluator는 generator가 만든 구현 결과를 plan과 acceptance criteria에 대조해 평가하고, 그 구현 결과에서 실패나 blocker를 확인했을 때만 planner가 재계획합니다. 서로 독립인 계획은 병렬로, 의존성이 있는 계획은 순차로 진행합니다. `subagents_docs/` 작업 문서는 선택된 언어를 따르며, 생성된 저장소에는 `.codex/config.toml`, `.codex/agents/*.toml`, 그리고 `.codex/skills/` 아래의 개발 절차 중심 starter local skill 세트가 함께 포함됩니다. 기존 프로젝트 모드에서는 inspect 결과를 바탕으로 starter skill과 일부 README/rule/guide 산출물이 관찰된 runtime, test, docs 신호를 반영해 더 구체적으로 생성됩니다. subagent 응답이 느려도 coordinator는 직접 구현하지 않고 기다리거나 재계획합니다.

## 사용법

저장소 구조를 Codex 기준으로 초기화하거나 retrofit하고 싶을 때 이 스킬을 사용합니다.
명령만 호출해도 진행되며, 필요하면 아주 짧은 요청을 덧붙이면 됩니다.

예시:

```text
$hs-init-project
```

```text
이 저장소 초기 프로젝트 구성해줘.
```

요청이나 session에 사용할 언어가 이미 고정되어 있지 않으면 초기화를 시작하기 전에 plain text로 언어를 먼저 확인합니다.
언어가 정해진 뒤에 이 저장소를 신규 초기화로 다룰지 기존 프로젝트 retrofit으로 다룰지 결정합니다.

## 개발

이 저장소는 샘플 애플리케이션이 아니라 스킬 자체를 개발하는 저장소입니다.

스킬을 수정할 때:

- `SKILL.md`는 얇게 유지합니다.
- 안정적인 상세 내용은 `references/`로 옮깁니다.
- 재사용 가능한 템플릿은 `assets/`에 둡니다.
- 반복되는 출력이 안정되면 `scripts/`를 통한 결정론적 생성을 우선합니다.
- 릴리스 태그 기반 설치와 업데이트 안내도 함께 최신 상태로 유지합니다.

## 기여

기여는 환영합니다. 브랜치와 PR 규칙은 [CONTRIBUTING.md](CONTRIBUTING.md)를 참고하세요.

## 라이선스

이 프로젝트는 MIT License를 따릅니다. 자세한 내용은 [LICENSE](LICENSE)를 참고하세요.
