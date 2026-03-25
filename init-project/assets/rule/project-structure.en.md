# Project Structure Rule

## Purpose

Define the top-level directory model for this repository and make the role of each major area explicit.

## Top-Level Areas

- `AGENTS.md`: repository-wide orchestration guidance
- `rule/`: authoritative Codex execution rules
- `docs/guide/`: human-facing guidance
- `docs/implementation/`: human-facing implementation records

## Runtime Areas

List the directories treated as runtime here.

Example placeholder:

- `[runtime-directory]`

## Non-Runtime Areas

List the directories treated as non-runtime here.

Example placeholder:

- `rule/`
- `docs/`
- `[non-runtime-directory]`

## Change Rules

- Keep runtime and non-runtime boundaries explicit.
- Replace placeholder entries with observed paths once the real directory structure becomes known.
- Reflect actual top-level structure changes in `rule/project-structure.md`.
- Do not move or rename established top-level areas without updating `rule/index.md` and related rule documents.
- When local structure becomes complex, add local instruction files only where they improve scope clarity.
