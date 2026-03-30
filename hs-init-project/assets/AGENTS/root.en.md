# Repository Instructions

This file defines repository-wide Codex guidance.
Keep this file thin and use it to route work to `rule/index.md` and the detailed documents under `rule/rules/`.

## Role Of This File

- Define project-wide instruction boundaries.
- Point to `rule/index.md` and the authoritative rule documents in `rule/rules/`.
- Do not duplicate detailed rules that belong in rule documents or local instruction files.

## Rule Model

- Treat `rule/index.md` as the discovery point for authoritative rule documents.
- Read the relevant `rule/rules/*.md` documents before changing project structure or writing new long-lived docs.
- Use `rule/rules/rule-maintenance.md` when adding, deleting, renaming, or moving rule documents.
- Update `rule/index.md` whenever rule documents are added, removed, renamed, or moved.

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

- Keep the root `README.md` current as the primary human-facing summary of the repository.
- In fresh repositories, start `README.md` from a minimal template and replace placeholders as the real project purpose becomes known.
- In existing repositories, update `README.md` from observed project structure and durable project facts instead of inventing missing details.
- When work creates or changes a stable user-facing workflow, such as running, deploying, testing, operations, or request intake, create or update the relevant guide document under `docs/guide/`.
- Do not create guide documents from repository structure summaries, project rules, test directory inventories, or implementation notes alone.
- For every plan cycle that evaluator passes, create or update the corresponding final briefing inside the most relevant concern-based category under `docs/implementation/`.
- Keep working plans, generator change notes, and evaluator reports under `subagents_docs/` instead of `docs/implementation/`.
- For behavior changes, add or update the most relevant test layer when practical and keep `rule/rules/testing-standards.md` aligned with real test conventions as they emerge.
- When a rule gains new explicit requirements or an existing rule changes, follow `rule/rules/rule-maintenance.md` so the relevant rule document and `rule/index.md` are updated in the same change.
- When project-specific implementation standards become clearer, update `rule/rules/development-standards.md` so it reflects observed conventions instead of generic defaults.
- If starter rules still contain placeholders, replace them with observed values once the real structure or boundaries become known.

## Skill Work

- If this repository contains Codex skills or a new skill is being created, use `skill-creator`.
- Write each skill so it can be invoked both explicitly by name and implicitly by matching task descriptions through clear `SKILL.md` descriptions and metadata.
- Unless explicit-only behavior is requested, set `policy.allow_implicit_invocation: true` in each skill's `agents/openai.yaml`.
- Have each skill reference the relevant `rule/rules/*.md` documents instead of copying stable repository-wide rules into the skill body.

## Subagent Harness

- When a task should use a planner / generator / evaluator workflow, read `rule/rules/subagent-orchestration.md` first.
- The main agent is orchestration-only in that workflow: it coordinates handoffs and does not directly become planner, generator, or evaluator unless the user explicitly waives the split.
- Run the harness in `planner -> generator -> evaluator` order.
- The evaluator judges the implemented result against the plan and acceptance criteria, and only evaluator-reported failures or blockers send the cycle back to planner.
- Keep the three roles separate and do not let one role edit another role's owned outputs.
- If subagents are slow, wait or re-plan instead of directly implementing in their place.
- When the harness is active, keep `.codex/agents/*.toml`, `docs/guide/subagent-workflow.md`, and the related rules aligned.
- When the harness is active, keep `subagents_docs/` aligned with the plan cycle outputs and keep `docs/implementation/` as the user-facing summary layer through concern-based categories.

## Language Policy

- Write human-facing generated documents in English.
- Keep `subagents_docs/` working documents in the selected language.
- Keep control filenames stable: `README.md`, `AGENTS.md`, `rule/index.md`.
- Keep indexed rule documents under `rule/rules/*.md`.
- Keep directory names in English.
- Keep code, commands, config keys, slugs, and path literals in English.
- Keep rule document paths stable in English where predictable pathing matters.
- Keep `.codex/` and its agent files in English.

## Non-Duplication

- Keep this file thin as the project evolves.
- Move stable, detailed guidance into `rule/rules/*.md`.
- Add local `AGENTS.md` files only where they improve scope clarity.
