---
name: hschoi-init-project
description: Bootstrap Codex-oriented repository structure for both brand-new and already-existing projects. Use when Codex needs to initialize or retrofit root and local AGENTS.md files, a root-level `rule/` directory with `rule/index.md` and `rule/rules/*.md`, human-facing docs structure, runtime versus non-runtime separation, and GitHub repository workflow policy without guessing ambiguous structural decisions or destructively rewriting existing project contents.
---

# Init Project

## Critical First Turn

If no valid language selection is already present in the current request or session, the very first user-facing response must be exactly:

```text
1. English
2. Korean(한국어)
```

Do not add any other text.
Do not inspect the repository first.
Do not read templates first.
Do not send progress updates first.
After printing the two lines, stop and wait for the answer.
Do not repeat the same question unless the user starts a new attempt.

## Overview

Initialize repository structure from the real current state, not from assumptions. Support two modes: full initialization for near-empty repositories, and additive Codex-structure initialization for repositories that already contain source code, directories, or documentation.

Read [references/language-output.md](references/language-output.md) before generating any user-facing document.
Use `scripts/materialize_repo.sh` as a materialization step after inspection and clarification, not as a substitute for asking questions.
In existing repositories or uncertain structures, inspect first, ask the missing questions, then rerun the generator with resolved inputs.

## Workflow

1. Ask the language question first.
   - Before any other clarification question, ask:
     ```text
     1. English
     2. Korean(한국어)
     ```
   - If no valid language selection is already present, the entire next user-facing message must be exactly those two lines and nothing else.
   - After printing the language question, stop and wait for the answer.
   - Do not inspect the repository, read templates, or emit progress updates before the language is fixed.
   - If the client supports a two-option chooser, use it. Otherwise print only the two numbered lines and accept `1` or `2` as the answer.
   - If the current request already includes a valid language selection such as `1`, `2`, `English`, or `Korean(한국어)`, do not ask again.
   - After a valid selection is made, do not repeat the question in the same session.
   - If the environment is non-interactive and no answer can be collected, ask once and stop instead of repeating the same prompt.
   - Use the selected language for generated documentation and all later clarification questions.
2. Inspect the repository before changing anything.
   - Check whether the project is effectively empty or already has meaningful structure.
   - Look for existing source directories, docs, AGENTS-like files, rule docs, and runtime/non-runtime boundaries.
   - Inspect the remote default branch and active GitHub protection system before changing workflow policy.
3. Stop on structural ambiguity by asking, not by abandoning the run.
   - If directory semantics, runtime boundaries, naming boundaries with existing directories, incorporation of existing `docs/` or `rule/` trees, or overwrite of existing control files are unclear, ask minimal clarification questions and wait.
   - Do not guess high-impact structure decisions.
   - Do not produce partial final structure when core structural decisions are unresolved.
   - Do not surface raw generator ambiguity as a final failure when the missing decision can be resolved by asking the user.
4. Choose the operating mode.
   - Fresh mode: create the full base structure from scratch.
   - Existing-project mode: add Codex-compatible structure around the existing repository without arbitrary moves, renames, or destructive edits.
   - In existing-project mode, prefer an inspect pass first. Use `scripts/materialize_repo.sh --inspect` to gather runtime candidates, existing `docs/` and `rule/` signals, and overwrite conflicts before materializing files.
   - After the user answers, rerun the generator with explicit confirmation flags such as `--runtime-dirs`, `--confirm-existing-docs`, `--confirm-existing-rule`, and `--overwrite` as needed.
5. Apply the language policy to output.
   - If English is selected, generate human-facing document contents and filenames in English by default.
   - If Korean is selected, generate human-facing document contents in Korean.
   - Read and use only the selected-language templates unless you are explicitly updating the skill itself.
   - Keep control filenames stable in English, including `README.md`, `AGENTS.md`, and `rule/index.md`.
   - Keep directory names, code, commands, config keys, slugs, and path literals in English.
   - In Korean mode, use Korean filenames only for non-control human-facing documents generated under `docs/guide/` and `docs/implementation/`.
   - Keep `rule/index.md`, `rule/rules/*.md`, and other rule-path conventions stable in English where predictable pathing matters.
   - Include the chosen language policy in generated `AGENTS.md` files.
