---
name: verbose-planning
description: >-
  Structured planning-to-implementation workflow that produces versioned specs, phased task files, and roadmaps.
  Use this skill whenever the user mentions planning, specs, roadmaps, task breakdowns, implementation plans,
  feature design, architecture proposals, or uses /verbose-planning. Also trigger when the user asks to
  "formalize a plan", "break this into tasks", "create a spec", "generate a roadmap", or "implement from spec".
  This skill has three modes: /verbose-planning spec, /verbose-planning tasks, /verbose-planning implement.
  Trigger on any of these slash commands. Even without slash commands, use this skill when the user is clearly
  doing multi-phase planning work that would benefit from structured specs and task files.
---

# Verbose Planning

A workflow for turning rough ideas into versioned specs, detailed task files, and parallel implementation.
The core loop: **Plan → Specify → Break into tasks → Validate assumptions → Implement**.

## Modes

This skill operates in three modes, invoked via slash command or inferred from context:

| Command | Mode | What it does |
|---|---|---|
| `/verbose-planning spec` | Formalize | Turn planning docs, notes, or conversation into a versioned spec |
| `/verbose-planning tasks` | Break down | Generate phased task files from a spec with code samples and architecture context |
| `/verbose-planning implement` | Execute | Implement tasks from task files using parallel subagents |

If the user says `/verbose-planning` without a mode, look at what exists and pick the right one:
- No spec yet → `spec`
- Spec exists but no task files → `tasks`
- Task files exist → `implement`

## Folder convention

