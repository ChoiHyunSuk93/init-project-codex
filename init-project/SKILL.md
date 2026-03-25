---
name: init-project
description: Bootstrap Codex-oriented repository structure for both brand-new and already-existing projects. Use when Codex needs to initialize or retrofit root and local AGENTS.md files, a root-level `rule/` directory and index, human-facing docs structure, runtime versus non-runtime separation, and GitHub repository workflow policy without guessing ambiguous structural decisions or destructively rewriting existing project contents.
---

# Init Project

## Overview

Initialize repository structure from the real current state, not from assumptions. Support two modes: full initialization for near-empty repositories, and additive Codex-structure initialization for repositories that already contain source code, directories, or documentation.

Read [references/language-output.md](references/language-output.md) before generating any user-facing document.

## Workflow

1. Ask the language question first.
   - Before any other clarification question, ask:
     ```text
     1. English
     2. Korean(한국어)
     ```
   - Use the selected language for generated documentation and all later clarification questions.
2. Inspect the repository before changing anything.
   - Check whether the project is effectively empty or already has meaningful structure.
   - Look for existing source directories, docs, AGENTS-like files, rule docs, and runtime/non-runtime boundaries.
   - Inspect the remote default branch and active GitHub protection system before changing workflow policy.
3. Stop on structural ambiguity.
   - If directory semantics, runtime boundaries, naming boundaries with existing directories, or incorporation of existing docs are unclear, ask minimal clarification questions and wait.
   - Do not guess high-impact structure decisions.
   - Do not produce partial final structure when core structural decisions are unresolved.
4. Choose the operating mode.
   - Fresh mode: create the full base structure from scratch.
   - Existing-project mode: add Codex-compatible structure around the existing repository without arbitrary moves, renames, or destructive edits.
5. Apply the language policy to output.
   - If English is selected, generate human-facing document contents and filenames in English by default.
   - If Korean is selected, generate human-facing document contents in Korean.
   - Keep control filenames stable in English, including `README.md`, `AGENTS.md`, and `rule/index.md`.
   - Keep directory names, code, commands, config keys, slugs, and path literals in English.
   - In Korean mode, use Korean filenames only for non-control human-facing documents generated under `docs/guide/` and `docs/implementation/`.
   - Keep `rule/index.md` and other rule-path conventions stable in English where predictable pathing matters.
   - Include the chosen language policy in generated `AGENTS.md` files.
6. Create the rule and documentation structure.
   - Create a thin root `AGENTS.md` that orchestrates more detailed rules instead of duplicating them.
   - Start the root file from the language-appropriate template in `assets/AGENTS/`.
   - Create `rule/index.md` as the authoritative discovery point for detailed rules.
   - Start `rule/index.md` from the language-appropriate template in `assets/rule/`, then adapt the entries to the repository's actual starter rules.
   - Create starter rule documents from the language-appropriate templates in `assets/rule/`.
   - Default to `docs/guide/README.md` for human navigation and `docs/implementation/AGENTS.md` for implementation-record placement rules.
   - When an implementation record is created, start from the language-appropriate template in `assets/docs/implementation/`.
   - Do not pre-create empty implementation category directories during initialization.
   - Create other local `AGENTS.md` files only where they improve scope clarity.
   - Keep `rule/` authoritative for Codex execution. Treat `docs/guide/` and `docs/implementation/` as human-facing, not primary rule authority.
   - Put guidance into the generated `AGENTS.md` files stating that implementation categories are concern-based and chosen by Codex from observed repository structure.
7. Preserve existing projects carefully.
   - Prefer additive initialization.
   - Reuse meaningful existing structure where possible.
   - Ask before reinterpreting existing directory meaning or folding existing docs into the new rule model.
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

## Required Outputs

- thin root `AGENTS.md`
- canonical root template at `assets/AGENTS/root.en.md` and `assets/AGENTS/root.ko.md`
- `rule/index.md` with an explicit Markdown index
- canonical starter templates at `assets/rule/index.en.md` and `assets/rule/index.ko.md`
- starter rule templates for the default rule set in `assets/rule/`
- `docs/guide/`
- `docs/implementation/` with category-based record placement rules instead of a flat history directory by default
- `docs/guide/README.md` by default
- `docs/implementation/AGENTS.md` by default
- canonical implementation-record templates at `assets/docs/implementation/record.en.md` and `assets/docs/implementation/record.ko.md`
- other local `AGENTS.md` files where they reduce scope and context
- minimal but meaningful starter content in generated files

Read [references/structure-initialization.md](references/structure-initialization.md) for the detailed structural requirements and ambiguity rules.

## Guardrails

- Do not invent application features, stack choices, package files, or category names that are disconnected from observed repository concerns.
- Do not ask the user to name implementation categories unless the user explicitly wants to control category naming.
- Do not flatten `docs/implementation/` unless the user explicitly asks for a flat layout.
- Do not pre-create empty implementation category directories or placeholder implementation records during initialization.
- Do not create `docs/guide/AGENTS.md` by default when `README.md` is sufficient for that directory.
- Do not leave starter rule placeholders untouched once the real structure becomes known.
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
