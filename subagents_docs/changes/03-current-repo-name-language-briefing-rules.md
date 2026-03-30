# 현재 저장소 skill명/언어/브리핑 규칙 정합성 반영

## 요약

이번 사이클에서 현재 저장소 기준 규칙을 정리해 `hs-init-project`로 통일했고, `subagents_docs/` 문서 언어를 실행 언어 기준으로 바인딩했습니다. 또한 planner→generator→evaluator의 pass-until-pass 순환에서 지연 시 직접 구현을 하지 않고 재계획 또는 대기 규칙을 명시해 적용했습니다.

## 작업 노트

- 실제 top-level skill 디렉터리를 `hschoi-init-project/`에서 `hs-init-project/`로 rename해 current-repo authoritative 문서와 저장소 표면의 경로를 일치시켰다.
- rename 이후 현재 저장소에서 직접 참조하는 README, Codex agent scope, skill self-identifier를 `hs-init-project` 기준으로 정리했다.
- `subagents_docs/` 문서 언어는 현재 실행 언어(이번 사이클은 한국어)로 작성·운영된다.
- generator가 구현 지연으로 판단되지 않더라도 코디네이터가 직접 개입해 코드를 수정하지 않고, subagent 출력 대기 또는 재계획을 한다.
- `docs/implementation/`은 카테고리 기반 사용자-facing 구현 브리핑 구조를 유지하고, 이 규칙 라운드에서는 `briefings/` 브랜치 생성을 도입하지 않는다.
- 역할 경계(기획/구현/평가)와 재작업 루프를 orchestration 룰 및 작업 문서에 반영한다.

## Generator 작업 노트 (docs)

- `docs/implementation/AGENTS.md`에서 `briefings/` 디렉터리 금지와 `docs/implementation/`의 카테고리형 간결 기록 원칙을 명시했다.
- `docs/implementation/subagent-harness/01-subagent-harness-redesign.md`, `02-subagent-harness-implementation.md`는 동일한 카테고리형 브리핑 방향으로 조정됐다.
- 이 작업은 generator 역할 범위 내에서 오직 지정된 파일만 편집해 완료했다.
