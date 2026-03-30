# Subagent Harness Record

## Summary

The repository now separates planner, generator, and evaluator work through `subagents_docs/` while keeping `docs/implementation/` for short user-facing briefings.

## Key Points

- The category-based `docs/implementation/` model stays intact in user-facing categories.
- Working documents stay in `subagents_docs/`; only implementation briefings are kept under category folders in `docs/implementation/`.
- The selected language controls the language used in `subagents_docs/`.
- The coordinator does not bypass slow subagents by implementing directly.
