# Runtime Boundaries Rule

## Purpose

Define how runtime and non-runtime areas are separated in this repository.

## Runtime Directories

List runtime directories here.

Multiple runtime directories are valid.
Examples include `backend/` and `frontend/`, or `api/` and `web/`.

Example placeholder:

- `[runtime-directory]`

## Non-Runtime Directories

List non-runtime directories here.

Example placeholder:

- `rule/`
- `docs/`
- `[non-runtime-directory]`

## Ambiguity Handling

- If the boundary is unclear in an existing repository, confirm it before making structural changes.
- If several likely runtime directories exist, present them together and confirm whether they should all be treated as runtime.
- Align to meaningful existing structure when possible instead of inventing a conflicting model.
- Replace placeholder entries with observed directories once runtime and non-runtime boundaries become clear.
- When the boundary changes, update `rule/rules/runtime-boundaries.md` and any related `rule/rules/*.md` documents in the same change.
