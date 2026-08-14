# hs-init-project

[English](README.md) | [한국어](README.ko.md)

`hs-init-project` is an open-source Codex skill for adding an evidence-based project contract, documentation entrypoints, and adaptive work records to a new or existing repository.

## Purpose

The generated baseline stays small and product-neutral:

- root [`AGENTS.md`](AGENTS.md) as the shared agent entrypoint
- optional root `CLAUDE.md` for Claude Code
- root [`PROJECT_OVERVIEW.md`](PROJECT_OVERVIEW.md) for project purpose, constraints, and open questions
- [`rule/index.md`](rule/index.md) plus five focused rules for structure, development, testing, documentation, and agent workflow
- `docs/guide/README.md` and `docs/implementation/AGENTS.md` for current user workflows and verified implementation history
- `subagents_docs/AGENTS.md`, `subagents_docs/roadmap.md`, and on-demand cycles for phase status, handoffs, and verification provenance
- English or Korean document generation

The baseline does not create project-scoped custom agents, starter skills, `.codex/config.toml`, stacks, CI, or product features. Existing-project initialization must analyze real source, configuration, tests, commands, and documentation, then replace semantic markers before completion.

## Repository Layout

- [`hs-init-project/SKILL.md`](hs-init-project/SKILL.md): skill behavior and workflow
- [`hs-init-project/agents/openai.yaml`](hs-init-project/agents/openai.yaml): skill metadata
- [`hs-init-project/references/`](hs-init-project/references/): detailed supporting guidance
- [`hs-init-project/assets/`](hs-init-project/assets/): generated-file templates
- [`hs-init-project/scripts/`](hs-init-project/scripts/): deterministic materialization, update, and validation helpers

## Installation

The direct `skill-installer` script treats `--ref` literally; it does not give `latest` any special meaning. The examples below pin the current documented release, `v2.0.0`.

### Project-Scoped Installation (Recommended)

Codex's canonical project skill directory is `<project-root>/.agents/skills/`.

Through Codex, request the current release tag:

```text
$skill-installer
Install hs-init-project from GitHub repository ChoiHyunSuk93/init-project-codex at v2.0.0 into <project-root>/.agents/skills.
```

Direct installer script:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

mkdir -p .agents/skills

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo ChoiHyunSuk93/init-project-codex \
  --path hs-init-project \
  --ref v2.0.0 \
  --dest "$PWD/.agents/skills"
```

This creates `<project-root>/.agents/skills/hs-init-project/` from the current documented release.

### Global Installation

Omitting `--dest` installs into the installer's global Codex skill directory:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo ChoiHyunSuk93/init-project-codex \
  --path hs-init-project \
  --ref v2.0.0
```

An explicit ref URL works as well:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --url https://github.com/ChoiHyunSuk93/init-project-codex/tree/v2.0.0/hs-init-project
```

Restart Codex after installation if it is already running.

### Updating an Existing Installation

The bundled updater, unlike the direct installer, intentionally supports `--ref latest` and resolves it to the latest GitHub Release tag.

Project-scoped installation:

```bash
python3 ./.agents/skills/hs-init-project/scripts/update-skill-release.py --ref latest
python3 ./.agents/skills/hs-init-project/scripts/update-skill-release.py --ref vX.Y.Z
```

Global installation:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/hs-init-project/scripts/update-skill-release.py" --ref latest
python3 "$CODEX_HOME/skills/hs-init-project/scripts/update-skill-release.py" --ref vX.Y.Z
```

If an installed copy predates the updater, reinstall it once from an explicit tag. Restart Codex after updating if it is already running.

### Maintainer Release Flow

Push the next semantic version tag for the intended release:

```bash
git tag vX.Y.Z
git push origin vX.Y.Z
```

The repository's release workflow validates the skill bundle and creates a GitHub Release for tags matching `v*`. Detailed versioning rules live in [CONTRIBUTING.md](CONTRIBUTING.md).

## Generated Structure

The exact entrypoints depend on `--target`; the shared baseline is:

```text
AGENTS.md
CLAUDE.md                         # target claude or both only
README.md                         # controlled by --readme-mode
PROJECT_OVERVIEW.md
docs/
  guide/README.md
  implementation/AGENTS.md
rule/
  index.md
  rules/
    project-structure.md
    development-standards.md
    testing-standards.md
    documentation.md
    agent-workflow.md
subagents_docs/
  AGENTS.md
  roadmap.md
  cycles/
```

- `AGENTS.md` points agents to the shared contract and rule index.
- `CLAUDE.md` imports `AGENTS.md` and contains only Claude Code-specific routing.
- `PROJECT_OVERVIEW.md` records durable project context without inventing stack or product decisions.
- `rule/index.md` is the authoritative navigation point for the five rules.
- `docs/guide/` holds current human-followable workflows and `docs/implementation/` accumulates verified user-facing history.
- `subagents_docs/` tracks phase gates and, when work merits it, append-only main-agent/subagent cycle provenance.

## Usage

Invoke the skill conversationally:

```text
$hs-init-project
```

For deterministic or automated materialization, use the helper's explicit contract:

```bash
sh hs-init-project/scripts/materialize_repo.sh \
  --root . \
  --language ko \
  --target both \
  --project-mode existing \
  --readme-mode preserve \
  --dry-run
```

Remove `--dry-run` after reviewing the planned output.

Materialization creates the deterministic baseline. The invoking agent must then analyze the actual repository, replace every `HS_INIT_SEMANTIC_TODO` marker with observed or user-confirmed facts, and run:

```bash
python3 hs-init-project/scripts/validate_materialized_repo.py \
  --root <project-root> \
  --project-mode existing
```

- `--target codex|claude|both` selects product entrypoints while keeping one shared rule set.
- `--project-mode fresh|existing` distinguishes a new repository from a safe additive retrofit.
- `--readme-mode create|merge|preserve` creates a README, updates only the managed section, or leaves the existing README untouched.
- `--language en|ko` selects the generated document language.
- Existing-project completion requires real repository-relative evidence in `PROJECT_OVERVIEW.md`; a directory-only inventory is not sufficient.

## Development

This repository develops the skill itself, not a sample application. Keep `SKILL.md` concise, stable details in `references/`, reusable output templates in `assets/`, and deterministic behavior in `scripts/`. Keep installation and generated-structure documentation aligned with the released behavior.

## Contributing

Contributions are welcome. For branch and pull request guidance, see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
