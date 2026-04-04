---
name: hs-init-project
description: Bootstrap Codex-oriented repository structure for both brand-new and already-existing projects. Use when Codex needs to initialize or retrofit root and local AGENTS.md files, a root-level `rule/` directory with `rule/index.md` and `rule/rules/*.md`, human-facing docs structure, a single source-root plus non-runtime boundary model, and GitHub repository workflow policy without guessing ambiguous structural decisions or destructively rewriting existing project contents.
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

Initialize repository structure from the real current state, not from assumptions. Support two modes: full initialization for near-empty repositories, and additive Codex-structure initialization for repositories that already contain source code, directories, or documentation.
Every initialized repository must include the role-separated `planner` / `generator` / `evaluator` harness and a minimal starter local skill set under `.codex/skills/` as part of the baseline structure without changing the underlying README/rule/docs model.

Read [references/language-output.md](references/language-output.md) before generating any user-facing document.
Read [references/subagent-orchestration.md](references/subagent-orchestration.md) before generating the required planner / generator / evaluator harness.
Use `scripts/materialize_repo.sh` as a materialization step after inspection and clarification, not as a substitute for asking questions.
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
   - Keep the prompt plain text only. Do not request or describe a chooser, submit UI, dummy confirmation, or any other structured selection widget.
   - If the current request already includes a valid language selection such as `1`, `2`, `English`, or `Korean(한국어)`, do not ask again.
   - After a valid selection is made, do not repeat the question in the same session.
   - If the environment is non-interactive and no answer can be collected, ask once and stop instead of repeating the same prompt.
   - Use the selected language for generated documentation, `subagents_docs/` working documents, and all later clarification questions.
2. Classify the user intent before entering the implementation cycle.
   - If the user is asking for analysis, questions, review, explanation, comparison, or other non-implementation guidance, do not materialize files and do not enter planner -> generator -> evaluator implementation flow.
   - Start the implementation cycle only when the user explicitly requests initialization, creation, change, update, fix, or materialization, or when the task unambiguously requires repository changes.
   - If the implementation intent is ambiguous, ask or answer analytically instead of guessing and editing files.
3. Inspect the repository before changing anything.
   - Check whether the project is effectively empty or already has meaningful structure.
   - Look for existing source directories, docs, AGENTS-like files, rule docs, and whether there is already a clear single source-root plus non-runtime boundary.
   - Inspect the remote default branch and active GitHub protection system before changing workflow policy.
4. Stop on structural ambiguity by asking, not by abandoning the run.
   - If directory semantics, runtime boundaries, naming boundaries with existing directories, incorporation of existing `docs/` or `rule/` trees, or overwrite of existing control files are unclear, ask minimal clarification questions and wait.
   - Do not guess high-impact structure decisions.
   - Do not produce partial final structure when core structural decisions are unresolved.
   - Do not surface raw generator ambiguity as a final failure when the missing decision can be resolved by asking the user.
5. Choose the operating mode.
   - Fresh mode: create the full base structure from scratch.
   - Existing-project mode: add Codex-compatible structure around the existing repository without arbitrary moves, renames, or destructive edits.
   - In existing-project mode, prefer an inspect pass first. Use `scripts/materialize_repo.sh --inspect` to gather source-root candidates, existing `docs/` and `rule/` signals, and overwrite conflicts before materializing files.
   - After the user answers, rerun the generator with explicit confirmation flags such as `--source-root-dir`, `--confirm-existing-docs`, `--confirm-existing-rule`, and `--overwrite` as needed.
6. Apply the language policy to output.
   - Follow [references/language-output.md](references/language-output.md) for the language-selection flow and template-loading behavior.
   - Materialize `rule/rules/language-policy.md` and keep generated `AGENTS.md`, guide docs, and `subagents_docs/` aligned with that authoritative rule.
   - Read and use only the selected-language templates unless you are explicitly updating the skill itself.
   - Keep control filenames, directory names, code, commands, config keys, slugs, and predictable rule-path conventions aligned with the generated language rule.
