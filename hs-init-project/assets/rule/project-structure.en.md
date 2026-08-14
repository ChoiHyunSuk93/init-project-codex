# Project Structure Rules

## Purpose

Prefer observed repository structure and responsibility boundaries instead of imposing an agent-invented layout.

## Observed Project Structure

- `HS_INIT_SEMANTIC_TODO`: Record real source areas, runtime entrypoints, major module responsibilities, and test/tool/docs boundaries with repository-relative paths.

## Standards

- Inspect top-level areas, runtime source, tests, docs, generated artifacts, and tooling boundaries before changing structure.
- Prefer existing layout and naming; do not move or reorganize content without a concrete benefit.
- Allow multiple intentional source areas in monorepos and multi-runtime repositories.
- Distinguish runtime code from non-runtime documentation, tests, tools, and generated artifacts.
- Add a top-level directory only when existing locations cannot express the responsibility clearly.
- Add local instruction files only when a directory has genuinely narrower rules.

## Existing Repositories

- Do not infer meaning from file or directory names alone.
- Inspect package and workspace configuration, build and test entrypoints, imports, real source, and existing docs together.
- Ask the smallest necessary question when an ambiguous boundary would materially change the result.

## Fresh Repositories

- Do not create unconfirmed stacks, packages, modules, or deployment structures.
- Start small and expand only when real responsibilities appear.
