# Structure Initialization

## Output Model

Materialize a shared, product-neutral core:

```text
AGENTS.md
PROJECT_OVERVIEW.md
docs/
├── guide/README.md
└── implementation/AGENTS.md
rule/
├── index.md
└── rules/
    ├── project-structure.md
    ├── development-standards.md
    ├── testing-standards.md
    ├── documentation.md
    └── agent-workflow.md
subagents_docs/
├── AGENTS.md
├── roadmap.md
└── cycles/
```

For `target=claude` or `target=both`, also create `CLAUDE.md`. Do not generate product-specific custom agents, skills, hooks, settings, or runtime config.

## Inspection

Before writing:

- list existing instruction, overview, README, rule, source, test, automation, and documentation paths
- distinguish a fresh repository from one with meaningful content
- identify conflicts with every planned output
- preserve a meaningful `PROJECT_OVERVIEW.md`, guide index, roadmap, or local instruction file unless replacement is explicitly authorized
- accept monorepos and multiple intentional source areas; do not force a single source root

Use:

```bash
sh hs-init-project/scripts/materialize_repo.sh --root <repo> --inspect
```

The inspect output is a conflict and navigation aid. It is not a substitute for reading actual source and configuration in an existing repository.

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
- `merge` preserves unmanaged content and replaces only the materializer marker section.
- `preserve` never writes `README.md`.
- Existing-project mode defaults to `preserve`; fresh mode defaults to `create`.

## Template Policy

- Keep all generated prose under `assets/`.
- Select one language/target asset and replace only stable placeholders in the materializer.
- Do not add generated document bodies as shell heredocs or duplicate fresh/existing builders.
- Treat `HS_INIT_SEMANTIC_TODO` as an intentionally unresolved marker that the invoking agent must replace after observing the project.

## Semantic Retrofit

After materialization:

1. Read the target repository following [existing-project-analysis.md](existing-project-analysis.md) when `project-mode=existing`.
2. Replace semantic markers in `PROJECT_OVERVIEW.md`, `docs/guide/README.md`, and `subagents_docs/roadmap.md` with user-provided or observed facts.
3. Refine generated structure, development, testing, and documentation rules where the repository has stronger observed conventions.
4. Preserve main-agent/subagent provenance and planned phase gates in the generated work-record documents.
5. Run `scripts/validate_materialized_repo.py`; do not report completion while it fails.

## Completion

Report created, updated, preserved, skipped, unresolved, and evidence-bearing paths separately. A successful template copy is only materialization, not completed project initialization.
