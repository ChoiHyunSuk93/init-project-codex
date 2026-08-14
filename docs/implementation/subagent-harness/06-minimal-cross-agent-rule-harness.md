# 최소 Cross-Agent 규약 하네스

## 요약

`hs-init-project`의 기본 생성물을 프로젝트별 확장 없이 사용할 수 있는 최소 규약 하네스로 축소했다.
Codex와 Claude Code는 같은 `AGENTS.md`, `PROJECT_OVERVIEW.md`, 다섯 rule을 공유하고 제품별 차이는 얇은 진입점에서만 처리한다.

## 변경 내용

- 범용 planner/generator/evaluator custom agent, starter skill, `.codex/config.toml` 생성을 제거했다.
- 기본 generated rule을 structure, development, testing, documentation, agent workflow 다섯 관심사로 통합했다.
- `--target codex|claude|both`, `--project-mode fresh|existing`, `--readme-mode create|merge|preserve` 계약을 도입했다.
- materializer를 asset template 기반 renderer로 재작성하고 dry-run, preserve, atomic conflict, README marker merge와 symlink guard를 추가했다.
- Claude Code용 `CLAUDE.md` adapter와 현재 저장소의 root adapter를 추가했다.
- direct installer의 `latest` 오해와 stale release ref를 제거하고 `.agents/skills/` 설치 경로로 정렬했다.
- PR과 release workflow가 같은 저장소 소유 E2E validation suite를 실행하도록 했다.

## 이유

보편적인 분석, 구현, 테스트, 검토 역량은 현재 agent 제품이 기본 제공하므로 저장소마다 같은 custom agent와 skill을 복제할 필요가 줄었다.
이 skill은 프로젝트 전용 자동화를 미리 만드는 대신, 어떤 프로젝트에서도 발견 가능한 최소 작업 기준과 안전한 retrofit 동작만 책임진다.

## 검증

- skill `quick_validate.py`: PASS
- `validate_scaffold.py`: 30 checks, 0 skipped, PASS
- fresh/existing, KO/EN, codex/claude/both 생성 matrix: PASS
- README preserve/merge, unexpected overwrite, invalid marker, symlink destination, explicit preserve guard: PASS
- Python compile, shell syntax, workflow/metadata YAML parse, Markdown link/index, `git diff --check`: PASS
- 독립 read-only evaluation: PASS
- GitHub-hosted Actions, 실제 release/tag와 updater network 동작은 이번 local 검증 범위에서 제외했다.

## 관련 규칙

- [`rule/rules/subagent-orchestration.md`](../../../rule/rules/subagent-orchestration.md)
- [`rule/rules/project-structure.md`](../../../rule/rules/project-structure.md)
- [`rule/rules/testing-standards.md`](../../../rule/rules/testing-standards.md)
- [`subagents_docs/cycles/33-minimal-cross-agent-rule-harness.md`](../../../subagents_docs/cycles/33-minimal-cross-agent-rule-harness.md)
