# Documentation And Language Rules

## Observed Documentation Map

- `HS_INIT_SEMANTIC_TODO`: Record existing documentation areas, real audiences, authoritative documents, and update ownership with repository-relative paths.

## Authority And Roles

- [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md) is authoritative for purpose, scope, requirements, structure, and constraints.
- [`rule/index.md`](../index.md) is the rule discovery point and `rule/rules/*.md` contains detailed standards.
- `README.md` explains current human-facing state and usage entrypoints.
- [`docs/guide/README.md`](../../docs/guide/README.md) is the entrypoint for real usage and operating guides.
- [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md) tracks current phase status and completion gates.
- [`subagents_docs/AGENTS.md`](../../subagents_docs/AGENTS.md) defines plan, handoff, and verification working-record rules.
- [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md) defines user-facing implementation history added after verification.

## Writing Standards

- Record only facts confirmed by the current repository or the user.
- Link real files with Markdown and keep placeholders or not-yet-created paths as literals.
- Link to authoritative documents instead of duplicating the same rule.
- Write human-facing documents in the selected language while keeping filenames, directories, commands, config keys, and code identifiers stable in English.
- Update [`rule/index.md`](../index.md) in the same change when adding, removing, renaming, or moving a rule.

## Current State And History

- Update the overview, README, guides, roadmap, and relevant rules when behavior, entrypoints, structure, or operating facts change.
- Accumulate in-progress provenance in append-only cycle sections.
- After acceptance criteria and required verification pass, add a new numbered record under the nearest `docs/implementation/<category>/` for material changes.
- Preserve old cycles and implementation briefings unless correcting an error, broken link, invalid verification record, or explicit user request.
