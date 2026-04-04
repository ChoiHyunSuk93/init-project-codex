# Structure Initialization Requirements

## Contents

1. Dual-mode behavior
2. Stop-and-ask conditions
3. Rule structure requirements
4. Runtime versus non-runtime requirements
5. Documentation structure requirements
6. Local AGENTS.md guidance
7. Existing project safety rules

## Dual-mode behavior

Support both of these cases:

1. Fresh project initialization
2. Existing-project Codex-structure initialization

In fresh projects, create the full base structure.

In existing projects:

- inspect the existing structure first
- preserve unrelated contents
- avoid arbitrary moves or renames
- prefer additive initialization over restructuring
- let observed runtime, test, tooling, and docs signals make generated starter skills and selected baseline docs more specific when that information is actually present

Read [language-output.md](language-output.md) before generating any user-facing document so the initial language choice is applied consistently.
If no valid language selection exists yet, ask the plain-text language question and wait before inspecting repository contents.
If the request or session already fixes the language, do not ask again.
Load only the templates for the selected language unless you are explicitly updating the skill itself.
If the user request is analysis-only, question-only, review-only, or explanation-only, stop before materialization and answer analytically instead of entering the implementation cycle.

## Stop-and-ask conditions

Stop and ask clear, minimal questions before proceeding when any of these are ambiguous:

- single source-root versus non-runtime directory naming
- boundaries between existing directories and new structure
- naming conventions
- whether existing docs should be incorporated, preserved, or ignored
- whether existing rule docs should be incorporated, preserved, or ignored
- whether existing control files should be updated in place or left untouched

Do not guess these decisions.
Do not present partial final structure as if it were complete.
If a deterministic generation step discovers one of these gaps, convert it into a question-and-resume flow instead of treating it as a terminal failure.
If existing `docs/` or `rule/` trees are already compatible with the planned structure and do not need reinterpretation, proceed without asking.
Do not treat a non-implementation request as permission to materialize files just because the skill matched.

## Rule structure requirements

Create a thin root `AGENTS.md`.

The root file must:

- contain only project-wide guidance
- orchestrate more detailed rules instead of duplicating them
- define root scope versus local scope
- explain how detailed rules are referenced
- distinguish authoritative rule documents from human-facing docs
- reinforce the principle of keeping the root thin over time
- point readers to `rule/rules/language-policy.md` for the active document language policy
- include documentation automation expectations for root `README.md`, user-facing guide docs, implementation records, and rule docs
- tell Codex to keep root `README.md` updated as durable project-facing facts change
- include conditional guidance for skill creation when the repository contains Codex skills

Use the language-appropriate root template in:

- `assets/AGENTS/root.en.md`
- `assets/AGENTS/root.ko.md`

Use the skill-bundled templates as internal generation sources only.
Do not create a target-repository `assets/` directory unless the user explicitly asked for project assets unrelated to this skill.

Create `rule/`, `rule/index.md`, and `rule/rules/`.

The rule system must:

- avoid duplication
- use explicit references
- make the rule index the discovery point for detailed rules
- keep detailed rule documents under `rule/rules/*.md`
- require additions, deletions, and updates to be reflected in the index
- treat rules not listed in the index as non-authoritative until indexed
- keep generated docs and prompts pointing to authoritative rule documents instead of duplicating long stable contracts

### Rule index standard

Use this standard unless the user explicitly asks for a different format:

- file name: `rule/index.md`
- format: Markdown
- structure: section-based headings with repeated fixed-field entries
- primary audience: both humans and Codex
- canonical starter templates: `assets/rule/index.en.md` and `assets/rule/index.ko.md`

Avoid these patterns by default:

- Markdown tables as the main structure
- long prose summaries instead of explicit fields
- inconsistent field names between entries

Each rule entry should use a stable heading plus these exact fields:

- `Path`
- `Scope`
- `Applies to`
- `Authority`
- `Summary`

Recommended shape:

```md
# Rule Index

## Global Rules

### project-structure
- Path: `rule/rules/project-structure.md`
- Scope: repository-wide
- Applies to: all directories
- Authority: global
- Summary: Defines top-level structure and document roles.
```

When rules are added, deleted, renamed, or moved, update `rule/index.md` in the same change.
When generating a fresh repository, start from the language-appropriate template in `assets/rule/` and then adapt the entries to the repository's actual starter rule files.
Do not copy the source templates themselves into the target repository.

### Default starter rule set

Create these starter rule documents by default unless the repository already has a stronger equivalent:

- `rule/rules/project-structure.md`
- `rule/rules/instruction-model.md`
- `rule/rules/rule-maintenance.md`
- `rule/rules/documentation-boundaries.md`
- `rule/rules/cycle-document-contract.md`
- `rule/rules/language-policy.md`
- `rule/rules/readme-maintenance.md`
- `rule/rules/development-standards.md`
- `rule/rules/testing-standards.md`
- `rule/rules/runtime-boundaries.md`
- `rule/rules/implementation-records.md`
- `rule/rules/subagent-orchestration.md`
- `rule/rules/subagents-docs.md`

