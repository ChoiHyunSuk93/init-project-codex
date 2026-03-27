# hschoi-init-project

[English](README.md) | [한국어](README.ko.md)

`hschoi-init-project` is an open-source Codex skill for bootstrapping or retrofitting a repository with a Codex-oriented working structure.

## Purpose

The skill is meant for two cases:

1. initializing a near-empty repository
2. adding Codex structure to an existing repository without rewriting unrelated project files

It focuses on a small, explicit baseline:

- root `AGENTS.md`
- root `rule/` with `rule/index.md` and indexed rule documents under `rule/rules/*.md`
- `docs/guide/README.md`
- `docs/implementation/AGENTS.md`
- language-aware document generation

## Repository Layout

- `hschoi-init-project/SKILL.md`: skill behavior and workflow
- `hschoi-init-project/agents/openai.yaml`: skill metadata
- `hschoi-init-project/references/`: detailed supporting rules for the skill
- `hschoi-init-project/assets/`: internal templates used by the skill
- `hschoi-init-project/scripts/`: deterministic helper scripts used by the skill

## Installation

Install the skill with the built-in `skill-installer` helper.
Prefer a tagged release over `main` so later updates can follow GitHub releases.
The current latest public release is `v0.1.2`.

### Project-Scoped Installation (Recommended)

Use this when you want the skill only for the current repository.
Install it into `<project-root>/.codex/skills/`.

Through Codex:

```text
$skill-installer
Install the skill from GitHub repo ChoiHyunSuk93/init-project-codex path hschoi-init-project at release tag vX.Y.Z into <project-root>/.codex/skills.
```

Direct installer script:

```bash
TAG=vX.Y.Z
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

mkdir -p .codex/skills

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo ChoiHyunSuk93/init-project-codex \
  --path hschoi-init-project \
  --ref "$TAG" \
  --dest "$PWD/.codex/skills"
```

This creates:

```text
<project-root>/.codex/skills/hschoi-init-project/
```

### Global Installation

Use this when you want the skill available across repositories.

Through Codex:

```text
$skill-installer
Install the skill from GitHub repo ChoiHyunSuk93/init-project-codex path hschoi-init-project at release tag vX.Y.Z.
```

Direct installer script:

```bash
TAG=vX.Y.Z
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo ChoiHyunSuk93/init-project-codex \
  --path hschoi-init-project \
  --ref "$TAG"
```

You can also install it by URL:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --url https://github.com/ChoiHyunSuk93/init-project-codex/tree/vX.Y.Z/hschoi-init-project
```

If Codex is already running, restart it after installation so the new skill is picked up.

### Updating An Existing Installation

Use the bundled updater to replace the installed skill directory in place.
`--ref latest` resolves the latest GitHub release tag, not the `main` branch.
If your installed copy predates this updater, reinstall once from a tagged release and use the updater after that.

Project-scoped installation:

```bash
python3 ./.codex/skills/hschoi-init-project/scripts/update-skill-release.py --ref latest
python3 ./.codex/skills/hschoi-init-project/scripts/update-skill-release.py --ref vX.Y.Z
```

Global installation:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/hschoi-init-project/scripts/update-skill-release.py" --ref latest
python3 "$CODEX_HOME/skills/hschoi-init-project/scripts/update-skill-release.py" --ref vX.Y.Z
```

The updater records the installed release source so later updates can continue from the same repo and skill path. Restart Codex after updating if it is already running.

### Maintainer Release Flow

Push the next semantic version tag for the intended release.

```bash
git tag vX.Y.Z
git push origin vX.Y.Z
```

The repository includes `.github/workflows/release.yml`, which validates the skill bundle and creates a GitHub Release for tags matching `v*`.
At least one GitHub release tag must exist before `--ref latest` can resolve successfully.
Detailed versioning rules live in [CONTRIBUTING.md](CONTRIBUTING.md).

## Generated Structure

The skill creates or updates this baseline structure:

```text
AGENTS.md
README.md
rule/
  index.md
  rules/
    project-structure.md
    instruction-model.md
    documentation-boundaries.md
    readme-maintenance.md
    development-standards.md
    testing-standards.md
    runtime-boundaries.md
    implementation-records.md
docs/
  guide/
    README.md
    [focused guide documents]   # existing-project mode when observed user-facing workflows justify them
  implementation/
    AGENTS.md
```

- `AGENTS.md`: thin repository-wide Codex guidance
- root `README.md`: durable human-facing repository summary
- `rule/`: authoritative execution rules for Codex, with `rule/index.md` as the index and `rule/rules/*.md` as the detailed rule set
- `docs/guide/`: human-facing navigation and guide documents
- `docs/implementation/`: implementation record placement rules and future record categories
- In existing-project mode, additional guide documents are created only when observed user-facing workflows provide durable reader-facing material.

## Usage

Use the skill when you want Codex to initialize or retrofit repository structure.
The command alone is enough to start; you can add a very short intent phrase if needed.

Examples:

```text
$hschoi-init-project
```

```text
Set up the initial project structure for this repository.
```

If no language choice can be inferred first, the skill asks for the language before it starts initialization.
After language is fixed, it decides whether the repository should be handled as a fresh initialization or an additive retrofit.

## Development

This repository develops the skill itself, not a sample application.

When changing the skill:

- keep `SKILL.md` thin
- move stable detail into `references/`
- keep reusable templates in `assets/`
- prefer deterministic generation through `scripts/` when repeated output becomes stable
- keep release-tag installation and update instructions current

## Contributing

Contributions are welcome. For branch and pull request guidance, see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
