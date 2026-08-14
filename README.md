# hs-init-project

[English](README.md) | [한국어](README.ko.md)

`hs-init-project` is an open-source Codex skill for adding a minimal, cross-agent project contract to a new or existing repository.

## Purpose

The generated baseline stays small and product-neutral:

- root [`AGENTS.md`](AGENTS.md) as the shared agent entrypoint
- optional root `CLAUDE.md` for Claude Code
- root [`PROJECT_OVERVIEW.md`](PROJECT_OVERVIEW.md) for project purpose, constraints, and open questions
- [`rule/index.md`](rule/index.md) plus five focused rules for structure, development, testing, documentation, and agent workflow
- English or Korean document generation

The baseline does not create project-scoped custom agents, starter skills, `.codex/config.toml`, or empty `subagents_docs/` and `docs/` work-log hierarchies. Add those only when the target project has a concrete need for them.

## Repository Layout

- [`hs-init-project/SKILL.md`](hs-init-project/SKILL.md): skill behavior and workflow
- [`hs-init-project/agents/openai.yaml`](hs-init-project/agents/openai.yaml): skill metadata
- [`hs-init-project/references/`](hs-init-project/references/): detailed supporting guidance
- [`hs-init-project/assets/`](hs-init-project/assets/): generated-file templates
- [`hs-init-project/scripts/`](hs-init-project/scripts/): deterministic materialization, update, and validation helpers

## Installation

The direct `skill-installer` script treats `--ref` literally; it does not give `latest` any special meaning. The examples below pin the `v1.0.0` release that contains the minimal cross-agent harness.

### Project-Scoped Installation (Recommended)

Codex's canonical project skill directory is `<project-root>/.agents/skills/`.

Through Codex, request an explicit tag:

```text
$skill-installer
Install hs-init-project from GitHub repository ChoiHyunSuk93/init-project-codex at tag v1.0.0 into <project-root>/.agents/skills.
```

Direct installer script:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

mkdir -p .agents/skills

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo ChoiHyunSuk93/init-project-codex \
  --path hs-init-project \
  --ref v1.0.0 \
  --dest "$PWD/.agents/skills"
```

This creates `<project-root>/.agents/skills/hs-init-project/`. Replace `v1.0.0` with another existing release tag when needed.

### Global Installation

Omitting `--dest` installs into the installer's global Codex skill directory:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo ChoiHyunSuk93/init-project-codex \
  --path hs-init-project \
  --ref v1.0.0
```

An explicitly tagged URL works as well:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --url https://github.com/ChoiHyunSuk93/init-project-codex/tree/v1.0.0/hs-init-project
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
rule/
  index.md
  rules/
    project-structure.md
    development-standards.md
    testing-standards.md
    documentation.md
    agent-workflow.md
```

- `AGENTS.md` points agents to the shared contract and rule index.
- `CLAUDE.md` imports `AGENTS.md` and contains only Claude Code-specific routing.
- `PROJECT_OVERVIEW.md` records durable project context without inventing stack or product decisions.
- `rule/index.md` is the authoritative navigation point for the five rules.

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

- `--target codex|claude|both` selects product entrypoints while keeping one shared rule set.
- `--project-mode fresh|existing` distinguishes a new repository from a safe additive retrofit.
- `--readme-mode create|merge|preserve` creates a README, updates only the managed section, or leaves the existing README untouched.
- `--language en|ko` selects the generated document language.

## Development

This repository develops the skill itself, not a sample application. Keep `SKILL.md` concise, stable details in `references/`, reusable output templates in `assets/`, and deterministic behavior in `scripts/`. Keep installation and generated-structure documentation aligned with the released behavior.

## Contributing

Contributions are welcome. For branch and pull request guidance, see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
