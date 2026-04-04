# 저장소 지침

이 파일은 저장소 전역에 적용되는 Codex 지침을 정의한다.
이 파일은 얇게 유지하고, `rule/index.md`와 `rule/rules/` 아래의 상세 규칙 문서로 연결하는 데 사용한다.

## 이 파일의 역할

- 프로젝트 전역 지침의 경계를 정의한다.
- `rule/index.md`와 `rule/rules/` 아래의 기준 규칙 문서로 연결한다.
- 상세 규칙이 들어가야 할 내용을 이 파일에 중복 작성하지 않는다.

## 규칙 모델

- `rule/index.md`를 기준 규칙 문서의 탐색 시작점으로 취급한다.
- 프로젝트 구조를 바꾸거나 장기 보관 문서를 새로 만들기 전에 관련 `rule/rules/*.md` 문서를 읽는다.
- rule 문서를 추가, 삭제, 이름 변경, 이동할 때는 `rule/rules/rule-maintenance.md`를 기준으로 삼는다.
- rule 문서를 추가, 삭제, 이름 변경, 이동할 때는 `rule/index.md`도 함께 갱신한다.

## 범위 모델

- 이 root 파일은 저장소 전체에 적용된다.
- local `AGENTS.md`가 있으면 그 디렉토리 범위에서 더 좁거나 구체적인 지침을 추가할 수 있다.
- local `AGENTS.md`는 local 동작을 구체화해야 하며, 이유 없이 전역 규칙을 반복하지 않는다.

## 문서 역할

- `rule/`은 기준 Codex 실행 규칙을 담는다.
- `docs/guide/`는 사람이 실제로 따라야 하는 사용자 가이드를 담는다.
- `docs/implementation/`는 사람이 읽는 최종 브리핑과 결과만 담는다.
- `subagents_docs/`는 planner, generator, evaluator 작업 문서를 담는다.

## 문서화 자동화

- root `README.md`를 저장소를 대표하는 사람이 읽는 요약 문서로 계속 갱신한다.
- 신규 저장소에서는 `README.md`를 최소 template에서 시작하고, 실제 프로젝트 목적이 드러나면 placeholder를 교체한다.
- 기존 저장소에서는 없는 내용을 지어내지 말고, 관찰된 프로젝트 구조와 오래 유지되는 사실을 기준으로 `README.md`를 갱신한다.
- 실행, 배포, 테스트 실행, 요청 절차처럼 실제 사용자가 따라야 하는 안정적인 워크플로가 생기거나 바뀌면 `docs/guide/` 아래의 관련 가이드 문서를 생성하거나 수정한다.
- 저장소 구조 요약, 프로젝트 규약, 테스트 디렉토리 나열, 구현 메모만으로 guide 문서를 만들지 않는다.
- evaluator가 통과시킨 각 plan cycle마다 `docs/implementation/` 아래의 가장 가까운 관심사 카테고리 안에 최종 브리핑을 생성하거나 수정한다.
- 작업용 계획, generator 변경 노트, evaluator 보고서는 `subagents_docs/`에 둔다.
- 동작이 바뀌는 변경이라면 가능하면 가장 관련 있는 테스트 계층을 추가하거나 수정하고, 실제 테스트 관례가 드러나면 `rule/rules/testing-standards.md`도 함께 갱신한다.
- 규칙에 새로운 명시 사항이 추가되거나 기존 규칙이 바뀌면 `rule/rules/rule-maintenance.md`를 따라 관련 규칙 문서와 `rule/index.md`를 같은 변경에서 함께 갱신한다.
- 프로젝트별 구현 표준이 더 분명해지면 `rule/rules/development-standards.md`를 갱신해 일반 기본값이 아니라 관찰된 관례를 반영한다.
- starter rule에 placeholder가 남아 있다면 실제 구조나 경계가 분명해지는 시점에 관찰된 값으로 교체한다.

## Skill 작업

- 이 저장소에 Codex skill이 있거나 새로 만들면 `skill-creator`를 사용한다.
- 각 skill은 명확한 `SKILL.md` 설명과 정렬된 메타데이터를 갖추도록 작성한다.
- 각 skill의 `agents/openai.yaml`에는 특별한 이유가 없다면 `policy.allow_implicit_invocation: true`를 둔다.
- 저장소가 `.codex/skills/` 아래 starter local skill을 함께 가지면 `SKILL.md` 설명, metadata, `allow_implicit_invocation` 설정을 서로 맞춘다.
- 각 skill은 관련 `rule/rules/*.md` 문서를 참조형으로 연결하고, 저장소 공통 규칙을 skill 본문에 중복 복사하지 않는다.

## 서브에이전트 하네스

- 이 저장소는 기본적으로 planner / generator / evaluator 흐름을 사용하므로 먼저 `rule/rules/subagent-orchestration.md`를 읽는다.
- 메인 에이전트는 이 흐름에서 orchestration-only 역할만 맡고, 사용자가 역할 분리를 명시적으로 완화하지 않는 한 planner/generator/evaluator를 직접 겸하지 않는다.
- 분석, 질문, 리뷰, 설명 요청은 명시적 구현/변경/materialize 지시가 없으면 구현 사이클로 시작하지 않는다.
- coordinator는 subagent 결과를 오래 기다릴 수 있지만, 반영이 끝난 completed/unused thread는 정리해야 한다.
- stale session이나 thread limit 때문에 새 delegation이 막히면 직접 구현 대신 cleanup을 먼저 수행한다.
- exact cycle 문서 경로, header 상태 전이, append-only section, provenance, dirty-worktree 평가 기준은 `rule/rules/cycle-document-contract.md`를 따른다.
- 문서 언어와 안정적인 filename/path 규칙은 `rule/rules/language-policy.md`를 따른다.
- `.codex/agents/*.toml`과 `subagents_docs/AGENTS.md`는 이 authoritative rule들과 함께 맞춘다.
- `subagents_docs/`는 작업 기록에만 사용하고, `docs/implementation/`은 pass된 cycle의 사용자-facing 요약 계층으로만 유지한다.

## 언어 규칙

- exact 언어 규칙과 path 불변 조건은 `rule/rules/language-policy.md`를 따른다.
- `.codex/`와 그 agent 파일명은 영어로 유지한다.

## 중복 금지

- 프로젝트가 커져도 이 파일은 얇게 유지한다.
- 안정적인 상세 지침은 `rule/rules/*.md`로 이동한다.
- local `AGENTS.md`는 범위를 분명하게 해주는 경우에만 추가한다.
