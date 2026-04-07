---
name: cmux
description: Interact with cmux workspaces and SSH remotes. Use when user asks to run commands in cmux, interact with dev-bunker, execute commands in workspaces, send terminal input, or manage remote sessions.
---

# cmux Workspace Interaction

## Critical: Two-Step Command Execution

**Commands are NOT submitted automatically.** You MUST send the command AND press Enter:

```bash
# Step 1: Send the command text
cmux send --workspace <ref> '<command>'

# Step 2: Press Enter to execute (REQUIRED)
cmux send-key --workspace <ref> --surface <surface> 'Enter'
```

**Example - Running `echo "hello world"`:**
```bash
cmux send --workspace workspace:12 'echo "hello world"'
cmux send-key --workspace workspace:12 --surface surface:36 'Enter'
# Output shows: hello world
```

## Finding Workspace References

```bash
# List all workspaces
cmux list-workspaces

# Get workspace tree (shows panes & surfaces)
cmux tree --workspace <ref>
```

**Output format:** `workspace:12  dev-bunker` means workspace:12 is dev-bunker.

## Identifying Surfaces

```bash
# List panes in workspace
cmux list-panes --workspace workspace:12

# List surfaces in a pane
cmux list-pane-surfaces --workspace workspace:12 --pane pane:17
```

**Finding current surface:** When in a cmux terminal, `CMUX_SURFACE_ID` env var is auto-set. Use `--surface surface:36` (typical) or find via `list-pane-surfaces`.

## Two Interaction Modes

### Mode 1: Direct Workspace Interaction

Use when workspace is already connected:
```bash
cmux send --workspace workspace:12 'vim --version'
cmux send-key --workspace workspace:12 --surface surface:36 'Enter'
cmux capture-pane --workspace workspace:12 --surface surface:36 --lines 20
```

### Mode 2: SSH Mode (Creates New Workspace)

Use `cmux ssh <destination>` to connect to remote - creates new workspace:
```bash
cmux ssh dev-bunker 'echo "test"'  # Creates workspace:XX, state=connecting
cmux send --workspace workspace:16 'ls -la'  # Then interact
cmux send-key --workspace workspace:16 'Enter'
```

**Note:** SSH mode auto-opens a new workspace. Get ref from output or `cmux list-workspaces`.

## Essential Command Pattern

```bash
# 1. Send command
cmux send --workspace <workspace-ref> --surface <surface-ref> '<command>'

# 2. Submit (press Enter) - CRITICAL
cmux send-key --workspace <workspace-ref> --surface <surface-ref> 'Enter'

# 3. Read output
cmux capture-pane --workspace <workspace-ref> --surface <surface-ref> --lines 30
```

## Use Cases

| Task | Command |
|------|---------|
| Run arbitrary command | send `<cmd>`, then send-key Enter |
| List files | send `ls`, send-key Enter |
| Read screen | capture-pane |
| Create new terminal pane | new-pane --type terminal --workspace <ref> |
| Remote control browser | create a browser split, then use agent-browser skill to interact with it |

## Browser Split Use Case

To use the browser automation feature with a cmux workspace:

1. **Create a browser split** in the workspace:
```bash
cmux new-pane --type browser --workspace <ref>
```

2. **Identify the browser surface**:
```bash
cmux list-pane-surfaces --workspace <ref> --pane <pane-id>
```

3. **Interact with the browser** - the browser pane can be controlled via cmux send-key commands, or use the `agent-browser` skill for advanced automation (navigation, form filling, clicking, screenshots).

This enables scenarios like: testing web apps, automating browser workflows, scraping data, or verifying UI behavior in a remote workspace.

## Workspace Ref Formats

- Full: `workspace:12` (from list-workspaces)
- Short refs work where accepted
- SSH connections show "state=connecting" then create workspace automatically


