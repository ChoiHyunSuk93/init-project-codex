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
