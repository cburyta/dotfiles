# jira-cli Skill

Interact with Atlassian Jira from the command line.

## Required CLI Tools

| Tool | Install |
|------|---------|
| [jira-cli](https://github.com/ankitpokhrel/jira-cli) | `brew install ankitpokhrel/jira-cli/jira-cli` · [all install options](https://github.com/ankitpokhrel/jira-cli#installation) |

## Setup

```bash
export JIRA_API_TOKEN="your-token"   # from id.atlassian.com → Security → API tokens
jira init                             # follow prompts to connect to your instance
```

> **Security:** Never commit real tokens. Use a secrets manager or store tokens in a local `.env` file excluded via `.gitignore`.
