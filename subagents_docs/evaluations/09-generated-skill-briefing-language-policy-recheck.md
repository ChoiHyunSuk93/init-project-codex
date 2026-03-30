# 생성 스킬 브리핑·언어 정책 재검증

## 판정

PASS

## 평가 범위

- 계획 문서: `subagents_docs/plans/09-generated-skill-briefing-language-policy-replan.md`
- 구현 기록: `subagents_docs/changes/04-generated-skill-name-language-briefing-rules.md`
- 제품 범위:
  - `hs-init-project/SKILL.md`
  - `hs-init-project/agents/openai.yaml`
  - `hs-init-project/scripts/materialize_repo.sh`
  - `hs-init-project/assets/**`
  - `hs-init-project/references/**`

## 주요 판정 근거

### 1. 스킬명과 메타데이터/문서 정렬

- `hs-init-project/SKILL.md:2`에서 스킬 slug가 `hs-init-project`로 선언되어 있다.
- `hs-init-project/agents/openai.yaml:4`의 default prompt가 `$hs-init-project`를 직접 사용한다.
- `hs-init-project/SKILL.md:127-153`과 루트 `README.md`, `README.ko.md`도 동일한 이름과 디렉터리 구조를 설명한다.
- 비차단 메모:
  - `hs-init-project/agents/openai.yaml:2`의 `display_name`은 humanized label인 `HS Init Project Harness`다.
  - 하지만 호출 slug, 본문 설명, 설치 경로, 생성 결과 설명은 모두 `hs-init-project`에 정렬되어 있어 acceptance blocker로 보지 않았다.

### 2. 생성 저장소의 `subagents_docs` 언어 정책

- `hs-init-project/SKILL.md:49`, `hs-init-project/SKILL.md:64-72`가 선택 언어를 generated docs와 `subagents_docs/` working docs에 적용하라고 명시한다.
- `hs-init-project/scripts/materialize_repo.sh:1216-1290`은 `rule/rules/subagents-docs.md`를 언어별 본문으로 직접 생성한다.
- `hs-init-project/scripts/materialize_repo.sh:1427-1449`는 선택 언어에 맞는 `AGENTS`, guide, rule 템플릿을 복사한다.
- 실제 생성 검증:
  - fresh English repo의 `/tmp/hs-init-eval-ZvrYTa/fresh-en/subagents_docs/AGENTS.md:3-20`는 영어 본문으로 생성됐다.
  - fresh Korean repo의 `/tmp/hs-init-eval-ZvrYTa/fresh-ko/subagents_docs/AGENTS.md:3-20`는 한국어 본문으로 생성됐다.
  - existing Korean repo도 `/tmp/hs-init-eval-ZvrYTa/existing-ko/subagents_docs/AGENTS.md`와 `/tmp/hs-init-eval-ZvrYTa/existing-ko/rule/rules/subagents-docs.md`가 한국어 기준으로 생성됐다.

### 3. slow subagent 상황에서 coordinator 직접 구현 금지

- `hs-init-project/SKILL.md:100-108`이 planner -> generator -> evaluator 분리와 wait/re-plan 원칙을 직접 규정한다.
- `hs-init-project/agents/openai.yaml:4`도 “If subagents are slow, do not directly implement in place of them; wait or re-plan.”을 포함한다.
- `hs-init-project/assets/docs/guide/subagent-workflow.en.md:20-21`, `hs-init-project/assets/docs/guide/subagent-workflow.ko.md:20-21`가 generated repo guide에도 같은 규칙을 남긴다.
- existing Korean 생성 결과의 `/tmp/hs-init-eval-ZvrYTa/existing-ko/rule/rules/subagent-orchestration.md:32-38`, `:56-61`에서도 동일 원칙이 유지된다.

### 4. `docs/implementation/briefings/` 미생성

- `hs-init-project/SKILL.md:176-178`이 `docs/implementation/briefings/` 생성을 금지한다.
- `hs-init-project/scripts/materialize_repo.sh:1247-1252`, `:1284-1289`가 inline rule 텍스트에서 같은 금지를 생성한다.
- fresh English, fresh Korean, existing Korean 모두 `find` 결과에 `docs/implementation/briefings/`가 나타나지 않았다.
- 생성 결과는 세 케이스 모두 `docs/implementation/AGENTS.md`만 만들고 빈 category나 `briefings/` 디렉터리를 선생성하지 않았다.

### 5. `docs/implementation/`의 category 기반 짧은 브리핑 모델

- `hs-init-project/assets/docs/implementation/AGENTS.en.md:7-26`과 `hs-init-project/assets/docs/implementation/AGENTS.ko.md:7-26`가 다음을 명시한다.
  - concern-based category 디렉터리 사용
  - 첫 기록 시점에만 category 생성
  - 최종 브리핑은 짧고 읽기 쉬운 구조 유지
  - top-level `briefings/` 금지
  - `NN-name.md` 규칙