Outputs go into a `personal-tasks/` directory (or the user's preferred location):

```
personal-tasks/
  planning/        # Rough notes, evaluations, brainstorms (living docs)
  specs/           # Versioned specs — the authoritative reference
    {project}-v{X.Y.Z}.md
  tasks/           # Phased task files, organized by project
    {project}-v{X.Y.Z}/
      roadmap.md
      future/      # Not yet started
      active/      # In progress (moved here when work begins)
      done/        # Completed (moved here when finished)
```

If the user already has a different structure, adapt to it. The key principle is separation of lifecycle stages: scratchpad → spec → tasks.

---

## Mode 1: Formalize Spec (`/verbose-planning spec`)

Turn rough planning into a versioned, comprehensive spec document.

### Input

One or more of:
- Planning documents, rough notes, markdown files
- Conversation context (the user has been discussing architecture)
- Existing codebases to evaluate (use subagents to explore)
- Jira tickets or design docs

### Process

#### 1. Research (subagents for codebase exploration)

If the plan involves existing codebases, spawn **explore subagents** to map them:

```
For each codebase the plan touches:
  → Subagent: "Analyze {repo}. Report: directory structure, key patterns
     (config, DB, CLI, testing), code you'd copy/adapt, pain points."
```

Run these in parallel. The findings feed into the spec.

#### 2. Draft the spec

Write a spec document covering these sections (adapt numbering/depth to the project):

1. **Purpose** — what this project does and doesn't do
2. **Design principles** — 3-5 architectural truths that guide decisions
3. **Codebase structure** — full file tree with annotations
4. **Naming conventions** — Python, S3/storage paths, database, API
5. **CLI/API design** — command tree or endpoint map with examples
6. **Config design** — settings classes, env vars, defaults
7. **Database/storage design** — schemas, DDL, why these choices
8. **Core architecture** — data flow diagrams, sequence of operations
9. **Domain-specific sections** — as many as the project needs
10. **Code to copy/adapt** — table of source → target with changes
11. **Dependencies** — `pyproject.toml` / `package.json` / etc.
12. **Testing strategy** — layers, fixtures, what's mocked, fail-first approach
13. **Phased delivery** — phases with steps, timelines, dependencies
14. **Risks and mitigations** — table format
15. **Related tickets** — Jira/GitHub links

Every section should include **code samples** — not pseudocode, but actual implementation-ready snippets. A developer reading the spec should be able to start coding immediately.

Mark the spec with a date, status, and version in the header:

```markdown
# {Project} — Specification

**Date:** {today}
**Status:** Draft
**Version:** v0.0.1
```

#### 3. Audit with subagents

After the initial draft, spawn two subagents to review:

**Code audit subagent:**
```
Review {spec-path} as a code auditor. Focus on:
- SQL injection risks in dynamic queries
- Path construction correctness
- Schema/DDL assumptions that could break
- Missing error handling or edge cases
- Inconsistencies between sections
Report: critical/important/minor categorized findings.
```

**Data audit subagent:**
```
Review {spec-path} as a data auditor. Focus on:
- Data flow correctness (does data arrive where it should?)
- Schema compatibility between systems
- Naming inconsistencies (same thing called different names)
- Missing fields in contracts (JSON schemas, metadata)
- Test data coverage
Report: critical/important/minor categorized findings.
```

Run both in parallel. Incorporate findings into the spec, adding an appendix for audit-driven additions. Record the date of the audit in the spec.

#### 4. User review checkpoint

Present the spec for review. Address feedback iteratively. The spec is a living document during drafting but becomes authoritative once moved to `specs/`.

#### 5. Save

Save to `specs/{project}-v{version}.md`. Remove from `planning/` if it was there.

---

## Mode 2: Generate Tasks (`/verbose-planning tasks`)

Break a spec into implementation-ready task files.

### Input

A spec file (in `specs/` or provided by the user).

### Process

#### 1. Read the spec's phased delivery section

The spec's delivery phases become task files. Each phase = one task file.

#### 2. Write task files

Each task file goes in `tasks/{project}-v{version}/future/` and follows this structure:

```markdown
# Phase {N}: {Title}

**Spec:** [{project}]({relative-path-to-spec}) §{sections}
**Timeline:** {estimate}
**Depends on:** {what must complete first}
**Blocks:** {what can't start until this completes}

---

## Goal

{One sentence: what does "done" look like? Include the exact CLI command or API call that works when this phase is complete.}

---

## Architecture context

{Explain the architecture decisions a developer needs to understand to implement this phase. Include:}
- Data flow diagrams (ASCII art)
- Key design decisions with rationale
- S3/storage paths with examples
- Schema/DDL if relevant
- How this phase connects to previous and next phases

---

## Codebase structure

{Full file tree of what's created or modified in this phase. Annotate each file.}

---

## Steps

### {N.1} — {Step title}

{For each step, include:}
- **Full code sample** — not pseudocode. A developer should be able to copy this and iterate.
- **What it connects to** — which spec section, which other file
- **Why this approach** — brief rationale for non-obvious choices

### {N.2} — ...

---

## Tests

{Testing section with:}
- Fixture code (conftest.py or equivalent)
- Example test cases with assertions
- What's mocked and why
- Integration test approach

---

## Parallelism

{ASCII diagram showing which steps can run in parallel}

## Deliverable

{The exact command and expected output when this phase is complete}
```

The critical quality bar: **a developer with no conversation context picks up this file and implements without asking questions**. That means:
- Every code sample is real, not pseudo
- Architecture decisions are explained, not just stated
- Config values, env vars, schemas are all concrete
- Test patterns show the full fixture → act → assert cycle

#### 3. Identify Phase 0 (validation gates)

Look for risky assumptions in the spec — things that could be wrong and would invalidate later work. These become **Phase 0** tasks: scripted setup/teardown validation that proves the assumption before implementation begins.

Common Phase 0 candidates:
- Database DDL that uses undocumented behavior
- API integrations with unclear contracts
- Third-party service behavior assumptions
- Data format assumptions (file layouts, encoding)
- Permission/access patterns

Phase 0 tasks include the full validation script in the task file.

#### 4. Write the roadmap

Create `tasks/{project}-v{version}/roadmap.md`:

```markdown
# {Project} — Roadmap

**Spec:** [{project}]({path-to-spec})

## Execution order

{ASCII diagram showing phase dependencies and parallelism}

## Task files

| # | File | Status | Depends on | Parallelism notes |
|---|---|---|---|---|

## Critical path

{Which steps are on the critical path and why}

## Cross-repo/team dependencies

{External dependencies, who owns them, when they're needed}

## Decision points

{When decisions must be made and what options exist}
```

#### 5. Audit with subagents

Spawn a subagent to review the task files against the spec:

```
Compare {task-files} against {spec-path}. Verify:
- Every spec section is covered by at least one task step
- Code samples in tasks match spec's architecture
- No spec decisions are contradicted in tasks
- Phase dependencies are correct
- Parallelism claims are valid
Report: gaps, contradictions, missing coverage.
```

---

## Mode 3: Implement (`/verbose-planning implement`)

Execute task files using parallel subagents where possible.

### Input

A task file (from `tasks/{project}/future/` or `active/`).

### Process

#### 1. Read the task file and roadmap

Understand what phase we're implementing, what's already done, and what can run in parallel.

#### 2. Move task to active

```bash
mv tasks/{project}/future/{task}.md tasks/{project}/active/
```

#### 3. Identify parallel work

Look at the task file's parallelism section. Group steps into:
- **Sequential**: must happen in order
- **Parallel**: can be dispatched as concurrent subagents

#### 4. Implement with subagents

For parallel steps, spawn subagents simultaneously:

```
Implement step {N.X} of {task-file-path}.

Context:
- Spec: {spec-path}
- This step: {paste the step content including code samples}
- Working directory: {repo-path}

The code samples in the task file are implementation-ready starting points.
Adapt them as needed but preserve the architecture decisions.

When done, report what files were created/modified and any issues encountered.
```

For sequential steps, implement them in order in the main context.

#### 5. Run tests after each logical group

After completing a group of related steps, run the test suite. If tests were written fail-first, they should start passing.

#### 6. Mark complete

When all steps pass:

```bash
mv tasks/{project}/active/{task}.md tasks/{project}/done/
```

Update `roadmap.md` status column.

---

## Subagent patterns

### When to use subagents

| Situation | Subagent type | Why |
|---|---|---|
| Exploring unfamiliar codebases | `explore` | Fast, read-only, parallel |
| Code/data audit of spec | `code-audit` / `data-audit` | Independent review catches blind spots |
| Implementing parallel steps | `generalPurpose` | Parallel execution saves time |
| Validating Phase 0 scripts | `shell` | Run setup/teardown/validation scripts |
| Reviewing completed work | `code-reviewer` | Verify implementation matches spec |

### Audit subagent prompts

Always include the date in audit outputs. Add this to the spec:

```markdown
## Audit log

| Date | Auditor | Findings | Resolution |
|---|---|---|---|
| {date} | code-audit | {summary} | Incorporated in Appendix A |
| {date} | data-audit | {summary} | Incorporated in Appendix A |
```

### POC scripts in Phase 0

Phase 0 validation scripts follow this pattern:

1. **Setup**: create temporary resources (test schema, S3 prefix, test data)
2. **Execute**: run the operation you're validating (DDL, API call, query)
3. **Assert**: compare actual vs expected results
4. **Debug output**: print raw values so failures are diagnosable
5. **Teardown**: clean up all temporary resources
6. **Exit code**: 0 = proceed, 1 = fix and retry

The script is committed to the repo as a permanent regression artifact.

---

## Quality checklist

Before delivering any artifact (spec, tasks, or implementation), verify:

- [ ] Every code sample compiles/parses (no pseudocode)
- [ ] Architecture decisions include rationale
- [ ] Config values, env vars, schemas use real names
- [ ] Test patterns show full fixture → act → assert
- [ ] Parallelism claims are justified by dependency analysis
- [ ] Phase 0 covers the riskiest assumptions
- [ ] Cross-references between spec sections and task steps are correct
- [ ] Audit subagents have reviewed the work (date recorded)
