---
name: hs-init-project
description: Bootstrap Codex-oriented repository structure by first running project-scoped `omx setup`, then layering detailed rules, docs, and a team-first plus Ralph-led execution model around result briefings instead of repository working-doc logs.
---

# Init Project

## Critical First Turn

If no valid language selection is already present in the current request or session, the very first user-facing response must be exactly this plain-text message:

```text
1. English
2. Korean(한국어)
```

Do not add any other text.
Do not request a chooser, submit dialog, modal, or any other structured selection UI.
Do not inspect the repository first.
Do not read templates first.
Do not send progress updates first.
After printing the two lines, stop and wait for the answer.
Do not repeat the same question unless the user starts a new attempt.

## Overview

Initialize repository structure from the real current state, not from assumptions.
Support two modes: full initialization for near-empty repositories, and additive Codex-structure initialization for repositories that already contain source code, directories, or documentation.

This skill uses the user's OMX installation as the source of truth for project-scoped runtime scaffolding:

1. run `omx setup --scope project` inside the target repository
2. let OMX create or refresh the project-local `.codex/`, `.omx/`, prompts, skills, agents, and root `AGENTS.md`
3. create the repository-specific `rule/` and `docs/` structure
4. revise the OMX-generated root `AGENTS.md` so it references detailed rules, documentation boundaries, and the default team-first plus Ralph-led execution loop

The generated repository must treat team-based subagent separation as the core operating principle.
Default execution is `omx team` / `$team`, and the leader remains in a Ralph-style ownership loop until fresh evidence shows the cycle has passed.
Inside that team execution, planning, implementation, and evaluation are mandatory minimum distinct lanes or subagents.
Depending on task shape, additional specialist lanes may be added on top of that minimum split.
Repository working-doc directories are not required in this model; OMX runtime state under `.omx/` carries internal coordination, and the durable human-facing output is the final briefing under `docs/implementation/`.
When the selected language is Korean, the revised root `AGENTS.md` must also include Korean magic-keyword aliases alongside the default English OMX mappings.

Read [references/language-output.md](references/language-output.md) before generating any user-facing document.
Read [references/structure-initialization.md](references/structure-initialization.md) before materializing files.
Read [references/subagent-orchestration.md](references/subagent-orchestration.md) before generating workflow rules and guides.
Use `scripts/materialize_repo.sh` only after inspection and clarification are complete.
In existing repositories or uncertain structures, inspect first, ask the missing questions, then rerun the generator with resolved inputs.

## Workflow

1. Check whether the language is already fixed first.
   - If no valid language selection is already present, ask this plain-text question before any other clarification:
     ```text
     1. English
     2. Korean(한국어)
     ```
   - If no valid language selection is already present, the entire next user-facing message must be exactly those two lines and nothing else.
   - After printing the language question, stop and wait for the answer.
   - Do not inspect the repository, read templates, or emit progress updates before the language is fixed.
   - If the current request already includes a valid language selection such as `1`, `2`, `English`, or `Korean(한국어)`, do not ask again.
   - Use the selected language for generated documentation, all later clarification questions, and the root `AGENTS.md` overlay.
2. Classify the user intent before entering the implementation cycle.
   - If the user is asking for analysis, questions, review, explanation, comparison, or other non-implementation guidance, do not materialize files and do not enter the implementation flow.
   - Start materialization only when the user explicitly requests initialization, creation, change, update, fix, or repository generation.
   - If implementation intent is ambiguous, ask or answer analytically instead of guessing and editing files.
3. Inspect the repository before changing anything.
   - Check whether the project is effectively empty or already has meaningful structure.
   - Look for existing source directories, docs, AGENTS-like files, rule docs, runtime/non-runtime boundaries, and overwrite conflicts.
   - In existing-project mode, prefer an inspect pass first. Use `scripts/materialize_repo.sh --inspect` to gather runtime candidates, existing `docs/` and `rule/` signals, and overwrite conflicts before materializing files.
4. Stop on structural ambiguity by asking, not by abandoning the run.
   - If directory semantics, runtime boundaries, naming boundaries with existing directories, incorporation of existing `docs/` or `rule/` trees, or overwrite of existing control files are unclear, ask minimal clarification questions and wait.
   - Do not guess high-impact structure decisions.
5. Choose the operating mode.
   - Fresh mode: create the full base structure around a newly initialized project.
   - Existing-project mode: add Codex-compatible structure around the existing repository without arbitrary moves, renames, or destructive edits.
