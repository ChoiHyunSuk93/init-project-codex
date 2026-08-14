---
name: hs-init-project
description: Initialize or retrofit a repository with a minimal, product-neutral agent rule harness. Use when Codex should create thin AGENTS.md or CLAUDE.md entrypoints, PROJECT_OVERVIEW.md, and a small indexed rule set for a new or existing project while preserving existing content and avoiding project-specific stacks, custom agents, or generic starter skills.
---

# Initialize A Project Rule Harness

Create the smallest durable instruction structure that lets coding agents discover project requirements and rules. Treat project-specific agents, skills, tooling, CI, and product architecture as later project work.

Read [references/language-output.md](references/language-output.md) when choosing document language.
Read [references/structure-initialization.md](references/structure-initialization.md) before inspecting or materializing a repository.
Read [references/subagent-orchestration.md](references/subagent-orchestration.md) when writing the generated agent workflow rule.

## Intent Gate

- Do not edit files for review-only, question-only, comparison, or explanation requests.
- Start materialization only when the user explicitly requests initialization, creation, retrofit, update, or implementation.
- If language is clear from the request or session, use it. Otherwise ask once before writing user-facing documents.

## Workflow

1. Inspect the repository.
   - Determine whether it is fresh or existing.
   - Find current instruction files, overview documents, rule trees, README content, source areas, tests, and user-owned documentation.
   - Do not infer a single source root when the repository is a monorepo or has multiple intentional runtime roots.
2. Select explicit inputs.
   - `target`: `codex`, `claude`, or `both`
   - `language`: `en` or `ko`
   - `project-mode`: `fresh` or `existing`
   - `readme-mode`: `create`, `merge`, or `preserve`
3. Preview the materialization.
   - Run `scripts/materialize_repo.sh` with `--dry-run` first.
   - In existing repositories, default to `--readme-mode preserve` unless the user explicitly wants the managed README section.
   - Resolve file conflicts before using `--overwrite`.
4. Materialize the minimal structure.
5. Replace template placeholders only with user-provided or observed facts.
6. Validate generated links, the five-rule index, language/target output, and preservation behavior.
7. Report created, updated, preserved, and unresolved paths separately.

## Generated Baseline

Always generate:

- `AGENTS.md`
- `PROJECT_OVERVIEW.md`
- `rule/index.md`
- `rule/rules/project-structure.md`
- `rule/rules/development-standards.md`
- `rule/rules/testing-standards.md`
- `rule/rules/documentation.md`
- `rule/rules/agent-workflow.md`

Generate `CLAUDE.md` only for `target=claude` or `target=both`. It must remain a thin adapter that imports `AGENTS.md` and points to `rule/index.md`.

Handle `README.md` according to `readme-mode`:

- `create`: create the template; refuse to replace an existing README without `--overwrite`
- `merge`: preserve existing content and append or refresh only the marked harness section
- `preserve`: do not write the README

## Explicit Non-Outputs

Do not generate these as baseline infrastructure:

- `.codex/config.toml`
- `.codex/agents/` or `.claude/agents/`
- `.agents/skills/`, `.codex/skills/`, or `.claude/skills/`
- `subagents_docs/`, roadmaps, cycles, or implementation histories
- package manifests, stack choices, hooks, permissions, CI, or product features

Create any of those later only when the target project has a concrete, project-specific need and the user authorizes that work.

## Rule Contract

- Keep `AGENTS.md` thin and route detailed behavior through `rule/index.md`.
- Keep exactly five baseline rule concerns: structure, development, testing, documentation, and agent workflow.
- Prefer observed repository conventions over generic defaults.
- Keep analysis and implementation intent distinct.
- Use subagents only when independent exploration, bounded parallel work, or risk-based independent validation materially helps.
- Do not require a fixed planner/generator/evaluator pipeline.
- Keep shared working documents coordinator-owned when parallel agents are involved.
- Prioritize correctness, acceptance criteria, safety, regression coverage, and verification evidence over novelty.

## Existing Repository Safety

- Preserve meaningful existing files by default.
- Never overwrite the complete README as a side effect of choosing existing-project mode.
- Never reinterpret existing `docs/`, `rule/`, source, test, or instruction paths without inspecting them.
- `--overwrite` applies only to files selected for materialization; `--preserve PATH` always wins.
- Use `--dry-run` to show the exact plan before writing.
- If a conflict cannot be resolved from observed facts, ask the smallest necessary question.

## Semantic Completion

The materializer creates deterministic templates; it does not know the user's requirements by itself.

- In fresh projects, adapt `PROJECT_OVERVIEW.md` from the user's stated purpose and keep unknowns explicit.
- In existing projects, refine it only from observed modules, workflows, tests, docs, and current requested work.
- Keep a meaningful existing overview unless the user requested replacement.
- Do not claim commands, frameworks, architecture, users, or delivery surfaces that were not observed.

## Validation

Before finishing:

```bash
python3 /path/to/skill-creator/scripts/quick_validate.py hs-init-project
sh -n hs-init-project/scripts/materialize_repo.sh
python3 hs-init-project/scripts/validate_scaffold.py
git diff --check
```

Use the installed `skill-creator` path available in the current environment. Also inspect `git diff --stat` and the generated-file inventory so deleted baseline components cannot silently return.