6. Create the rule and documentation structure.
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
   - Default to `docs/guide/README.md` for human navigation and `docs/implementation/AGENTS.md` for implementation-record placement rules.
   - When an implementation record is created, follow the rule-defined section shape directly, including unit-test, end-to-end test, manual-check, and gap notes in `Verification`; do not copy skill `assets/` into the target repository.
   - Do not create a target-repository `assets/` directory unless the user explicitly asked for project assets unrelated to this skill.
   - Do not pre-create empty implementation category directories during initialization.
   - Create other local `AGENTS.md` files only where they improve scope clarity.
   - Keep `rule/` authoritative for Codex execution. Treat `docs/guide/` and `docs/implementation/` as human-facing, not primary rule authority.
   - Put guidance into the generated `AGENTS.md` files stating that implementation categories are concern-based and chosen by Codex from observed repository structure.
7. Preserve existing projects carefully.
   - Prefer additive initialization.
   - Reuse meaningful existing structure where possible.
   - Ask before reinterpreting existing directory meaning or folding existing `docs/` or `rule/` trees into the new rule model.
   - If the inspect pass reports existing `docs/`, existing `rule/`, or generated-file overwrite conflicts, ask the user and continue after the answer instead of treating that state as terminal.
8. Derive implementation categories instead of outsourcing the decision.
   - Choose `docs/implementation/` categories from the repository's observed source areas, architecture boundaries, documentation domains, and recurring work streams when an implementation record is actually being written.
   - If the repository is new or sparse, do not pre-create placeholder categories. Defer category creation until the first implementation record is needed.
   - Avoid weak catch-all category names.
9. Configure GitHub workflow policy when the user asked for it.
   - Prefer the protection mechanism already in use by the repository.
   - Verify the observed remote state after every change.
   - Prefer non-destructive checks such as `git push --dry-run` when validating direct-push behavior.
10. Report exact observed state.
   - Distinguish between intended policy and observed remote behavior.
   - List what was created, what was preserved, what was left untouched, and what is blocked pending clarification.
   - If the run pauses for clarification, report the exact questions still pending and resume from those answers instead of restarting the entire workflow.

## Required Outputs

### Target Repository Outputs

- root `README.md`
- thin root `AGENTS.md`
- `rule/index.md` with an explicit Markdown index
- `rule/rules/` with the detailed starter rule documents
- `docs/guide/`
- `docs/implementation/` with category-based record placement rules instead of a flat history directory by default
- `docs/guide/README.md` by default
- focused guide documents under `docs/guide/` only when actual user-facing workflows justify them
- `docs/implementation/AGENTS.md` by default
- starter rule documents including `rule/rules/rule-maintenance.md`, `rule/rules/readme-maintenance.md`, `rule/rules/development-standards.md`, and `rule/rules/testing-standards.md`
- other local `AGENTS.md` files where they reduce scope and context
- minimal but meaningful starter content in generated files
- no project-local `assets/` directory unless explicitly requested by the user

### Skill-Bundled Resources

- canonical root README templates at `assets/README/root.en.md` and `assets/README/root.ko.md`
- canonical root templates at `assets/AGENTS/root.en.md` and `assets/AGENTS/root.ko.md`
- canonical starter templates at `assets/rule/index.en.md` and `assets/rule/index.ko.md`
- starter rule templates for the default rule set in `assets/rule/`
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
- Do not ask the language question twice after a valid answer or explicit language selection is already available.
- Do not treat an inspect result that needs user clarification as a terminal failure.
- Do not ask about `docs/` or `rule/` when the existing tree is already compatible with the planned structure and no reinterpretation is needed.
- Do not duplicate rules across root and local instruction files.
- Do not use free-form prose or table-first layouts for the rule index when the standard section-and-fields format is sufficient.
- Do not skip the first language question.
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
