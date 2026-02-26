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

## Architecture

```
Main Thread (this command)
    ├── Phase Loop (owned by main thread)
    │   ├── Build Phase → Validate Phase (per phase)
    │   └── Retry on failure (up to 3x per phase)
    └── State Management
```

**CRITICAL**: The main thread ALWAYS owns the phase loop. Do NOT spawn orchestrator subagents to manage phases.

**Loop Pattern**: Build → Validate → (if fail) Build → Validate → ... (max 3 retries per phase)

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

### Step 3: Initialize State

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

### Step 4: Execute Phase Loop

The main thread ALWAYS executes this loop directly. Each iteration processes ONE phase at a time with the build → validate → (optional retry) pattern:

```
FOR EACH PHASE (1 to N):
    phase_iteration = 1
    phase_passed = false

    WHILE phase_iteration <= 3 AND NOT phase_passed:
        1. Update status.json:
           - current_phase = N
           - iteration = phase_iteration
           - phase_status = "in_progress"

        2. Log to progress.log:
           "Starting Phase N (iteration {phase_iteration}): <title>"

        3. Invoke ralph-builder for THIS PHASE ONLY:
           - subagent_type: ralph-builder
           - description: "Implement phase N tasks"
           - prompt: Include:
             * Phase N tasks only
             * Context from proposal/design
             * Guardrails from previous iterations (if phase_iteration > 1)

        4. Wait for builder to complete
           - If builder fails critically: Log error, break to next phase

        5. Invoke ralph-validator for THIS PHASE ONLY:
           - subagent_type: ralph-validator
           - description: "Validate phase N implementation"
           - prompt: Include:
             * What builder implemented
             * Acceptance criteria for phase N
             * Test commands to run (from project/spec test plan)

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
- **Build → Validate** sequence for each attempt
- **Retry same phase** if validation fails (up to 3 iterations)
- **Move to next phase** only after validation passes
- Each retry invokes builder THEN validator (not validator only)

### Step 5: Report Completion

When all phases complete:
1. Update status.json with `phase_status: "completed"`
2. Log completion to progress.log
3. Verify all tasks in tasks.md are marked `- [x]`
4. Report summary: phases completed, retries needed, files modified

## Subagent Invocation

### Invoking Builder

ALWAYS use the Task tool with these parameters:

| Parameter | Value |
|-----------|-------|
| **subagent_type** | `ralph-builder` |
| **description** | "Implement phase N tasks" |
| **prompt** | See template below |

**Builder Prompt Template:**
```
Implement the following tasks for Phase <N> of <change-id>:

Tasks:
- [ ] <task 1>
- [ ] <task 2>

Context:
- Files to modify: <list from design.md or inferred>
- Patterns to follow: <examples from codebase>
- Standards: Follow project conventions

Acceptance criteria:
<from proposal.md>

Guardrails (lessons from previous attempts):
<from .cursor/ralph/guardrails.md if retrying>
```

### Invoking Validator

ALWAYS use the Task tool with these parameters after builder completes:

| Parameter | Value |
|-----------|-------|
| **subagent_type** | `ralph-validator` |
| **description** | "Validate phase N implementation" |
| **prompt** | See template below |

**Validator Prompt Template:**
```
Validate Phase <N> implementation of <change-id>:

What was implemented:
<summary from builder response>

Acceptance criteria:
<from proposal.md>

Test commands:
<Refer to project test plan and OpenSpec change test plan>
<Common patterns: make test-unit, npm test, pytest, etc.>
<Use project-specific commands as documented>

Files to review:
<list of modified files from builder>
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
- The change scope is unclear or ambiguous

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
