# Herdr helpers

## `herdr-work`

Create a new Herdr tab with three shell panes:

- `agent`
- `browse`
- `term`

By default, the helper creates a Git worktree first and uses it as the tab's
working directory. It does not start an agent.

```sh
herdr-work alpha
herdr-work alpha --branch feature/ABC-123-widget
herdr-work alpha --dir ~/Repos/project
herdr-work alpha --dir ~/Repos/project --no-worktree
herdr-work alpha --worktree-dir ~/Repos/project/worktrees
```

The command must run from an existing Herdr pane. Use `--no-worktree` when the
new tab should share the supplied/current directory.
