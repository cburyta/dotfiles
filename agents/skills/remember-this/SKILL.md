---
name: remember-this
description: >-
  Saves conversation context and findings to memory files for later reference.
  Use when the user invokes /remember-this to capture important information
  from the current chat session.
disable-model-invocation: true
---

# Remember This

Saves conversation context and findings to structured memory files for later reference.

## Memory Structure

Memory files are stored in `.memory/` directory with the following structure:

```
.memory/
├── plans/          # Project plans, roadmaps, architecture decisions
├── research/       # Research findings, investigations, analysis
├── tasks/          # Task breakdowns, implementation details
└── general/        # Fallback category for other context
```

## File Naming

Memory files use the format: `YYYY-MM-DD-slug.md`

- Date prefix: Current date in `YYYY-MM-DD` format
- Slug: Short descriptive identifier derived from the conversation context (lowercase, hyphens)
- Example: `2026-03-13-database-review.md`

## Category Selection

Determine the appropriate category from conversation context:

- **plans**: Architecture decisions, project roadmaps, design proposals, strategic planning
- **research**: Investigation results, analysis findings, exploration of options, research summaries
- **tasks**: Implementation details, task breakdowns, step-by-step guides, technical procedures
- **general**: Default fallback when category is unclear or content spans multiple categories

## Memory File Format

Each memory file must include:

1. **Executive Summary** (at the top)
   - One-paragraph overview of key findings and context
   - Should be concise but comprehensive enough to understand the main points

2. **Details Section**
   - Comprehensive capture of important information from the conversation
   - Include relevant code snippets, decisions, findings, and context
   - Organize with clear headings and structure

3. **Metadata** (optional frontmatter)
   - Can include tags, related files, or other metadata if relevant

## Process

When `/remember-this` is invoked:

1. **Analyze the conversation**
   - Review the entire chat history
   - Identify key findings, decisions, and important context
   - Extract relevant technical details, code snippets, and conclusions

2. **Determine category**
   - Analyze conversation content to select appropriate category
   - Use "general" if uncertain

3. **Generate slug**
   - Create a short, descriptive slug from the main topic
   - Use lowercase with hyphens (e.g., "database-review", "auth-implementation")

4. **Create directory structure**
   - Ensure `.memory/` directory exists
   - Ensure category subdirectory exists (create if missing)

5. **Write memory file**
   - Generate date-prefixed filename
   - Write executive summary at the top
   - Write detailed content below
   - Use clear markdown formatting with headings

## Example Output

```markdown
# Executive Summary

During this session, we reviewed the database schema and identified several
optimization opportunities. The main findings include index recommendations for
frequently queried columns, normalization opportunities in the user_profiles table,
and a plan to migrate from JSON columns to proper relational tables for better
query performance.

## Database Schema Review

### Current State

The application uses PostgreSQL with the following key tables:
- `users` (id, email, created_at)
- `user_profiles` (user_id, profile_data JSONB)
- `orders` (id, user_id, total, status)

### Key Findings

1. **Missing Indexes**
   - `orders.user_id` is frequently queried but lacks an index
   - `orders.status` is used in WHERE clauses but not indexed

2. **Normalization Opportunities**
   - `user_profiles.profile_data` JSONB column contains structured data that
     should be normalized into separate tables
   - Current structure makes querying profile attributes inefficient

3. **Query Performance**
   - Several queries scan large portions of tables
   - JOIN operations could benefit from better indexing

### Recommendations

1. Add indexes: `CREATE INDEX idx_orders_user_id ON orders(user_id);`
2. Normalize profile data into `profile_attributes` table
3. Review and optimize slow queries identified in logs

## Code Snippets

[Relevant code examples from conversation]

## Related Files

- `db/schema.sql`
- `app/models/user.rb`
```

## Implementation Notes

- Always create the `.memory/` directory structure if it doesn't exist
- Use the current date (YYYY-MM-DD format) for the filename prefix
- Generate a meaningful slug from the conversation's main topic
- Write a comprehensive executive summary that captures the essence
- Include all relevant details, code snippets, and context
- Use clear markdown formatting with appropriate headings
- If the file already exists, append a number suffix (e.g., `-2`, `-3`)
