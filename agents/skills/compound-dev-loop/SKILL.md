---
name: compound-dev-loop
description: Compound engineering workflow for complex tasks. Use when implementing features in brownfield codebases, solving multi-file problems, or when context management is critical. Follows Research-Plan-Implement pattern with sub-agents and compaction.
---

# Compound Development Loop

A workflow where each unit of work makes subsequent work easier through context engineering, sub-agents, and knowledge compaction.

## When to Use

- Complex features spanning multiple files
- Brownfield codebases with existing patterns
- Tasks requiring research before implementation
- When context window management is critical

## Input

Start with ONE of:
- A prompt/task description
- A file reference (`@path/to/spec.md` or `@path/to/ticket.md`)

## Workflow Phases

### Phase 1: Research (sub-agent)

Fork a fresh context to research. Output compressed findings, not raw exploration.

**Output:** `.memory/research/<task-slug>.md`

Contents:
- Exact file paths and relevant line numbers
- Code flow summary (how the feature currently works)
- Existing patterns to follow
- Constraints discovered

See `references/research-template.md` for format.

### Phase 2: Plan

Using research output, create implementation plan with explicit details.

**Output:** `.memory/plans/<task-slug>.plan.md`

Contents:
- Numbered steps with file:line references
- Actual code snippets showing proposed changes
- Test verification after each change
- Edge cases and error handling

**CHECKPOINT**: Present plan for human review before proceeding.

### Phase 3: Implement

Execute plan step-by-step:
- One logical change at a time
- Run tests/linting after each change
- If blocked or spiraling, return to planning

### Phase 4: Compound

After completion, capture learnings:
- What patterns emerged worth documenting?
- What went wrong that should be prevented?
- Update project AGENTS.md or CLAUDE.md

## Context Management

- **40% rule**: Start fresh context when >40% used
- **Sub-agents for research**: Fork context, return compressed results
- **No raw dumps**: Never put large JSON/logs in main context
- **Compaction before switches**: Save progress to markdown

## Anti-patterns

- **Don't spiral**: 2+ corrections = restart with better plan
- **Don't anthropomorphize**: Sub-agents control context, not roles
- **Don't skip review**: Plans require human validation for complex work
- **Don't outsource thinking**: Bad research = 100 bad lines of code

## References

- `references/research-template.md` - Research output format
- `references/plan-template.md` - Plan output format
- `references/context-engineering.md` - Deep dive on context management
