# 프로젝트 오버뷰

이 문서는 `hs-init-project` skill의 요구사항 기준 문서다.
생성되는 저장소 구조, 규칙 문서, 템플릿, materialize 스크립트는 이 오버뷰와 로드맵 요구를 기준으로 정렬한다.

## 목적

- Codex가 신규 또는 기존 저장소에 일관된 작업 구조를 생성하도록 돕는 `hs-init-project` skill을 유지한다.
- 생성 구조는 제품 중립적인 최소 규약, 얇은 agent 진입점, 프로젝트 요구사항 명세만 기본으로 포함한다.
- 범용 custom subagent, 범용 starter skill, 빈 작업 기록 계층은 생성하지 않는다.
- Codex와 Claude Code의 차이는 공통 규약을 가리키는 얇은 제품별 진입점으로만 흡수한다.

## 대상 사용자

- Codex 또는 Claude Code로 새 저장소를 초기화하거나 기존 저장소에 공통 작업 규약을 얹는 사용자
- 생성된 저장소에서 프로젝트 요구사항과 규칙을 유지하는 에이전트와 유지보수자

## 핵심 흐름

- 요청이나 session에서 언어를 합리적으로 판단하고, 실제로 불명확할 때만 한 번 질문한다.
- 저장소가 신규인지 기존인지 확인하고, 기존 저장소는 source root, docs, rule, overwrite 충돌을 먼저 inspect한다.
- `PROJECT_OVERVIEW.md`를 요구사항 기준으로 만들고, `rule/index.md`를 최소 규약 탐색 진입점으로 만든다.
- 작업 크기와 모호성에 따라 main agent가 직접 수행하거나 필요한 경우에만 동적 subagent를 사용한다.
- roadmap, cycle, implementation record는 실제 프로젝트나 작업이 요구할 때 해당 프로젝트에서 별도로 만든다.

## 요구사항

- fresh mode와 existing-project mode 모두 `PROJECT_OVERVIEW.md`와 최소 규약을 안전하게 생성해야 한다.
- fresh mode는 초기 사용자 요구사항을 기준으로 오버뷰를 만들고, 부족한 정보는 placeholder와 open question으로 남긴다.
- existing-project mode는 관찰된 구조, source area, 문서, 테스트/빌드 신호, 현재 요청을 기준으로 오버뷰를 작성하거나 보강한다.
- 생성 규칙은 project structure, development, testing, documentation, agent workflow의 다섯 관심사로 제한한다.
- 모든 생성 문서는 `assets/` template 하나를 source of truth로 사용하고, materializer는 선택과 치환만 담당한다.
- `--target codex|claude|both`, `--project-mode fresh|existing`, `--readme-mode create|merge|preserve`를 분리한다.
- existing-project mode는 기존 사용자 문서를 기본 보존하고, 명시적 충돌 정책 없이 덮어쓰지 않는다.
- 프로젝트 전용 agent, skill, roadmap, cycle, release 절차는 생성 대상 프로젝트에서 별도 작업으로 정의한다.

## 비범위

- 생성 대상 프로젝트의 실제 애플리케이션 기능, 기술 스택, 실행 명령을 임의로 확정하지 않는다.
- 사용자가 명시하지 않은 package, CI, product feature를 생성하지 않는다.
- 범용 planner, generator, evaluator custom agent를 생성하지 않는다.
- 범용 change-analysis, implementation, test/debug, docs sync, quality review skill을 생성하지 않는다.
- `docs/guide/`를 rule 복사본이나 작업 로그 저장소로 쓰지 않는다.
- 기존 구현 브리핑을 현재 변경사항에 맞추기 위해 불필요하게 탐색하거나 수정하지 않는다.

## 제약과 결정

- source of truth는 `hs-init-project/` 아래의 skill 본문, templates, references, scripts다.
- materializer 안에 문서 본문 heredoc을 중복하지 않는다.
- agent 역할은 파일로 고정하지 않고 제품이 제공하는 기본 또는 동적 subagent에 작업 단위로 부여한다.
- 실제 entrypoint와 control document 참조는 Markdown link를 사용하고, placeholder나 아직 생성되지 않은 경로는 literal로 유지한다.
- 생성 문서 본문은 선택된 언어를 따르지만 filename, directory, config key는 안정적인 영어 경로를 유지한다.

## 미해결 질문

- 없음. 새 요구사항이 추가되면 이 문서와 [`subagents_docs/roadmap.md`](subagents_docs/roadmap.md)를 먼저 갱신한다.
