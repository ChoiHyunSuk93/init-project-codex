# Development Standards Rule

## Purpose

Define how implementation quality standards are established and maintained in this repository.

## Fresh Repositories

- Do not treat generic defaults as the final project standard.
- Until the real stack, structure, and tooling conventions become concrete, use only minimal baseline expectations:
  - clear names
  - focused responsibilities
  - explicit data flow
  - readable control flow
  - correct error handling
  - synchronized code, current-state docs, and verification
- As real project conventions emerge, replace generic guidance here with observed rules.

## Existing Repositories

- Analyze observed source layout, naming patterns, tooling, automation, and existing docs before treating any standard as authoritative.
- Derive project-specific standards from what is already present instead of forcing generic defaults over the repository.
- If stronger area-specific conventions exist, record them here or in narrower local rule documents.

## Working Principles

### Think Before Coding

- State assumptions, uncertainty, possible interpretations, and meaningful tradeoffs before implementation.
- If a requirement is unclear, do not silently choose an interpretation. Name the confusion and ask.
- If a simpler approach exists or the request should be adjusted, say so before implementing.

### Simplicity First

- Write the minimum change that solves the requested problem.
- Do not add unrequested features, single-use abstractions, or unnecessary flexibility or configurability.
- Do not add error handling or defensive code for scenarios that cannot realistically happen.
- If the same requirement can be solved with much less code, rewrite it more simply.

### Surgical Changes

- Every changed line must trace directly to the user's request.
- Do not casually improve adjacent code, comments, or formatting, and do not refactor code that is not broken.
- Match the existing style even when you would prefer a different one.
- Remove only unused imports, variables, functions, or dead code introduced by your change.
- Mention unrelated pre-existing dead code when useful, but do not delete it without being asked.

### Goal-Driven Execution

- Convert each task into verifiable success criteria.
- For bug fixes, reproduce then pass; for added validation, test invalid inputs then pass; for refactors, verify before and after.
- For multi-step work, state each step and its verification method briefly.
- Iterate until verification passes or a clear blocker is identified.

## Required Code Implementation Principles

These principles are mandatory for all code implementation. Project-specific conventions and local rules may make them more concrete, but must not weaken them. Conflicting implementations are incorrect even if the feature appears to work.

1. Existing structure first: Before implementing, inspect existing structure, patterns, and shared modules, then extend the existing architecture. Do not add new patterns for the same problem or create mixed architecture.
2. Reuse first (DRY): Manage identical or similar logic and business rules in a single source of truth, reused through shared modules, functions, classes, or components.
3. Responsibility separation (Single Responsibility): Each file, module, class, and function has one clear responsibility. Do not mix UI, business logic, data access, retrieval, validation, persistence, transformation, and notification in one unit.
4. No hardcoding: Put repeated values in constants, environment-specific values in configuration or environment variables, and policy values in a single definition point. Do not hardcode magic numbers, repeated strings, URLs, paths, API endpoints, or thresholds.
5. Fail fast: When expected behavior fails, expose an error immediately with enough diagnostic information. Do not hide failures with silent fallback, ignored exceptions, default returns, or bypass logic.
6. YAGNI: Implement only the current requirement. Do not add unused features, options, settings, interfaces, extension points, or speculative abstractions.
7. Explicitness: Names must reveal role and intent, and behavior must be explicit. Avoid vague names such as `util`, `helper`, `common`, `temp`, `data`, and `value`, and avoid implicit state changes.
8. Testability: Core business logic must be independently testable and external dependencies injectable. Avoid tightly coupling functions to DB, API, or filesystem dependency creation.
9. Observability: Major processing flows and failure causes must be traceable. Empty `catch` blocks, error messages without cause information, and undebuggable exception handling are prohibited.

Implementation priority is: existing structure, reuse, responsibility separation, no hardcoding, fail fast, YAGNI, explicitness, testability, observability.

## Baseline Quality Expectations

- Keep functions, modules, and files focused on a clear responsibility where practical.
- Prefer readable control flow over clever compression.
- Handle errors at the correct boundary and avoid silent failure.
- Update related types, schemas, DTOs, interfaces, and current-state docs together when behavior changes.
- Current-state docs are limited to documents that describe current usage, requirements, rules, and phase status. Existing records under `docs/implementation/` are historical implementation records, not current-change synchronization targets.
- Remove dead code, stale comments, and obvious duplication introduced by the change.
- Keep current-state docs, tests, and public behavior synchronized with the actual implementation.

## Verification Expectations

- Run or describe the most relevant available verification for the changed area.
- If the repository already has lint, type-check, test, or formatting commands, use the existing commands instead of inventing new ones.
- If no automated checks exist yet, leave a concise manual verification note.

## Ongoing Refinement

- When stronger language-specific or framework-specific standards become known, replace generic guidance with those observed conventions.
- Prefer observed project conventions over generic defaults.
- Keep unit-test and end-to-end-test specifics in [`rule/rules/testing-standards.md`](testing-standards.md) instead of overloading this file with testing detail.
