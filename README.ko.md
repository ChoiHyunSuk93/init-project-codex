# hschoi-init-project

[English](README.md) | [한국어](README.ko.md)

`hschoi-init-project`는 저장소에 Codex 지향 작업 구조를 초기화하거나 덧붙이는 오픈소스 Codex 스킬입니다.

## 목적

이 스킬은 두 가지 경우를 대상으로 합니다.

1. 거의 비어 있는 저장소를 초기화하는 경우
2. 기존 프로젝트 파일을 임의로 재구성하지 않고 Codex 작업 구조를 추가하는 경우

기본적으로 아래의 작은 기준 구조를 만듭니다.

- root `AGENTS.md`
- `rule/index.md`와 `rule/rules/*.md` 규칙 문서를 포함한 root `rule/`
- `docs/guide/README.md`
- `docs/implementation/AGENTS.md`
- 언어 인식 문서 생성

## 저장소 구조

- `hschoi-init-project/SKILL.md`: 스킬 동작과 워크플로
- `hschoi-init-project/agents/openai.yaml`: 스킬 메타데이터
- `hschoi-init-project/references/`: 스킬을 보조하는 상세 규칙 문서
- `hschoi-init-project/assets/`: 스킬 내부 템플릿
- `hschoi-init-project/scripts/`: 결정론적 helper 스크립트

## 설치

내장 `skill-installer` helper로 설치합니다.
이후 업데이트를 안정적으로 하려면 `main` 대신 태그 릴리스를 기준으로 설치하는 편이 좋습니다.
현재 최신 공개 릴리스는 `v0.1.3`입니다.

### 프로젝트 스코프 설치 (권장)

현재 프로젝트에서만 이 스킬을 쓰고 싶을 때 사용합니다.
`<project-root>/.codex/skills/` 아래에 설치합니다.

Codex에서 설치:

```text
$skill-installer
GitHub repo ChoiHyunSuk93/init-project-codex 의 hschoi-init-project 경로에 있는 스킬을 릴리스 태그 vX.Y.Z 기준으로 <project-root>/.codex/skills 에 설치해줘.
```

직접 installer 스크립트를 실행하는 방법:

```bash
TAG=vX.Y.Z
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

mkdir -p .codex/skills

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo ChoiHyunSuk93/init-project-codex \
  --path hschoi-init-project \
  --ref "$TAG" \
  --dest "$PWD/.codex/skills"
```

설치 결과는 아래와 같습니다.

```text
<project-root>/.codex/skills/hschoi-init-project/
```

### 전역 설치

여러 저장소에서 공통으로 쓰고 싶을 때 사용합니다.

Codex에서 설치:

```text
$skill-installer
GitHub repo ChoiHyunSuk93/init-project-codex 의 hschoi-init-project 경로에 있는 스킬을 릴리스 태그 vX.Y.Z 기준으로 설치해줘.
```

직접 installer 스크립트를 실행하는 방법:

```bash
TAG=vX.Y.Z
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo ChoiHyunSuk93/init-project-codex \
  --path hschoi-init-project \
  --ref "$TAG"
```

URL로도 설치할 수 있습니다.

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --url https://github.com/ChoiHyunSuk93/init-project-codex/tree/vX.Y.Z/hschoi-init-project
```

Codex가 이미 실행 중이면 설치 후 재시작해야 새 스킬이 인식됩니다.

### 기존 설치 업데이트

번들된 updater 스크립트로 현재 설치 디렉터리를 제자리에서 교체할 수 있습니다.
`--ref latest`는 `main`이 아니라 GitHub의 최신 릴리스 태그를 해석합니다.
이미 설치된 복사본이 이 updater 추가 이전 버전이라면, 태그 릴리스로 한 번 재설치한 뒤부터 updater를 사용할 수 있습니다.

프로젝트 스코프 설치:

```bash
python3 ./.codex/skills/hschoi-init-project/scripts/update-skill-release.py --ref latest
python3 ./.codex/skills/hschoi-init-project/scripts/update-skill-release.py --ref vX.Y.Z
```

전역 설치:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/hschoi-init-project/scripts/update-skill-release.py" --ref latest
python3 "$CODEX_HOME/skills/hschoi-init-project/scripts/update-skill-release.py" --ref vX.Y.Z
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
docs/
  guide/
    README.md
    [추가 guide 문서]       # 기존 프로젝트 모드에서 실제 사용자 워크플로가 확인될 때 생성
  implementation/
    AGENTS.md
```

- `AGENTS.md`: 저장소 전역의 얇은 Codex 지침
- root `README.md`: 사람이 읽는 대표 요약 문서
- `rule/`: `rule/index.md`를 인덱스로 두고 `rule/rules/*.md`에 상세 규칙을 두는 Codex 실행 기준 문서
- `docs/guide/`: 사람이 읽는 안내와 탐색 문서
- `docs/implementation/`: 구현 기록 배치 규칙과 이후 구현 기록 카테고리 공간
- 기존 프로젝트 모드에서는 실제 사용자 워크플로가 확인될 때만 추가 guide 문서를 생성합니다.

## 사용법

저장소 구조를 Codex 기준으로 초기화하거나 retrofit하고 싶을 때 이 스킬을 사용합니다.
명령만 호출해도 진행되며, 필요하면 아주 짧은 요청을 덧붙이면 됩니다.

예시:

```text
$hschoi-init-project
```

```text
이 저장소 초기 프로젝트 구성해줘.
```

요청에서 사용할 언어를 먼저 판단할 수 없으면 초기화를 시작하기 전에 언어를 먼저 확인합니다.
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
