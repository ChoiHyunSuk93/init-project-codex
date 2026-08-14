@AGENTS.md

# Claude Code Project Instructions

This file is a thin entrypoint that loads the shared repository instructions for Claude Code.
Share the common contract through the `@AGENTS.md` import above instead of duplicating it here.

## Rule Discovery

- Use [`rule/index.md`](rule/index.md) as the authoritative entrypoint for detailed rules.
- Before working, read the `rule/rules/*.md` documents relevant to the request and change scope.
- Follow any narrower directory instructions within their applicable scope.

## Claude Code-Specific Instructions

- Keep only Claude Code-specific differences in this file.
- Do not add content that conflicts with or duplicates the shared contract.
- Update `AGENTS.md` and the relevant rule documents as the source of truth for shared changes.
