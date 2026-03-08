---
name: formalize-notes
description: >
  Enrich and complete notes in an Obsidian vault. Tasks include: adding YAML frontmatter,
  formatting YouTube links with transcript context, creating smaller atomic notes in
  correct locations. Use when user asks to formalize, complete, enrich, or clean up notes.
---

# Formalize Notes

Enrich and complete Obsidian notes with structured metadata, formatted links, and proper organization.

## Vault Location

```
/Users/chris/Library/CloudStorage/Dropbox/Notes/cburyta/
```

## Core Tasks

### 1. Add YAML Frontmatter

See `references/frontmatter.md` for details.

**Quick check**: If note lacks `---` frontmatter at top, add:
- `created:` date
- `tags:` relevant tags
- `type:` note type (daily/fleeting/project/area/tech)

### 2. YouTube Links

See `references/youtube.md` for details.

**Quick workflow**:
1. Find ALL youtube.com/youtu.be URLs in the note (even if mixed with other content)
2. Fetch transcript with `/opt/homebrew/bin/ytt fetch <url> --lang en`
3. Generate 1-2 sentence description
4. Format as `[Title](url) — description`

### 3. Link Formatting

**ALWAYS format any link that looks like it should have a description**:
- YouTube videos → fetch transcript and add description
- GitHub repos → add brief description of what the repo is
- Articles/blogs → add title or brief summary
- If link is bare (just URL on its own line), it needs formatting

**This is mandatory** - do not skip link formatting even when logging to Muninn.

See `references/note-creation.md` for details.

**Quick workflow**:
1. Identify discrete topics in current note
2. Create new notes in appropriate folder
3. Add backlinks and references

## Folder Structure

The vault has a topic-centric folder structure. The agent should:

1. **Discover structure dynamically** - Look at the folder tree to understand organization
2. **Infer purpose from context** - Use folder names and user's request to determine folder intent
3. **Adapt to any naming convention** - Folders may be prefixed with numbers, use kebab-case, or follow other patterns

When processing notes, determine appropriate folder placement based on:
- Folder names (e.g., "daily", "fleeting", "projects", "areas", "tech")
- User's explicit instructions
- Content type inferred from frontmatter or content

## Trigger Patterns

Use this skill when user mentions:
- "formalize" / "complete" / "enrich" a note
- "add frontmatter" / "add tags"
- "process YouTube links" / "format video links"
- "create smaller notes" / "split into notes"
- "organize" / "clean up" a note
- "log to muninn" / "ingest to memory" / "remember notes"

## Log to Muninn (Bulk)

Use when user wants to ingest notes into MuninnDB:

1. **Determine folder and scope** - Understand from user prompt which folder(s) to process
2. **Scan folder** for markdown files
3. **Check frontmatter** for `logged-to-muninn` - skip if exists and file not modified after
4. **Read each note** - extract content
5. **Analyze with LLM** - identify key topics, concepts, entities for tags
6. **Store to Muninn** - use `muninn_remember` with:
   - `concept`: Note title or filename
   - `content`: Note body (truncated to 2000 chars if needed)
   - `tags`: Inferred from content + folder scope
   - `metadata`: source file, logged date
7. **Update frontmatter** - add `logged-to-muninn: <date>` so not re-logged

**Re-processing**: If note was updated after `logged-to-muninn` date, process again.

**Scope mapping**: Derive scope from folder name or ask user for clarification.
