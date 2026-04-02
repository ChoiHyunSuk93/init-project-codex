# 프로젝트 구조 규칙

## 목적

이 저장소의 최상위 디렉토리 모델을 정의하고, 각 주요 영역의 역할을 분명하게 한다.

## 최상위 영역

- `AGENTS.md`: OMX가 생성한 root 계약과 저장소 전용 overlay
- `.codex/`: `omx setup --scope project`가 생성한 프로젝트 스코프 OMX 설치 영역
- `.omx/`: project-scoped runtime state, setup scope, team/Ralph 산출물 영역
- `rule/`: 저장소 전용 authoritative rule
- `docs/guide/`: 사용자-facing 안내 문서
- `docs/implementation/`: PASS 이후의 사용자-facing 최종 브리핑
