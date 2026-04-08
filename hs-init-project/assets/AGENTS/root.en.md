# Repository Instructions

This file defines repository-wide Codex guidance.
Keep this file thin and use it to route work to [`rule/index.md`](rule/index.md) and the detailed documents under `rule/rules/`.

## Role Of This File

- Define project-wide instruction boundaries.
- Point to [`rule/index.md`](rule/index.md) and the authoritative rule documents in `rule/rules/`.
- Do not duplicate detailed rules that belong in rule documents or local instruction files.

## Rule Model

- Treat [`rule/index.md`](rule/index.md) as the discovery point for authoritative rule documents.
- Read the relevant `rule/rules/*.md` documents before changing project structure or writing new long-lived docs.
- Use [`rule/rules/rule-maintenance.md`](rule/rules/rule-maintenance.md) when adding, deleting, renaming, or moving rule documents.
- Update [`rule/index.md`](rule/index.md) whenever rule documents are added, removed, renamed, or moved.

## Scope Model

- This root file applies repository-wide.
- A local `AGENTS.md` may narrow or extend instructions for its own directory scope.
- Local instruction files should refine local behavior, not restate repository-wide rules without a reason.

## Document Roles

- `rule/` contains authoritative Codex execution rules.
- `docs/guide/` contains user-facing guides for real project workflows.
- `docs/implementation/` contains human-facing final briefings and outcomes only.
- `subagents_docs/` contains planner, generator, and evaluator working documents.

## Documentation Automation

- Keep the root [`README.md`](README.md) current as the primary human-facing summary of the repository.
- In fresh repositories, start [`README.md`](README.md) from a minimal template and replace placeholders as the real project purpose becomes known.
- In existing repositories, update [`README.md`](README.md) from observed project structure and durable project facts instead of inventing missing details.
- When work creates or changes a stable user-facing workflow, such as running, deploying, testing, operations, or request intake, create or update the relevant guide document under `docs/guide/`.
- Do not create guide documents from repository structure summaries, project rules, test directory inventories, or implementation notes alone.
- For every plan cycle that evaluator passes, create or update the corresponding final briefing inside the most relevant concern-based category under `docs/implementation/`.
- Keep working plans, generator change notes, and evaluator reports under `subagents_docs/` instead of `docs/implementation/`.
- For behavior changes, add or update the most relevant test layer when practical and keep [`rule/rules/testing-standards.md`](rule/rules/testing-standards.md) aligned with real test conventions as they emerge.
- When a rule gains new explicit requirements or an existing rule changes, follow [`rule/rules/rule-maintenance.md`](rule/rules/rule-maintenance.md) so the relevant rule document and [`rule/index.md`](rule/index.md) are updated in the same change.
- When project-specific implementation standards become clearer, update [`rule/rules/development-standards.md`](rule/rules/development-standards.md) so it reflects observed conventions instead of generic defaults.
- If starter rules still contain placeholders, replace them with observed values once the real structure or boundaries become known.

## Skill Work

- If this repository contains Codex skills or a new skill is being created, use `skill-creator`.
- Write each skill with clear `SKILL.md` descriptions and aligned metadata.
- Unless explicit-only behavior is requested, set `policy.allow_implicit_invocation: true` in each skill's `agents/openai.yaml`.
- If the repository ships starter local skills under `.codex/skills/`, keep their `SKILL.md` descriptions, metadata, and `allow_implicit_invocation` setting aligned.
- Have each skill reference the relevant `rule/rules/*.md` documents instead of copying stable repository-wide rules into the skill body.

## Subagent Harness

- This repository uses an adaptive harness rather than one fixed planner / generator / evaluator pipeline. Read [`rule/rules/subagent-orchestration.md`](rule/rules/subagent-orchestration.md) first.
- The main agent chooses the path by task size and ambiguity, keeps plan approval and integration responsibility, and may autonomously invoke subagents when needed.
- For document analysis, prefer parallel `explorer` calls when the questions are independent.
- Do not start the implementation cycle for analysis-only, question-only, review-only, or explanation-only requests.
- The coordinator may wait as long as needed for subagent output, but it must close completed or no-longer-needed threads after integrating their outputs.
- If stale sessions or thread limits block new delegation, perform thread cleanup before continuing.
- Use [`rule/rules/cycle-document-contract.md`](rule/rules/cycle-document-contract.md) for exact cycle file paths, header transitions, append-only section rules, provenance, and dirty-worktree evaluation requirements.
- Use [`rule/rules/language-policy.md`](rule/rules/language-policy.md) for document-language and stable filename/path rules.
- Generated `.codex/agents/*.toml` should default to `model_reasoning_effort = "high"` and allow task-specific adjustment.
- Keep `.codex/agents/*.toml` and [`subagents_docs/AGENTS.md`](subagents_docs/AGENTS.md) aligned with those authoritative rules.
- Keep `subagents_docs/` for working records and keep `docs/implementation/` as the user-facing summary layer for passed cycles only.

## Language Policy

- Follow [`rule/rules/language-policy.md`](rule/rules/language-policy.md) for exact language and path rules.
- Keep `.codex/` and its agent files in English.

## Non-Duplication

- Keep this file thin as the project evolves.
- Move stable, detailed guidance into `rule/rules/*.md`.
- Add local `AGENTS.md` files only where they improve scope clarity.
