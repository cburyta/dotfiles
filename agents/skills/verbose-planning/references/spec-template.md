# Spec Template

Use this as a starting structure. Adapt sections to the project — not every project needs every section, and some projects need domain-specific sections not listed here.

## Header

```markdown
# {Project Name} — Specification

**Date:** {YYYY-MM-DD}
**Status:** Draft | Review | Final
**Version:** v{X.Y.Z}
**Repo:** {org/repo} (proposed | existing)
```

## Standard sections

### 1. Purpose
What this project does. What it explicitly does NOT do. One paragraph.

### 2. Design principles
3-5 numbered architectural truths. Each is a decision, not a platitude. Bad: "Be scalable." Good: "S3 as source of truth — Snowflake external tables are read-only indexes, not data stores."

### 3. Codebase structure
Full annotated file tree. Include comments explaining each directory/file's role.

### 4. Naming conventions
Tables for each domain: Python, storage paths, database, API. Include concrete examples.

### 5. CLI / API design
Command tree or endpoint map with full argument signatures. Include code showing how commands are wired (e.g., Typer app registration).

### 6. Config design
Full config class with all fields, types, defaults. Env var mapping table.

### 7. Database / storage design
DDL with comments. Explain why this schema shape (not just what it is). Include GRANTs, permissions, roles.

### 8-N. Domain-specific sections
As many as needed. Each should include:
- Data flow diagram (ASCII art)
- Code samples showing the implementation approach
- Contract definitions (JSON schemas for files exchanged between systems)

### N+1. Code copied from existing repos
If brownfield: table of source file → target file → what changes. This saves the implementer from guessing.

### N+2. Dependencies
Full dependency file (`pyproject.toml`, `package.json`, etc.) with pinned versions where stability matters.

### N+3. Testing strategy
- Test layers table (unit/integration/e2e with tools and markers)
- Full `conftest.py` or test setup code
- Example tests for the most complex command
- What's mocked and why
- Where database/service tests are deferred and why

### N+4. Phased delivery
Phases with step tables. Each step has: description, ticket references, parallelism notes.

### N+5. Risks and mitigations
Table: risk, severity, mitigation.

### N+6. Related tickets
Table: ticket ID, summary, which phase it informs.

## Appendices

Added after audit subagent review:

### Appendix A: Audit-driven additions
Organized by finding, with the original audit category (critical/important/minor) noted.

## Audit log

| Date | Auditor | Scope | Findings summary |
|---|---|---|---|