7. Create the rule, subagent, and documentation structure.
   - Create `.codex/config.toml` and `.codex/agents/planner.toml`, `.codex/agents/generator.toml`, `.codex/agents/evaluator.toml` as required baseline files.
   - Create process-oriented starter local skills under `.codex/skills/change-analysis/`, `.codex/skills/code-implementation/`, `.codex/skills/test-debug/`, `.codex/skills/docs-sync/`, and `.codex/skills/quality-review/`, each with a thin `SKILL.md` and `agents/openai.yaml`.
   - Write those starter skills with clear task-matching descriptions, aligned metadata, and `policy.allow_implicit_invocation: true`.
   - Keep starter skill bodies thin and rule-referencing. Do not copy stable repository rules into the skill body.
   - In existing-project mode, use inspect results to make starter local skill bodies more specific from the observed source root, test/tooling signals, and docs structure without inventing unobserved details.
   - Create or update the root `README.md` as the primary human-facing repository summary.
   - In fresh mode, start `README.md` from a minimal template and keep placeholders explicit.
   - In existing-project mode, inspect the current project and write or refine `README.md` from observed purpose, major directories, existing docs, and current entry points without inventing missing details.
   - In existing-project mode, create focused `docs/guide/` documents only when inspection or existing docs reveal stable user-facing workflows that readers actually need.
   - Good guide targets include execution, deployment, test-running, operations, request intake, or design-request flows that a real reader can follow.
   - Do not create guide documents that merely summarize repository layout, runtime areas, tooling signals, test directory listings, project rules, or implementation details.
   - Create a thin root `AGENTS.md` that orchestrates more detailed rules instead of duplicating them.
   - Start the root file from the language-appropriate template in the skill's `assets/AGENTS/`.
   - Create `rule/index.md` as the authoritative discovery point for detailed rules.
   - Put detailed rule documents under `rule/rules/`.
   - Start `rule/index.md` from the language-appropriate template in the skill's `assets/rule/`, then adapt the entries to the repository's actual starter rules under `rule/rules/`.
   - Create starter rule documents under `rule/rules/` from the language-appropriate templates in the skill's `assets/rule/`.
   - Include a starter rule for rule maintenance and rule-index alignment unless the repository already has a stronger equivalent.
   - Include starter rules for root README maintenance and development standards unless the repository already has stronger equivalents.
   - Include a starter rule for unit-test and end-to-end test expectations unless the repository already has a stronger equivalent.
   - In fresh mode, make `rule/rules/development-standards.md` provisional and refine it as real stack, tooling, and structure conventions become concrete during ongoing work.
   - In existing-project mode, derive `rule/rules/development-standards.md` from observed project structure, naming patterns, tooling, automation, and verification commands instead of leaving it generic.
   - In fresh mode, make `rule/rules/testing-standards.md` provisional and refine it as real test paths, commands, and frameworks become concrete.
   - In existing-project mode, derive `rule/rules/testing-standards.md` from observed test directories, naming patterns, commands, and tooling instead of leaving it generic.
   - Include `rule/rules/subagent-orchestration.md` and `rule/rules/subagents-docs.md` in the starter rule set unless the repository already has stronger equivalents.
   - Create `subagents_docs/AGENTS.md` plus the `subagents_docs/cycles/` working area as baseline harness structure.
   - Default to `docs/guide/README.md` and `docs/implementation/AGENTS.md`.
   - When an implementation record is created, follow the rule-defined section shape directly, including unit-test, end-to-end test, manual-check, and gap notes in `Verification`; do not copy skill `assets/` into the target repository.
   - Do not create a target-repository `assets/` directory unless the user explicitly asked for project assets unrelated to this skill.
   - Do not pre-create empty implementation category directories during initialization.
   - Create other local `AGENTS.md` files only where they improve scope clarity.
   - Keep `rule/` authoritative for Codex execution. Treat `docs/guide/` and `docs/implementation/` as human-facing, not primary rule authority.
   - Put guidance into the generated `AGENTS.md` files stating that implementation categories are concern-based and chosen by Codex from observed repository structure.
8. Apply the required subagent harness.
   - Follow [references/subagent-orchestration.md](references/subagent-orchestration.md) for the harness model and role boundaries.
   - Materialize `rule/rules/cycle-document-contract.md` and keep generated cycle docs, prompts, and harness-related docs aligned with that authoritative rule.
   - The main agent stays orchestration-only: it coordinates planner/generator/evaluator handoffs and does not directly become one of those roles unless the user explicitly waives the split.
   - The main agent may wait as long as needed for subagent output, but it must close completed or no-longer-needed subagent threads after their outputs are integrated.
   - If stale sessions or thread-limit blockage prevent further delegation, treat thread cleanup as required orchestration work before continuing.
   - Re-run the same plan through planner -> generator -> evaluator until evaluator passes the implemented result.
   - When evaluator records `FAIL`, restart the cycle without asking the user again unless the blocker is truly missing external input.
   - Re-planning happens only after evaluator findings identify failures or blockers in the implemented result.
   - Do not create or update final `docs/implementation/` briefings from a plan-only or generator-only state.
   - Keep starter local skills aligned through clear `SKILL.md` descriptions, matching metadata, and `allow_implicit_invocation` support.
   - Split multiple plans into separate plan cycles; run them in parallel only when they are independent and in order when they are dependent.
   - Treat design quality and originality as higher-weight evaluation criteria than completeness and functionality.
