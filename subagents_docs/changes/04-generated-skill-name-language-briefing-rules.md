# 생성 스킬 이름·언어·브리핑 규칙 구현 기록

## 요약

`hs-init-project` 생성 스킬을 최신 요구사항에 맞게 정리했다. 생성되는 저장소는 이제 `subagents_docs/`를 선택 언어 기준 작업 문서 영역으로 쓰고, `docs/implementation/briefings/` 없이 관심사 카테고리 안에 짧은 브리핑만 남긴다.

## 변경 내용

- `hs-init-project/SKILL.md`, `hs-init-project/agents/openai.yaml`에서 스킬명, selected-language `subagents_docs` 정책, slow-subagent 시 coordinator 직접 구현 금지 문구를 정렬했다.
- `hs-init-project/assets/AGENTS/*`, `assets/docs/guide/*`, `assets/docs/implementation/*`, `assets/subagents_docs/*`, `assets/rule/*`에서 `docs/implementation/briefings/` 전제를 제거하고 category-based briefing 모델로 바꿨다.
- `hs-init-project/references/language-output.md`, `references/subagent-orchestration.md`, `references/structure-initialization.md`에 같은 규칙을 반영했다.
- `hs-init-project/scripts/materialize_repo.sh`가 생성 결과 설명과 `rule/rules/subagents-docs.md` 내용을 같은 기준으로 만들도록 수정했다.
- 더 이상 쓰지 않는 `hs-init-project/assets/docs/implementation/briefings/` 템플릿 파일들을 제거했다.
- root `README.md`, `README.ko.md`의 생성 결과 예시와 설명을 새 구조에 맞게 갱신했다.

## 결과

- 생성 스킬 이름 표기는 `hs-init-project`로 일치한다.
- 생성 repo의 `subagents_docs` 문서는 선택된 언어를 따른다.
- coordinator는 subagent 응답 지연을 이유로 직접 구현하지 않고 기다리거나 재계획해야 한다.
- 생성 repo는 `docs/implementation/briefings/`를 만들지 않는다.
- `docs/implementation/`은 concern-based category 구조를 유지하고, 그 안에 짧고 읽기 쉬운 브리핑만 둔다.

## 검증

- 단위 테스트:
  - 없음
- E2E 테스트:
  - `./hs-init-project/scripts/materialize_repo.sh /tmp/hs-init-en-pU3ASh --language en`
  - `./hs-init-project/scripts/materialize_repo.sh /tmp/hs-init-ko-pDNzCv --language ko`
- 수동 검증:
  - `rg -n "docs/implementation/briefings/|HSChoi Init Project Harness|hschoi-init-project|briefings/" hs-init-project README.md README.ko.md -S`
  - `rg -n "selected language|active language|subagents_docs/.*language|subagents are slow|directly implement|wait or re-plan|wait or replan|직접 구현|재계획|느리" hs-init-project README.md README.ko.md -S`
  - `find hs-init-project/assets/docs/implementation -maxdepth 3 -type d | sort`
  - `find /tmp/hs-init-en-pU3ASh/docs/implementation -maxdepth 3 -print | sort`
  - `find /tmp/hs-init-ko-pDNzCv/docs/implementation -maxdepth 3 -print | sort`
  - `rg -n "briefings/|selected language|subagents are slow|directly implement|wait or re-plan|category|subagents_docs" /tmp/hs-init-en-pU3ASh/AGENTS.md /tmp/hs-init-en-pU3ASh/docs/guide/subagent-workflow.md /tmp/hs-init-en-pU3ASh/docs/implementation/AGENTS.md /tmp/hs-init-en-pU3ASh/rule/rules/subagent-orchestration.md /tmp/hs-init-en-pU3ASh/rule/rules/subagents-docs.md -S`
  - `rg -n "briefings/|선택된 언어|직접 구현|재계획|카테고리|subagents_docs" /tmp/hs-init-ko-pDNzCv/AGENTS.md /tmp/hs-init-ko-pDNzCv/docs/guide/subagent-workflow.md /tmp/hs-init-ko-pDNzCv/docs/implementation/AGENTS.md /tmp/hs-init-ko-pDNzCv/rule/rules/subagent-orchestration.md /tmp/hs-init-ko-pDNzCv/rule/rules/subagents-docs.md -S`
- 미실행 / 남은 공백:
  - existing-repository mode 생성 검증은 이번 cycle에서 다시 돌리지 않았다.
