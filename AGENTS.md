# Repository Guide

This repository develops the `hschoi-init-project` Codex skill.

## Scope

- `hschoi-init-project/SKILL.md` is the primary skill entry point.
- `hschoi-init-project/agents/openai.yaml` must stay aligned with `SKILL.md`.
- Put detailed supporting behavior in `hschoi-init-project/references/`.
- Put reusable generation templates in `hschoi-init-project/assets/`.
- Put deterministic helper scripts in `hschoi-init-project/scripts/`.

## Public Repo Rules

- Keep root documents human-facing and public-safe.
- Keep `AGENTS.md` thin and use it only for repository-wide guidance.
- Do not include local machine paths, private environment details, or maintainer-specific workflow notes here.

## Skill Rules

- Use `skill-creator` when changing the skill structure or metadata.
- Keep `SKILL.md` concise and move stable detail into `references/`.
- Add `assets/` or `scripts/` only when the output shape or workflow is stable enough to justify them.
- Validate skill changes before finishing.

## Product Rules

- The skill must support both fresh repositories and existing repositories.
- The skill must ask for language first when the language is not already fixed.
- The skill must create or update root `README.md`, root `AGENTS.md`, `rule/`, `docs/guide/`, and `docs/implementation/`.
- Generated repositories should keep control filenames stable: `README.md`, `AGENTS.md`, `rule/index.md`.
- Generated repositories should treat `rule/` as authoritative execution rules and keep `docs/guide/` and `docs/implementation/` human-facing.
- Starter rules should include README maintenance, development standards, and testing standards.

## Change Rules

- Keep open-source defaults minimal and maintainable.
- Do not invent project-specific stack choices, package files, CI, or features unless explicitly requested.
- Report observed results when changing GitHub workflow or repository policy.
