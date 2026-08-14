# Testing And Verification Rules

## Confirmed Verification Entrypoints

- `HS_INIT_SEMANTIC_TODO`: Record unit, integration, E2E, build, and lint commands confirmed in real manifests, tasks, CI, or existing docs, together with their scope. Do not record guessed commands.

## Selection

- Prefer existing test structure, naming, commands, and frameworks.
- Select the smallest test layer that reliably verifies the change.
- Prioritize business rules, permissions, data integrity, state transitions, failure handling, integrations, and high-risk regressions.
- Do not duplicate behavior already guaranteed by types, linting, frameworks, or the database.
- Verify observable behavior instead of private helpers or internal call order.

## Verification Depth

- Prefer focused unit tests for narrow logic.
- Use integration or E2E verification for important flows that cross boundaries.
- Exercise the representative CLI, API, browser, app, or game runtime entrypoint in proportion to risk.
- Consider independent validation for high-risk changes, release gates, security, or data changes.
- When no automated path exists, record manual verification and the remaining gap.

## Reporting

- Separate exact commands from observed results.
- Do not summarize failures as success or claim tests that were not run.
- Record surfaces blocked by environment or permissions and the limitations of substitute checks.
