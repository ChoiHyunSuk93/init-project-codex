# Agent Workflow Rules

## Intent Gate

- Do not interpret analysis, questions, reviews, or explanations as authorization to implement.
- Change files only when the user clearly requests creation, modification, a fix, or implementation.
- Ask the smallest necessary question only when an important choice changes the result and cannot be resolved from the repository.

## Work Classification

- Let the main agent handle small clear work directly with focused verification.
- For broader clear work, plan briefly, then let the main agent implement and integrate.
- Delegate large work only as non-conflicting bounded slices.
- Reduce major ambiguity with read-only exploration before implementation.

## Work Records

- Keep durable requirements in [`PROJECT_OVERVIEW.md`](../../PROJECT_OVERVIEW.md) and phase status in [`subagents_docs/roadmap.md`](../../subagents_docs/roadmap.md).
- Record medium-or-larger changes, explicit work-sharing, multiple handoffs, or audit-worthy state transitions in `subagents_docs/cycles/<NN>-<slug>.md`.
- Keep `Status`, `Current Plan Version`, and `Next Handoff` in the cycle header.
- Append `Planner vN`, `Generator vN`, and `Evaluator vN` sections, including main or delegated provenance and exact verification evidence.
- Small direct changes without shared handoff may omit a cycle.
- Record verified outcomes as new category-based history following [`docs/implementation/AGENTS.md`](../../docs/implementation/AGENTS.md).

## Delegation

- Use subagents only when independent exploration, parallel bounded slices, or risk-based validation materially helps.
- Do not assume a fixed planner, generator, evaluator pipeline or custom agent files.
- Do not have multiple agents edit the same file or shared journal concurrently.
- Have delegated agents return results; keep shared cycle headers, roadmap state, and final integration main-agent owned.
- Do not require thread-closing or lifecycle APIs the host does not provide.

## Completion

- Prioritize correctness, acceptance criteria, safety, regression risk, verification evidence, and maintainability.
- Report verification that was not run and remaining risk explicitly.
