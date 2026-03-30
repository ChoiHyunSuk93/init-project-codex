# Plan 2 Change Note (Generator)

- Updated `hschoi-init-project/SKILL.md` so generated repositories explicitly use `subagents_docs/` for planner, generator, and evaluator working docs.
- Clarified that `docs/guide/` stays user-facing and `docs/implementation/` is only for final implementation briefings after a plan cycle passes.
- Added repeated planner -> generator -> evaluator cycle behavior and multi-plan parallel-vs-sequential guidance.
- Updated `hschoi-init-project/agents/openai.yaml` and `hschoi-init-project/references/subagent-orchestration.md` to match the generated-repository model.
- Added reusable templates for `subagents_docs/AGENTS.md` and user-facing final briefings under `docs/implementation/briefings/`.
- Updated the generated-repo rule templates so `docs/implementation` is framed as final briefings and `subagents_docs` is the working area.
- Updated `hschoi-init-project/scripts/materialize_repo.sh` so generated repositories actually write `subagents_docs/AGENTS.md` and `rule/rules/subagents-docs.md`, and so generated structure text treats `subagents_docs/` as a first-class top-level area.
- Updated `README.md` and `README.ko.md` so the public generated-structure description matches the new harness model, including repeated plan cycles and user-facing final briefings.
- Verification for this micro-task was structural review only. No runtime tests were run.
- Added missing generated-skill templates: `assets/rule/subagent-orchestration.en.md` and `.ko.md`, enabling deterministic materialization to proceed to script completion.
- Added missing generated skill templates for deterministic copy: `assets/.codex/agents/planner.toml`, `assets/.codex/agents/generator.toml`, `assets/.codex/agents/evaluator.toml`, and guide docs `assets/docs/guide/subagent-workflow.en.md` / `assets/docs/guide/subagent-workflow.ko.md` so generated repos can materialize `subagents_docs` vs user-facing docs boundaries plus cycle-based agent workflow.
