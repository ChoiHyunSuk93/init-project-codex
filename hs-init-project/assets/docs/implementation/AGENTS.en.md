# Implementation Records Instructions

This directory stores human-facing final briefings.

## Scope

- Keep implementation history organized by concern-based category directories.
- Create a category directory only when the first record for that concern is actually written.
- Place new records in the closest existing category.
- Add a new category only when the current categories no longer describe the work cleanly.
- This directory is for human-facing short final briefings and outcomes only.
- Keep briefings inside concern-based categories. Do not create a top-level `briefings/` directory.

## File Rules

- Do not pre-create empty category directories or placeholder records during initialization.
- For every plan cycle that evaluator passes, create or update the corresponding final briefing.
- Do not create or update final briefings from a plan-only or generator-only state.
- Use `NN-name.md` filenames inside each category.
- Keep numbering ordered within each category.
- Do not dump records flat under `docs/implementation/` unless a flat layout was explicitly requested.

## Record Shape

- Each final briefing should include at least `Summary`, `What Changed`, `Outcome`, and `Verification`.
- Keep this minimal structure stable and fill it with the actual change details.
- In `Verification`, note unit tests, end-to-end tests, and manual checks separately when that distinction matters.

## Related Updates

- If a change affects a real user-facing workflow, create or update the relevant guide document under `docs/guide/`.
- Do not move implementation notes, repository maps, or copied rule text into `docs/guide/`.
- When a rule gains explicit new requirements or an existing rule changes, follow `rule/rules/rule-maintenance.md` and keep the relevant rule document plus `rule/index.md` aligned in the same change.
- Keep implementation records aligned with `rule/rules/testing-standards.md` when tests or verification conventions become more concrete.
- Keep planner documents, generator change records, and evaluator reports in separate owned outputs under `subagents_docs/`.
- Use `rule/rules/cycle-document-contract.md` for the exact working-record contract that keeps cycle outputs out of `docs/implementation/`.

## Authority

- This directory is for human review and work history.
- The primary execution authority remains the root `AGENTS.md`, `rule/index.md`, and the documents under `rule/rules/`.

## Language Policy

- Follow `rule/rules/language-policy.md` for the exact language and filename/path rules for human-facing records.
- `subagents_docs/` working records follow that same rule within their own working-doc boundary.
- Keep this control filename as `AGENTS.md`.
- Keep code, commands, config keys, slugs, and path literals in English.
