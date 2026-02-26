Commit all pending changes using the `git-commit` skill.

## Requirements

- Use Conventional Commits format: `<type>(scope): description`
- One commit per logical group of changes — do NOT lump unrelated changes together
- Keep the subject line under 72 characters, single line, imperative mood
- Stage and commit each group separately before moving to the next

## Commit types

| Type       | When to use                           |
| ---------- | ------------------------------------- |
| `feat`     | New feature or capability             |
| `fix`      | Bug fix                               |
| `docs`     | Documentation only                    |
| `test`     | Add or update tests                   |
| `build`    | Build system, dependencies, scripts   |
| `ci`       | CI/CD config changes                  |
| `refactor` | Code restructure (no behavior change) |
| `chore`    | Maintenance, cleanup                  |

## Process

1. Run `git status` and `git diff` to review all uncommitted changes
2. Identify logical groups (e.g., a docs change + a build script change = 2 commits)
3. For each group: stage the relevant files, commit with a descriptive message
4. Run `git status` after all commits to confirm a clean working tree
