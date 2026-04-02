## 저장소별 규칙 오버레이

- 저장소 전용 실행 규칙의 탐색 시작점으로 `rule/index.md`를 사용한다.
- 프로젝트 구조, 장기 보관 문서, 워크플로 정책을 바꾸기 전에는 관련 `rule/rules/*.md` 문서를 먼저 읽는다.
- `rule/`은 authoritative rule, `docs/guide/`는 사용자 안내, `docs/implementation/`은 PASS 이후의 짧은 최종 브리핑으로 분리한다.
- `.omx/`는 OMX runtime state이며 사용자-facing 문서가 아니다.
- 오래 유지되는 프로젝트 사실이 바뀌면 root `README.md`를 함께 갱신한다.

## 기본 실행 모델

- 구현 작업의 기본 다중 에이전트 실행 표면은 `omx team` / `$team`으로 본다.
- 리더는 worker lane에 들어가지 않고 Ralph-style completion owner로 남아 팀을 띄우고, 증거를 읽고, PASS/FAIL을 판정하며, 통과하지 못한 경우 다음 team cycle을 다시 시작한다.
- team 안에서는 planning, implementation, evaluation을 서로 다른 lane 또는 subagent가 맡는 것을 최소 필수 구조로 유지한다.
- 작업에 따라 specialist lane을 더 추가할 수는 있어도 이 최소 분리를 합치거나 생략하지 않는다.
- team을 시작하기 전에 workspace가 이미 dirty한지 확인하고, dirty하면 기본적으로 preservation commit을 만든 뒤 clean 상태에서 진행한다.
- durable한 사용자-facing 산출물은 PASS 이후 `docs/implementation/` 아래 최종 브리핑만 남긴다.

## 언어 및 매직 키워드

- 문서 언어와 filename/path 불변 조건은 `rule/rules/language-policy.md`를 따른다.
- OMX가 관리하는 `.codex/`, `.omx/` 카탈로그는 OMX 기준으로 유지하고, 저장소 전용 지침은 이 오버레이와 `rule/` 문서로 추가한다.
- 한국어 운영에서는 아래 표현도 OMX 기본 영문 키워드와 함께 magic keyword로 취급한다.
  - `팀`, `팀으로`, `스웜`, `팀 실행` -> `$team`
  - `랄프`, `끝까지`, `통과할때까지`, `계속 돌려`, `완료될때까지` -> `$ralph`
  - `계획`, `계획 세워`, `계획 짜`, `플랜` -> `$plan`
  - `랄플랜`, `합의 계획`, `합의 플랜` -> `$ralplan`
  - `분석`, `조사` -> `$analyze`
  - `취소`, `중단`, `멈춰`, `그만` -> `$cancel`
  - `테스트 먼저`, `테스트 우선`, `TDD` -> `$tdd`
  - `빌드 고쳐`, `타입 에러`, `타입 오류` -> `$build-fix`
  - `코드 리뷰`, `리뷰해줘` -> `$code-review`
  - `보안 리뷰`, `보안 점검` -> `$security-review`
