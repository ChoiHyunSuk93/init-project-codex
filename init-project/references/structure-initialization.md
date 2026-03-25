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

Read [language-output.md](language-output.md) before generating any user-facing document so the initial language choice is applied consistently.

## Stop-and-ask conditions

Stop and ask clear, minimal questions before proceeding when any of these are ambiguous:

- runtime versus non-runtime directory naming
- boundaries between existing directories and new structure
- naming conventions
- whether existing docs should be incorporated, preserved, or ignored

Do not guess these decisions.
Do not present partial final structure as if it were complete.

## Rule structure requirements

Create a thin root `AGENTS.md`.

The root file must:

- contain only project-wide guidance
- orchestrate more detailed rules instead of duplicating them
- define root scope versus local scope
- explain how detailed rules are referenced
- distinguish authoritative rule documents from human-facing docs
- reinforce the principle of keeping the root thin over time
- include the active document language policy
- include documentation automation expectations for guide docs, implementation records, and rule docs
- include conditional guidance for skill creation when the repository contains Codex skills

Use the language-appropriate root template in:

- `assets/AGENTS/root.en.md`
- `assets/AGENTS/root.ko.md`

Create `rule/` and `rule/index.md`.

The rule system must:

- avoid duplication
- use explicit references
- make the rule index the discovery point for detailed rules
- require additions, deletions, and updates to be reflected in the index
- treat rules not listed in the index as non-authoritative until indexed

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
- Path: `rule/project-structure.md`
- Scope: repository-wide
- Applies to: all directories
- Authority: global
- Summary: Defines top-level structure and document roles.
```

When rules are added, deleted, renamed, or moved, update `rule/index.md` in the same change.
When generating a fresh repository, start from the language-appropriate template in `assets/rule/` and then adapt the entries to the repository's actual starter rule files.

### Default starter rule set

Create these starter rule documents by default unless the repository already has a stronger equivalent:

- `rule/project-structure.md`
- `rule/instruction-model.md`
- `rule/documentation-boundaries.md`
- `rule/runtime-boundaries.md`
- `rule/implementation-records.md`

Use the language-appropriate templates in `assets/rule/` and adapt them to the repository's actual structure.

Starter rule documents may begin with placeholders in fresh repositories, but they should not remain stale once real structure or policy becomes known.
When repository structure, runtime boundaries, or rule-bearing conventions become concrete, replace placeholders with observed values in the relevant `rule/*.md` files.

## Runtime versus non-runtime requirements

Make the runtime versus non-runtime split explicit in both structure and guidance.

In existing projects:

- detect whether this distinction already exists
- align to the existing distinction when possible
- ask before inventing a conflicting boundary model

Reflect the distinction in generated `AGENTS.md` files where relevant.

Use this question template when the runtime/non-runtime split is unclear:

```md
I need to place the Codex structure around an explicit runtime/non-runtime split, but the current repository does not make that boundary clear.

Please confirm:
1. Which directories should be treated as runtime?
2. Which directories should be treated as non-runtime?
3. Should I align to existing names, or introduce explicit runtime/non-runtime labels in new guidance?
4. Should existing directories be reclassified, or only documented as they are?
```

## Documentation structure requirements

Create these directories:

- `docs/guide/`
- `docs/implementation/`
- `rule/`

Interpret them like this:

- `guide`: human-facing project guidance
- `implementation`: human-facing work history and outcome tracking
- `rule`: authoritative Codex execution rules

Do not treat `guide` or `implementation` as primary rule authority.

### Default control files by directory

Use these defaults unless the repository already has a stronger existing convention:

- `docs/guide/` -> create `README.md`
- `docs/implementation/` -> create `AGENTS.md`
- `rule/` -> create `index.md`

Keep these control filenames stable across language modes.

Rationale:

- `docs/guide/README.md` is better for human navigation and does not usually need local execution rules.
- `docs/implementation/AGENTS.md` is better for instructing Codex where records belong, how categories work, and how ordered filenames are maintained.
- `rule/index.md` is the rule discovery point and should replace a README-style summary for that directory.

Do not create `docs/guide/AGENTS.md` by default unless that directory actually needs local execution rules beyond what the root file and `rule/` documents already define.

### Implementation categories

Do not make `docs/implementation/` flat by default.

Use category subdirectories based on actual implementation concerns when implementation records are actually created, for example:

- `docs/implementation/architecture/`
- `docs/implementation/documentation/`
- `docs/implementation/gameplay/`

Each category directory should use ordered markdown files in `NN-name.md` format.

Do not pre-create empty starter categories during initialization.

When an implementation record is actually created, start from the language-appropriate template in:

- `assets/docs/implementation/record.en.md`
- `assets/docs/implementation/record.ko.md`

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
- implementation records should use a stable minimal section structure such as summary, changes, why, verification, and related rules

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
