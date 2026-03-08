# YAML Frontmatter

Add structured metadata to notes that lack it.

## When to Add

Add frontmatter if note lacks `---` at the top OR has empty frontmatter.

## Standard Fields

```yaml
---
created: 2024-01-15
tags:
  - tag1
  - tag2
type: project  # daily | fleeting | project | area | tech
---
```

## Type Values

| Type | Folder | Description |
|------|--------|-------------|
| daily | 10 - daily/ | Daily journal |
| fleeting | 10 - fleeting/ | Temporary notes |
| project | 20 - projects/ | Active project |
| area | 50 - areas/ | Area of responsibility |
| tech | 55 - tech notes/ | Technical reference |
| career | 30 - career/ | Career notes |

## Tags Strategy

- Infer from folder path and content
- Use lowercase, hyphenated names
- Add 2-5 relevant tags **specific to content** (e.g., `ai`, `memory-systems`, `skald`, `productivity`)
- **Avoid generic tags** like "youtube", "links", "video"
- Example: For video links, use tags about the topic (`llm`, `coding-assistants`, `knowledge-graphs`) not the format

## Implementation

Edit note to prepend frontmatter:
1. Read current note content
2. Create frontmatter block
3. Insert at top of file