Use the language-appropriate templates in `assets/rule/` and adapt them to the repository's actual structure.
Use `rule/rules/rule-maintenance.md` as the canonical starter rule for keeping `rule/index.md` and detailed rule files aligned over time.

Starter rule documents may begin with placeholders in fresh repositories, but they should not remain stale once real structure or policy becomes known.
When repository structure, runtime boundaries, or rule-bearing conventions become concrete, replace placeholders with observed values in the relevant `rule/rules/*.md` files.

### Development standards requirements

Treat `rule/rules/development-standards.md` differently by mode.

In fresh repositories:

- create a provisional standards document
- keep only minimal baseline quality expectations at first
- do not present generic defaults as the final project-specific standard
- replace provisional guidance as real stack, tooling, naming, and workflow conventions become concrete

In existing repositories:

- analyze observed project structure before finalizing standards
- inspect source areas, top-level layout, naming patterns, automation, lint/test/format commands, and other tooling signals when available
- codify observed project conventions instead of leaving the standards file generic
- if stronger local conventions exist, narrow them into local rule documents instead of forcing one flat global rule

### Testing standards requirements

Treat `rule/rules/testing-standards.md` differently by mode.

In fresh repositories:

- create a provisional testing standards document
- do not assume a specific unit-test or end-to-end framework before the stack becomes known
- define only minimal expectations for when unit tests, end-to-end tests, and manual verification should be used
- replace generic guidance as real test paths, commands, and frameworks become concrete

In existing repositories:

- analyze observed test structure before finalizing standards
- inspect test directories, file naming, config files, commands, automation, and existing verification patterns when available
- codify observed unit-test and end-to-end-test conventions instead of leaving the standards file generic
- if stronger area-specific testing rules exist, narrow them into local rule documents instead of forcing one flat global rule

## Runtime versus non-runtime requirements

Make the single source-root versus non-runtime split explicit in both structure and guidance.

The generated structure should use one source-root directory under the project root.
Put implementation directories under that source root instead of scattering multiple top-level runtime directories directly under the project root.
Do not default to several top-level runtime directories.

In existing projects:

- detect whether a clear single source root already exists
- align to the existing distinction when possible
- ask before inventing a conflicting boundary model
- if several obvious source-root candidates exist, ask which single directory should be treated as the source root, or whether a new source-root label should be introduced in guidance before materialization

Reflect the distinction in generated `AGENTS.md` files where relevant.

Use this question template when the runtime/non-runtime split is unclear:

```md
I need to place the Codex structure around an explicit single source-root/non-runtime split, but the current repository does not make that boundary clear.

Please confirm:
1. Which directory should be treated as the single source root?
2. Which directories should be treated as non-runtime?
3. Should I align to an existing source-root name, or introduce a new source-root label in guidance?
4. Should existing directories be reclassified, or only documented as they are?
```

If existing repositories already expose likely source-root candidates, adapt the question to confirm them instead of asking from scratch.
Example candidates may include `src/`, `app/`, `packages/`, or another top-level directory that already groups implementation areas.

## Documentation structure requirements

Treat root `README.md` as the primary human-facing repository summary outside `docs/`.

Create these directories:

- `.codex/`
- `subagents_docs/`
- `docs/guide/`
- `docs/implementation/`
- `rule/`

Interpret them like this:

- `guide`: human-facing workflow and usage guides
- `implementation`: human-facing work history and outcome tracking
- `rule`: authoritative Codex execution rules
- `.codex`: project-scoped planner/generator/evaluator harness configuration plus process-oriented starter local skills
- `subagents_docs`: planner, generator, and evaluator working documents

Do not treat `guide` or `implementation` as primary rule authority.

### Default control files by directory

Use these defaults unless the repository already has a stronger existing convention:

- `.codex/` -> create `config.toml`, `agents/`, and process-oriented starter local skills under `skills/`
- `subagents_docs/` -> create `AGENTS.md` and `cycles/`
- `docs/guide/` -> create `README.md`
- `docs/implementation/` -> create `AGENTS.md`
- `rule/` -> create `index.md` and `rules/`

Keep these control filenames stable across language modes.

### Root `README.md` requirements

Create or update root `README.md` by default.

In fresh repositories:

- create a minimal template `README.md`
- use safe placeholders for project-specific facts that are not known yet
- keep it summary-oriented and easy to replace as the real project takes shape

In existing repositories:

- inspect current source areas, top-level directories, existing docs, and available automation before writing
- reflect only observed project purpose, major areas, and current entry points
- if the repository already has a meaningful `README.md`, refine or extend it instead of replacing it blindly

Keep root `README.md` synchronized with durable repository-facing facts over time.

Rationale:

- `docs/guide/README.md` is better for human navigation and does not usually need local execution rules.
- `docs/implementation/AGENTS.md` is better for instructing Codex where records belong, how categories work, and how ordered filenames are maintained.
- `rule/index.md` is the rule discovery point, and `rule/rules/*.md` holds the detailed rule set instead of a README-style summary for that directory.

