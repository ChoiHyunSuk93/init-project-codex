Create a Codex skill for bootstrapping my standard Codex-oriented repository rule structure.

## First interaction rule

When the skill starts, the first user-facing question must be the language selection prompt below.
Do this before any structural clarification questions.

```md
1. English
2. Korean(한국어)
```

After the user answers, all generated documentation and all follow-up clarification questions must use the selected language.

This skill must support two distinct use cases:

1. initializing a brand-new project with no meaningful existing source structure
2. initializing Codex rule/document structure inside an already existing project that already contains source code and directories

The skill must work correctly in both cases.

## Language behavior

The selected language controls generated document language and generated instruction language.

### English mode

- Generate document contents in English.
- Generate `AGENTS.md` contents in English.
- Use English filenames for generated documents unless another rule explicitly overrides this.

### Korean mode

- Generate document contents in Korean.
- Generate `AGENTS.md` contents in Korean.
- Keep control filenames stable in English:
  - `README.md`
  - `AGENTS.md`
  - `rule/index.md`
- Generate filenames in Korean only for non-control documents created under:
  - `docs/guide/`
  - `docs/implementation/`
- Keep directory names in English.
- Keep code, commands, config keys, slugs, and path literals in English.
- Keep rule-path conventions stable in English where predictable pathing matters, including `rule/index.md`.

When Korean mode is selected, the generated documentation should be fully Korean in prose, while code and path notation remain English.

## Core requirement

This is not just a blank-project scaffold generator.

It must also work as a structure-initialization skill for an existing project.
When existing files or directories are already present, the skill must integrate the Codex structure carefully without blindly overwriting, flattening, or reorganizing unrelated project contents.

---

## Critical behavior requirement

If any part of the structure is ambiguous, incomplete, or could have multiple valid interpretations, you MUST:

1. stop execution
2. ask clear, minimal clarification questions
3. wait for answers
4. only proceed after the structure is fully specified

Do NOT guess.
Do NOT assume defaults for structural decisions.
Do NOT generate partial output.

This applies especially to:
- runtime vs non-runtime directory naming
- boundaries between existing directories and new structure
- naming conventions
- whether existing docs should be incorporated, preserved, or ignored

---

## Dual-mode behavior

### Mode A: fresh project initialization
If the project is effectively empty or has no meaningful existing structure:
- generate the full base structure
- create the required directories and files
- establish the rule/document layout from scratch

### Mode B: existing project Codex-structure initialization
If the project already contains meaningful source code, directories, or documentation:
- inspect the existing structure first
- preserve unrelated existing contents
- do not arbitrarily rename, move, or rewrite existing project files
- add the Codex structure around the existing project
- integrate root and local instruction files in a way that respects the current project layout
- determine where runtime and non-runtime areas already exist
- ask the user before making structural decisions that would reinterpret or reorganize the existing project

In existing projects, the skill should prefer additive initialization over destructive restructuring.

---

## What this skill must create

### 1) Root rule + referenced detailed rules

- Create a root `AGENTS.md`
- The root `AGENTS.md` must:
  - contain only project-wide guidance
  - stay intentionally thin
  - act as orchestration for detailed rules
  - explicitly reference detailed rules instead of duplicating them
  - include the chosen document language policy
  - include conditional guidance for Codex skill work when the repository contains skills

Because the actual project domain may not yet be fully known at initialization time, the root `AGENTS.md` must still contain meaningful initial content.
It must not be empty.
It must define:
- the role of the root instruction file
- the rule orchestration model
- how detailed rules are referenced
- what belongs in root scope vs local scope
- the principle of avoiding duplicated instructions
- the distinction between authoritative rule documents and human-facing documents
- expectations for keeping the root thin as the project evolves

Do not fill it with fake project-specific details.
Use neutral structural guidance when project specifics are unknown.

If the repository contains Codex skills or new skills are added later, the root `AGENTS.md` should also state that:
- skill creation and skill updates use `skill-creator`
- skills should be written to support both explicit invocation and implicit invocation through matching task descriptions
- each skill should reference applicable `rule/*.md` documents instead of copying repository-wide rules into the skill body

- Create `rule/`
- Create `rule/index.md`

The rule system must:
- avoid duplication
- use explicit references
- require rule additions, deletions, and updates to be reflected in the rule index
- make the rule index the discovery point for detailed rules
- treat rules not listed in the rule index as non-authoritative until indexed

The rule index format is fixed:

- file name: `rule/index.md`
- format: Markdown
- structure: section-based, not table-first
- each rule entry must use explicit fixed fields

Each rule entry must include:
- `Path`
- `Scope`
- `Applies to`
- `Authority`
- `Summary`

The generated index should be easy for both humans and Codex to scan.
Prefer explicit headings plus repeated field lines over prose paragraphs or Markdown tables.

---

### 2) Runtime vs non-runtime separation

- The project must structurally separate:
  - runtime directories
  - non-runtime directories

- This separation must be:
  - explicit in directory structure
  - reinforced in guidance
  - reflected in generated AGENTS files where relevant

In existing projects, the skill must detect whether a runtime/non-runtime distinction already exists.
If it does, align the generated Codex structure to that distinction rather than inventing a conflicting one.

If directory naming, ownership, or boundaries are unclear, ask before proceeding.

Use this question template when the runtime/non-runtime split is unclear:

```md
I need to place the Codex structure around an explicit runtime/non-runtime split, but the current repository does not make that boundary clear.

Please confirm:
1. Which directories should be treated as runtime?
2. Which directories should be treated as non-runtime?
3. Should I align to existing names, or introduce explicit runtime/non-runtime labels in new guidance?
4. Should existing directories be reclassified, or only documented as they are?
```

