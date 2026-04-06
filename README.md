# hs-init-project

[English](README.md) | [한국어](README.ko.md)

`hs-init-project` is an open-source Codex skill for bootstrapping or retrofitting a repository with a Codex-oriented working structure.

## Purpose

The skill is meant for two cases:

1. initializing a near-empty repository
2. adding Codex structure to an existing repository without rewriting unrelated project files

It focuses on a small, explicit baseline:

- root [`AGENTS.md`](AGENTS.md)
- root `rule/` with [`rule/index.md`](rule/index.md) and indexed rule documents under `rule/rules/*.md`
- [`subagents_docs/AGENTS.md`](subagents_docs/AGENTS.md) plus `subagents_docs/` working docs for planner / generator / evaluator
- [`docs/guide/README.md`](docs/guide/README.md)
- [`docs/implementation/AGENTS.md`](docs/implementation/AGENTS.md) plus user-facing final briefings
- language-aware document generation

## Repository Layout

- [`hs-init-project/SKILL.md`](hs-init-project/SKILL.md): skill behavior and workflow
- [`hs-init-project/agents/openai.yaml`](hs-init-project/agents/openai.yaml): skill metadata
- [`hs-init-project/references/`](hs-init-project/references/): detailed supporting rules for the skill
- [`hs-init-project/assets/`](hs-init-project/assets/): internal templates used by the skill
- [`hs-init-project/scripts/`](hs-init-project/scripts/): deterministic helper scripts used by the skill

When this README points to a real entrypoint or control document, keep that reference as a Markdown link.
Leave placeholders, wildcards, and not-yet-created paths as plain path literals.

## Installation

Install the skill with the built-in `skill-installer` helper.
Prefer a tagged release over `main` so later updates can follow GitHub releases.
The direct installer script supports `--ref latest` and resolves the newest version tag in the repository at install time.

### Project-Scoped Installation (Recommended)

Use this when you want the skill only for the current repository.
Install it into `<project-root>/.codex/skills/`.

Through Codex:

```text
$skill-installer
Install the skill from GitHub repo ChoiHyunSuk93/init-project-codex path hs-init-project at the latest version into <project-root>/.codex/skills.
```

Direct installer script:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

mkdir -p .codex/skills

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo ChoiHyunSuk93/init-project-codex \
  --path hs-init-project \
  --ref latest \
  --dest "$PWD/.codex/skills"
```

If you want to pin a specific release instead, replace `latest` with a tag such as `vX.Y.Z`.

This creates:

```text
<project-root>/.codex/skills/hs-init-project/
```

### Global Installation

Use this when you want the skill available across repositories.

Through Codex:

```text
$skill-installer
Install the skill from GitHub repo ChoiHyunSuk93/init-project-codex path hs-init-project at the latest version.
```

Direct installer script:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo ChoiHyunSuk93/init-project-codex \
  --path hs-init-project \
  --ref latest
```

You can also install it by URL:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --url https://github.com/ChoiHyunSuk93/init-project-codex/tree/latest/hs-init-project
```

If Codex is already running, restart it after installation so the new skill is picked up.

### Updating An Existing Installation

Use the bundled updater to replace the installed skill directory in place.
For the updater, `--ref latest` resolves the latest GitHub release tag, not the `main` branch.
This differs from the direct installer, where `--ref latest` resolves the newest version tag in the repository.
If your installed copy predates this updater, reinstall once from a tagged release and use the updater after that.

Project-scoped installation:

```bash
python3 ./.codex/skills/hs-init-project/scripts/update-skill-release.py --ref latest
python3 ./.codex/skills/hs-init-project/scripts/update-skill-release.py --ref vX.Y.Z
```

Global installation:

```bash
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

