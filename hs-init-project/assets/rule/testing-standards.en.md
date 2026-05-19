# Testing Standards Rule

## Purpose

Define how unit tests, end-to-end tests, and verification expectations are established and maintained in this repository.

## Fresh Repositories

- This document starts as a provisional rule.
- Do not assume a specific unit-test or end-to-end framework before the real stack becomes known.
- Until stronger project conventions exist:
  - use unit tests for isolated logic, data transformation, and edge-case behavior where practical
  - use end-to-end tests for user-critical flows or cross-boundary behavior once those flows and interfaces exist
  - prefer the smallest test layer that gives reliable coverage for the change
- Replace generic guidance with project-specific paths, commands, and tooling once they become concrete.

## Existing Repositories

- Analyze the observed test layout, naming patterns, commands, and tooling before treating any testing rule as authoritative.
- Prefer existing test directories, commands, and naming conventions over generic defaults.
- If the repository already separates unit and end-to-end tests, document and follow that separation here.
- If stronger area-specific testing rules exist, narrow them into local rule documents instead of forcing one flat global rule.

## Baseline Expectations

- Do not create tests mechanically for every function or feature.
- For behavior changes, add or update the smallest relevant automated test layer only when the test meets the decision criteria below.
- Do not rely on end-to-end tests alone when a focused unit test is the better fit.
- Do not add broad end-to-end coverage for low-level logic that should be protected by narrower tests.
- When no automated test path exists yet, leave a concise manual verification note and update this rule once a real test path is introduced.
- In a role-separated harness, generator prioritizes unit-level verification while evaluator owns the strongest feasible user-surface/end-to-end validation.
- When a representative user surface exists, evaluator should directly exercise that surface where possible, such as browser UI, app simulator/runtime, game runtime/scene, CLI entrypoints, or API request/response flows.
- If the representative user surface could not be exercised directly, the verification record should explain why, what environment is missing, what substitute validation was used, and what gap remains.

## Test Authoring Decision Criteria

- Write tests when they protect meaningful behavior, business rules, permission/security behavior, data integrity, money/count calculations, state transitions, failure handling, external integrations, or high-risk regressions.
- Tests should verify observable behavior, not implementation details.
- Before adding a test, check:
  - What regression does this prevent?
  - What business or user risk does it reduce?
  - Is this already guaranteed by types, linting, framework behavior, or the database?
  - Will this test survive a valid refactor?

## Prefer

- Business invariant tests
- Permission and security tests
- Money, count, and state transition tests
- Boundary and failure-handling tests
- Integration tests for external systems

## Avoid

- Tests for simple CRUD passthroughs, getters/setters, or DTO shape alone
- Tests for framework defaults, library behavior, or behavior already guaranteed by the type system or database
- Tests coupled to private helpers, internal call order, or other implementation details
- Mock-heavy tests with no real behavior
- Snapshots without behavioral value
- Assertions written only to increase coverage

## Verification Recording

- New implementation records should state which unit tests were added or run.
- New implementation records should state which end-to-end tests were added or run when relevant.
- If tests were not added or run, the record should explain why and describe the manual verification that was used instead.
