# Rule Index

This index is the authoritative discovery point for detailed rules in `rule/`.

Update this file in the same change whenever a rule is added, deleted, renamed, or moved.
Rules that are not listed here are not authoritative until they are indexed.

## How To Read This Index

- `Path`: canonical location of the rule document
- `Scope`: level at which the rule applies
- `Applies to`: directories or files governed by the rule
- `Authority`: whether the rule is global or local in effect
- `Summary`: brief statement of what the rule controls

## Global Rules

### project-structure
- Path: `rule/project-structure.md`
- Scope: repository-wide
- Applies to: all directories
- Authority: global
- Summary: Defines top-level structure, directory roles, and root versus local instruction boundaries.

### instruction-model
- Path: `rule/instruction-model.md`
- Scope: repository-wide
- Applies to: `AGENTS.md`, local `AGENTS.md`, `rule/`
- Authority: global
- Summary: Defines thin-root orchestration, local scope rules, and non-duplication requirements.

### documentation-boundaries
- Path: `rule/documentation-boundaries.md`
- Scope: documentation
- Applies to: `docs/guide/`, `docs/implementation/`, `rule/`
- Authority: global
- Summary: Defines the distinction between human-facing docs, implementation history, and authoritative rule docs.

## Structural Rules

### runtime-boundaries
- Path: `rule/runtime-boundaries.md`
- Scope: structural
- Applies to: runtime and non-runtime directories
- Authority: global
- Summary: Defines how runtime and non-runtime areas are separated and how ambiguous boundaries are resolved.

### implementation-records
- Path: `rule/implementation-records.md`
- Scope: implementation history
- Applies to: `docs/implementation/`
- Authority: global
- Summary: Defines concern-based category directories, ordered record naming, and non-flat history rules.

## Local Rules

Add local-scope rule documents here when the repository introduces directory-specific rule files.
Delete the placeholder entry below when the first real local rule is added.

### [local-rule-slug]
- Path: `rule/[local-rule-file].md`
- Scope: local
- Applies to: `[directory-or-area]`
- Authority: local
- Summary: `[Describe the local rule briefly.]`
