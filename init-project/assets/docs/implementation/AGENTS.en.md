# Implementation Records Instructions

This directory stores human-facing implementation records.

## Scope

- Keep implementation history organized by concern-based category directories.
- Create a category directory only when the first record for that concern is actually written.
- Place new records in the closest existing category.
- Add a new category only when the current categories no longer describe the work cleanly.

## File Rules

- Do not pre-create empty category directories or placeholder records during initialization.
- For every implementation change, create or update the corresponding implementation record.
- Use `NN-name.md` filenames inside each category.
- Keep numbering ordered within each category.
- Do not dump records flat under `docs/implementation/` unless a flat layout was explicitly requested.

## Record Shape

- Each implementation record should include at least `Summary`, `Changes`, `Why`, `Verification`, and `Related Rules`.
- Keep this minimal structure stable and fill it with the actual change details.

## Related Updates

- When work produces durable guide content, create or update the relevant document under `docs/guide/`.
- When a rule gains explicit new requirements or an existing rule changes, update the relevant `rule/*.md` document and `rule/index.md` in the same change.

## Authority

- This directory is for human review and work history.
- The primary execution authority remains the root `AGENTS.md` and the documents under `rule/`.

## Language Policy

- Human-facing records follow the active language policy.
- Keep this control filename as `AGENTS.md`.
- In Korean mode, the human-readable filename portion may be Korean only for non-control record files.
- Keep code, commands, config keys, slugs, and path literals in English.
