# Agent Workflow Reference

Generated repositories use the host product's built-in agent capabilities. Do not create generic planner, generator, evaluator, explorer, reviewer, or debugger definitions.

## Decision Model

- Small and clear work: the main agent works directly and performs focused verification.
- Broader but clear work: the main agent plans briefly, implements, and verifies proportionally to risk.
- Large clear work: split only independent, bounded slices; keep integration with the main agent.
- Large ambiguous work: reduce ambiguity with read-only exploration before implementation.
- Independent evaluation: use when risk, release impact, security, data integrity, or change breadth justifies the additional context and cost.

## Guardrails

- Do not confuse analysis or review requests with authorization to edit.
- Do not delegate merely because an agent role exists.
- Do not have parallel agents edit the same file or shared journal.
- Keep any shared work record coordinator-owned.
- Continue non-overlapping local work while delegated work runs.
- Follow the host's lifecycle controls; do not prescribe unavailable thread-closing APIs.
- Evaluate correctness, acceptance criteria, safety, regression risk, verification evidence, and maintainability. Novelty is not a default software quality metric.

Project-specific agents or skills belong to the target project and should be introduced only after a repeated, specialized need is observed.
