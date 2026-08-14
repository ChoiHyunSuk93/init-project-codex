# Documentation And Language Rule

## Authority And Roles

- [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md) is the authority for purpose, scope, and constraints.
- [`rule/index.md`](../index.md) is the execution-rule discovery point and `rule/rules/*.md` contains detailed standards.
- `README.md` explains current human-facing state and usage entrypoints.
- Do not mix working plans, temporary notes, or historical implementation records into those authority documents.

## Authoring

- Record only facts observed in the repository or confirmed by the user.
- Use Markdown links for existing files; keep placeholders and not-yet-created paths as literals.
- Link to authoritative rules instead of copying the same rule into multiple documents.
- Write human-facing prose in the selected language while keeping filenames, directories, commands, config keys, and code identifiers in stable English form.
- Update [`rule/index.md`](../index.md) in the same change when a rule is added, removed, renamed, or moved.

## Maintenance

- Update current-state docs when behavior, entrypoints, structure, or operational facts change.
- Do not rewrite historical records to match current state except for typos, broken links, incorrect verification facts, or explicit user requests.
- Create documentation directories only when a stable workflow exists for a real reader.
