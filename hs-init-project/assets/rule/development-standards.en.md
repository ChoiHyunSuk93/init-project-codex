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
  - synchronized code, docs, and verification
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

## Baseline Quality Expectations

- Keep functions, modules, and files focused on a clear responsibility where practical.
- Prefer readable control flow over clever compression.
- Handle errors at the correct boundary and avoid silent failure.
- Update related types, schemas, DTOs, interfaces, and docs together when behavior changes.
- Remove dead code, stale comments, and obvious duplication introduced by the change.
- Keep docs, tests, and public behavior synchronized with the actual implementation.

## Verification Expectations

- Run or describe the most relevant available verification for the changed area.
- If the repository already has lint, type-check, test, or formatting commands, use the existing commands instead of inventing new ones.
- If no automated checks exist yet, leave a concise manual verification note.

## Ongoing Refinement

- When stronger language-specific or framework-specific standards become known, replace generic guidance with those observed conventions.
- Prefer observed project conventions over generic defaults.
- Keep unit-test and end-to-end-test specifics in [`rule/rules/testing-standards.md`](testing-standards.md) instead of overloading this file with testing detail.
