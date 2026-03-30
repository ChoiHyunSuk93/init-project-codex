# 생성 스킬 브리핑·언어 정책 재계획

## 배경

현재 저장소의 current-repo 쪽 요구사항은 이미 `pass` 상태다. 이 계획은 그 다음 단계인 `hs-init-project` 생성 스킬 쪽만 다시 맞추기 위한 연속 작업이다.

남은 핵심 차이는 네 가지다.

1. 스킬명은 `hs-init-project`로 유지되어야 한다.
2. `subagents_docs`에 쓰이는 문서 언어는 선택된 언어 설정을 그대로 따라야 한다.
3. coordinator는 subagent 응답이 느리다는 이유로 직접 구현에 개입하면 안 되며, 반드시 기다리거나 재계획해야 한다.
4. 생성되는 저장소는 `docs/implementation/briefings/` 디렉토리를 만들지 않아야 하고, `docs/implementation/`은 기존처럼 category 기반으로 유지하되 각 category 안에 짧고 읽기 쉬운 브리핑 문서만 두어야 한다.

## 범위

이번 cycle은 생성 스킬 산출물만 다룬다.

- `hs-init-project/SKILL.md`
- `hs-init-project/agents/openai.yaml`
- `hs-init-project/scripts/materialize_repo.sh`
- `hs-init-project/assets/**`
- `hs-init-project/references/**`
- 생성 결과를 설명하는 `README.md`, `README.ko.md`

## 작업 분해

### Plan A: 메타데이터와 진입 문구 정렬

- `SKILL.md`와 `agents/openai.yaml`의 스킬명, default prompt, 언어 분기 문구를 `hs-init-project` 기준으로 맞춘다.
- `subagents_docs` 언어 정책과 coordinator 비개입 원칙을 generated-skill 문구에 명시한다.
- generated repo 설명 문구에서 `docs/implementation/briefings/`를 제거하고, category 기반 `docs/implementation/` 모델로 바꾼다.

### Plan B: 템플릿과 리소스 정리

- `assets/AGENTS/*`와 `assets/docs/implementation/AGENTS.*`에서 `briefings/` 상위 디렉토리 전제를 삭제한다.
- `assets/docs/implementation/record.*`는 category 내부의 짧은 브리핑 형식만 설명하도록 유지한다.
- `assets/docs/guide/subagent-workflow.*`는 user-facing 문서가 `docs/implementation/briefings/`를 만들지 않는다는 점을 반영한다.
- `subagents_docs/AGENTS.*` 및 관련 rule/reference 템플릿은 선택 언어를 따르는 문구로 맞춘다.

### Plan C: deterministic generator 정비

- `scripts/materialize_repo.sh`가 생성 repo에 `docs/implementation/briefings/`를 만들지 않도록 정리한다.
- category 기반 implementation record 생성 규칙을 유지하되, 새 category는 실제 필요 시에만 만든다.
- generated repo에서 planner/generator/evaluator의 작업 문서는 계속 `subagents_docs/`에만 둔다.

### Plan D: 사용자-facing 설명 정합성

- root `README.md`와 `README.ko.md`의 생성 결과 설명이 실제 템플릿과 일치하도록 정리한다.
- generated repo가 `subagents_docs` 언어 정책, no-direct-implementation 원칙, category-based implementation briefings를 어떻게 쓰는지 사용자에게 일관되게 설명한다.

## 순서 규칙

- Plan A는 Plan B와 Plan C보다 먼저 정리되어야 한다. 메타데이터와 진입 문구가 틀리면 downstream 템플릿이 모두 어긋난다.
- Plan B와 Plan C는 서로 독립적인 부분이 있어 일부는 병렬 처리 가능하지만, `docs/implementation/briefings/` 제거 여부는 둘 다에서 같은 기준으로 맞춰야 한다.
- Plan D는 A/B/C의 결과를 반영해야 하므로 마지막에 맞춘다.
- 평가에서 실패하면 같은 plan에서 재계획, 재구현, 재평가를 반복한다.

## 병렬 처리 가능 범위

- `SKILL.md` / `agents/openai.yaml` 정리와 root README 설명 정리는 병렬 가능하다.
- `assets/**` 안의 템플릿 정리와 `scripts/materialize_repo.sh` 정리는 병렬 가능하다.
- `references/**`의 상세 규칙 정리와 `README.md`, `README.ko.md`의 설명 정리는 병렬 가능하다.

## 의존 관계

- `agents/openai.yaml`의 default prompt는 `SKILL.md`와 함께 맞춰야 한다.
- `assets/docs/implementation/AGENTS.*`와 `scripts/materialize_repo.sh`는 같은 directory model을 공유해야 한다.
- `subagents_docs` 언어 정책은 generated repo의 rule/reference 템플릿과 일치해야 한다.
- coordinator 비개입 원칙은 skill 본문, generated repo rule 문서, 그리고 user-facing 설명에 동시에 반영되어야 한다.

## 수용 기준

- 생성 스킬 이름이 `hs-init-project`로 일치한다.
- 생성된 저장소의 `subagents_docs` 문서는 선택된 언어로 작성된다.
- coordinator가 subagent 지연을 이유로 직접 구현하는 경로가 문서상 금지된다.
- 생성된 저장소에는 `docs/implementation/briefings/` 디렉토리가 없다.
- `docs/implementation/`은 category 기반 구조를 유지하고, 각 category 안에 짧은 브리핑 문서만 생긴다.
- current-repo와 generated-skill 양쪽의 문서 경계 설명이 서로 충돌하지 않는다.
- planner -> generator -> evaluator 반복 사이클이 pass될 때까지 계속된다는 규칙이 generated skill 문서에 남아 있다.
