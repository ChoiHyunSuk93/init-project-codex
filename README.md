# hs-init-project

[English](README.md) | [한국어](README.ko.md)

`hs-init-project` is an open-source Codex skill for bootstrapping or retrofitting a repository with repository-specific rules/docs **on top of a project-scoped OMX install**.

## Purpose

The generated baseline now follows this order:

1. run `omx setup --scope project`
2. create `rule/` and `docs/`
3. revise the OMX-generated root `AGENTS.md` with repository-specific rules and documentation boundaries
4. use `omx team` as the default execution surface while the leader keeps a Ralph-style completion loop until PASS

## Repository Layout

- `hs-init-project/SKILL.md`: skill behavior and workflow
- `hs-init-project/agents/openai.yaml`: skill metadata
- `hs-init-project/references/`: detailed supporting rules for the skill
- `hs-init-project/assets/`: internal templates used by the skill
- `hs-init-project/scripts/`: deterministic helper scripts used by the skill

## Installation

Install the skill with the built-in `skill-installer` helper.
A globally available `omx` CLI is the preferred baseline because the generated project uses `omx setup --scope project` as the first materialization step.
Prefer a tagged release over `main` so later updates can follow GitHub releases.
The direct installer script supports `--ref latest` and resolves the newest version tag in the repository at install time.

### If `omx` Is Not Installed Globally

If `omx --version` fails, install oh-my-codex globally first.
The currently installed package metadata in this environment reports `oh-my-codex` with `bin.omx` and `node >=20`, so this is the expected bootstrap path:

```bash
node --version
npm install -g oh-my-codex
omx --version
omx doctor
```

### Project-Scoped Installation (Recommended)

Use this when you want the skill only for the current repository.
Install it into `<project-root>/.codex/skills/`.

Through Codex:

```text
$skill-installer
Install the skill from GitHub repo ChoiHyunSuk93/init-project-codex path hs-init-project at the latest version into <project-root>/.codex/skills.
```

### Global Installation

Use this when you want the skill available across repositories.
This pairs naturally with the skill's project-generation flow because the skill will later call `omx setup --scope project` inside the target repository.

Through Codex:

```text
$skill-installer
Install the skill from GitHub repo ChoiHyunSuk93/init-project-codex path hs-init-project at the latest version.
```

### Updating an Existing Installation

Use `skill-installer` again with the same target scope.
Reinstalling at the newer version is the supported update path in this README.

Project-scoped update through Codex:

```text
$skill-installer
Install the skill from GitHub repo ChoiHyunSuk93/init-project-codex path hs-init-project at the latest version into <project-root>/.codex/skills.
```

Global update through Codex:

```text
$skill-installer
Install the skill from GitHub repo ChoiHyunSuk93/init-project-codex path hs-init-project at the latest version.
```

If Codex is already running, restart it after the update so the refreshed skill is picked up.

## Generated Structure

```text
AGENTS.md                      # OMX-generated root contract + repository-specific overlay
.codex/                       # created/refreshed by omx setup --scope project
.omx/                         # created/refreshed by omx setup --scope project
README.md
rule/
  index.md
  rules/
    project-structure.md
    instruction-model.md
    rule-maintenance.md
    documentation-boundaries.md
    language-policy.md
    readme-maintenance.md
    development-standards.md
    testing-standards.md
    runtime-boundaries.md
    implementation-records.md
    subagent-orchestration.md
docs/
  guide/
    README.md
    subagent-workflow.md
  implementation/
    AGENTS.md
    [category]/
      [final briefings]
```

## Execution Model

Generated repositories use a **team-first plus Ralph-led** execution rule.
The leader owns intake, staffing, PASS/FAIL judgment, relaunch decisions, and dirty-workspace preflight.
`omx team` / `$team` is the default worker execution surface.
Inside the team run, planning, implementation, and evaluation are mandatory minimum distinct lanes, with optional specialist lanes on top.
Before team launch, a pre-existing dirty workspace is blocked by default and should be preserved with a commit first.
Internal coordination stays in `.omx/`; the durable repository output is the final briefing under `docs/implementation/` after PASS.
