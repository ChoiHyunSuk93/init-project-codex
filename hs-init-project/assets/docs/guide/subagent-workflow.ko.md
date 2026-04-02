# subagent 워크플로우

이 저장소는 team-first 실행 모델을 사용한다.
리더는 worker lane 밖에 머물면서 `omx team` / `$team`을 시작하고, active cycle이 통과할 때까지 Ralph-style ownership loop를 유지한다.
최소 team 구조는 planning, implementation, evaluation lane의 분리이며, 복잡한 작업은 specialist lane을 더 추가할 수 있다.
내부 coordination state는 저장소 working-doc 디렉토리가 아니라 `.omx/` 아래에 남는다.

## Durable Output

- `docs/guide/`는 사용자-facing 안내서만 둔다.
- `docs/implementation/`은 PASS 이후의 durable summary output이다.
- `.omx/`는 runtime coordination state이며 사용자-facing 문서가 아니다.

## 사이클

1. 리더가 workspace가 이미 dirty한지 확인한다.
2. dirty하면 team launch 전에 preservation commit을 먼저 만든다.
3. 리더가 `omx team` / `$team`을 시작하거나 재개한다.
4. planning, implementation, evaluation은 서로 다른 team lane에서 수행한다.
5. 리더가 Ralph-style review로 PASS 또는 FAIL을 판정한다.
6. PASS이면 `docs/implementation/`에 최종 브리핑을 발행하거나 갱신한다.
7. FAIL이면 다음 team cycle을 시작한다.
