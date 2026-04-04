# Runtime Boundaries Rule

## Purpose

Define how a single source root and non-runtime areas are separated in this repository.

## Source Root Directory

List the single source-root directory here.

Example placeholder:

- `[source-root-directory]`

## Non-Runtime Directories

List non-runtime directories here.

Example placeholder:

- `rule/`
- `docs/`
- `[non-runtime-directory]`

## Ambiguity Handling

- If the boundary is unclear in an existing repository, confirm it before making structural changes.
- If several likely source-root candidates exist, confirm which single directory should be treated as the source root.
- Align to meaningful existing structure when possible instead of inventing a conflicting model.
- Replace placeholder entries with observed directories once runtime and non-runtime boundaries become clear.
- When the boundary changes, update `rule/rules/runtime-boundaries.md` and any related `rule/rules/*.md` documents in the same change.
