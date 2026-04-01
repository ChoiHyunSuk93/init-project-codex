# 19 Cleanup Legacy Subagents Docs

- Status: PASS
- Current Plan Version: Evaluator v1
- Next Handoff: complete

## Planner v1

### 목표

- current repo의 legacy `subagents_docs/plans`, `subagents_docs/changes`, `subagents_docs/evaluations`를 active top level에서 정리한다.
- historical record는 보존하면서 active baseline을 `subagents_docs/cycles/`만 남는 구조로 만든다.

### 확인 결과

- top-level legacy 디렉토리 `subagents_docs/plans`, `subagents_docs/changes`, `subagents_docs/evaluations`가 아직 존재한다.
- 세 디렉토리의 파일 수는 총 42개다.
- current repo에는 이 경로들을 직접 참조하는 historical 문서가 많이 남아 있다.

### 범위

- current repo의 `subagents_docs/` 하위 디렉토리 구조 정리
- current repo 안에서 legacy 경로를 직접 가리키는 문서 경로 갱신
- active baseline 문서가 `subagents_docs/cycles/`만 기준으로 보이도록 유지

### 비범위

- historical record 삭제
- generated-skill template, reference, script 수정
- historical 문서의 내용 의미 재작성

### 정리 전략

1. `subagents_docs/archive/`를 만들고 `plans`, `changes`, `evaluations`를 각각 `subagents_docs/archive/plans`, `subagents_docs/archive/changes`, `subagents_docs/archive/evaluations`로 이동한다.
2. 이동 전에 legacy 파일 목록을 고정해 누락 없이 옮길 수 있게 한다.
3. current repo에서 `subagents_docs/plans`, `subagents_docs/changes`, `subagents_docs/evaluations`를 가리키는 참조를 전수 검색한다.
4. historical 문서의 본문 의미는 바꾸지 않고, 경로 literal만 새 archive 경로로 갱신한다.
5. active baseline 문서에서는 `subagents_docs/cycles/`만 current working area로 유지한다.
6. 이동 후 top-level `subagents_docs/` 아래에는 `cycles/`와 필요한 경우 `archive/`만 남도록 정리한다.

### acceptance criteria

- legacy 42개 파일이 삭제 없이 `subagents_docs/archive/` 아래로 이동한다.
- current repo의 legacy 경로 참조는 archive 경로로 유효하게 갱신된다.
- active baseline은 계속 `subagents_docs/cycles/`만 current working area로 설명한다.
- top-level `subagents_docs/plans`, `changes`, `evaluations`는 제거된다.

### 위험 요소

- historical 문서가 많아 경로 치환 누락이 생길 수 있다.
- 평가 문서나 검증 명령 예시 안의 literal path도 archive 경로로 같이 맞춰야 한다.
- cycle 문서 자체가 legacy 경로 cleanup을 언급하고 있어, active baseline 문서와 historical record 문서를 구분해서 다뤄야 한다.

### 다음 handoff

- generator가 archive 디렉토리 이동과 current repo 경로 갱신을 함께 수행하고, 누락 여부를 검증한다.

## Planner v2

### 목표

- current repo의 legacy `subagents_docs/plans/`, `subagents_docs/changes/`, `subagents_docs/evaluations/`와 그 내부 파일을 삭제한다.
- active baseline은 `subagents_docs/cycles/`만 남는 구조로 유지한다.

### 변경된 전략

- archive 이동은 하지 않는다.
- `subagents_docs/plans/`, `subagents_docs/changes/`, `subagents_docs/evaluations/`를 내용물과 함께 삭제한다.
- scope는 current repo only로 유지한다.

### 범위

- current repo의 legacy subagents_docs 디렉토리 삭제
- 삭제에 꼭 필요한 최소 current repo 정리

### 비범위

- archive 디렉토리 생성 또는 migration
- generated-skill template, reference, script 수정
- historical cycle 문서 전수 rewrite

### 정리 원칙

