# hs-init-project

[English](README.md) | [한국어](README.ko.md)

`hs-init-project`는 **프로젝트 스코프 OMX 설치 위에 저장소 전용 rule/docs 구조를 얹는** 오픈소스 Codex 스킬입니다.

## 목적

생성 순서의 기본값은 이제 다음과 같습니다.

1. `omx setup --scope project` 실행
2. `rule/`과 `docs/` 생성
3. OMX가 만든 root `AGENTS.md`를 저장소 전용 rule/문서 경계 규칙으로 개정
4. 기본 실행을 `omx team`으로 두고, 리더가 Ralph-style completion loop로 PASS까지 팀 사이클을 계속 반복

## 저장소 구조

- `hs-init-project/SKILL.md`: 스킬 동작과 워크플로
- `hs-init-project/agents/openai.yaml`: 스킬 메타데이터
- `hs-init-project/references/`: 스킬을 보조하는 상세 규칙 문서
- `hs-init-project/assets/`: 스킬 내부 템플릿
- `hs-init-project/scripts/`: 결정론적 helper 스크립트

## 설치

내장 `skill-installer` helper로 설치합니다.
생성된 프로젝트가 첫 단계로 `omx setup --scope project`를 사용하므로, 전역에서 사용할 수 있는 `omx` CLI가 있는 상태가 가장 자연스럽습니다.
이후 업데이트를 안정적으로 하려면 `main` 대신 태그 릴리스를 기준으로 설치하는 편이 좋습니다.

### `omx`가 전역 설치되어 있지 않은 경우

`omx --version`이 실패하면 먼저 oh-my-codex를 전역 설치합니다.
현재 이 환경에 설치된 패키지 metadata 기준으로 `oh-my-codex`는 `bin.omx`를 제공하고 `node >=20`을 요구하므로, 기본 부트스트랩 순서는 아래와 같습니다.

```bash
node --version
npm install -g oh-my-codex
omx --version
omx doctor
```

### 프로젝트 스코프 설치 (권장)

현재 프로젝트에서만 이 스킬을 쓰고 싶을 때 사용합니다.
`<project-root>/.codex/skills/` 아래에 설치합니다.

Codex에서 설치:

```text
$skill-installer
GitHub repo ChoiHyunSuk93/init-project-codex 의 hs-init-project 경로에 있는 스킬을 최신 버전으로 <project-root>/.codex/skills 에 설치해줘.
```

### 전역 설치

여러 저장소에서 공통으로 쓰고 싶을 때 사용합니다.
이 경우 스킬이 나중에 대상 저장소 안에서 `omx setup --scope project`를 실행하는 흐름과 잘 맞습니다.

Codex에서 설치:

```text
$skill-installer
GitHub repo ChoiHyunSuk93/init-project-codex 의 hs-init-project 경로에 있는 스킬을 최신 버전으로 설치해줘.
```

## 생성 구조

```text
AGENTS.md                      # OMX root 계약 + 저장소 전용 오버레이
.codex/                       # omx setup --scope project가 생성/갱신
.omx/                         # omx setup --scope project가 생성/갱신
README.md
rule/
  index.md
  rules/
    project-structure.md
    instruction-model.md
    rule-maintenance.md
    documentation-boundaries.md
    language-policy.md
    readme-maintenance.md
    development-standards.md
    testing-standards.md
    runtime-boundaries.md
    implementation-records.md
    subagent-orchestration.md
docs/
  guide/
    README.md
    subagent-workflow.md
  implementation/
    AGENTS.md
    [category]/
      [final briefings]
```

## 실행 모델

생성된 저장소는 **team-first + Ralph-led** 실행 규칙을 사용합니다.
리더가 intake, staffing, PASS/FAIL 판정, relaunch 결정, dirty-workspace preflight를 소유합니다.
`omx team` / `$team`이 기본 worker 실행 표면입니다.
team 내부에서는 planning, implementation, evaluation을 최소 필수로 분리하고, 작업에 따라 specialist lane을 더 둘 수 있습니다.
team 시작 전 workspace가 이미 dirty하면 기본적으로 차단하고, 먼저 preservation commit을 남긴 뒤 진행합니다.
내부 coordination은 `.omx/`에 남기고, 저장소에 남기는 durable 산출물은 PASS 이후 `docs/implementation/` 아래 최종 briefing입니다.
