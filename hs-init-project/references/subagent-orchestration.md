# Agent Workflow And Work Records

Generated repositories use the host product's built-in agent capabilities. Do not create generic planner, generator, evaluator, explorer, reviewer, or debugger definitions.

## Decision Model

- Small and clear work: let the main agent work directly and perform focused verification; omit a cycle when no shared handoff or durable audit trail is needed.
- Broader but clear work: let the main agent plan briefly, implement, and verify proportionally to risk.
- Large clear work: split only independent bounded slices and keep integration with the main agent.
- Large ambiguous work: reduce ambiguity with read-only exploration before implementation.
- High-risk or release work: consider independent evaluation when security, data integrity, breadth, or release impact justifies it.

## Record Model

- Keep durable requirements in `PROJECT_OVERVIEW.md`.
- Keep current phase status and gates in `subagents_docs/roadmap.md`.
- Use one `subagents_docs/cycles/<NN>-<slug>.md` per medium-or-larger work cycle, explicit work-sharing flow, multi-handoff task, or audit-worthy state transition.
- Use an authoritative header with `Status`, `Current Plan Version`, and `Next Handoff`.
- Append `Planner vN`, `Generator vN`, and `Evaluator vN` sections as work iterates. These are provenance labels, not required custom agents.
- State whether the main agent or a delegated agent produced each section and record exact validation evidence.
- Keep the header, roadmap, shared journal, and final integration main-agent/coordinator-owned.
- After verification passes, add a concise new `docs/implementation/<category>/NN-name.md` briefing; preserve older briefings as history.

## Guardrails

- Do not confuse analysis or review requests with authorization to edit.
- Do not delegate merely because an agent role exists.
- Do not have parallel agents edit the same file or shared record.
- Have delegated agents return results instead of directly changing shared roadmap or cycle state.
- Continue non-overlapping local work while delegated work runs.
- Follow the host's lifecycle controls; do not prescribe unavailable thread-closing APIs.
- Evaluate correctness, acceptance criteria, safety, regression risk, verification evidence, and maintainability. Novelty is not a default quality metric.

Introduce project-specific agents or skills only after a repeated specialized need is observed.