- historical cycle 문서는 제거된 경로를 계속 언급할 수 있다.
- minimal cleanup 요청을 넘어서 historical reference 전수 수정으로 범위를 넓히지 않는다.
- active baseline 문서와 현재 구조만 `subagents_docs/cycles/` 기준으로 유지한다.

### acceptance criteria

- `subagents_docs/plans/`, `subagents_docs/changes/`, `subagents_docs/evaluations/`가 current repo에서 제거된다.
- archive 경로는 만들지 않는다.
- active baseline은 계속 `subagents_docs/cycles/`만 current working area로 본다.

### 다음 handoff

- generator가 current repo에서 legacy subagents_docs 디렉토리를 삭제하고, 필요한 최소 확인만 수행한다.

## Generator v1

### planner section reference

- `Planner v2`

### 실제 반영한 범위

- current repo의 `subagents_docs/plans/`, `subagents_docs/changes/`, `subagents_docs/evaluations/`를 내용물과 함께 삭제했다.
- archive 생성이나 migration은 하지 않았다.
- active top-level 구조는 `subagents_docs/cycles/`만 남도록 정리했다.

### 변경 파일

- 삭제: `subagents_docs/plans/`
- 삭제: `subagents_docs/changes/`
- 삭제: `subagents_docs/evaluations/`

### 검증

- `find subagents_docs -maxdepth 2 -type d | sort`
- 결과에서 `subagents_docs/cycles/`만 남고 세 legacy 디렉토리가 사라진 것을 확인했다.

### 남은 위험/제약

- historical cycle 문서와 과거 검증 기록에는 삭제된 경로 literal이 계속 남아 있을 수 있다.
- 사용자 요청 범위대로 dead reference 정리나 historical 문서 rewrite는 수행하지 않았다.

### 다음 handoff

- evaluator가 세 legacy 디렉토리가 실제로 제거됐는지와 current repo active baseline이 `subagents_docs/cycles/` 중심으로 유지되는지 확인한다.

## Evaluator v1

### 결과

- PASS

### planner section reference

- `Planner v2`

### generator section reference

- `Generator v1`

### 검증 절차

- `git diff --check`
- `find subagents_docs -maxdepth 2 -type d | sort`
- `test ! -d subagents_docs/plans && test ! -d subagents_docs/changes && test ! -d subagents_docs/evaluations`
- `test ! -d subagents_docs/archive`
- `git diff --name-status -- subagents_docs`
- `sed -n '1,220p' subagents_docs/AGENTS.md`
- `git diff --name-status -- hs-init-project`

### acceptance criteria 판정

- `subagents_docs/plans/`, `subagents_docs/changes/`, `subagents_docs/evaluations/`는 현재 저장소에서 제거됐다.
- `subagents_docs/archive`는 생성되지 않았다.
- active top-level `subagents_docs/` 구조는 `subagents_docs/cycles/` 중심으로 정리돼 있다.
- 이번 cleanup cycle의 planner/generator 기록과 `subagents_docs` 범위 diff 기준으로, cycle 자체는 generated-skill 변경 없이 current repo cleanup에 머물렀다.

### findings

- 없음.
- `find subagents_docs -maxdepth 2 -type d | sort` 결과는 `subagents_docs/`와 `subagents_docs/cycles/`만 남는다.
- `test ! -d ...` 검증으로 세 legacy 디렉토리와 `subagents_docs/archive`가 모두 없음을 확인했다.
- `git diff --name-status -- subagents_docs`는 legacy 디렉토리 삭제와 `subagents_docs/AGENTS.md` 수정만 보여 준다.
- `git diff --name-status -- hs-init-project`에는 기존 워크트리 수정이 남아 있지만, 이는 이번 cycle의 current-repo-only cleanup 범위와 별개의 선행 변경으로 보인다.
- historical cycle 문서 안에 삭제된 경로 literal이 남아 있을 수 있다는 점은 planner 지시대로 out-of-scope risk이며, 이번 explicit delete 요청의 자동 실패 조건으로 보지 않았다.

### 품질 평가

- design quality: PASS
- originality: PASS
- completeness: PASS
- functionality: PASS

### 다음 handoff

- 없음. cycle 종료.
