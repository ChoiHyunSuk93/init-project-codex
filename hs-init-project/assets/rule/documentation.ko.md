# 문서와 언어 규칙

## 권한과 역할

- [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md)는 목적, 범위, 제약의 기준 문서다.
- [`rule/index.md`](../index.md)는 실행 규칙의 탐색 시작점이고 `rule/rules/*.md`가 상세 기준이다.
- `README.md`는 사람이 읽는 현재 상태와 사용 진입점을 설명한다.
- 작업 계획, 임시 메모, 과거 구현 기록은 위 기준 문서에 섞지 않는다.

## 작성 원칙

- 현재 저장소와 사용자에게 확인한 사실만 적는다.
- 실제 파일은 Markdown link로 연결하고 placeholder와 아직 없는 경로는 literal로 둔다.
- 같은 규칙을 여러 문서에 복제하지 않고 authoritative 문서를 연결한다.
- 사용자-facing 문서는 선택된 언어로 작성하되 filename, directory, command, config key와 code identifier는 안정적인 영어 형태를 유지한다.
- 규칙을 추가, 삭제, 이름 변경, 이동할 때 [`rule/index.md`](../index.md)를 같은 변경에서 갱신한다.

## 갱신

- 동작, 진입점, 구조 또는 운영 사실이 바뀔 때 관련 현재 상태 문서를 갱신한다.
- 과거 이력 문서는 오기, 깨진 링크, 잘못된 검증 정보 또는 명시적 요청이 아니면 현재 상태에 맞춰 다시 쓰지 않는다.
- 문서 디렉터리는 실제 독자가 따라야 할 안정된 workflow가 있을 때만 만든다.
