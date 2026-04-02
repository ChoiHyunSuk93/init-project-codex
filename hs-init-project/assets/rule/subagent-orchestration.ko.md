# 서브에이전트 오케스트레이션 규칙

## 목적

team-first delivery model과 리더의 Ralph-style completion을 정의한다.
최소 필수 team 분리는 planning, implementation, evaluation lane의 분리다.
작업 성격에 따라 specialist lane을 더 추가할 수 있다.

## Intent Gate

- 분석, 질문, 리뷰, 설명 요청은 구현 사이클로 시작하지 않는다.
- team / Ralph 사이클은 사용자가 명시적으로 구현, 변경, 생성, 수정, materialize를 요청했을 때만 시작한다.

## Clean Workspace Gate

- `omx team`을 시작하기 전에 workspace가 이미 dirty한지 먼저 확인한다.
- 새 작업 시작 전 workspace가 dirty하면 team launch는 기본적으로 차단한다.
- 먼저 preservation commit을 만든 뒤 clean HEAD 상태에서 진행한다.

## Output Model

- `.omx/`는 내부 coordination state를 가진다.
- `docs/implementation/`은 PASS 이후 durable한 사용자-facing briefing을 가진다.
- team runtime을 위한 repository-owned working-doc 디렉토리는 만들지 않는다.
