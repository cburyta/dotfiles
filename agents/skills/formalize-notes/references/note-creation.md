# Note Creation

Split large notes into smaller atomic notes in correct locations.

## When to Create

- Note covers multiple distinct topics
- User asks to "split" or "create smaller notes"
- Content could be linked from elsewhere

## Finding Topics

Scan for:
- H2/H3 headings that could be standalone topics
- Lists of related items (tools, resources, links)
- Sections with clear boundaries

## Placement Rules

| Content Type | Best Folder |
|--------------|-------------|
| Project work | 20 - projects/anytime/ |
| Technical how-to | 55 - tech notes/[topic]/ |
| Area-specific | 50 - areas/[area]/ |
| Temporary ideas | 10 - fleeting/ |
| Daily references | 10 - daily/ |

## Creation Steps

1. Identify discrete topic to extract
2. Create new note with descriptive name
3. Add frontmatter with appropriate type/tags
4. In original note, replace content with link to new note
5. Add backlink in new note pointing to source

## Naming Conventions

- Lowercase, hyphenated: `python-async-basics.md`
- Descriptive: `how-to-configure-vim.md` not `vim.md`
- Atomic: one topic per note

## Links Format

Replace extracted section with:
```markdown
See [[new-note-name]] for details.
```
