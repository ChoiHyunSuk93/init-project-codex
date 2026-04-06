# Rule Maintenance Rule

## Purpose

Define how authoritative rule documents are created, indexed, changed, and kept aligned over time.

## Authority Model

- [`rule/index.md`](../index.md) is the discovery point for authoritative rule documents.
- Indexed rule documents live under `rule/rules/` unless the user explicitly asks for a different structure.
- A rule document is not authoritative until it is listed in [`rule/index.md`](../index.md).

## Rule Lifecycle

- When a new explicit rule is needed, create or update the most relevant document under `rule/rules/` instead of scattering the requirement across multiple instruction files.
- Update [`rule/index.md`](../index.md) in the same change whenever a rule document is added, deleted, renamed, or moved.
- Keep the index entry fields aligned with the real rule document path, scope, applies-to area, authority, and summary.
- Prefer extending an existing rule document when the requirement belongs to an established rule boundary.

## Consistency Requirements

- Keep the control filename stable as [`rule/index.md`](../index.md).
- Keep indexed rule paths stable and predictable.
- If one change affects multiple rules, update every impacted rule document in the same change.
- Remove stale references, orphaned summaries, and outdated paths when rule structure changes.
- When entrypoint or control-document references are maintained as Markdown links, update those links in the same change as the path change.
- Real links must resolve correctly from the current document and must not be left broken.
- When a new entrypoint or control document is introduced, align related references in README, AGENTS, guides, skills, and script-generated outputs within the same change.

## Starter Rule Maintenance

- Starter rule placeholders may exist in fresh repositories, but replace them with observed project-specific values once real structure or conventions become clear.
- Do not leave copied rule text spread across [`AGENTS.md`](../../AGENTS.md), guide docs, or implementation records when the source rule document is the authoritative location.
- When introducing a local-scope rule, add it to [`rule/index.md`](../index.md) as a local entry and keep it under `rule/rules/` unless the user explicitly requested a different location.
