# 프로젝트 오버뷰

이 문서는 `hs-init-project` skill의 요구사항 기준 문서다.
생성되는 저장소 구조, 규칙 문서, 템플릿, materialize 스크립트는 이 오버뷰와 로드맵 요구를 기준으로 정렬한다.

## 목적

- Codex가 신규 또는 기존 저장소에 일관된 작업 구조를 생성하도록 돕는 `hs-init-project` skill을 유지한다.
- 생성 구조는 얇은 root `AGENTS.md`, authoritative `rule/`, 사용자-facing `docs/`, working-record `subagents_docs/`, `.codex` harness를 포함한다.
- 프로젝트 요구사항 명세와 phase 기반 로드맵을 생성 구조의 기본 흐름으로 포함한다.

## 대상 사용자

- Codex로 새 저장소를 초기화하거나 기존 저장소에 Codex 작업 구조를 얹는 사용자
- 생성된 저장소에서 요구사항, phase 계획, 구현 cycle, 검수 결과를 이어서 관리하는 에이전트와 유지보수자

## 핵심 흐름

- 언어 선택이 없으면 `1. English` / `2. Korean(한국어)`만 먼저 묻고 기다린다.
- 저장소가 신규인지 기존인지 확인하고, 기존 저장소는 source root, docs, rule, overwrite 충돌을 먼저 inspect한다.
- `PROJECT_OVERVIEW.md`를 요구사항 기준으로 만들고, `subagents_docs/roadmap.md`에 phase와 완료 체크리스트를 만든다.
- 각 구현 cycle은 roadmap phase에 연결하고, evaluator 검수 후 checklist와 상태를 갱신한다.
- 의존 phase는 선행 phase가 `PASS`가 된 뒤에만 시작한다.

## 요구사항

- fresh mode와 existing-project mode 모두 `PROJECT_OVERVIEW.md`와 `subagents_docs/roadmap.md`를 생성해야 한다.
- fresh mode는 초기 사용자 요구사항을 기준으로 오버뷰를 만들고, 부족한 정보는 placeholder와 open question으로 남긴다.
- existing-project mode는 관찰된 구조, source root, 문서, 테스트/빌드 신호, 현재 요청을 기준으로 오버뷰와 로드맵을 작성한다.
- `rule/rules/planning-roadmap.md`가 overview, roadmap, phase checklist, phase gate의 authoritative rule이어야 한다.
- 템플릿 산출물과 `scripts/materialize_repo.sh`의 direct-generation 경로는 같은 구조와 문구를 생성해야 한다.
- 생성되는 starter local skill과 agent metadata는 새 phase-gate 구조를 참조해야 한다.

## 비범위

- 생성 대상 프로젝트의 실제 애플리케이션 기능, 기술 스택, 실행 명령을 임의로 확정하지 않는다.
- 사용자가 명시하지 않은 package, CI, product feature를 생성하지 않는다.
- `docs/guide/`를 rule 복사본이나 작업 로그 저장소로 쓰지 않는다.

## 제약과 결정

- source of truth는 `hs-init-project/` 아래의 skill 본문, templates, references, scripts다.
- 템플릿만 수정하면 existing-project direct-generation 결과가 어긋날 수 있으므로 `scripts/materialize_repo.sh`도 함께 반영한다.
- 실제 entrypoint와 control document 참조는 Markdown link를 사용하고, placeholder나 아직 생성되지 않은 경로는 literal로 유지한다.
- 생성 문서 본문은 선택된 언어를 따르지만 filename, directory, config key는 안정적인 영어 경로를 유지한다.

## 미해결 질문

- 없음. 새 요구사항이 추가되면 이 문서와 [`subagents_docs/roadmap.md`](subagents_docs/roadmap.md)를 먼저 갱신한다.
