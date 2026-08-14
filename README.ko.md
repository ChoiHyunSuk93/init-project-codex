# hs-init-project

[English](README.md) | [한국어](README.ko.md)

`hs-init-project`는 신규 또는 기존 저장소에 에이전트 제품 간에 공유할 수 있는 최소 프로젝트 규약을 추가하는 오픈소스 Codex 스킬입니다.

## 목적

생성하는 기준 구조는 작고 제품 중립적으로 유지합니다.

- 공통 에이전트 진입점인 root [`AGENTS.md`](AGENTS.md)
- Claude Code용 선택적 root `CLAUDE.md`
- 프로젝트 목적, 제약, 미결 사항을 위한 root [`PROJECT_OVERVIEW.md`](PROJECT_OVERVIEW.md)
- [`rule/index.md`](rule/index.md)와 구조, 개발, 테스트, 문서, 에이전트 워크플로에 집중한 다섯 규칙
- 영어 또는 한국어 문서 생성

기본 구조에는 프로젝트 스코프 custom agent, starter skill, `.codex/config.toml`, 빈 `subagents_docs/` 및 `docs/` 작업 기록 계층을 만들지 않습니다. 대상 프로젝트에 구체적인 필요가 생겼을 때만 별도로 추가합니다.

## 저장소 구조

- [`hs-init-project/SKILL.md`](hs-init-project/SKILL.md): 스킬 동작과 워크플로
- [`hs-init-project/agents/openai.yaml`](hs-init-project/agents/openai.yaml): 스킬 메타데이터
- [`hs-init-project/references/`](hs-init-project/references/): 상세 보조 지침
- [`hs-init-project/assets/`](hs-init-project/assets/): 생성 파일 템플릿
- [`hs-init-project/scripts/`](hs-init-project/scripts/): 결정론적 materialize, update, validation helper

## 설치

direct `skill-installer` 스크립트는 `--ref` 값을 그대로 사용하며 `latest`를 특별하게 해석하지 않습니다. 아래 예시는 최소 cross-agent 하네스가 포함된 `v1.0.0` 릴리스를 고정합니다.

### 프로젝트 스코프 설치 (권장)

Codex의 canonical 프로젝트 스킬 경로는 `<project-root>/.agents/skills/`입니다.

Codex에서는 태그를 명시해 요청합니다.

```text
$skill-installer
GitHub 저장소 ChoiHyunSuk93/init-project-codex의 hs-init-project를 v1.0.0 태그로 <project-root>/.agents/skills에 설치해줘.
```

직접 installer 스크립트를 실행하는 방법:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

mkdir -p .agents/skills

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo ChoiHyunSuk93/init-project-codex \
  --path hs-init-project \
  --ref v1.0.0 \
  --dest "$PWD/.agents/skills"
```

설치 결과는 `<project-root>/.agents/skills/hs-init-project/`입니다. 다른 버전이 필요하면 `v1.0.0`을 실제로 존재하는 릴리스 태그로 바꾸세요.

### 전역 설치

`--dest`를 생략하면 installer의 전역 Codex skill 디렉터리에 설치합니다.

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo ChoiHyunSuk93/init-project-codex \
  --path hs-init-project \
  --ref v1.0.0
```

태그를 명시한 URL로도 설치할 수 있습니다.

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --url https://github.com/ChoiHyunSuk93/init-project-codex/tree/v1.0.0/hs-init-project
```

Codex가 이미 실행 중이면 설치 후 재시작해야 새 스킬을 인식합니다.

### 기존 설치 업데이트

번들 updater는 direct installer와 달리 의도적으로 `--ref latest`를 지원하며, 이를 최신 GitHub Release 태그로 해석합니다.

프로젝트 스코프 설치:

```bash
python3 ./.agents/skills/hs-init-project/scripts/update-skill-release.py --ref latest
python3 ./.agents/skills/hs-init-project/scripts/update-skill-release.py --ref vX.Y.Z
```

전역 설치:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/hs-init-project/scripts/update-skill-release.py" --ref latest
python3 "$CODEX_HOME/skills/hs-init-project/scripts/update-skill-release.py" --ref vX.Y.Z
```

설치된 복사본이 updater 추가 이전 버전이라면 명시적 태그로 한 번 재설치하세요. Codex가 이미 실행 중이면 업데이트 후 재시작합니다.

### 유지보수자 릴리스 절차

의도한 릴리스의 다음 semantic version 태그를 푸시합니다.

```bash
git tag vX.Y.Z
git push origin vX.Y.Z
```

저장소의 release workflow는 `v*` 태그에서 스킬 번들을 검증하고 GitHub Release를 생성합니다. 상세 버전 관리 기준은 [CONTRIBUTING.md](CONTRIBUTING.md)를 참고하세요.

## 생성 구조

정확한 진입점은 `--target`에 따라 달라지며, 공통 기준 구조는 다음과 같습니다.

```text
AGENTS.md
CLAUDE.md                         # target이 claude 또는 both일 때만 생성
README.md                         # --readme-mode로 제어
PROJECT_OVERVIEW.md
rule/
  index.md
  rules/
    project-structure.md
    development-standards.md
    testing-standards.md
    documentation.md
    agent-workflow.md
```

- `AGENTS.md`는 에이전트가 공통 규약과 rule index를 찾도록 안내합니다.
- `CLAUDE.md`는 `AGENTS.md`를 import하며 Claude Code 전용 routing만 둡니다.
- `PROJECT_OVERVIEW.md`는 stack이나 제품 결정을 추측하지 않고 지속적인 프로젝트 맥락을 기록합니다.
- `rule/index.md`는 다섯 규칙의 authoritative 탐색 진입점입니다.

## 사용법

대화형으로 스킬을 호출할 수 있습니다.

```text
$hs-init-project
```

결정론적 또는 자동화된 materialize에는 helper의 명시적 계약을 사용합니다.

```bash
sh hs-init-project/scripts/materialize_repo.sh \
  --root . \
  --language ko \
  --target both \
  --project-mode existing \
  --readme-mode preserve \
  --dry-run
```

계획된 출력을 검토한 뒤 `--dry-run`을 제거합니다.

- `--target codex|claude|both`는 하나의 공통 규칙 세트를 유지하면서 제품별 진입점을 선택합니다.
- `--project-mode fresh|existing`은 새 저장소 초기화와 안전한 additive retrofit을 구분합니다.
- `--readme-mode create|merge|preserve`는 README 생성, 관리 구역만 갱신, 기존 README 유지 중 하나를 선택합니다.
- `--language en|ko`는 생성 문서의 언어를 선택합니다.

## 개발

이 저장소는 샘플 애플리케이션이 아니라 스킬 자체를 개발합니다. `SKILL.md`는 간결하게, 안정적인 상세 내용은 `references/`에, 재사용 출력 템플릿은 `assets/`에, 결정론적 동작은 `scripts/`에 둡니다. 설치 및 생성 구조 문서를 릴리스 동작과 정렬된 상태로 유지합니다.

## 기여

기여는 환영합니다. 브랜치와 PR 규칙은 [CONTRIBUTING.md](CONTRIBUTING.md)를 참고하세요.

## 라이선스

이 프로젝트는 MIT License를 따릅니다. 자세한 내용은 [LICENSE](LICENSE)를 참고하세요.
