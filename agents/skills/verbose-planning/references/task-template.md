# Task File Template

Each phase in the spec's delivery plan becomes one task file. The goal: a developer picks up this file and implements without needing conversation context.

## Structure

```markdown
# Phase {N}: {Title}

**Spec:** [{project}]({relative-path-to-spec}) §{sections}
**Timeline:** {estimate}
**Depends on:** {what must complete first, or "Nothing" for Phase 0}
**Blocks:** {what can't start until this completes}

---

## Goal

{One sentence describing the deliverable. Include the exact command or API call that works when done.}

Example: `aso-ml comet snapshot create --currency videoamp25` produces correct S3 layout + `split.json` for one currency.

---

## Architecture context

{Everything a developer needs to understand before writing code.}

### Data flow

{ASCII diagram showing how data moves through this phase}

### Key design decisions

{Numbered list of decisions with rationale. Not just "we use X" but "we use X because Y."}

### Storage/schema layout

{Concrete paths, DDL, or API contracts with examples}

---

## Codebase structure

{Full file tree of what's created or modified in this phase.}
{Annotate each file with a brief description.}
{Flag stubs that will be completed in later phases.}

---

## Steps

### {N.1} — {Step title}

{Description of what this step produces.}

**`path/to/file.py`:**

```python
# Full implementation-ready code, not pseudocode.
# A developer copies this and iterates.
```

{Brief notes on what connects to what, and why non-obvious choices were made.}

### {N.2} — ...

---

## Tests

{Full test section with:}

**`tests/conftest.py`:**
```python
# Complete fixture code
```

**`tests/path/test_feature.py`:**
```python
# Example tests covering the main command and edge cases
# Show the full arrange → act → assert pattern
```

**`tests/NOTE_ON_*.md`:** (if tests for certain layers are deferred)

---

## Parallelism

{ASCII diagram showing step dependencies}

```
{N.1} (step A) ────→ {N.3} (step C) ────→ {N.5} (step E)
                ↗
{N.2} (step B) ─┘
                                            ↕
{N.4} (step D) ← runs in parallel, no dependency
```

## Deliverable

{The exact command/operation and its expected output when this phase is complete.}
```

## Phase 0 specifics

Phase 0 is a validation gate — it proves risky assumptions before implementation.

- The task file includes the **complete validation script**
- The script follows: setup → execute → assert → debug output → teardown
- Exit criteria are explicit checkboxes
- The script is committed as a permanent regression artifact
- Common failure modes are documented in a troubleshooting table
- Environment requirements (credentials, permissions, endpoints) are listed

## Quality bar

Before finalizing a task file, verify:

- [ ] A developer with no chat context can implement from this file alone
- [ ] Every code sample is syntactically valid (not pseudocode)
- [ ] Config values and env vars use real names, not placeholders
- [ ] Test code shows the full fixture → act → assert pattern
- [ ] Architecture decisions explain WHY, not just WHAT
- [ ] Spec section cross-references are correct
- [ ] Dependencies between steps are explicit
- [ ] Parallelism claims are justified
