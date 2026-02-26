---
name: consolidate-tests
description: Review and consolidate unit tests to reduce maintenance burden. MUST trigger automatically after all implementation tasks complete on a feature branch when git diff shows new test files. Also use when user mentions test consolidation, reducing tests, test cleanup, or /consolidate-tests.
---

# Test Consolidation

Review new tests for consolidation opportunities when implementation is complete.

## When to Trigger

Activate this skill when ALL conditions are met:
1. On a feature branch (not main/master)
2. Tasks/todos show completed status
3. Git diff shows new test files or significant test additions
4. User hasn't explicitly skipped consolidation

## Quick Check

```bash
# Check for new test code in current branch
git diff main --stat | grep -E "tests/.*\.py"
```

If no test changes, skip consolidation.

## Analysis Process

### 1. Identify New Tests

```bash
git diff main --name-only | grep -E "^tests/"
```

For each changed test file, analyze the diff for new test classes/methods.

### 2. Evaluate Each Test

Score tests on this matrix:

| Criteria | High Value | Low Value |
|----------|------------|-----------|
| Coverage | Tests unique code path | Duplicates other test |
| Breakage signal | Catches real bugs | Tests implementation detail |
| Maintenance | Stable, rarely changes | Brittle, frequent updates |
| Complexity | Simple assertions | Complex setup/mocking |

### 3. Identify Consolidation Patterns

Look for:

**Remove candidates:**
- Config/constant tests (if functional tests would catch breakage)
- Tests that duplicate higher-level integration tests
- Tests asserting obvious behavior

**Merge candidates:**
- Multiple tests calling same function with different inputs → parameterize
- Tests with identical setup → shared fixture
- Sequential assertion tests → single test with multiple asserts

**Parameterize candidates:**
- Same test logic, different inputs
- Pattern: `test_foo_case_a`, `test_foo_case_b`, `test_foo_case_c`

## Output Format

Present findings as a table:

```markdown
| Test | Value | Complexity | Recommendation |
|------|-------|------------|----------------|
| test_foo | Low | Low | REMOVE - covered by integration test |
| test_bar_a, test_bar_b | Medium | Low | PARAMETERIZE |
| test_baz | High | Low | KEEP |
```

Then summarize:
- Tests before: X
- Tests after: Y
- Reduction: Z%

Ask for permission before making changes.

## Consolidation Patterns

### Parameterize Example

Before:
```python
def test_network_nick(self):
    ctx = build_context('NICK')
    assert ctx.clause == "network = 'NICK'"

def test_network_mtv(self):
    ctx = build_context('MTV')
    assert ctx.clause == "network = 'MTV'"
```

After:
```python
@pytest.mark.parametrize("network,expected", [
    ("NICK", "network = 'NICK'"),
    ("MTV", "network = 'MTV'"),
])
def test_network_clause(self, network, expected):
    ctx = build_context(network)
    assert ctx.clause == expected
```

### Merge Example

Before:
```python
def test_case_has_when(self):
    expr = build_case()
    assert "WHEN" in expr

def test_case_has_then(self):
    expr = build_case()
    assert "THEN" in expr
```

After:
```python
def test_case_expression_structure(self):
    expr = build_case()
    assert "WHEN" in expr
    assert "THEN" in expr
    assert expr.startswith("CASE")
```

## Rules

- DO NOT remove tests without presenting analysis first
- DO NOT reduce coverage of critical paths
- DO use moto for AWS mocking (not raw boto3 mocks)
- DO keep error path tests (they catch real bugs)
- DO prefer parameterization over multiple similar tests
- DO keep fixtures local to test module when possible
