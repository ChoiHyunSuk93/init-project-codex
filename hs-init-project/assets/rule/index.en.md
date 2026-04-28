# Rule Index

This index is the authoritative discovery point for detailed rules in `rule/rules/`.

Update this file in the same change whenever a rule is added, deleted, renamed, or moved.
Rules that are not listed here are not authoritative until they are indexed.

## How To Read This Index

- `Path`: canonical location of the rule document. Use a Markdown link when the file exists.
- `Scope`: level at which the rule applies
- `Applies to`: directories or files governed by the rule
- `Authority`: whether the rule is global or local in effect
- `Summary`: brief statement of what the rule controls

## Global Rules

### project-structure
- Path: [`rule/rules/project-structure.md`](rules/project-structure.md)
- Scope: repository-wide
- Applies to: all directories
- Authority: global
- Summary: Defines top-level structure, directory roles, and root versus local instruction boundaries.

### instruction-model
- Path: [`rule/rules/instruction-model.md`](rules/instruction-model.md)
- Scope: repository-wide
- Applies to: `AGENTS.md`, local `AGENTS.md`, `rule/`
- Authority: global
- Summary: Defines thin-root orchestration, local scope rules, and non-duplication requirements.

### rule-maintenance
- Path: [`rule/rules/rule-maintenance.md`](rules/rule-maintenance.md)
- Scope: repository-wide
- Applies to: `rule/index.md`, `rule/rules/`
- Authority: global
- Summary: Defines how rule documents are added, indexed, updated, moved, and kept authoritative over time.

### documentation-boundaries
- Path: [`rule/rules/documentation-boundaries.md`](rules/documentation-boundaries.md)
- Scope: documentation
- Applies to: `docs/guide/`, `docs/implementation/`, `subagents_docs/`, `rule/`
- Authority: global
- Summary: Defines the distinction between human-facing docs, subagent working docs, implementation history, and authoritative rule docs.

### cycle-document-contract
- Path: [`rule/rules/cycle-document-contract.md`](rules/cycle-document-contract.md)
- Scope: repository-wide workflow
- Applies to: `subagents_docs/cycles/`, `.codex/agents/`, cycle-aware docs
- Authority: global
- Summary: Defines the cycle-file contract that applies when a shared working document is opened.

### language-policy
- Path: [`rule/rules/language-policy.md`](rules/language-policy.md)
- Scope: repository-wide documentation
- Applies to: `AGENTS.md`, `PROJECT_OVERVIEW.md`, `rule/`, `docs/guide/`, `docs/implementation/`, `subagents_docs/`
- Authority: global
- Summary: Defines generated document language rules, overview/roadmap paths, and stable filename/path conventions.

### readme-maintenance
- Path: [`rule/rules/readme-maintenance.md`](rules/readme-maintenance.md)
- Scope: documentation
- Applies to: `README.md`
- Authority: global
- Summary: Defines how the root README is created, analyzed, and kept current as the primary repository summary.

### subagent-orchestration
- Path: [`rule/rules/subagent-orchestration.md`](rules/subagent-orchestration.md)
- Scope: repository-wide workflow
- Applies to: `.codex/agents/`, `subagents_docs/`, root coordination
- Authority: global
- Summary: Defines adaptive harness selection, main-agent integration responsibility, delegation, and evaluator separation.

### subagents-docs
- Path: [`rule/rules/subagents-docs.md`](rules/subagents-docs.md)
- Scope: repository-wide workflow
- Applies to: `subagents_docs/`
- Authority: global
- Summary: Defines `subagents_docs/` as the cycle-backed working area and sets phase ownership boundaries.

### planning-roadmap
- Path: [`rule/rules/planning-roadmap.md`](rules/planning-roadmap.md)
- Scope: repository-wide workflow
- Applies to: `PROJECT_OVERVIEW.md`, `subagents_docs/roadmap.md`, `subagents_docs/cycles/`
- Authority: global
- Summary: Defines the project overview, phase roadmap, required phase checklists, and the gate for entering the next phase.

## Quality Rules

### development-standards
- Path: [`rule/rules/development-standards.md`](rules/development-standards.md)
- Scope: repository-wide
- Applies to: code, tests, schemas, public interfaces, and related docs
- Authority: global
- Summary: Defines working principles, baseline implementation quality, convention-following, and verification expectations.

### testing-standards
- Path: [`rule/rules/testing-standards.md`](rules/testing-standards.md)
- Scope: repository-wide
- Applies to: unit tests, end-to-end tests, verification notes, and related test docs
- Authority: global
- Summary: Defines how unit tests, end-to-end tests, and verification expectations are chosen, updated, and recorded.

## Structural Rules

### runtime-boundaries
- Path: [`rule/rules/runtime-boundaries.md`](rules/runtime-boundaries.md)
- Scope: structural
- Applies to: runtime and non-runtime directories
- Authority: global
- Summary: Defines how a single source root and non-runtime areas are separated and how ambiguous boundaries are resolved.

### implementation-records
- Path: [`rule/rules/implementation-records.md`](rules/implementation-records.md)
- Scope: implementation history
- Applies to: `docs/implementation/`
- Authority: global
- Summary: Defines concern-based category directories, ordered record naming, and non-flat history rules.

## Local Rules

Add local-scope rule documents here when the repository introduces directory-specific rule files.
Delete the placeholder entry below when the first real local rule is added.
Keep local rule files under `rule/rules/` unless the user explicitly asks for a different structure.

### [local-rule-slug]
- Path: `rule/rules/[local-rule-file].md`
- Scope: local
- Applies to: `[directory-or-area]`
- Authority: local
- Summary: `[Describe the local rule briefly.]`
