# Testing And Verification Rule

## Selection

- Prefer the repository's existing test layout, naming, commands, and frameworks.
- Choose the smallest test layer that reliably verifies the change.
- Prioritize meaningful business rules, authorization, data integrity, state transitions, failure handling, external integrations, and high-risk regressions.
- Do not duplicate behavior already guaranteed by types, linting, frameworks, or database constraints.
- Verify observable behavior instead of private helpers or internal call order.

## Verification Strength

- Prefer focused unit tests for narrow logic.
- Use integration or end-to-end verification for user-critical cross-boundary flows.
- When the representative surface is a CLI, API, browser, app, or game runtime, exercise the real entrypoint in proportion to risk.
- Consider independent validation for high-risk changes, release gates, security, or data changes.
- When automation is unavailable, record manual checks and the remaining gap explicitly.

## Reporting

- Distinguish exact commands run from observed results.
- Do not summarize failures as success or claim unexecuted tests passed.
- Record surfaces blocked by environment or permissions and the limits of substitute verification.