---

### 3) Docs structure

Create:

- `docs/guide/`
- `docs/implementation/`
- `rule/`

Rules:

- `guide` → human-facing guidance about the project
- `implementation` → implementation result and work history tracking
- `rule` → authoritative detailed rules for Codex execution at the repository root

Important distinctions:

- Codex must NOT treat `guide` or `implementation` as primary rule authority
- Codex MAY write useful outputs or summaries there
- Codex MUST use `rule` as the direct implementation rule source

If an existing project already contains documentation directories, do not automatically merge, rename, or reinterpret them without confirmation.
Ask first when incorporation is unclear.

### 3a) Implementation directory requirements

`docs/implementation/` must NOT be a flat directory by default.

It must use category subdirectories when implementation records actually exist.
Do not pre-create empty starter categories during initialization.

Examples of valid category structures:
- `docs/implementation/gameplay/`
- `docs/implementation/documentation/`
- `docs/implementation/architecture/`

The category names must be based on the project’s actual implementation concerns.

Implementation categories must be selected by Codex based on repository inspection.
They must not default to a user-question step.

Codex should derive categories from:
- major source areas
- architectural boundaries
- recurring work streams
- documentation domains already present in the repository

If the repository is new or sparse, Codex should defer category creation until the first implementation record is actually needed, instead of asking the user to name categories or creating placeholders.

Avoid weak bucket names such as:
- `misc`
- `general`
- `notes`
- `other`

Each category directory must contain ordered markdown records using the `NN-name.md` format.

Each implementation record should use a stable minimal structure with sections such as:
- Summary
- Changes
- Why
- Verification
- Related Rules

Do NOT place all implementation history files directly under `docs/implementation/` unless the user explicitly requests a flat layout.

The generated structure must make it obvious that:
- implementation records are for humans to review
- they preserve work history and outcomes
- they are not the main rule authority for Codex behavior

When real structure becomes known in a fresh repository, starter rule placeholders must be replaced with observed values in the relevant rule documents, especially `rule/project-structure.md` and `rule/runtime-boundaries.md`.

---

### 4) Context minimization and indexing

- Create subdirectory `AGENTS.md` files when appropriate
- These subdirectory `AGENTS.md` files must:
  - define local scope instructions
  - reduce unnecessary global context
  - act as local indexes when useful
  - clarify what local files and subdirectories are in scope

Because project-specific details may be incomplete during initialization, these local `AGENTS.md` files must still contain useful structural guidance.
They must not be empty placeholders.

They should define, where applicable:
- local scope boundaries
- how this area relates to root rules
- which detailed rules are relevant here
- whether the area is runtime or non-runtime
- what kinds of files belong in this directory
- what should not be duplicated from other instruction files
- what language policy applies in this scope when language-specific guidance matters

When `docs/implementation/` exists, the relevant generated `AGENTS.md` must also explain that:
- implementation categories are chosen by Codex from observed repository concerns
- implementation categories are created lazily when the first relevant record is written
- new implementation records should be placed into the closest existing concern-based category
- new categories should be added only when the existing categories no longer describe the work cleanly
- flat dumping of records into `docs/implementation/` is not allowed unless explicitly requested

In existing projects, add local `AGENTS.md` files only where they improve scope clarity.
Do not spam them into every directory without purpose.

System requirements:
- no duplicated rules across files
- minimal necessary context only
- clear scoping boundaries
- explicit indexing when it improves navigation and context efficiency
- Codex-friendly rule discovery through predictable Markdown structure

---

## Existing project safety requirements

When operating on an existing project, the skill must:

- inspect the repository structure before generating files
- preserve existing source code and unrelated directories
- avoid destructive edits
- avoid arbitrary moves or renames
- avoid duplicating structure that already meaningfully exists
- ask before changing established directory semantics
- prefer adding Codex-compatible structure over restructuring the whole project

If the existing repository already has AGENTS-like files, rule docs, or project docs, the skill must examine them and ask how they should be incorporated before proceeding.

---

## Design principles

The generated structure must enforce:

- thin root orchestration
- detailed rules in referenced documents
- strict separation of runtime vs non-runtime
- docs categorized by purpose
- implementation history preserved in ordered markdown files
- implementation history grouped by category subdirectories
- minimal and non-redundant context
- reusable structure across many projects
- safe operation for both fresh and existing repositories

---

## What the skill should produce

Generate:
- directory structure
- root and subdirectory `AGENTS.md` files
- `rule/` index
- starter placeholder files where needed
- minimal but meaningful content explaining the role of each generated area

The generated `rule/index.md` should follow this pattern:

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

Do NOT:
- generate feature code
- assume a specific language or framework
- add unnecessary tooling
- over-engineer
- leave instruction files empty when project specifics are unknown
- destructively restructure an existing repository without confirmation
- use free-form rule-index prose when a predictable section-and-fields layout will work
- make Markdown tables the primary rule index format

When project specifics are unknown, generate structural guidance, scope rules, indexing guidance, and reference conventions instead of fake business/domain content.

---

## Skill requirements

- clear trigger condition: use when initializing a new project or retrofitting an existing project with my standard Codex rule architecture
- deterministic output
- instruction-first design
- optimized for repeatable usage
- enforce distinction between:
  - orchestration rules
  - detailed rules
  - human-facing guides
  - implementation records

---

## Output format

Return:
- skill name
- description optimized for reliable triggering
- full `SKILL.md`
- only truly necessary supporting files

---

## Interaction rule

If any structural element is not explicitly defined:
- ask questions FIRST
- do not proceed with generation
- do not fill gaps with assumptions

The skill must prioritize structural correctness, additive safety, and consistency over speed.
