# Plan 1 Replan: Current Repo Structure

## 목표

Plan 1에서 현재 저장소 구조를 subagent 하네스에 맞게 끝까지 통과시키기 위한 재계획을 정의한다.
다음 사이클에서는 `planner -> generator -> evaluator`가 같은 범위 안에서 반복 가능해야 하며, 실패하면 같은 Plan 1 안에서 재계획, 재구현, 재평가를 다시 돈다.

## 재계획 배경

- evaluator는 현재 Plan 1이 fail이라고 판정했다.
- 원인은 generator의 책임 범위가 아직 Plan 1에 필요한 현재 저장소 파일 전체를 포괄하지 못한 점과, `docs/implementation/`의 브리핑 경로가 작업 문서 카테고리처럼 보이는 점이다.

## 요구사항 수정

- generator는 Plan 1을 끝내는 데 필요한 현재 저장소 구조 파일을 책임질 수 있어야 한다.
- planner는 generator가 실제로 손봐야 하는 현재 저장소 범위를 계획 문서에서 명시해야 한다.
- `docs/implementation/`의 결과 브리핑은 user-facing 최종 요약으로 보이도록 정리하고, 작업 문서처럼 보이는 경로 인상을 줄여야 한다.
- subagent 작업 문서는 `subagents_docs/`에만 남고, `docs/implementation/`은 사용자에게 보이는 결과 요약만 담아야 한다.

## 다음 사이클에서 통과해야 할 항목

1. 현재 저장소 구조가 subagent 하네스 기준으로 일관되게 설명된다.
2. generator 소유 범위가 Plan 1 완료에 필요한 파일들을 충분히 포함한다.
3. `docs/implementation/`의 최종 브리핑 구조가 작업용 계획/변경 문서처럼 보이지 않는다.
4. planner, generator, evaluator의 역할 분리가 유지되고, 재계획/재구현/재평가 사이클이 계속 가능하다.
5. Plan 1 evaluator가 `pass`를 줄 수 있을 정도로 구조와 문서 경계가 정리된다.

## 범위

- 이 문서는 요구사항 조정용이다.
- 구현 diff, 파일 이동 세부, 코드 수정 지시는 여기서 적지 않는다.
- 다음 generator와 evaluator 사이클의 성공 조건만 고정한다.
