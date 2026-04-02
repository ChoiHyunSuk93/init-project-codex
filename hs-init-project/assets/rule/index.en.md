# Rule Index

This index is the authoritative discovery point for detailed rules in `rule/rules/`.

## Global Rules

### project-structure
- Path: `rule/rules/project-structure.md`
- Scope: repository-wide
- Applies to: all directories
- Authority: global
- Summary: Defines top-level structure, directory roles, and OMX-managed versus repository-owned areas.

### instruction-model
- Path: `rule/rules/instruction-model.md`
- Scope: repository-wide
- Applies to: `AGENTS.md`, local `AGENTS.md`, `rule/`
- Authority: global
- Summary: Defines root-overlay behavior, local scope rules, and non-duplication requirements.

### rule-maintenance
- Path: `rule/rules/rule-maintenance.md`
- Scope: repository-wide
- Applies to: `rule/index.md`, `rule/rules/`
- Authority: global
- Summary: Defines how rule documents are added, indexed, updated, moved, and kept authoritative over time.

### documentation-boundaries
- Path: `rule/rules/documentation-boundaries.md`
- Scope: documentation
- Applies to: `docs/guide/`, `docs/implementation/`, `.omx/`, `rule/`
- Authority: global
- Summary: Defines the distinction between human-facing docs, OMX runtime state, and authoritative rule docs.

### language-policy
- Path: `rule/rules/language-policy.md`
- Scope: repository-wide documentation
- Applies to: `AGENTS.md`, `rule/`, `docs/guide/`, `docs/implementation/`
- Authority: global
- Summary: Defines generated document language rules, Korean magic-keyword aliases, and stable filename/path conventions.

### readme-maintenance
- Path: `rule/rules/readme-maintenance.md`
- Scope: documentation
- Applies to: `README.md`
- Authority: global
- Summary: Defines how the root README is created, analyzed, and kept current as the primary repository summary.

### subagent-orchestration
- Path: `rule/rules/subagent-orchestration.md`
- Scope: repository-wide workflow
- Applies to: `AGENTS.md`, `.omx/`, root coordination
- Authority: global
- Summary: Defines the team-first workflow, leader ownership, dirty-workspace gate, and Ralph-style completion loop.

## Quality Rules

### development-standards
- Path: `rule/rules/development-standards.md`
- Scope: repository-wide
- Applies to: code, tests, schemas, public interfaces, and related docs
- Authority: global
- Summary: Defines baseline implementation quality, convention-following, and verification expectations.

### testing-standards
- Path: `rule/rules/testing-standards.md`
- Scope: repository-wide
- Applies to: tests, verification notes, and related test docs
- Authority: global
- Summary: Defines how verification expectations are chosen, updated, and recorded.

## Structural Rules

### runtime-boundaries
- Path: `rule/rules/runtime-boundaries.md`
- Scope: structural
- Applies to: runtime and non-runtime directories
- Authority: global
- Summary: Defines how runtime and non-runtime areas are separated and how ambiguous boundaries are resolved.

### implementation-records
- Path: `rule/rules/implementation-records.md`
- Scope: implementation history
- Applies to: `docs/implementation/`
- Authority: global
- Summary: Defines concern-based category directories, ordered record naming, and non-flat history rules.
