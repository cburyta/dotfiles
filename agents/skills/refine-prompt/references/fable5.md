# Prompting Claude Fable 5 — technique reference

Claude Fable 5 is Anthropic's most capable widely released model, tuned for long-horizon, high-autonomy agentic work with thinking always on. A prompt written for a prior model — Opus, Sonnet, even earlier internal guidance — is frequently **too prescriptive** for it and measurably *reduces* output quality: over-specifying steps crowds out the planning and judgment Fable 5 is actually good at. Everything below is about restructuring prompt *content*. It has no bearing on API request parameters (`thinking`, `effort`, beta headers) — that's the claude-api skill's model-migration reference, a different concern entirely.

## Core shift: full spec + the why, not a progressive checklist

Deliver the complete task in one place — every requirement, all context, every constraint — rather than a list to be worked through and clarified as it goes. For every non-obvious requirement, restate the *reason* behind it, not just the ask itself: Fable 5 uses the stated reason to resolve ambiguity the way the requester actually meant, rather than guessing or asking. Put the "why this matters" motivation near the top or interleaved with the requirements — not in a separate rationale section it might not weight as load-bearing.

**When to skip:** a short, single-shot instruction (a one-off question, a small transform) rarely needs restructuring at all — this technique is for multi-part, ambiguous, or long-horizon work.

## Grant autonomy explicitly, and mean it

State plainly which classes of action can proceed without stopping to ask — typically anything reversible: edits within the declared scope, restarting or recreating its own test resources, git commits on a branch it controls. Separately state what must stop and ask — irreversible or shared-system actions: force pushes, deleting anything that isn't clearly its own, anything touching production, another person's environment, or a system outside the declared scope.

Without this split stated explicitly, Fable 5 defaults toward asking permission more than a genuinely autonomous run needs — this is a prompting default, not something an API flag fixes. Pair it with a light reverse-guard: it's operating autonomously, no one is watching in real time, so a turn shouldn't end with an unstarted plan or a question about something already covered by the autonomy grant.

## Head off over-engineering and scope creep

At higher effort, an unguided Fable 5 can gather more context, add more abstraction, or defensively handle cases that can't occur, beyond what the task actually needs. Include a plain no-gold-plating line: fix what's asked, note adjacent findings without acting on them unprompted, and resist expanding scope even when a "better" version is visible nearby.

## Give it somewhere to keep state across a long or resumable task

For anything likely to span a context-compaction boundary or be resumed in a later session, tell it to write non-obvious decisions to a durable file as it makes them — a scratch notes file, a decisions log, or an existing docs section — rather than holding the reasoning only in working context, where it would otherwise have to be re-derived after a compaction or a resume.

**When to skip:** short-lived tasks that will finish in one sitting don't need this.

## Let it delegate — asynchronously, not serially

If the task has genuinely independent pieces, say so explicitly and instruct it to delegate them to sub-agents and keep working itself in the meantime, rather than either doing everything serially or blocking on each sub-agent one at a time. This is the single biggest lever for wall-clock time on multi-part work.

**When to skip:** a task with no independent parts (a single linear change) gets nothing from this — don't add a delegation instruction that has nothing to delegate.

## Require evidence before any "done" claim

Ask for the actual command output, diff, or reproduction behind a completion claim, not a summary asserting it. This is the general "evidence before assertions" discipline, worth restating explicitly for long autonomous runs, where the temptation to summarize instead of show is strongest — a run that's been working unsupervised for a while has no one to catch an unverified claim before it's reported as fact.

## Split the communication-style instruction: working notes vs. final report

Terse shorthand while working — arrow chains, abbreviations, fragments — is fine and often good; that's Fable 5 thinking out loud efficiently. The *final* human-facing report needs its own, separate instruction: complete sentences, lead with the outcome, no arrow-chain notation, no jargon or shorthand invented mid-task, and no assuming the reader followed along with the working notes. Without this split stated explicitly, the working-notes habit leaks into the one part of the output a human actually reads carefully.

## State boundaries on adjacent-but-unrequested actions

Fable 5 can take reasonable-seeming but unrequested adjacent actions — drafting an email straight to a real outbox, creating a backup branch nobody asked for — when the state it's touching has an "obvious next step." If the task touches state like that, say explicitly what it should *not* do without being asked, not just what it should do.

## Note (for the human running the prompt, not prompt text itself)

If the target surface exposes an effort/thinking-depth knob, recommend `high` as the default and `xhigh` for coding/agentic work when drafting the run instructions — and note that `low`/`medium` still perform well and are the right choice for routine or latency-sensitive sub-tasks. This is guidance for whoever invokes the model, not a line to embed in the prompt document itself.

## When less applies

Not every technique here belongs in every rewrite. A short prompt doesn't need a memory-file instruction, a delegation callout, or a five-paragraph autonomy grant — padding a two-line ask with unneeded meta-instruction is its own form of over-prescription, the exact failure mode this whole reference exists to avoid. Apply judgment: use what the source's actual complexity and length call for, and say in the final report which techniques you deliberately left out and why.