- 실제 생성된 `/tmp/hs-init-eval-ZvrYTa/fresh-ko/docs/implementation/AGENTS.md:7-26`도 같은 내용을 반영한다.
- 초기화 단계에서 실제 user-facing implementation briefing 파일은 생성되지 않았지만, 이는 category와 기록을 선생성하지 말라는 동일 규칙과 일치한다.

### 6. planner -> generator -> evaluator 반복 사이클 문서화 유지

- `hs-init-project/SKILL.md:105-108`이 “Re-run the same plan through planner -> generator -> evaluator until it passes.”를 유지한다.
- `hs-init-project/assets/docs/guide/subagent-workflow.en.md:14-21`, `hs-init-project/assets/docs/guide/subagent-workflow.ko.md:14-21`가 pass까지 반복된다고 안내한다.
- fresh English 생성 결과의 `/tmp/hs-init-eval-ZvrYTa/fresh-en/docs/guide/subagent-workflow.md:14-21`와 fresh Korean / existing Korean 생성 결과의 대응 파일에서도 동일 cycle 규칙을 확인했다.
- existing Korean 생성 결과의 `/tmp/hs-init-eval-ZvrYTa/existing-ko/rule/rules/subagent-orchestration.md:34-38`은 재계획 후 재실행과 pass까지 순환을 다시 명시한다.

### 7. fresh / existing repository 동작 검증

- fresh English:
  - materialize 성공
  - 영어 문서 생성
  - `subagents_docs`, `rule/rules/subagents-docs.md`, category-based `docs/implementation/AGENTS.md` 확인
- fresh Korean:
  - materialize 성공
  - 한국어 문서 생성
  - `subagents_docs` 언어 정책과 wait/re-plan 규칙 확인
- existing Korean:
  - `--inspect` 실행 시 runtime 후보(`src/`), 기존 `docs/legacy/`, 기존 `rule/rules/custom.md`, 기존 `README.md` overwrite 필요를 질문 형태로 정확히 보고했다.
  - 확인 플래그와 `--runtime-dirs src --overwrite`를 주고 재실행했을 때 materialize 성공.
  - `/tmp/hs-init-eval-ZvrYTa/existing-ko/docs/legacy/README.md`, `/tmp/hs-init-eval-ZvrYTa/existing-ko/rule/rules/custom.md`, `/tmp/hs-init-eval-ZvrYTa/existing-ko/src/index.js`가 보존됐다.
  - `/tmp/hs-init-eval-ZvrYTa/existing-ko/README.md:10-31`, `/tmp/hs-init-eval-ZvrYTa/existing-ko/rule/rules/development-standards.md:7-37`, `/tmp/hs-init-eval-ZvrYTa/existing-ko/rule/rules/testing-standards.md:7-33`가 관찰된 구조를 반영해 existing mode 설명을 생성했다.

## 점수

- design quality: 9/10
- originality: 8/10
- completeness: 9/10
- functionality: 9/10
- weighted overall: 8.7/10

## 총평

이번 변경은 acceptance criteria 1~7을 모두 충족했다.
특히 language-aware `subagents_docs`, inspect-then-confirm existing mode, concern-based `docs/implementation/` 경계, slow-subagent 시 coordinator 비개입 원칙이 텍스트와 실제 materialization 결과에서 함께 맞물린 점이 좋다.

별도 blocker는 발견하지 못했다.

## 실행한 핵심 검증 명령

```sh
sh hs-init-project/scripts/materialize_repo.sh /tmp/hs-init-eval-ZvrYTa/fresh-en --language en
sh hs-init-project/scripts/materialize_repo.sh /tmp/hs-init-eval-ZvrYTa/fresh-ko --language ko
sh hs-init-project/scripts/materialize_repo.sh /tmp/hs-init-eval-ZvrYTa/existing-ko --language ko --readme-mode existing --inspect
sh hs-init-project/scripts/materialize_repo.sh /tmp/hs-init-eval-ZvrYTa/existing-ko --language ko --readme-mode existing --runtime-dirs src --confirm-existing-docs --confirm-existing-rule --overwrite
find /tmp/hs-init-eval-ZvrYTa/fresh-en -maxdepth 4 | sort
find /tmp/hs-init-eval-ZvrYTa/fresh-ko -maxdepth 4 | sort
find /tmp/hs-init-eval-ZvrYTa/existing-ko -maxdepth 4 | sort
rg -n "briefings/|wait or re-plan|directly implement|selected language|subagents_docs|category" /tmp/hs-init-eval-ZvrYTa/fresh-en -S
rg -n "briefings/|직접 구현|재계획|선택된 언어|subagents_docs|관심사 기반 카테고리|짧고 읽기" /tmp/hs-init-eval-ZvrYTa/fresh-ko /tmp/hs-init-eval-ZvrYTa/existing-ko -S
```
