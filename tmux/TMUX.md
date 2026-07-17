# TMUX Notes

This tmux setup now keeps the stock tmux key model so it feels familiar on a
production server.

Prefix:

- Default prefix is `Ctrl-b`.
- Send a literal `Ctrl-b` to the program running inside tmux with `Ctrl-b Ctrl-b`.

Everyday motions:

- Split vertically into top and bottom panes: `Ctrl-b "`
- Split horizontally into left and right panes: `Ctrl-b %`
- Create a new window: `Ctrl-b c`
- Move to the next window: `Ctrl-b n`
- Move to the previous window: `Ctrl-b p`
- Jump to a numbered window: `Ctrl-b 0` through `Ctrl-b 9`
- Move to the next pane: `Ctrl-b o`
- Move to a pane by direction: `Ctrl-b` plus an arrow key
- Show pane numbers briefly: `Ctrl-b q`
- Toggle pane zoom: `Ctrl-b z`
- Detach from tmux: `Ctrl-b d`
- List key bindings: `Ctrl-b ?`
- Open the tmux command prompt: `Ctrl-b :`

Copy mode:

- Enter copy mode: `Ctrl-b [`
- With `mode-keys vi`, movement is vi-like inside copy mode.
- Search backward in copy mode: `?`
- Search forward in copy mode: `/`
- Start selection in vi copy mode: `Space`
- Copy selection in vi copy mode: `Enter`
- Exit copy mode: `q`

Resizing panes:

- Resize one cell at a time: `Ctrl-b` plus `Ctrl-Up`, `Ctrl-Down`,
  `Ctrl-Left`, or `Ctrl-Right`
- Resize five cells at a time: `Ctrl-b` plus `Alt-Up`, `Alt-Down`,
  `Alt-Left`, or `Alt-Right`
- If mouse support is on, you can also drag pane borders with the mouse.

Common commands to run from `Ctrl-b :`:

- Reload the config: `source-file ~/.tmux.conf`
- Turn vi copy mode on for the current server: `set -g mode-keys vi`
- Switch back to emacs copy mode: `set -g mode-keys emacs`
- Turn mouse support on: `set -g mouse on`
- Turn mouse support off: `set -g mouse off`
- Renumber windows after closes: `set -g renumber-windows on`
- Stop renumbering windows: `set -g renumber-windows off`
- Start window numbering at 1: `set -g base-index 1`
- Start pane numbering at 1: `setw -g pane-base-index 1`

Persistence:

- Commands entered at `Ctrl-b :` affect the running tmux server now.
- To keep a setting across restarts, add it to `~/.tmux.conf`.
- In this dotfiles repo, the source file is
  `~/.dotfiles/tmux/tmux.conf.symlink`, which is symlinked to `~/.tmux.conf`.

Notes about this repo's tmux settings:

- `mode-keys vi` is enabled, so copy mode feels Vim-like.
- `mouse on` is enabled, so pane selection, resize, and scroll work with the
  mouse.
- Window and pane numbering start at `1`, and windows are renumbered after a
  close.
