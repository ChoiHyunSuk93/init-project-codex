# Project Structure Rule

## Purpose

Prefer observed repository structure and responsibility boundaries instead of imposing an agent-invented layout.

## Standards

- Inspect top-level areas, runtime source, tests, docs, generated artifacts, and tooling boundaries before changing structure.
- Prefer existing layout and naming; do not move or reorganize content without a concrete benefit.
- A single application may keep one clear source root, while monorepos and multi-runtime repositories may have multiple intentional source areas.
- Distinguish runtime code from non-runtime documentation, tests, tools, and generated artifacts.
- Add a new top-level directory only when existing locations cannot express the responsibility clearly.
- Add local instruction files only for genuinely narrower directory constraints.

## Existing Repositories

- Do not infer semantics from directory names alone.
- Inspect package/workspace configuration, build and test entrypoints, imports, and existing docs together.
- Ask the smallest question when an ambiguous boundary would materially change the implementation.

## Fresh Repositories

- Do not create stacks, packages, modules, or deployment structure the user did not confirm.
- Start small and expand only when real responsibilities emerge.
