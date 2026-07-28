---
name: refine-prompt
description: Rewrites an existing prompt, spec, or task document so its structure matches how a specific target model actually performs best — not a find-and-replace of the model name. Use whenever the user says "refine this prompt for Fable 5", "adapt this spec for Claude Fable 5", "rewrite this for fable", "optimize this prompt for a different model", "make this work better with Fable 5", or is about to hand a long task spec to Fable 5 and hasn't restructured it for it yet. Currently implements the `fable5` target only — other targets can be added later as references/<target>.md files. This is about the CONTENT and structure of a prompt or spec document, not API call parameters (thinking config, beta headers, model ID strings) — for migrating code that calls the Claude API, use the claude-api skill's `migrate` subcommand instead, not this skill.
---

# refine-prompt

Different Claude models don't just have different capabilities — they perform measurably better or worse depending on how a prompt is *structured*, independent of the model-name string in an API call. This skill takes an existing prompt/spec and rewrites it to match a specific target model's actual prompting characteristics, while preserving every concrete requirement and fact from the original. Nothing here touches API parameters (`thinking`, `effort`, beta headers, model IDs) — that's a code-migration concern, handled by the claude-api skill's `migrate` subcommand. If the user actually wants that, redirect them there instead of proceeding.

## Invocation

`/refine-prompt <target> [source]`

- `target` — which model's prompting style to adapt for. Currently only `fable5` (Claude Fable 5) is implemented. If the user names a different target and no `references/<target>.md` exists, say so plainly, list what *is* implemented, and ask whether to proceed anyway using general reasoning-model best practices or to stop.
- `source` — a file path to the prompt/spec, or omitted. If omitted, check whether a prompt or spec was just discussed in the conversation; if there's a clear candidate, confirm it with the user before proceeding rather than guessing. If there's no clear candidate, ask for a path or for the text to be pasted.

## Workflow

1. **Resolve the source.** Read the file (or use the pasted/discussed text). Don't summarize or paraphrase it yet — you need the literal requirements and constraints intact for step 3.

2. **Resolve the target and load its technique reference.** For `fable5`, read `references/fable5.md` before writing anything — it's the actual content of what changes and why; don't rely on recalling it from a prior read.

3. **Rewrite, don't reword.** Every concrete requirement, constraint, and fact in the source must survive into the output — this is a *restructuring* pass, not a summarization or a rewording pass, and it must not invent new requirements the source didn't have. What changes is: ordering (full spec up front vs. a progressive list), how much *why* accompanies each requirement, what's explicitly granted as autonomous vs. gated, whether over-engineering or scope-creep guardrails are needed, whether a memory/notes instruction is warranted, whether independent sub-tasks should be called out for delegation, and how the final-report communication style is specified. Apply judgment about which of the reference file's techniques actually fit this source — a short single-shot instruction doesn't need a memory-file note or a delegation callout; see the reference file's own "when less applies" section.

4. **Open with a short, explicit note explaining the restructuring**, mirroring how a diff's commit message explains *why*, not just *what*. State plainly which target this was adapted for and briefly why the structure changed (2-5 bullet points is usually enough) — this makes the output self-explanatory to someone who reads it later without this conversation's context, including the original author if they revisit it.

5. **Write the output.** Unless the user already gave an output path, derive one from the source filename by inserting `_<target>` before the extension (`prompt_v3.md` → `prompt_v3_fable5.md`), or appending `-<target>` if there's no extension. Don't overwrite the source.

6. **Report back concisely.** Summarize the structural changes you made and why in plain language — not a line-by-line diff dump, and not a repeat of the full output (the user can read the file). If you judged that some of the reference file's techniques didn't apply, say which and why in one line each.

## Extending to other targets

To add a new target, write `references/<target>.md` following the same shape as `references/fable5.md`: what's actually different about how that model wants to be prompted, and why, sourced from real documented behavior — not guessed. Don't add a target file speculatively; only add one when there's real guidance to put in it.
