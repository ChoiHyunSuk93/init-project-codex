# Repository Guide

This repository develops the `hs-init-project` Codex skill.
Keep this file thin and use `rule/index.md` as the discovery point for detailed rules.

## Scope

- Root guidance lives here.
- Authoritative detailed rules live in `rule/index.md` and `rule/rules/*.md`.
- Human-facing workflow docs live in `docs/guide/`.
- Human-facing final implementation briefings live in `docs/implementation/` as category-based records after evaluator pass.
- Subagents read and write working documents in `subagents_docs/`.
- The skill source of truth remains under `hs-init-project/`.

## Skill Scope

- `hs-init-project/SKILL.md` is the primary skill entry point.
- `hs-init-project/agents/openai.yaml` must stay aligned with `hs-init-project/SKILL.md`.
- Put detailed supporting behavior in `hs-init-project/references/`.
- Put reusable generation templates in `hs-init-project/assets/`.
- Put deterministic helper scripts in `hs-init-project/scripts/`.

## Subagent Harness

- This repository uses a role-separated `planner`, `generator`, `evaluator` workflow.
- The main agent is orchestration-only in that workflow: it coordinates the three roles, collects handoffs, and preserves order.
- The workflow order is `planner -> generator -> evaluator`.
- The evaluator assesses the implemented result against the plan and acceptance criteria.
- Re-planning happens only after evaluator findings identify failures or blockers in that implemented result.
- Read `rule/rules/subagent-orchestration.md` before spawning or coordinating subagents.
- Do not collapse planner, generator, and evaluator responsibilities into one role unless the user explicitly waives the split.
- Do not let the main agent directly become planner, generator, or evaluator by default.
- Do not place subagent working documents under `docs/implementation/`; use `subagents_docs/` instead.
- If subagents are slow, do not jump in and implement directly; wait for the role output or replan the cycle.

## Repository Rules

- Keep root documents human-facing and public-safe.
- Do not include local machine paths, private environment details, or maintainer-specific workflow notes in committed docs.
- Use `skill-creator` when changing the skill structure or metadata.
- Keep `SKILL.md` concise and move stable detail into `references/`.
- Add `assets/` or `scripts/` only when the output shape or workflow is stable enough to justify them.
- Validate skill changes before finishing.
- Keep open-source defaults minimal and maintainable.
- Do not invent project-specific stack choices, package files, CI, or features unless explicitly requested.
- Report observed results when changing GitHub workflow or repository policy.
