# AGENTS.md

## Purpose

This repo manages Mac environment dotfiles, configurations, and shell scripts. It ensures a reproducible, personalized macOS setup including shell configuration, CLI tools, git settings, and application preferences.

## Repo Structure

The repo is **topic-centric** — each top-level directory is a topic (e.g. `git/`, `zsh/`, `node/`).

### File Conventions

| Pattern | Behavior |
|---|---|
| `topic/*.zsh` | Auto-loaded into the shell environment |
| `topic/path.zsh` | Loaded **first**; use for `$PATH` setup |
| `topic/completion.zsh` | Loaded **last**; use for autocompletions |
| `topic/install.sh` | Executed by `script/install` (`.sh` to avoid auto-load) |
| `topic/*.symlink` | Symlinked into `$HOME` (without `.symlink` extension) by `script/bootstrap` |
| `bin/*` | Added to `$PATH` and available everywhere |

### Key Paths

- `script/bootstrap` — initial setup, symlinks dotfiles into `$HOME`
- `script/install` — runs all `topic/install.sh` scripts
- `bin/dot` — day-to-day updater for dependencies and macOS defaults
- `Brewfile` — Homebrew packages, casks, and taps
- `zsh/zshrc.symlink` — main zsh config entry point

## Shell Scripts

All scripts in `bin/` must be executable and should use `#!/bin/sh` or `#!/usr/bin/env bash` shebangs. New shell utilities go in `bin/` so they're automatically on `$PATH`.

Topic-specific shell config (aliases, env vars, functions) goes in the relevant topic directory as `.zsh` files.

## Guidelines

- Follow the topic-centric pattern: create a new directory for a new tool/area.
- Don't hardcode machine-specific paths; use `$ZSH` (set to the dotfiles root) or `$HOME`.
- Keep shell scripts POSIX-compatible where possible; use zsh-specific features only in `.zsh` files.
- The `Brewfile` is the source of truth for installed packages — update it when adding dependencies.
