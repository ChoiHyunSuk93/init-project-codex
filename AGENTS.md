# Repository Guide

This repository develops the `init-project` Codex skill.

The skill itself lives in `./init-project`. Keep repository-level files human-facing and skill files agent-facing.

## Source Of Truth

- `init-project/SKILL.md` defines the skill trigger and behavior.
- `init-project/agents/openai.yaml` defines UI-facing metadata and must stay aligned with `SKILL.md`.
- `PROMPT.md` is the current product-requirements source for this repository. Treat it as input for skill development, not as runtime skill content.
- Root-level docs such as `README.md` are for humans. Do not duplicate them inside the skill folder.

## Working Rules

- Use the `skill-creator` workflow when changing skill structure or metadata.
- Keep `SKILL.md` concise. Add bundled resources only when they are clearly reusable.
- Keep SKILL frontmatter limited to `name` and `description`.
- Put stable, detailed behavior into `init-project/references/` instead of bloating `SKILL.md`.
- Put reusable generated-file templates into `init-project/assets/` when the output format is stable enough to reuse.
- Add `scripts/` or `assets/` only when the repeated workflow is stable enough to justify them.
- Run `python3 /home/iotree/.codex/skills/.system/skill-creator/scripts/quick_validate.py init-project` after skill edits.

## Scope Rules

- This skill is for initializing repositories, GitHub rule structure, and minimal project scaffolding.
- This skill must handle both blank repositories and existing repositories that already contain meaningful source code.
- This skill must ask language first and apply the chosen language consistently to generated documents and generated `AGENTS.md` files.
- Control filenames such as `README.md`, `AGENTS.md`, and `rule/index.md` should remain stable across language modes.
- Runtime versus non-runtime naming ambiguity should use an explicit question template, not ad hoc questioning.
- Implementation categories should be derived by Codex from observed repository concerns, created lazily when records are written, and reflected in generated `AGENTS.md` guidance.
- Generated implementation records should follow a stable minimal shape: summary, changes, why, verification, and related rules.
- When starter rule templates begin with placeholders, the skill should require those placeholders to be replaced once real structure and boundaries are known.
- Generated root `AGENTS.md` should include conditional guidance for skill work: use `skill-creator`, support both explicit and implicit invocation, and reference applicable `rule/*.md` documents from each skill.
- Do not turn it into a generic app generator.
- Do not invent project-specific stack choices, package files, or CI unless explicitly requested.
- Keep open-source defaults minimal, credible, and easy to maintain.

## GitHub Ruleset Guidance

- Treat GitHub settings as untrusted until verified against the remote state.
- Prefer editing the existing protection system already in use by the repository instead of mixing branch protection and rulesets without a reason.
- When validating direct-push behavior, prefer non-destructive checks first, such as `git push --dry-run`.
- If admin bypass exists, state clearly that direct pushes may still be possible for privileged users.

## Git Hygiene

- Keep changes focused and easy to review.
- Do not rewrite unrelated history.
- If you change repository rules, default branch behavior, or merge policy, report the observed result, not just the intended configuration.
