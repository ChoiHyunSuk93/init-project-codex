# Implementation Records Rule

## Purpose

Define how human-facing final briefings are stored under `docs/implementation/`.

## Category Model

- Use concern-based category directories.
- Create a category directory only when the first record for that concern is actually needed.
- Choose categories from evaluator-passed plan cycles, user-facing outcome groupings, and existing documentation domains.
- Avoid weak catch-all categories such as `misc`, `general`, `notes`, or `other`.

## Record Placement

- Do not pre-create empty category directories or placeholder records during initialization.
- Put each record into the closest existing category directory.
- Add a new category only when the current categories no longer describe the work cleanly.
- Do not dump records flat under `docs/implementation/` unless a flat layout is explicitly requested.
- Do not create a top-level `docs/implementation/briefings/` directory.
- For every plan cycle that evaluator passes, create or update the corresponding final briefing.
- Keep numbering ordered within the chosen category.

## File Naming

- Use ordered markdown filenames in `NN-name.md` format.
- Keep control filenames stable, including `AGENTS.md`.
- In Korean mode, the human-readable filename portion may be Korean only for non-control record files.
- Keep numbering stable and sequential within each category.

## Record Shape

- Each final briefing should include at least `Summary`, `What Changed`, `Outcome`, and `Verification`.
- Keep this minimal structure stable and fill it with the actual change details.
- Keep the writing short and readable for users.
- In `Verification`, separate unit tests, end-to-end tests, manual checks, and remaining gaps when that distinction is meaningful.
