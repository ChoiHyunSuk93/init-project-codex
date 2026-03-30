# Subagent 하네스 리디자인 계획

## 목표

현재 `hschoi-init-project` 스킬의 초기화 구조, 규칙 체계, 문서화 모델은 유지한다.
그 위에 `planner`, `generator`, `evaluator` 역할이 분리된 Codex subagent 하네스를 추가해, 이후 작업이 역할별로 분리된 흐름으로 진행되도록 만든다.

## 범위

- 기존 `README.md`, `AGENTS.md`, `rule/`, `docs/guide/`, `docs/implementation/` 구조를 유지한다.
- 프로젝트 스코프에서 동작하는 subagent 하네스와 관련 문서를 생성할 수 있게 한다.
- planner, generator, evaluator가 각자 고유한 책임만 갖고 실행되도록 정의한다.
- 생성 대상 저장소에서 역할 분리와 문서 역할 분리가 함께 보이도록 만든다.

## 비범위

- 기존 init-project 스킬의 핵심 목적을 다른 제품으로 바꾸는 일
- 역할 경계를 흐리게 만드는 단일 에이전트 재통합
- 특정 애플리케이션 스택, 배포 방식, CI, 패키지 파일을 새로 가정하는 일
- 저수준 구현 세부나 파일별 diff를 이 계획 문서에 직접 적는 일

## 필수 산출물

- planner가 작성하는 계획 문서
- generator가 바탕으로 삼는 구현 문서와 변경 기록
- evaluator가 남기는 E2E 중심 평가 문서
- 역할 분리를 설명하는 저장소 문서와 규칙

## 사용자 흐름

1. 사용자는 스킬을 통해 저장소 초기화 또는 개편을 요청한다.
2. planner가 요구사항을 해석해 무엇을 만들지 먼저 정의한다.
3. generator가 planner 문서를 읽고 실제 구조와 문서를 생성한다.
4. evaluator가 결과를 end-to-end 관점에서 점검하고 품질 평가를 남긴다.

## 인수 기준

- 역할별 책임이 문서와 실행 흐름에서 분명하게 구분된다.
- planner는 기획만 담당하고 구현에 개입하지 않는다.
- generator는 구현과 단위 검증을 담당하고 기획을 재정의하지 않는다.
- evaluator는 최종 점검과 품질 평가를 담당하고 코드를 수정하지 않는다.
- 생성된 저장소는 기존 control 파일과 문서 구조를 유지한 채 subagent 하네스만 추가한다.

## 열린 질문 및 리스크

- Codex CLI의 프로젝트 스코프 subagent 설정 방식이 환경별로 다를 수 있다.
- 역할 분리가 문서상으로는 명확해도 실제 실행 습관에서 섞일 위험이 있다.
- 평가 기준에서 design quality와 originality를 더 크게 반영하는 방식이 과도하게 주관적으로 보일 수 있다.
- 기존 init-project 구조와 새 subagent 하네스가 서로 충돌하지 않도록 문서 경계를 유지해야 한다.
