# Project Structure Rule

## Purpose

Define the top-level directory model for this repository and make the role of each major area explicit.

## Top-Level Areas

- `AGENTS.md`: repository-wide orchestration guidance
- `.codex/`: project-scoped Codex configuration, planner/generator/evaluator definitions, and starter local skills
- `rule/`: authoritative Codex execution rules
- `subagents_docs/`: planner, generator, and evaluator working documents
- `docs/guide/`: user-facing workflow guides
- `docs/implementation/`: human-facing implementation records

## Source Root Area

List the single source-root directory that groups implementation areas under the project root.

Example placeholder:

- `[source-root-directory]`

## Non-Runtime Areas

List the directories treated as non-runtime here.

Example placeholder:

- `.codex/`
- `rule/`
- `subagents_docs/`
- `docs/`
- `[non-runtime-directory]`

## Change Rules

- Keep runtime and non-runtime boundaries explicit.
- Do not spread multiple top-level runtime directories directly under the project root; keep implementation areas under one source root.
- Replace placeholder entries with observed paths once the real directory structure becomes known.
- Reflect actual top-level structure changes in `rule/rules/project-structure.md`.
- Do not move or rename established top-level areas without updating `rule/index.md` and related `rule/rules/*.md` documents.
- When local structure becomes complex, add local instruction files only where they improve scope clarity.
