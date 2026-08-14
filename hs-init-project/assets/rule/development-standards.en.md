# Development Standards Rule

## Priorities

1. User requirements and observable correctness
2. Existing structure and project conventions
3. Safety, data integrity, and regression prevention
4. Simplicity, maintainability, and verifiability

## Required Principles

- Search for existing implementations and shared abstractions before adding duplicates.
- Keep the change limited to what the requirement needs.
- Separate responsibilities clearly and use names that expose intent and behavior.
- Do not hardcode environments, paths, secrets, or policy values without a project contract.
- Fail fast for unsupported states; do not hide them behind silent fallback behavior.
- Do not pre-build extension points or configuration that the current requirement does not need.
- Provide errors and observability that make failures diagnosable.
- Avoid hidden side effects and global state that make behavior difficult to test.

An implementation is not complete merely because it appears to work when it conflicts with these principles or a stronger project-local rule.

## Before And After Changes

- Inspect relevant callers, public interfaces, data boundaries, and verification entrypoints before editing.
- Run the closest automated verification afterward and report anything not run with the reason.
- Preserve unrelated user changes.
