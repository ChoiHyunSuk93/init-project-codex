# hschoi-init-project

[English](README.md) | [한국어](README.ko.md)

`hschoi-init-project` is an open-source Codex skill for bootstrapping or retrofitting a repository with a Codex-oriented working structure.

## Purpose

The skill is meant for two cases:

1. initializing a near-empty repository
2. adding Codex structure to an existing repository without rewriting unrelated project files

It focuses on a small, explicit baseline:

- root `AGENTS.md`
- root `rule/` with `rule/index.md` and starter rule documents
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

Install the skill through Codex with `skill-installer`.

```text
$skill-installer
Install the skill from GitHub repo ChoiHyunSuk93/init-project-codex path hschoi-init-project.
```

You can also run the installer script directly if needed.

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo ChoiHyunSuk93/init-project-codex \
  --path hschoi-init-project \
  --ref main
```

You can also install it by URL:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --url https://github.com/ChoiHyunSuk93/init-project-codex/tree/main/hschoi-init-project
```

After installation, restart Codex to pick up the new skill.

## Usage

Use the skill when you want Codex to initialize or retrofit repository structure.

Examples:

```text
$hschoi-init-project
```

```text
Initialize this repository for Codex with a root AGENTS.md, rule/, docs/guide, and docs/implementation.
```

The skill asks for language first when language is not already fixed, then decides whether the repository should be handled as a fresh initialization or an additive retrofit.

## Development

This repository develops the skill itself, not a sample application.

When changing the skill:

- keep `SKILL.md` thin
- move stable detail into `references/`
- keep reusable templates in `assets/`
- prefer deterministic generation through `scripts/` when repeated output becomes stable

## Contributing

Contributions are welcome. For branch and pull request guidance, see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
