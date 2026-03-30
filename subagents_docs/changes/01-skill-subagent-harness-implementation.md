# Subagent Harness Implementation

## Summary

Updated the skill definition and metadata so the existing init-project flow can optionally run with a planner / generator / evaluator harness layered on top.

## Changes

- Added an explicit subagent-harness section to `hschoi-init-project/SKILL.md`.
- Kept the original init-project behavior, language-first flow, and fresh/existing repository support intact.
- Added a dedicated reference file for the role split and evaluation weighting.
- Updated `hschoi-init-project/agents/openai.yaml` to reflect the new positioning.

## Why

The skill now needs to describe both the existing repository-structure bootstrap workflow and the added role-separated harness that coordinates planning, implementation, and evaluation.

## Verification

- Review only, no runtime tests run in this stage.
- Confirmed the edited files stay within the requested scope.

## Related Rules

- `rule/rules/subagent-orchestration.md`
- `rule/rules/instruction-model.md`
