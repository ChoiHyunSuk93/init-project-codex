# Agent Workflow Rule

## Intent Gate

- Do not interpret analysis, questions, reviews, or explanations as authorization to implement.
- Change files only when the user clearly requests creation, modification, fixing, or implementation.
- Ask the smallest question only when a material choice changes the result and cannot be resolved from the repository.

## Work Classification

- For small clear work, let the main agent work directly and run focused verification.
- For broader clear work, plan briefly and keep implementation and integration with the main agent.
- For large work, delegate only independent bounded slices that will not conflict.
- When ambiguity is material, reduce it with read-only exploration before implementation.

## Delegation

- Use subagents only when independent exploration, parallelizable slices, or risk-based independent validation provides material value.
- Do not require a generic planner, generator, evaluator pipeline or custom agent files.
- Do not let multiple agents edit the same file or shared journal concurrently.
- Keep shared work records and final integration owned by one coordinator.
- Continue non-conflicting local work while delegated work runs.
- Do not require thread-close or lifecycle APIs the host does not expose.

## Completion

- Prioritize correctness, acceptance criteria, safety, regression risk, verification evidence, and maintainability.
- Do not use originality as a quality criterion unless the task explicitly calls for creative or design exploration.
- Report verification that could not be run and any remaining risk explicitly.
