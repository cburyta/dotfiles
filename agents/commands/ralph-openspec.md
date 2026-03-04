# Ralph OpenSpec Command

The main thread owns the phase loop and directly invokes builder and validator subagents. Do NOT delegate loop control to subagents.

## Usage

```
/ralph-openspec <change-id>
```

**Example:**
```
/ralph-openspec replace-t08-snapshot-with-demo-factors
```

## Roles

This command uses two subagent roles. These are invoked as `general-purpose` subagents via the Task tool — no special subagent types are required.

| Role | Description |
|------|-------------|
| **Builder** | A software engineer. Implements the tasks for a given phase — writes code, creates files, modifies existing code according to the spec and prep findings. |
| **Validator** | A QA engineer / tester. Reviews the implementation for correctness, runs tests, checks acceptance criteria, and reports pass/fail with details. |

## Architecture

```
Main Thread (this command)
    ├── Step 1: Validate & Read Change
    ├── Step 2: Parse Phases
    ├── Step 3: Initialize or Resume State
    ├── Step 4: Prep Phase (per phase — research & plan)
    ├── Step 5: Verify Test Plan (per phase — before building)
    ├── Step 6: Execute Phase Loop (build → validate → retry)
    ├── Step 7: Report Completion
    └── Step 8: Compound Learnings
```

**CRITICAL**: The main thread ALWAYS owns the phase loop. Do NOT spawn orchestrator subagents to manage phases.

**Loop Pattern**: Prep → Verify Test Plan → Build → Validate → (if fail) Build → Validate → ... (max 3 retries per phase)

## Prerequisites

- `openspec/changes/<change-id>/proposal.md` (required)
- `openspec/changes/<change-id>/tasks.md` (required, with phased tasks)
- `openspec/changes/<change-id>/design.md` (optional)

## Main Thread Workflow

When this command is invoked, execute these steps directly in the main thread:

### Step 1: Validate and Read Change

1. Verify required files exist:
   - `openspec/changes/<change-id>/proposal.md`
   - `openspec/changes/<change-id>/tasks.md`
2. Read `proposal.md` for scope and acceptance criteria
3. Read `design.md` (if present) for technical decisions
4. Read `tasks.md` to extract phases and tasks

### Step 2: Parse Phases from tasks.md

- Look for sections like `## Phase 1:` or `## Phase N:`
- Extract tasks as checkboxed items under each phase
- Count total phases for progress tracking

### Step 3: Initialize or Resume State

Check if `.cursor/ralph/status.json` already exists:

**If exists AND `change_id` matches:**
1. Read `completed_phases` from status.json
2. Determine the next incomplete phase
3. Log to progress.log: `Resuming from Phase N`
4. Skip to Step 6, starting from that phase

**If not exists or different `change_id`:**

Create `.cursor/ralph/` directory and initialize:

**status.json:**
```json
{
  "change_id": "<change-id>",
  "current_phase": 1,
  "total_phases": <N>,
  "iteration": 1,
  "phase_status": "pending",
  "started_at": "<ISO timestamp>",
  "completed_phases": []
}
```

**progress.log:**
```
[<timestamp>] Initialized: <change-id>
```

### Step 4: Prep Phase (per phase, before building)

OpenSpec changes are already human-reviewed with codebase references. This step is NOT discovery — it prepares the agent for implementation and surfaces anything that needs clarification before code is written.

**For each phase, before invoking the builder:**

1. **Locate target files** — Using file paths from the proposal/design, read the actual source files that will be modified. Confirm they exist and match what the spec describes.
2. **Extract implementation patterns** — From the target files, identify:
   - Function signatures, class structures, naming conventions
   - Import patterns and dependency wiring
   - Test file locations and test patterns for this area
3. **Flag gaps** — If something in the spec doesn't match what's in the codebase (renamed file, missing dependency, changed API), log it to progress.log and HALT for clarification before building.
4. **Compile prep summary** — A compact block passed directly to the builder prompt:
   - Exact file paths with relevant line numbers
   - Code snippets showing patterns to follow
   - Any constraints or gotchas discovered

**Output:** The prep summary is NOT written to a file. It is passed inline to the builder prompt for the current phase.

**HALT condition:** If the prep phase reveals the spec is stale or ambiguous for this phase, log the issue and stop. Do not build against unclear instructions.

### Step 5: Verify Test Plan (per phase, before building)

Before any code is written, confirm that the test strategy for this phase is clear and actionable. The validator cannot do its job if there is no way to verify the implementation.

**For each phase, after prep and before invoking the builder:**

