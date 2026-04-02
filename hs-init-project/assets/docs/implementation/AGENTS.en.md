# Implementation Records Instructions

This directory stores human-facing final briefings.

## Scope

- Keep implementation history organized by concern-based category directories.
- Create a category directory only when the first record for that concern is actually written.
- Place new records in the closest existing category.
- Add a new category only when the current categories no longer describe the work cleanly.
- This directory is for human-facing short final briefings and outcomes only.

## File Rules

- Do not pre-create empty category directories or placeholder records during initialization.
- For every team cycle that the leader marks PASS, create or update the corresponding final briefing.
- Use `NN-name.md` filenames inside each category.
- Keep numbering ordered within each category.

## Record Shape

- Each final briefing should include at least `Summary`, `What Changed`, `Outcome`, and `Verification`.
- Keep the writing short and readable for users.
- In `Verification`, separate automated tests, manual checks, and remaining gaps when that distinction is meaningful.

## Runtime Note

- Internal team coordination and intermediate evidence live in `.omx/`, not in a repository-owned working-doc directory.
