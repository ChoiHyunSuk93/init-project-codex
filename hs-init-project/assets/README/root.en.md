# PROJECT_NAME

Short description placeholder. Replace this sentence with a one-line summary of the project.
This repository uses the base Codex structure together with a required role-separated `planner` / `generator` / `evaluator` harness.

## Purpose

Describe what this repository is for.

## Status

This repository has been freshly initialized with Codex-oriented working structure.
Update this README as the real project purpose, structure, and usage become concrete.

## Structure

- `AGENTS.md`: repository-wide Codex guidance
- `.codex/config.toml`: project-scoped agent runtime settings that are generated alongside `.codex/agents/*.toml`
- `.codex/agents/*.toml`: project-scoped planner, generator, and evaluator definitions
- `.codex/skills/`: starter local skills for change analysis, implementation, test/debug, docs sync, and quality review
- `subagents_docs/`: planner, generator, and evaluator working documents
- `rule/`: authoritative Codex rules
- `docs/guide/`: user-facing workflow guides
- `docs/guide/subagent-workflow.md`: user-facing harness workflow guide
- `docs/implementation/`: user-facing final briefings after evaluator-passed plan cycles
- `rule/rules/subagent-orchestration.md`: role split and handoff rule

Each plan runs in `planner -> generator -> evaluator` order. The main agent stays orchestration-only: it coordinates those roles and does not directly become planner, generator, or evaluator unless the user explicitly waives the split. The evaluator checks the implemented result against the plan and acceptance criteria, and only evaluator-reported failures or blockers send that plan back for re-planning. Generated repositories include `.codex/config.toml`, `.codex/agents/*.toml`, and process-oriented starter local skills under `.codex/skills/`. In existing-project mode, inspection results make starter skills and selected README/rule/guide outputs more specific to the observed repository.

## Usage

Add real setup and usage instructions once the project has working behavior to document.
