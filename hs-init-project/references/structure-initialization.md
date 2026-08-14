# Structure Initialization

## Output Model

Materialize a shared, product-neutral core:

```text
AGENTS.md
PROJECT_OVERVIEW.md
rule/
├── index.md
└── rules/
    ├── project-structure.md
    ├── development-standards.md
    ├── testing-standards.md
    ├── documentation.md
    └── agent-workflow.md
```

For `target=claude` or `target=both`, also create `CLAUDE.md`. Do not generate product-specific custom agents, skills, hooks, settings, or runtime config.

## Inspection

Before writing:

- list existing instruction, overview, README, rule, source, test, and documentation paths
- distinguish a fresh repository from one with meaningful content
- identify conflicts with every planned output
- preserve an existing meaningful `PROJECT_OVERVIEW.md` unless replacement is explicitly authorized
- accept monorepos and multiple intentional source roots; do not force a single source root

Use:

```bash
sh hs-init-project/scripts/materialize_repo.sh --root <repo> --inspect
```

## Materialization

Preview first:

```bash
sh hs-init-project/scripts/materialize_repo.sh \
  --root <repo> \
  --language ko \
  --target both \
  --project-mode existing \
  --readme-mode preserve \
  --dry-run
```

Then rerun without `--dry-run` after resolving conflicts.

Supported controls:

- `--root PATH`
- `--language en|ko`
- `--target codex|claude|both`
- `--project-mode fresh|existing`
- `--readme-mode create|merge|preserve`
- `--source-root-dir PATH` as an optional observed hint, not a universal structural requirement
- `--overwrite` for selected conflicting harness files
- repeatable `--preserve PATH` to protect exact repository-relative paths
- `--inspect`
- `--dry-run`

## README Policy

- `create` writes the full README template and refuses an existing file unless `--overwrite` is explicit.
- `merge` preserves all unmanaged content. It appends or replaces only the section between the materializer's start/end markers.
- `preserve` never writes `README.md`.
- Existing-project mode defaults to `preserve`; fresh mode defaults to `create`.

## Template Policy

- All generated prose lives under `assets/`.
- The materializer selects a language/target asset, replaces stable placeholders, and writes it.
- Do not add generated document bodies as shell heredocs or duplicate fresh/existing builders.
- Existing mode changes conflict behavior and observed placeholders, not the source template.

## Completion

After materialization, the invoking agent must replace placeholders using only observed or user-provided facts, run the validation suite, and report created, updated, preserved, skipped, and unresolved paths.