1. **Identify how this phase will be tested** — From the proposal, design, and prep findings, determine:
   - What test commands will run (e.g., `make test`, `pytest`, `npm test`)
   - What specific test files or test cases cover this phase's changes
   - Whether new tests need to be written as part of this phase
2. **Confirm test infrastructure exists** — Verify:
   - The test framework is installed and runnable
   - Existing test suites pass before changes are made (baseline)
   - Test file locations and naming conventions are known
3. **Define the test expectations** — Write a clear, compact test plan:
   - What MUST pass for the validator to approve this phase
   - What new tests the builder MUST write (if any)
   - What existing tests must continue to pass (regression)
4. **Include test plan in builder prompt** — The builder must know what tests to write and what the validator will check. This prevents the build-then-discover-no-tests problem.

**HALT condition:** If there is no clear way to test a phase's changes (no test framework, no testable acceptance criteria, no test commands), halt and request clarification. Do not build untestable code.

**Output:** A compact test plan block passed to both the builder prompt (so it knows what tests to write) and the validator prompt (so it knows what to check).

### Step 6: Execute Phase Loop

The main thread ALWAYS executes this loop directly. Each iteration processes ONE phase at a time with the prep → test plan → build → validate → (optional retry) pattern:

```
FOR EACH PHASE (1 to N):
    phase_iteration = 1
    phase_passed = false

    Run Step 4 (Prep) for this phase
    Run Step 5 (Verify Test Plan) for this phase

    WHILE phase_iteration <= 3 AND NOT phase_passed:
        1. Update status.json:
           - current_phase = N
           - iteration = phase_iteration
           - phase_status = "in_progress"

        2. Log to progress.log:
           "Starting Phase N (iteration {phase_iteration}): <title>"

        3. Invoke Builder for THIS PHASE ONLY:
           - subagent_type: general-purpose
           - description: "Implement phase N tasks"
           - prompt: Include:
             * Builder role definition (see Roles section)
             * Phase N tasks only
             * Prep summary from Step 4
             * Test plan from Step 5 (what tests to write/maintain)
             * Context from proposal/design
             * Guardrails from previous iterations (if phase_iteration > 1)

        4. Wait for builder to complete
           - If builder fails critically: Log error, break to next phase

        5. Invoke Validator for THIS PHASE ONLY:
           - subagent_type: general-purpose
           - description: "Validate phase N implementation"
           - prompt: Include:
             * Validator role definition (see Roles section)
             * What builder implemented
             * Acceptance criteria for phase N
             * Test plan from Step 5 (what to run and verify)

        6. Wait for validator result:
           - If PASS:
             * Set phase_passed = true
             * Update status.json: phase_status = "completed"
             * Add phase N to completed_phases array
             * Update tasks.md: Mark phase N tasks as [x]
             * Log success to progress.log
             * Break while loop, continue to next phase

           - If FAIL:
             * Log failure to errors.log with details
             * Add lesson to guardrails.md
             * Increment phase_iteration
             * Log retry attempt to progress.log
             * Continue while loop (retry build for same phase)

    7. If phase_iteration > 3 and NOT phase_passed:
       - Update status.json: phase_status = "failed"
       - Log failure to progress.log
       - HALT execution, report summary

    8. If phase_passed:
       - Continue to next phase (loop continues)
```

**Key Pattern:**
- **ONE phase per loop iteration**
- **Prep → Test Plan → Build → Validate** sequence (prep and test plan run once, build/validate may retry)
- **Retry same phase** if validation fails (up to 3 iterations)
- **Move to next phase** only after validation passes
- Each retry invokes builder THEN validator (not validator only)
- Retries reuse the same prep summary and test plan but add guardrails

### Step 7: Report Completion

When all phases complete:
1. Update status.json with `phase_status: "completed"`
2. Log completion to progress.log
3. Verify all tasks in tasks.md are marked `- [x]`
4. Report summary: phases completed, retries needed, files modified

### Step 8: Compound Learnings

After reporting completion, capture what was learned:

1. **Review guardrails.md** — If any retries occurred, extract patterns worth preserving
2. **Update project knowledge** — If the change revealed reusable insights (e.g., "this codebase requires X when modifying Y"), propose updates to project CLAUDE.md or AGENTS.md
3. **Archive state** — Move `.cursor/ralph/` contents to `.cursor/ralph/archive/<change-id>/` so future runs start clean but history is preserved
4. **Log to progress.log:**
   ```
   [<timestamp>] Completed: <change-id> — <N> phases, <M> retries, <K> files modified
   [<timestamp>] Learnings archived to .cursor/ralph/archive/<change-id>/
   ```

