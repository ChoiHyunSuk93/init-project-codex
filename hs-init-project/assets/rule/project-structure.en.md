# Project Structure Rule

## Purpose

Define the top-level directory model for this repository and make the role of each major area explicit.

## Top-Level Areas

- [`AGENTS.md`](../../AGENTS.md): repository-wide orchestration guidance
- [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md): project-wide requirements and core-flow authority
- `.codex/`: project-scoped Codex configuration, planner/generator/evaluator definitions, and starter local skills
- `rule/`: authoritative Codex execution rules, with [`rule/index.md`](../index.md) as the discovery entry point
- `subagents_docs/`: planner, generator, and evaluator working documents, with [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md) as the control file and [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md) as the phase roadmap
- `docs/guide/`: user-facing workflow guides, with [`docs/guide/README.md`](../../docs/guide/README.md) as the default entry point
- `docs/implementation/`: human-facing implementation records, with [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md) as the control file

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
- Reflect actual top-level structure changes in [`rule/rules/project-structure.md`](project-structure.md).
- When requirements flow or phase structure changes, update [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md) and [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md) in the same work.
- Do not move or rename established top-level areas without updating [`rule/index.md`](../index.md) and related `rule/rules/*.md` documents.
- When local structure becomes complex, add local instruction files only where they improve scope clarity.
