# PROJECT_NAME

짧은 설명 placeholder. 이 문장을 프로젝트 한 줄 소개로 교체한다.
이 저장소는 프로젝트 스코프 OMX 설치와 team-first, Ralph-led completion 모델을 사용한다.

## 목적

이 저장소가 무엇을 위한 것인지 적는다.

## 상태

이 저장소는 프로젝트 스코프 OMX 스캐폴드와 저장소 전용 rule/docs 구조를 갖춘 초기 상태로 만들어졌다.
프로젝트의 실제 목적, 구조, 사용 방법이 구체화되면 이 README를 함께 갱신한다.

## 구조

- `AGENTS.md`: OMX가 생성한 root orchestration 계약과 저장소 전용 오버레이
- `.codex/`: `omx setup --scope project`가 생성한 프로젝트 스코프 OMX 설치 영역
- `.omx/`: 프로젝트 스코프 OMX runtime state와 team/Ralph 산출물 영역
- `rule/`: 저장소 전용 authoritative 실행 규칙
- `docs/guide/`: 사람이 읽는 사용자 가이드 문서
- `docs/guide/subagent-workflow.md`: 사용자-facing team + Ralph 워크플로 가이드
- `docs/implementation/`: PASS 이후의 사용자-facing 최종 브리핑 문서

## 실행 모델

각 구현 요청은 `omx team`과 리더의 Ralph review loop로 진행한다.
planning, implementation, evaluation은 최소 필수로 분리된 team lane이다.
복잡한 작업은 그 위에 specialist lane을 더 세분화할 수 있다.
내부 coordination은 `.omx/`에 남기고, 저장소에 남기는 durable 산출물은 `docs/implementation/` 아래 최종 브리핑이다.
