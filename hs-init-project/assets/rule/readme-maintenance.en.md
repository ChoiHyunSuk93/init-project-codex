# README Maintenance Rule

## Purpose

Define how the root [`README.md`](../../README.md) is created and maintained as the repository's primary human-facing entry point.

## Role Of `README.md`

- [`README.md`](../../README.md) is the first human-facing summary of the repository.
- It should explain what the project is, what this repository contains, and how to navigate it at a high level.
- Link detailed requirements and phase planning to [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md) and [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md) instead of duplicating them at length in the README.
- Use Markdown links when `README.md` points readers to real entrypoint or control documents.
- Leave wildcards, placeholders, example paths, and not-yet-created documents as plain path literals instead of links.
- Keep the control filename stable as [`README.md`](../../README.md).

## Fresh Repositories

- Create a minimal template [`README.md`](../../README.md).
- Use safe placeholders when the project purpose or usage is not yet concrete.
- Do not invent features, setup steps, or technical guarantees.

## Existing Repositories

- Analyze the observed project structure, source areas, existing docs, and automation before writing or updating [`README.md`](../../README.md).
- Reflect the real project purpose, major directories, and current entry points only when they can be observed.
- If an existing [`README.md`](../../README.md) already contains meaningful project information, refine or extend it instead of replacing it blindly.

## Ongoing Maintenance

- Update [`README.md`](../../README.md) when durable project-facing facts change, such as repository purpose, major structure, usage entry points, or contributor-facing workflow.
- Keep [`README.md`](../../README.md) high-signal and summary-oriented.
- Move deeper user-facing workflow guides into `docs/guide/` when the documentation set grows, using [`docs/guide/README.md`](../../docs/guide/README.md) as the guide entry point.
- Link to relevant entrypoint documents such as [`AGENTS.md`](../../AGENTS.md), [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md), [`rule/index.md`](../index.md), [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md), [`docs/guide/README.md`](../../docs/guide/README.md), and [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md) when they improve navigation.