6. Run project-scoped OMX setup first.
   - After language and structural ambiguity are resolved, run `omx setup --scope project` in the target repository.
   - Treat the resulting project-local `.codex/`, `.omx/`, prompts, skills, agents, `.gitignore`, and root `AGENTS.md` as the baseline runtime scaffold.
   - Do not replace OMX-managed prompt, agent, or skill catalogs with skill-bundled copies.
7. Create the rule and documentation structure.
   - Create or update the root `README.md` as the primary human-facing repository summary.
   - Create `rule/index.md` as the authoritative discovery point for detailed rules.
   - Put detailed rule documents under `rule/rules/`.
   - Create starter rule documents from the language-appropriate templates in `assets/rule/`.
   - Create `docs/guide/README.md`, `docs/guide/subagent-workflow.md`, and `docs/implementation/AGENTS.md` by default.
   - Do not create `subagents_docs/` in the generated repository.
8. Revise the OMX root `AGENTS.md` after setup.
   - Keep the OMX-generated orchestration contract as the base.
   - Add a repository-specific overlay that points readers to `rule/index.md` and detailed `rule/rules/*.md` files.
   - Add documentation-boundary guidance so `rule/`, `docs/guide/`, and `docs/implementation/` stay distinct.
   - Set the default execution model to `omx team` / `$team` with the leader staying in a Ralph-owned verification loop until the cycle passes.
   - Add a clean-workspace preflight rule so dirty workspaces are committed before team launch by default.
   - Require fresh evidence before declaring completion or shutting down the team.
   - When the selected language is Korean, include Korean magic-keyword aliases in that revised root `AGENTS.md`.
9. Apply the required team-first / Ralph-led harness.
   - Follow [references/subagent-orchestration.md](references/subagent-orchestration.md) for the harness model and role boundaries.
   - The leader owns intake, acceptance criteria, staffing, team launch, PASS/FAIL judgment, and relaunch decisions.
   - `omx team` / `$team` is the default worker execution surface.
   - The leader must keep running team cycles until Ralph-style review passes with fresh evidence.
   - The durable user-facing output is the final briefing under `docs/implementation/` after PASS.

## Required Outputs

### OMX-Managed Baseline

These are expected from `omx setup --scope project` and should be treated as OMX-managed scaffolding:

- root `AGENTS.md` (later revised by this skill through a repository-specific overlay)
- project-local `.codex/`
- project-local `.omx/`
- refreshed project `.gitignore` when OMX adds `.omx/`

### Target Repository Outputs Added By This Skill

- root `README.md`
- `rule/index.md`
- `rule/rules/` with detailed starter rule documents
- `rule/rules/subagent-orchestration.md`
- `rule/rules/language-policy.md`
- `rule/rules/readme-maintenance.md`
- `rule/rules/development-standards.md`
- `rule/rules/testing-standards.md`
- `rule/rules/project-structure.md`
- `rule/rules/runtime-boundaries.md`
- `rule/rules/documentation-boundaries.md`
- `rule/rules/instruction-model.md`
- `rule/rules/rule-maintenance.md`
- `rule/rules/implementation-records.md`
- `docs/guide/README.md`
- `docs/guide/subagent-workflow.md`
- `docs/implementation/AGENTS.md`
- a revised OMX root `AGENTS.md` overlay that references detailed rules, the default team-first workflow, Ralph-led completion ownership, dirty-workspace commit gate, and Korean magic-keyword aliases when Korean mode is selected

### Skill-Bundled Resources

- canonical root README templates at `assets/README/root.en.md` and `assets/README/root.ko.md`
- repository-specific AGENTS overlay templates at `assets/AGENTS/root.en.md` and `assets/AGENTS/root.ko.md`
- canonical starter rule templates in `assets/rule/`
- canonical subagent workflow templates at `assets/docs/guide/subagent-workflow.en.md` and `assets/docs/guide/subagent-workflow.ko.md`
- deterministic generator script at `scripts/materialize_repo.sh`
- release-aware updater script at `scripts/update-skill-release.py`

## Guardrails

- Do not invent application features, stack choices, package files, or category names that are disconnected from observed repository concerns.
- Do not hand-author OMX-managed prompt, skill, agent, or config catalogs when `omx setup --scope project` is the source of truth.
- Do not create `subagents_docs/` or repository-owned working-record logs for the team runtime.
- Do not skip the root `AGENTS.md` revision step after OMX setup.
- Do not omit Korean magic-keyword aliases when the selected language is Korean.
- Do not flatten `docs/implementation/` unless the user explicitly asks for a flat layout.
- Do not pre-create empty implementation category directories or placeholder implementation records during initialization.
- Do not copy the skill's `assets/` directory into the target repository.
