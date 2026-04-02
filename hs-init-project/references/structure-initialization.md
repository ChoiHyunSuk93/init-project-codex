# Structure Initialization Requirements

## Contents

1. Dual-mode behavior
2. Stop-and-ask conditions
3. Project-scoped OMX setup first
4. Rule and documentation requirements
5. Root AGENTS revision requirements
6. Existing project safety rules

## Dual-mode behavior

Support both fresh project initialization and existing-project Codex-structure initialization.
In existing projects, inspect first, preserve unrelated contents, avoid arbitrary moves or renames, and prefer additive initialization.

## Stop-and-ask conditions

Stop and ask before proceeding when runtime boundaries, naming conventions, existing docs/rule interpretation, or control-file overwrite policy are ambiguous.
Do not guess these decisions.

## Project-scoped OMX setup first

Before writing repository-specific rule/docs files, run `omx setup --scope project` in the target repository.
This is the canonical source for `.codex/`, `.omx/`, OMX-installed prompts/skills/agents, `.gitignore` updates, and the base root `AGENTS.md`.
Do not replace these OMX-managed catalogs with skill-bundled `.codex` templates.

## Rule and documentation requirements

Create or update these repository-owned areas after OMX setup:

- root `README.md`
- `rule/index.md`
- `rule/rules/*.md`
- `docs/guide/README.md`
- `docs/guide/subagent-workflow.md`
- `docs/implementation/AGENTS.md`

Treat them like this:

- `rule/`: authoritative repository-specific execution rules
- `docs/guide/`: user-facing workflow guides
- `docs/implementation/`: short human-facing final briefings after PASS
- `.omx/`: OMX runtime state for internal team coordination, not human-facing documentation

Do not create `subagents_docs/` in the target repository.

## Root AGENTS revision requirements

After `omx setup --scope project`, revise the generated root `AGENTS.md` by adding a repository-specific overlay.
That overlay must:

- point readers to `rule/index.md` and `rule/rules/*.md`
- define documentation boundaries between `rule/`, `docs/guide/`, and `docs/implementation/`
- keep the root file aligned with the selected language
- set the default worker execution surface to `omx team` / `$team`
- require the leader to stay in a Ralph-style ownership loop until PASS evidence exists
- require fresh verification evidence before the team is shut down or the work is declared complete
- block team launch from a pre-existing dirty workspace until a preservation commit exists
- add Korean magic-keyword aliases when the selected language is Korean