**Skip this step** if the change failed (halted mid-execution). Learnings from failed runs stay in `.cursor/ralph/` for the next attempt.

## Subagent Invocation

Both roles use `general-purpose` as the subagent type. The role is established through the prompt itself.

### Invoking Builder

ALWAYS use the Task tool with these parameters:

| Parameter | Value |
|-----------|-------|
| **subagent_type** | `general-purpose` |
| **description** | "Implement phase N tasks" |
| **prompt** | See template below |

**Builder Prompt Template:**
```
You are a software engineer implementing a specific phase of a planned change.

Implement the following tasks for Phase <N> of <change-id>:

Tasks:
- [ ] <task 1>
- [ ] <task 2>

Prep findings:
- Files to modify: <exact paths with line numbers from Step 4>
- Patterns to follow: <actual code snippets from Step 4>
- Constraints: <gotchas or dependencies found in Step 4>

Context from spec:
<relevant sections from proposal.md and design.md>

Acceptance criteria:
<from proposal.md>

Test plan (you MUST write/update these tests):
<from Step 5 — specific tests to create or modify>
<test commands that must pass>
<regression tests that must continue to pass>

Guardrails (lessons from previous attempts):
<from .cursor/ralph/guardrails.md if retrying>
```

### Invoking Validator

ALWAYS use the Task tool with these parameters after builder completes:

| Parameter | Value |
|-----------|-------|
| **subagent_type** | `general-purpose` |
| **description** | "Validate phase N implementation" |
| **prompt** | See template below |

**Validator Prompt Template:**
```
You are a QA engineer validating a specific phase of a planned change.
Your job is to verify correctness, run tests, and report pass/fail.

Validate Phase <N> implementation of <change-id>:

What was implemented:
<summary from builder response>

Acceptance criteria:
<from proposal.md>

Test plan:
<from Step 5 — what tests must exist and pass>
<test commands to run>
<expected test outcomes>

Verify:
1. All specified tests exist and pass
2. No regressions in existing tests
3. Implementation matches acceptance criteria
4. Code changes are consistent with the spec

Files to review:
<list of modified files from builder>

Report PASS or FAIL with details. If FAIL, explain exactly what
failed and what needs to change.
```

## State Management

### status.json

Maintain in `.cursor/ralph/status.json`:
- `change_id`: The OpenSpec change being implemented
- `current_phase`: Phase currently being executed (1-indexed)
- `total_phases`: Total number of phases
- `iteration`: Retry attempt for current phase (starts at 1)
- `phase_status`: `pending`, `in_progress`, `completed`, `failed`
- `started_at`: ISO timestamp when started
- `completed_phases`: Array of completed phase numbers

### progress.log

Append to `.cursor/ralph/progress.log`:
```
[2026-01-19T10:00:00Z] Initialized: replace-t08-snapshot-with-demo-factors
[2026-01-19T10:00:01Z] Starting Phase 1 (iteration 1): Create demo_factors view
[2026-01-19T10:05:00Z] Phase 1 completed
[2026-01-19T10:05:01Z] Starting Phase 2 (iteration 1): Add tests
```

### errors.log

Append to `.cursor/ralph/errors.log` on failures:
```
[2026-01-19T10:10:00Z] Phase 2 failed: test_example failed
  Reason: Missing column 'factor_value'
  Iteration: 1
```

### guardrails.md

Track lessons learned for retry logic:
```markdown
## Phase 2 - Iteration 1

**Issue**: Missing column in view definition
**Resolution**: Added factor_value column mapping
**Lesson**: Always verify column names match between source and view
```

## Error Handling

### Retry Logic

When validation fails:
1. Log the error with full context to errors.log
2. Add lesson to guardrails.md
3. Increment iteration counter
4. If iteration <= 3:
   - Include guardrails in next builder prompt
   - Re-invoke builder THEN validator for same phase
5. If iteration > 3:
   - Mark phase as `failed`
   - Stop execution
   - Report failure with summary of attempts

### Halt Conditions

Stop and report if:
- Required files (`proposal.md`, `tasks.md`) are missing
- A phase fails after 3 retry attempts
- The prep phase reveals the spec is stale or ambiguous
- The change scope is unclear

## Updating tasks.md

After each phase passes validation:
1. Read current tasks.md content
2. Find the tasks for the completed phase
3. Change `- [ ]` to `- [x]` for completed tasks
4. Write updated content back to tasks.md

## Reference Commands

When you need additional context:
- `openspec show <id>` - View change details
- `openspec list` - List all changes
