# Implementation Records Rule

## Purpose

Define how implementation history is stored under `docs/implementation/`.

## Category Model

- Use concern-based category directories.
- Create a category directory only when the first record for that concern is actually needed.
- Choose categories from observed source areas, architecture boundaries, recurring work streams, and existing documentation domains.
- Avoid weak catch-all categories such as `misc`, `general`, `notes`, or `other`.

## Record Placement

- Do not pre-create empty category directories or placeholder records during initialization.
- Put each record into the closest existing category directory.
- Add a new category only when the current categories no longer describe the work cleanly.
- Do not dump records flat under `docs/implementation/` unless a flat layout is explicitly requested.
- For every implementation change, create or update the corresponding implementation record.
- Keep numbering ordered within the chosen category.

## File Naming

- Use ordered markdown filenames in `NN-name.md` format.
- Keep control filenames stable, including `AGENTS.md`.
- In Korean mode, the human-readable filename portion may be Korean only for non-control record files.
- Keep numbering stable and sequential within each category.

## Record Shape

- Each implementation record should include at least `Summary`, `Changes`, `Why`, `Verification`, and `Related Rules`.
- Keep this minimal structure stable and fill it with the actual change details.
