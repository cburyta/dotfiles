# YouTube Link Processing

Find YouTube links in notes and enrich with transcript context.

## Finding Links

Regex pattern:
```
https?://(?:www\.)?youtube\.com/watch\?v=[\w-]+|https?://youtu\.be/[\w-]+
```

## Fetching Transcripts

```bash
/opt/homebrew/bin/ytt fetch "<youtube-url>" --lang en
```

Accepts: full URLs, short URLs, video IDs.

## Generating Descriptions

1. Read first ~30-60 seconds of transcript
2. Identify main topic/purpose
3. Focus on **key takeaways** - what can the viewer learn or apply?
4. Create 1-2 sentence description emphasizing actionable insights

Description should be:
- **Takeaway-focused**: What will I learn or do after watching?
- **Relevant**: Tie to note's context
- **Concise**: 1-2 sentences max

## Output Format

```markdown
- **[Video Title](url)** — Brief description
```

Or in references section:
```markdown
## References

- [Title](url) — Description
```

## Progressively Loading

If multiple videos found:
1. Process first video completely
2. Show user results
3. Ask if they want to continue with next video

This avoids long-running operations and lets user approve each step.
