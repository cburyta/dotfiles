---
name: bug-fix
description: Use when diagnosing and fixing a bug reported by the user or discovered during development. Covers the full loop from reproduction to regression test to fix, with a hard stop before any schema or database migration changes.
---

# Bug Fix Workflow

## Overview

Systematic bug fix loop: reproduce → failing test → fix (or pause) → verify → commit. Schema/DB changes always require a review pause.

## Steps

### 1. Reproduce

Run the exact failing command and capture the full error output.

```bash
poetry run aso-ml <command> 2>&1
```

Read the stack trace completely. Note the file, line, and error type.

### 2. Trace Root Cause

Walk the stack trace bottom-up to the origin. Check recent commits to identify which change introduced the regression:

```bash
git log --oneline -10
git diff HEAD~1 -- <file>
```

State the root cause explicitly before touching code: *"X fails because Y was changed in commit Z."*

### 3. Write a Failing Test First

Before any fix, add a CliRunner (or unit) test that reproduces the exact failure:

```python
def test_<command>_does_not_<symptom>(monkeypatch):
    _minimal_env(monkeypatch)
    result = runner.invoke(app, ["<command>", "--flag"])
    assert result.exit_code == 0, result.output   # must fail RED before fix
```

Run it — confirm it fails with the same error seen in step 1.

```bash
poetry run pytest tests/path/test_file.py::test_name -q
```

### 4. Check Scope — Hard Gate

**Does the fix require a schema or database migration change?**

| Scope | Action |
|---|---|
| Code only | Implement fix, continue to step 5 |
| Schema / migration / DDL | Implement changes, commit, **STOP and pause for review** |

Never apply migration changes without explicit user review.

### 5. Implement the Fix

Make the smallest change that makes the test pass. One change at a time.

```bash
poetry run pytest tests/path/test_file.py -q   # GREEN
poetry run pytest -q                            # no regressions
```

### 6. Commit

```bash
git add <files>
git commit -m "fix: <one-line description of what was broken and why>"
```

Prefix must be `fix:`. No parenthetical scope syntax.

## Common Mistakes

| Mistake | Correction |
|---|---|
| Fix before test | Write test first — it must go RED before the fix |
| Test after fix that already passes | Worthless. Delete the fix, write test, re-fix |
| Amending instead of new commit | Always new commit; hooks may fail on amend |
| Skipping the schema gate | Any DDL/migration change pauses for review, no exceptions |

## Example (from this codebase)

**Symptom:** `migrate --dry-run` crashed with `TypeError: unhashable type: 'dict'`

**Root cause:** `get_migration_variables` returns a `"schemas"` key whose value is a `dict`; `_plan` iterates over all values and passes them to `re.sub(repl=val)`, which requires strings.

**Failing test added** (`test_migrate_dry_run_tolerates_non_string_migration_vars`): invoked `migrate --schema training --dry-run` via CliRunner, asserted `exit_code == 0`.

**Fix:** Filter non-string values before passing `variables` to `_plan`.

**No DB changes** → fix applied immediately.