python3 "$CODEX_HOME/skills/hs-init-project/scripts/update-skill-release.py" --ref latest
python3 "$CODEX_HOME/skills/hs-init-project/scripts/update-skill-release.py" --ref vX.Y.Z
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
.codex/
  config.toml
  agents/
    planner.toml
    generator.toml
    evaluator.toml
  skills/
    change-analysis/
      SKILL.md
      agents/
        openai.yaml
    code-implementation/
      SKILL.md
      agents/
        openai.yaml
    test-debug/
      SKILL.md
      agents/
        openai.yaml
    docs-sync/
      SKILL.md
      agents/
        openai.yaml
    quality-review/
      SKILL.md
      agents/
        openai.yaml
rule/
  index.md
  rules/
    project-structure.md         # top-level structure and directory roles
    instruction-model.md         # authority order, thin-root use, and non-duplication
    rule-maintenance.md          # rule file lifecycle and rule-index alignment
    documentation-boundaries.md  # boundaries between rules, guides, and implementation records
    readme-maintenance.md        # root README creation and maintenance rules
    development-standards.md     # baseline implementation quality and convention rules
    testing-standards.md         # test-layer selection and verification expectations
    runtime-boundaries.md        # runtime versus non-runtime boundary rules
    implementation-records.md    # implementation record placement and naming rules
    subagent-orchestration.md    # planner/generator/evaluator boundaries and loop rules
    subagents-docs.md            # working-doc ownership under subagents_docs/
subagents_docs/
  AGENTS.md
  cycles/
    [NN-plan-slug].md
docs/
  guide/
    README.md
    [focused guide documents]   # existing-project mode when observed user-facing workflows justify them
  implementation/
    AGENTS.md
    [category]/
      [short final cycle briefings]
```

- [`AGENTS.md`](AGENTS.md): thin repository-wide Codex guidance
- root [`README.md`](README.md): durable human-facing repository summary
- `.codex/config.toml`: project-scoped agent runtime settings that are generated alongside `.codex/agents/*.toml`
- `.codex/agents/`: project-scoped planner / generator / evaluator definitions
- `.codex/skills/`: starter local skills for common development workflows such as change analysis, implementation, test/debug, docs sync, and quality review
- `rule/`: authoritative execution rules for Codex, with [`rule/index.md`](rule/index.md) as the index and `rule/rules/*.md` as the detailed rule set
- `subagents_docs/`: planner, generator, and evaluator working documents, with [`subagents_docs/AGENTS.md`](subagents_docs/AGENTS.md) as the control file and new plan cycles tracked as one append-only document per plan under `subagents_docs/cycles/`
- `docs/guide/`: human-facing navigation and guide documents, with [`docs/guide/README.md`](docs/guide/README.md) as the default entry point
- `docs/implementation/`: user-facing short final briefings inside concern-based categories after a plan cycle passes, with [`docs/implementation/AGENTS.md`](docs/implementation/AGENTS.md) as the placement rule
- In existing-project mode, additional guide documents are created only when observed user-facing workflows provide durable reader-facing material.

Generated repositories run each plan in `planner -> generator -> evaluator` order as part of the default baseline. The main agent stays orchestration-only: it coordinates those roles, collects handoffs, and does not directly become planner, generator, or evaluator unless the user explicitly waives the split. New work is tracked as one append-only cycle document per plan, with `Status`, `Current Plan Version`, and `Next Handoff` at the top and role-specific `Planner vN` / `Generator vN` / `Evaluator vN` sections below. The evaluator checks the implemented result against the plan and acceptance criteria, and only evaluator-reported failures or blockers send that plan back for re-planning. Independent plans may run in parallel; dependent plans should run sequentially. `subagents_docs/` working documents follow the selected language, and generated repositories include `.codex/config.toml`, `.codex/agents/*.toml`, and process-oriented starter local skills under `.codex/skills/`. In existing-project mode, inspection results are used to make starter skills and selected README/rule/guide outputs more specific to the observed runtime, test, and docs signals. If subagents are slow the coordinator waits or re-plans instead of directly implementing.

## Usage

Use the skill when you want Codex to initialize or retrofit repository structure.
The command alone is enough to start; you can add a very short intent phrase if needed.

Examples:

```text
$hs-init-project
```

```text
Set up the initial project structure for this repository.
```

If no language choice is already fixed in the request or session, the skill asks for the language in plain text before it starts initialization.
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