9. Preserve existing projects carefully.
   - Prefer additive initialization.
   - Reuse meaningful existing structure where possible.
   - Ask before reinterpreting existing directory meaning or folding existing `docs/` or `rule/` trees into the new rule model.
   - If the inspect pass reports existing `docs/`, existing `rule/`, or generated-file overwrite conflicts, ask the user and continue after the answer instead of treating that state as terminal.
10. Derive implementation categories instead of outsourcing the decision.
   - Choose `docs/implementation/` categories from the repository's observed source areas, architecture boundaries, documentation domains, and recurring work streams when an implementation record is actually being written.
   - If the repository is new or sparse, do not pre-create placeholder categories. Defer category creation until the first implementation record is needed.
   - Avoid weak catch-all category names.
11. Configure GitHub workflow policy when the user asked for it.
   - Prefer the protection mechanism already in use by the repository.
   - Verify the observed remote state after every change.
   - Prefer non-destructive checks such as `git push --dry-run` when validating direct-push behavior.
12. Report exact observed state.
   - Distinguish between intended policy and observed remote behavior.
   - List what was created, what was preserved, what was left untouched, and what is blocked pending clarification.
   - If the run pauses for clarification, report the exact questions still pending and resume from those answers instead of restarting the entire workflow.

## Required Outputs

### Target Repository Outputs

- root `README.md`
- thin root `AGENTS.md`
- `.codex/config.toml`
- `.codex/agents/planner.toml`
- `.codex/agents/generator.toml`
- `.codex/agents/evaluator.toml`
- `.codex/skills/change-analysis/SKILL.md`
- `.codex/skills/change-analysis/agents/openai.yaml`
- `.codex/skills/code-implementation/SKILL.md`
- `.codex/skills/code-implementation/agents/openai.yaml`
- `.codex/skills/test-debug/SKILL.md`
- `.codex/skills/test-debug/agents/openai.yaml`
- `.codex/skills/docs-sync/SKILL.md`
- `.codex/skills/docs-sync/agents/openai.yaml`
- `.codex/skills/quality-review/SKILL.md`
- `.codex/skills/quality-review/agents/openai.yaml`
- `rule/index.md` with an explicit Markdown index
- `rule/rules/` with the detailed starter rule documents
- `rule/rules/subagent-orchestration.md`
- `rule/rules/subagents-docs.md`
- `rule/rules/cycle-document-contract.md`
- `rule/rules/language-policy.md`
- `subagents_docs/AGENTS.md`
- `subagents_docs/cycles/`
- `docs/guide/`
- `docs/implementation/` with category-based record placement rules instead of a flat history directory by default
- `docs/guide/README.md` by default
- focused guide documents under `docs/guide/` only when actual user-facing workflows justify them
- `docs/implementation/AGENTS.md` by default
- starter rule documents including `rule/rules/rule-maintenance.md`, `rule/rules/readme-maintenance.md`, `rule/rules/development-standards.md`, and `rule/rules/testing-standards.md`
- authoritative cycle and language rules at `rule/rules/cycle-document-contract.md` and `rule/rules/language-policy.md`
- other local `AGENTS.md` files where they reduce scope and context
- minimal but meaningful starter content in generated files
- no project-local `assets/` directory unless explicitly requested by the user

### Skill-Bundled Resources

