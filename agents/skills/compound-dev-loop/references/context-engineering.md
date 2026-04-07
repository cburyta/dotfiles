# Context Engineering

Core principle: LLMs are stateless. Better input = better output.

## The Smart Zone

- Context window has diminishing returns after ~40% usage
- More context = worse tool calling and reasoning
- Goal: Stay in "smart zone" throughout workflow

## Context Consumers

What fills context:
- File searching and reading
- Understanding code flow
- Editing files (diffs)
- Test/build output
- MCP tool JSON responses

## Sub-agents for Isolation

Sub-agents are for **context control**, not role-playing.

**Wrong:** Frontend-agent, Backend-agent, QA-agent
**Right:** Research-agent that returns compressed findings

Pattern:
1. Fork new context for exploration
2. Agent reads many files, searches codebase
3. Returns succinct summary to parent
4. Parent works with compressed knowledge

## Compaction Techniques

### Intentional Compaction

When context grows or trajectory is negative:
1. Ask agent to compress current state to markdown
2. Review and tag the compaction
3. Start fresh context with compacted knowledge

### What to Compact

Good compaction includes:
- Exact files and line numbers relevant to problem
- Decisions made and why
- Current state of implementation
- Next steps remaining

### Frequent Compaction

Build workflow around compaction:
- Research phase outputs `.memory/research/*.md`
- Plan phase outputs `.memory/plans/*.md`
- Each phase starts fresh with previous output

## Trajectory Management

Context trajectory affects next-token prediction.

**Bad trajectory:**
- Agent does wrong thing
- Human corrects
- Agent does wrong thing again
- Human corrects again
- Model predicts: "I should do wrong thing so human can correct"

**Solution:** If trajectory is negative, start fresh context with better initial prompt rather than accumulating corrections.

## Sources

- [Compound Engineering](https://every.to/guides/compound-engineering) - Every.to
- [No Vibes Allowed](https://youtube.com/watch?v=rmvDxxNubIg) - Dex Horthy, HumanLayer
- 12 Factor Agents - HumanLayer
