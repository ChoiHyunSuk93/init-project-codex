# Development Standards

## Observed Project Conventions

- `HS_INIT_SEMANTIC_TODO`: Record architecture, naming, formatting, dependency, and error-handling conventions confirmed in real source or configuration. Mark unresolved items explicitly.

## Priorities

1. User requirements and observable correctness
2. Existing structure and project conventions
3. Safety, data integrity, and regression prevention
4. Simplicity, maintainability, and verifiability

## Required Principles

- Find existing implementations and shared abstractions before adding duplicates.
- Keep the change limited to what the requirement needs.
- Separate responsibilities and use names that reveal intent and behavior.
- Do not arbitrarily hardcode environment values, paths, secrets, or policy values.
- Fail fast for unsupported states instead of hiding them with silent fallbacks.
- Do not pre-create extension points or configuration without a current need.
- Preserve diagnostic errors and observability for important failures.
- Avoid hidden side effects and global state that make behavior difficult to test.

An implementation that appears to work but conflicts with these principles or a stronger local rule is not complete.

## Before And After Changes

- Inspect related call sites, public interfaces, data boundaries, and verification paths before changing behavior.
- Run the closest automated verification afterward and report anything not run with its reason.
- Preserve unrelated user changes.