- canonical root README templates at `assets/README/root.en.md` and `assets/README/root.ko.md`
- canonical root templates at `assets/AGENTS/root.en.md` and `assets/AGENTS/root.ko.md`
- canonical `.codex` harness templates at `assets/.codex/config.toml` and `assets/.codex/agents/*.toml`
- canonical starter local skill templates at `assets/.codex/skills/change-analysis/`, `assets/.codex/skills/code-implementation/`, `assets/.codex/skills/test-debug/`, `assets/.codex/skills/docs-sync/`, and `assets/.codex/skills/quality-review/`
- canonical starter templates at `assets/rule/index.en.md` and `assets/rule/index.ko.md`
- starter rule templates for the default rule set in `assets/rule/`
- canonical cycle and language rule templates at `assets/rule/cycle-document-contract.en.md`, `assets/rule/cycle-document-contract.ko.md`, `assets/rule/language-policy.en.md`, and `assets/rule/language-policy.ko.md`
- canonical `subagents_docs/AGENTS.md` templates at `assets/subagents_docs/AGENTS.en.md` and `assets/subagents_docs/AGENTS.ko.md`
- canonical implementation-record templates at `assets/docs/implementation/record.en.md` and `assets/docs/implementation/record.ko.md`
- deterministic generator script at `scripts/materialize_repo.sh`
- release-aware updater script at `scripts/update-skill-release.py`

Read [references/structure-initialization.md](references/structure-initialization.md) for the detailed structural requirements and ambiguity rules.

## Guardrails

- Do not invent application features, stack choices, package files, or category names that are disconnected from observed repository concerns.
- Do not blindly replace a meaningful existing `README.md`.
- Do not invent `README.md` sections that imply unobserved features, commands, or setup guarantees.
- Do not freeze generic development standards as if they were final project-specific rules in a fresh repository.
- Do not write authoritative development standards for an existing repository without analyzing observed structure, tooling, and verification paths first.
- Do not write authoritative testing standards for an existing repository without analyzing observed test structure, tooling, and verification paths first.
- Do not assume an end-to-end framework exists in a fresh repository before the real stack or delivery surface exists.
- Do not ask the user to name implementation categories unless the user explicitly wants to control category naming.
- Do not flatten `docs/implementation/` unless the user explicitly asks for a flat layout.
- Do not pre-create empty implementation category directories or placeholder implementation records during initialization.
- Do not create `docs/guide/AGENTS.md` by default when `README.md` is sufficient for that directory.
- Do not create guide documents from repository structure, runtime classification, tooling inventories, or test layout alone.
- Do not copy project rules or implementation notes into `docs/guide/`.
- Do not create empty guide documents that merely restate placeholders without a real user workflow.
- Do not leave starter rule placeholders untouched once the real structure becomes known.
- Do not skip baseline development standards when the repository does not yet expose stronger project-specific quality rules.
- Do not copy the skill's `assets/` directory into the target repository.
- Do not place subagent working documents in `docs/guide/` or `docs/implementation/` for generated repositories; use `subagents_docs/` instead.
- Do not use `docs/implementation/` for subagent working records in generated repositories; reserve it for final implementation briefings inside concern-based categories after a cycle passes.
- Do not create `docs/implementation/briefings/`; keep `docs/implementation/` category-based.
- Do not ask the language question twice after a valid answer or explicit language selection is already available.
- Do not request chooser, submit, modal, or dummy selection UI for the language prompt.
- Do not treat an inspect result that needs user clarification as a terminal failure.
- Do not ask about `docs/` or `rule/` when the existing tree is already compatible with the planned structure and no reinterpretation is needed.
- Do not duplicate rules across root and local instruction files.
- Do not start planner/generator/evaluator implementation flow for analysis-only, question-only, review-only, or explanation-only requests.
- Keep starter local skills aligned through clear descriptions, matching metadata, and `allow_implicit_invocation` support.
- Do not leave completed or no-longer-needed subagent threads open after their outputs have been integrated.
- Do not use free-form prose or table-first layouts for the rule index when the standard section-and-fields format is sufficient.
- Do not skip the initial language check: use the already fixed language when present, otherwise ask once in plain text.
- Do not claim branch protection or ruleset enforcement without verifying the remote result.
- Prefer squash-merge workflows when the user wants a clean official history.
- Keep the first pass minimal and safe.

## Draft Mode

If the user has not yet provided enough structural decisions, create a clean draft only:

- a skill skeleton
- minimal repository guidance
- clearly labeled placeholders
- a short list of missing decisions

Do not pretend the final workflow is fully specified when it is not.

## Example Requests

- "Initialize a new public GitHub repo for a solo maintainer with PR-only main and minimal OSS files."
- "Set up a new Codex CLI project and verify that the default branch cannot be pushed directly."
- "Add Codex rule structure to this existing repo without disturbing the current source tree."
- "Create only a draft of the init workflow for now. I will give the exact repository rules later."
