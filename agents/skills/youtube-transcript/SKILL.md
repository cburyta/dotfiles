---
name: youtube-transcript
description: >
  Fetch and analyze YouTube video transcripts using the `ytt` CLI tool.
  Use this skill whenever the user shares a YouTube URL or video ID, or asks
  to review, summarize, analyze, critique, or discuss any YouTube video content.
  Trigger on any mention of YouTube videos, even if the user doesn't explicitly
  say "transcript" — if they want to know what's in a video, this is the tool.
  Also trigger when the user pastes a youtube.com or youtu.be link.
---

# YouTube Transcript Fetcher

This skill uses `ytt` (YouTube Transcript Fetcher CLI) to grab transcripts
from YouTube videos so you can analyze, summarize, or discuss their content.

**Important disambiguation**: `ytt` here refers to the YouTube Transcript
Fetcher installed via Homebrew (`brew install youtube-transcript`), located at
`/opt/homebrew/bin/ytt`. This is NOT the YAML templating tool also called
`ytt` — do not confuse the two.

## Workflow

1. **Extract the video URL or ID** from the user's message
2. **Fetch the transcript** using `ytt fetch`
3. **Analyze the content** according to what the user asked for

## Fetching a Transcript

Run `ytt fetch` with the YouTube URL or video ID:

```bash
/opt/homebrew/bin/ytt fetch "<youtube-url-or-video-id>"
```

The tool accepts multiple URL formats:
- Full URL: `https://www.youtube.com/watch?v=dQw4w9WgXcQ`
- Short URL: `https://youtu.be/dQw4w9WgXcQ`
- Video ID: `dQw4w9WgXcQ`

### Options

| Flag | Purpose |
|------|---------|
| `--lang en,es,fr` | Preferred transcript language(s), comma-separated, tried in order |
| `--json` | Output as JSON (includes timestamps per segment) |
| `-o file.txt` | Write output to a file instead of stdout |
| `--verbose` | Show detailed fetch information |

For most review/summary tasks, plain text output (the default) works best.
Use `--json` when the user needs timestamps or segment-level detail.

### If ytt Is Not Installed

If `/opt/homebrew/bin/ytt` is not found, tell the user to install it:

```
brew install youtube-transcript
```

Do not attempt to install it automatically — Homebrew installs should be
confirmed by the user.

## After Fetching

Once you have the transcript text, proceed with whatever the user requested:

- **Summarize**: Provide a concise summary hitting the key points
- **Review/Critique**: Analyze the arguments, accuracy, or presentation quality
- **Extract**: Pull out specific information the user asked about
- **Discuss**: Use the transcript as context for answering questions about the video

If the transcript is very long, focus on the sections most relevant to the
user's question rather than trying to process every line.
