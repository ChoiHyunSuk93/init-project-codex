# PROJECT_NAME

Short description placeholder. Replace this sentence with a one-line summary of the project.
This repository uses the base Codex structure together with adaptive `planner` / `generator` / `evaluator` support.

## Purpose

Describe what this repository is for.

## Status

This repository has been freshly initialized with Codex-oriented working structure.
Update this README as the real project purpose, structure, and usage become concrete.

## Structure

- [`AGENTS.md`](AGENTS.md): repository-wide Codex guidance
- [`PROJECT_OVERVIEW.md`](PROJECT_OVERVIEW.md): requirements, core flows, constraints, and open questions authority
- `.codex/config.toml`: project-scoped agent runtime settings that are generated alongside `.codex/agents/*.toml`
- `.codex/agents/*.toml`: project-scoped planner, generator, and evaluator definitions
- `.codex/skills/`: starter local skills for change analysis, implementation, test/debug, docs sync, and quality review
- `subagents_docs/`: planner, generator, and evaluator working documents, with [`subagents_docs/AGENTS.md`](subagents_docs/AGENTS.md) as the control entry point and [`subagents_docs/roadmap.md`](subagents_docs/roadmap.md) as the phase roadmap
- `rule/`: authoritative Codex rules, with [`rule/index.md`](rule/index.md) as the discovery entry point
- `docs/guide/`: user-facing workflow guides, with [`docs/guide/README.md`](docs/guide/README.md) as the default entry point
- `docs/implementation/`: user-facing final briefings after evaluator-passed plan cycles, with [`docs/implementation/AGENTS.md`](docs/implementation/AGENTS.md) as the placement rule
- [`rule/rules/subagent-orchestration.md`](rule/rules/subagent-orchestration.md): role split and handoff rule

Use Markdown links in this README when pointing to real entrypoint or control documents.
Leave placeholders, wildcards, and not-yet-created paths as plain literals.

Generated repositories use [`PROJECT_OVERVIEW.md`](PROJECT_OVERVIEW.md) as the requirements baseline and [`subagents_docs/roadmap.md`](subagents_docs/roadmap.md) for phase-level roadmap and completion checklists. A dependent next phase must not start until the previous phase reaches `PASS` and its required checklist is satisfied.

Generated repositories use an adaptive harness rather than one fixed pipeline. Small changes can go through `main/generator -> evaluator`. Medium changes use `main(plan+implementation) -> evaluator`. Large but clear changes use main-led decomposition with delegated implementation slices and a separate evaluator. Large ambiguous changes start with parallel `explorer` analysis, may use planner assistance, then continue through a main-approved plan, delegated implementation, and separate evaluation. When a shared working record is needed, keep one append-only cycle document per roadmap phase under `subagents_docs/cycles/`. Generated `.codex/agents/*.toml` should default to `model_reasoning_effort = "high"` and allow task-specific adjustment. The evaluator checks the implemented result against the plan and acceptance criteria with the strongest feasible validation by directly exercising the representative user surface when one exists. For web work that means browser UI, for apps a simulator or runtime, for games a runtime or scene, and for CLI/API work the real entrypoint or request/response flow. If a critical surface cannot be exercised directly, the evaluator records why and the remaining gap instead of soft-passing. `FAIL` restarts the cycle in the same phase unless the blocker truly requires new external input. Generated repositories include `.codex/config.toml`, `.codex/agents/*.toml`, and process-oriented starter local skills under `.codex/skills/`. In existing-project mode, inspection results make starter skills and selected README/rule/guide outputs more specific to the observed repository.

## Usage

Add real setup and usage instructions once the project has working behavior to document.
