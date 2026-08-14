# 문서와 Existing-Project Semantic Retrofit 복구

## 요약

`hs-init-project`가 다시 `docs/`와 adaptive 작업 기록을 생성하고, 기존 코드 프로젝트에서는 실제 source/config/test/docs 분석 결과를 반영해야만 초기화를 완료하도록 복구했다.

## 변경 내용

- `docs/guide/README.md`, `docs/implementation/AGENTS.md`, `subagents_docs/AGENTS.md`, `subagents_docs/roadmap.md` KO/EN 생성 asset을 추가했다.
- main agent와 delegated agent의 provenance를 append-only cycle에 누적하고, 검증 완료 결과를 category 기반 implementation briefing으로 남기는 계약을 generated rule에 반영했다.
- existing-project용 실제 source entrypoint, 주요 module, manifest/config, command, test, 기존 docs 분석 절차를 별도 reference로 정의했다.
- materializer가 새 문서와 work-record 경로를 dry-run, conflict, preserve, atomic safety 계약 안에서 생성하도록 확장했다.
- semantic completion validator와 raw-fail/evidence-pass E2E fixture를 추가했다.

## 이유

`v1.0.0`의 최소 하네스 전환은 custom agent 중복을 제거했지만, 필요한 문서 구조와 기존 프로젝트의 factual retrofit까지 함께 제거했다. 고정 custom agent를 되살리지 않으면서 실제 프로젝트 맥락과 작업 이력을 보존할 수 있도록 책임 경계를 다시 설정했다.

## 검증

- skill `quick_validate.py`: PASS
- materializer `sh -n`: PASS
- Python validator compile: PASS
- `validate_scaffold.py`: 34 checks, 0 skipped, PASS
- fresh/existing, KO/EN, codex/claude/both 생성 matrix: PASS
- raw existing semantic failure 및 source/config/test evidence completion: PASS
- README preserve/merge, atomic conflict, symlink, explicit preserve: PASS
- `git diff --check`: PASS

외부 GitHub 설치, hosted Actions와 release/tag는 이번 검증 범위에 포함하지 않았다.

## 관련 규칙

- [`rule/rules/planning-roadmap.md`](../../../rule/rules/planning-roadmap.md)
- [`rule/rules/documentation-boundaries.md`](../../../rule/rules/documentation-boundaries.md)
- [`rule/rules/subagent-orchestration.md`](../../../rule/rules/subagent-orchestration.md)
- [`subagents_docs/cycles/34-documentation-semantic-retrofit.md`](../../../subagents_docs/cycles/34-documentation-semantic-retrofit.md)
