---
name: devils-advocate
description: >-
  Launch an adversarial subagent to challenge the current plan or implementation
  before committing to it. Use when the user says "devils-advocate",
  "/devils-advocate", "challenge this plan", "argue alternatives", or when a
  plan is about to be implemented and could benefit from adversarial review.
---

# Devil's Advocate

Spawn an independent subagent to argue against the current plan, surface
hidden complexity, and propose simpler alternatives — before any code is written.

## When to Use

- A plan or proposal exists but hasn't been implemented yet
- An implementation is complete and needs cross-evaluation
- The user explicitly requests adversarial review

## Workflow

### 1. Capture the Current Plan

Gather the plan to challenge. Sources (check in order):

1. **Active todos** — summarize current task list
2. **Recent assistant messages** — extract the proposed approach
3. **Plan-mode output** — if a formal plan was written
4. **Git diff** — if reviewing an existing implementation (`git diff main --stat`)

Distill the plan into a concise brief: **what** is being done, **how**, and **why**.

### 2. Launch the Adversarial Subagent

Use the Task tool with `subagent_type: "generalPurpose"` and `readonly: true`.

Prompt template (adapt to context):

```
You are a senior engineer acting as devil's advocate. Your job is to
challenge the plan below and argue for simpler, cleaner alternatives.

## The Plan
{plan_brief}

## Your Mandate
1. **Challenge assumptions** — What is the plan assuming that might not hold?
2. **Identify over-engineering** — Where is complexity introduced that isn't
   justified by the requirements?
3. **Propose alternatives** — For each criticism, suggest a concrete simpler
   path. Don't just say "this is complex" — say what you'd do instead.
4. **Spot missing risks** — What failure modes, edge cases, or maintenance
   burdens does the plan ignore?
5. **Defend what's good** — Acknowledge parts of the plan that are solid.
   This is adversarial, not nihilistic.

## Output Format
Return a structured review:

### Assumptions Challenged
- [assumption] → [why it may not hold]

### Over-Engineering Concerns
- [area] → [simpler alternative]

### Missing Risks
- [risk] → [mitigation]

### What's Good
- [strength] → [why it works]

### Recommended Changes (Priority Order)
1. [highest impact simplification]
2. ...

Be specific. Reference concrete parts of the plan. Avoid vague platitudes.
```

### 3. Present the Review

Show the subagent's output to the user verbatim. Then summarize:

- **Key disagreements** between the plan and the review
- **Actionable changes** worth adopting
- **Items to dismiss** (where the original plan is stronger)

Ask the user how they'd like to proceed before making any changes.

## Rules

- **DO NOT** implement changes based on the review without user approval
- **DO** use `readonly: true` on the subagent — it should analyze, not edit
- **DO** provide the subagent with enough context to give specific feedback
  (relevant file contents, architecture decisions, constraints)
- **DO** include project-specific context (tech stack, conventions) so the
  subagent doesn't suggest incompatible alternatives
- **DO NOT** let the subagent see its own role as "helper" — frame it as
  adversarial reviewer to avoid sycophantic agreement
