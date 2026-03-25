# README Maintenance Rule

## Purpose

Define how the root `README.md` is created and maintained as the repository's primary human-facing entry point.

## Role Of `README.md`

- `README.md` is the first human-facing summary of the repository.
- It should explain what the project is, what this repository contains, and how to navigate it at a high level.
- Keep the control filename stable as `README.md`.

## Fresh Repositories

- Create a minimal template `README.md`.
- Use safe placeholders when the project purpose or usage is not yet concrete.
- Do not invent features, setup steps, or technical guarantees.

## Existing Repositories

- Analyze the observed project structure, source areas, existing docs, and automation before writing or updating `README.md`.
- Reflect the real project purpose, major directories, and current entry points only when they can be observed.
- If an existing `README.md` already contains meaningful project information, refine or extend it instead of replacing it blindly.

## Ongoing Maintenance

- Update `README.md` when durable project-facing facts change, such as repository purpose, major structure, usage entry points, or contributor-facing workflow.
- Keep `README.md` high-signal and summary-oriented.
- Move deeper reference material into `docs/guide/` when the documentation set grows.
- Link to relevant guide documents from `README.md` when they improve navigation.
