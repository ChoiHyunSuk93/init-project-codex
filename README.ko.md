# hschoi-init-project

[English](README.md) | [한국어](README.ko.md)

`hschoi-init-project`는 저장소에 Codex 지향 작업 구조를 초기화하거나 덧붙이는 오픈소스 Codex 스킬입니다.

## 목적

이 스킬은 두 가지 경우를 대상으로 합니다.

1. 거의 비어 있는 저장소를 초기화하는 경우
2. 기존 프로젝트 파일을 임의로 재구성하지 않고 Codex 작업 구조를 추가하는 경우

기본적으로 아래의 작은 기준 구조를 만듭니다.

- root `AGENTS.md`
- `rule/index.md`와 starter rule 문서를 포함한 root `rule/`
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

Codex에서 `skill-installer`를 사용해 설치합니다.

```text
$skill-installer
Install the skill from GitHub repo ChoiHyunSuk93/init-project-codex path hschoi-init-project.
```

필요하면 installer 스크립트를 직접 실행할 수도 있습니다.

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo ChoiHyunSuk93/init-project-codex \
  --path hschoi-init-project \
  --ref main
```

URL로도 설치할 수 있습니다.

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --url https://github.com/ChoiHyunSuk93/init-project-codex/tree/main/hschoi-init-project
```

설치 후에는 Codex를 재시작해야 새 스킬이 인식됩니다.

## 사용법

저장소 구조를 Codex 기준으로 초기화하거나 retrofit하고 싶을 때 이 스킬을 사용합니다.

예시:

```text
$hschoi-init-project
```

```text
Initialize this repository for Codex with a root AGENTS.md, rule/, docs/guide, and docs/implementation.
```

언어가 아직 정해지지 않았으면 먼저 언어를 묻고, 그 다음 이 저장소를 신규 초기화로 다룰지 기존 프로젝트 retrofit으로 다룰지 결정합니다.

## 개발

이 저장소는 샘플 애플리케이션이 아니라 스킬 자체를 개발하는 저장소입니다.

스킬을 수정할 때:

- `SKILL.md`는 얇게 유지합니다.
- 안정적인 상세 내용은 `references/`로 옮깁니다.
- 재사용 가능한 템플릿은 `assets/`에 둡니다.
- 반복되는 출력이 안정되면 `scripts/`를 통한 결정론적 생성을 우선합니다.

## 기여

기여는 환영합니다. 브랜치와 PR 규칙은 [CONTRIBUTING.md](CONTRIBUTING.md)를 참고하세요.

## 라이선스

이 프로젝트는 MIT License를 따릅니다. 자세한 내용은 [LICENSE](LICENSE)를 참고하세요.
