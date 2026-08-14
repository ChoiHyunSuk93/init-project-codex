---
name: hs-init-project
description: Initialize or retrofit a new or existing repository with thin Codex or Claude entrypoints, PROJECT_OVERVIEW.md, indexed rules, human-facing docs, and adaptive work records. Use when Codex must create a durable project harness and, for an existing codebase, inspect real source, configuration, tests, commands, and documentation before replacing template placeholders with observed project facts.
---

# Initialize A Project Harness

Create a small, product-neutral harness that records project facts, guides agent work, and preserves both in-progress work provenance and verified implementation history. Treat stack choices, product features, CI, and project-specific agents or skills as later project work.

Read [references/language-output.md](references/language-output.md) when choosing document language.
Read [references/structure-initialization.md](references/structure-initialization.md) before inspecting or materializing a repository.
Read [references/existing-project-analysis.md](references/existing-project-analysis.md) for every existing-project initialization.
Read [references/subagent-orchestration.md](references/subagent-orchestration.md) when writing the generated agent workflow and work-record rules.

## Intent Gate

- Do not edit files for review-only, question-only, comparison, or explanation requests.
- Start materialization only when the user explicitly requests initialization, creation, retrofit, update, or implementation.
- If language is clear from the request or session, use it. Otherwise ask once before writing user-facing documents.

## Workflow

1. Inspect before writing.
   - Determine whether the repository is fresh or existing.
   - Find instruction files, overview documents, README content, source areas, manifests, runtime entrypoints, tests, automation, and user-owned documentation.
   - Do not treat directory names alone as source analysis or force one source root on a monorepo.
2. Select explicit inputs.
   - `target`: `codex`, `claude`, or `both`
   - `language`: `en` or `ko`
   - `project-mode`: `fresh` or `existing`
   - `readme-mode`: `create`, `merge`, or `preserve`
3. Preview with `scripts/materialize_repo.sh --dry-run` and resolve every conflict.
   - In existing repositories, default to `--readme-mode preserve`.
   - Preserve meaningful existing control documents unless replacement or merge is explicitly authorized.
4. Materialize the baseline structure.
5. Complete the project semantics.
   - In fresh projects, replace semantic markers from the user's stated purpose and keep genuinely unknown facts explicit.
   - In existing projects, follow [references/existing-project-analysis.md](references/existing-project-analysis.md), read representative real source and configuration, and trace observed run/build/test entrypoints.
   - Update `PROJECT_OVERVIEW.md`, `docs/guide/README.md`, `subagents_docs/roadmap.md`, and relevant generated rules with observed or user-provided facts.
   - Do not finish with placeholder markers, directory-only inventories, or unverified commands.
6. Validate semantic completion.

   ```bash
   python3 /path/to/hs-init-project/scripts/validate_materialized_repo.py \
     --root <repo> \
     --project-mode fresh|existing
   ```

7. Report created, updated, preserved, unresolved, and evidence-bearing paths separately.

## Generated Baseline

Always generate:

- `AGENTS.md`
- `PROJECT_OVERVIEW.md`
- `rule/index.md` and five rules for structure, development, testing, documentation, and agent workflow
- `docs/guide/README.md`
- `docs/implementation/AGENTS.md`
- `subagents_docs/AGENTS.md`
- `subagents_docs/roadmap.md`
- `subagents_docs/cycles/` as the location for work-sharing or audit-worthy cycle records

Generate `CLAUDE.md` only for `target=claude` or `target=both`. Keep it as a thin adapter that imports `AGENTS.md` and routes to `rule/index.md`.

Handle `README.md` according to `readme-mode`:

- `create`: create the template; refuse to replace an existing README without `--overwrite`
- `merge`: preserve existing content and append or refresh only the marked harness section
- `preserve`: do not write the README

## Explicit Non-Outputs

Do not generate these as baseline infrastructure:

- `.codex/config.toml`
- `.codex/agents/` or `.claude/agents/`
- `.agents/skills/`, `.codex/skills/`, or `.claude/skills/`
- package manifests, stack choices, hooks, permissions, CI, or product features

Add those only after the target project demonstrates a concrete need and the user authorizes the work.

## Work Record Contract

- Keep durable requirements in `PROJECT_OVERVIEW.md` and phase status in `subagents_docs/roadmap.md`.
- For medium or larger changes, explicit work-sharing, multiple handoffs, or audit-worthy state transitions, create `subagents_docs/cycles/<NN>-<slug>.md`.
- Keep cycle sections append-only as `Planner vN`, `Generator vN`, and `Evaluator vN`; record whether the main agent or a delegated agent produced each result.
- Keep the cycle header and shared roadmap coordinator-owned. Delegated agents return results instead of editing shared records.
- After acceptance criteria and required verification pass, add a concise user-facing record under the nearest `docs/implementation/<category>/NN-name.md` category.
- Small direct changes without shared handoff may omit a cycle. Do not create empty implementation records in advance.

## Existing Repository Safety

- Preserve meaningful existing files by default.
- Never overwrite the complete README merely because existing-project mode was selected.
- Never reinterpret existing `docs/`, `rule/`, source, test, or instruction paths without inspecting them.
- `--overwrite` applies only to selected materialization paths; `--preserve PATH` always wins.
- Use `--dry-run` to show the exact plan before writing.
- If observed facts cannot resolve a material conflict, ask the smallest necessary question.

## Semantic Completion

The materializer creates deterministic templates; the invoking agent owns factual completion.

- Preserve and refine a meaningful existing overview instead of replacing it with a generic template.
- Cite real repository-relative paths in the overview's observed-evidence block.
- Record only commands confirmed in manifests, task definitions, CI, scripts, or existing documentation.
- Mark a fact as unresolved when evidence is insufficient; never invent frameworks, architecture, users, or delivery surfaces.
- Do not report initialization complete until `validate_materialized_repo.py` passes.

## Skill Validation

Before finishing changes to this skill:

```bash
python3 /path/to/skill-creator/scripts/quick_validate.py hs-init-project
sh -n hs-init-project/scripts/materialize_repo.sh
python3 -m py_compile \
  hs-init-project/scripts/validate_materialized_repo.py \
  hs-init-project/scripts/validate_scaffold.py
python3 hs-init-project/scripts/validate_scaffold.py
git diff --check
```

Use the installed `skill-creator` path available in the current environment. Inspect `git diff --stat` and the generated-file inventory so required documentation and work-record paths cannot silently disappear again.