Do not create `docs/guide/AGENTS.md` by default unless that directory actually needs local execution rules beyond what the root file and `rule/` documents already define.

Keep `docs/guide/README.md` as the guide index.
It is acceptable for that `README.md` to be the only file under `docs/guide/` at initialization time.

Create focused guide documents only when there is a real user-facing workflow or request flow to explain safely.
Good examples include:

- run or execution guides
- deployment guides
- test-running guides
- design request guides
- operator or support workflows

Do not auto-create guide files from observed structure, runtime classification, test directory listings, tooling signals, or implementation notes alone.
Do not use `docs/guide/` as a duplicate home for rule text or implementation history.

If a repository already has a meaningful top-level `docs/` tree, inspect it before creating new guide structure.
If it is unclear whether `docs/guide/` should be added alongside existing docs, ask first and continue from the answer.

Use this question template when an existing `docs/` tree needs clarification:

```md
I found an existing `docs/` tree before adding the Codex structure.

Please confirm:
1. Should I keep the current `docs/` contents as they are and add `docs/guide/` and `docs/implementation/` alongside them?
2. Are there any existing docs paths I should avoid rewriting?
```

If a repository already has a meaningful top-level `rule/` tree, inspect it before adding the starter rule set.
If it is unclear whether the existing rule structure should remain as-is, be extended, or be treated as the authoritative rule model, ask first and continue from the answer.

Use this question template when an existing `rule/` tree needs clarification:

```md
I found an existing `rule/` tree before adding the Codex starter rules.

Please confirm:
1. Should I keep the current `rule/` contents as they are and add only missing starter rule files under `rule/rules/`?
2. Are there any existing rule paths I should avoid rewriting?
```

### Implementation categories

Do not make `docs/implementation/` flat by default.

Use category subdirectories based on actual implementation concerns when implementation records are actually created, for example:

- `docs/implementation/architecture/`
- `docs/implementation/documentation/`
- `docs/implementation/gameplay/`

Each category directory should use ordered markdown files in `NN-name.md` format.

Do not pre-create empty starter categories during initialization.
Do not create a top-level `docs/implementation/briefings/` directory.

When an implementation record is actually created, start from the language-appropriate template in:

- `assets/docs/implementation/record.en.md`
- `assets/docs/implementation/record.ko.md`

Do not copy those template files into the target repository.

Determine categories by Codex judgment from the repository state at the time a record is written.

Choose categories from:

- major source areas
- architectural boundaries
- recurring work streams
- documentation domains already present in the repository

If the repository is new or sparse, defer category creation until the first implementation record is actually needed instead of asking the user to invent category names or creating placeholders.

Avoid weak catch-all names such as:

- `misc`
- `general`
- `notes`
- `other`

### Required AGENTS.md guidance for implementation areas

When generating the root `AGENTS.md` or a local `docs/implementation/AGENTS.md`, include guidance with this meaning:

- implementation categories are concern-based and chosen by Codex from observed repository structure
- implementation categories are created lazily when the first relevant record is written
- new implementation records belong in the closest existing category
- add a new category only when the current categories no longer describe the work cleanly
- do not dump records flat under `docs/implementation/` unless the user explicitly requested a flat layout
- include the active language policy for human-facing generated documents
- `subagents_docs/` working documents also follow the selected language
- implementation records should use a stable minimal section structure such as summary, changes, why, verification, and related rules
- implementation records should stay short and readable for users
- verification notes should separate unit tests, end-to-end tests, manual checks, and remaining gaps when that distinction is meaningful

## Local AGENTS.md guidance

Create local `AGENTS.md` files only where they improve scope clarity.

When created, they should define:

- local scope boundaries
- how the area relates to root rules
- which detailed rules matter locally
- whether the area is runtime or non-runtime
- what kinds of files belong there
- what should not be duplicated from other instruction files

Do not spam local `AGENTS.md` files into every directory without purpose.

## Deterministic generation

Once language choice and structural ambiguity are resolved, prefer the deterministic generator in `scripts/materialize_repo.sh`.
Use the script to materialize live files directly in the target repository instead of copying the skill's `assets/` tree.
In existing repositories or uncertain structures, run `scripts/materialize_repo.sh --inspect` first.
Use the inspection output to ask the missing questions, then rerun without `--inspect` once source-root boundaries, docs handling, and overwrite decisions are resolved.
Pass the resolved answers explicitly through flags such as `--source-root-dir`, `--confirm-existing-docs`, `--confirm-existing-rule`, and `--overwrite`.

## Existing project safety rules

When operating on an existing project:

- inspect the repository before generating files
- preserve existing source code and unrelated directories
- avoid destructive edits
- avoid arbitrary moves or renames
- avoid duplicating structure that already meaningfully exists
- ask before changing established directory semantics
- prefer adding Codex-compatible structure over restructuring the whole repository

If AGENTS-like files, rule docs, or project docs already exist, examine them and ask how they should be incorporated before proceeding.
If generated control files already exist, ask whether they should be updated in place and only materialize them after that answer is explicit.
