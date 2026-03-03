# tmux-sessions-tab

A tmux plugin that displays all sessions as a compact tab bar in `status-left`.
Attached sessions are shown in bold (full name), detached sessions are
abbreviated to their first character.

## Installation

### With [TPM](https://github.com/tmux-plugins/tpm)

Add to your `tmux.conf`:

```tmux
set -g @plugin 'al-bashkir/tmux-sessions-tab'
```

Press `prefix + I` to install.

### Manual

```bash
git clone https://github.com/al-bashkir/tmux-sessions-tab ~/.tmux/plugins/tmux-sessions-tab
```

Add to your `tmux.conf`:

```tmux
run-shell ~/.tmux/plugins/tmux-sessions-tab/sessions-tab.tmux
```

## Options

All options are set via `set -g @option "value"` in `tmux.conf`.

| Option | Default | Description |
|---|---|---|
| `@sessions-tab-active-style` | `bold` | tmux style for attached session (`bold`, `underscore`, `italics`, `none`) |
| `@sessions-tab-active-format` | `plain` | Text format for attached session: `plain` or `bracket` (wraps in `[name]`) |
| `@sessions-tab-inactive-format` | `first-char` | How to show detached sessions: `first-char` or `full` |
| `@sessions-tab-separator` | ` ` (space) | Separator between session names |
| `@sessions-tab-bg` | `#50fa7b` | Background color |
| `@sessions-tab-fg` | `#282a36` | Foreground color |
| `@sessions-tab-prefix-bg` | `#f1fa8c` | Background color when prefix key is pressed |
| `@sessions-tab-powerline` | `true` | Show powerline separator after the tab |
| `@sessions-tab-powerline-sep` | `` | Powerline separator character |
| `@sessions-tab-right-sep-bg` | `default` | Background color after the powerline separator (match your theme) |

### Example

```tmux
set -g @sessions-tab-bg "green"
set -g @sessions-tab-fg "colour232"
set -g @sessions-tab-prefix-bg "yellow"
set -g @sessions-tab-inactive-format "first-char"
set -g @sessions-tab-powerline "true"
```

## Using with Dracula

This plugin takes ownership of `status-left`. When used alongside
[dracula/tmux](https://github.com/dracula/tmux), load it **after** Dracula in
your plugin list so it overrides Dracula's `status-left` while Dracula
continues to manage `status-right`, window status, and colors.

```tmux
set -g @plugin 'dracula/tmux'
set -g @plugin 'al-bashkir/tmux-sessions-tab'   # must come after dracula
```

Set `@sessions-tab-right-sep-bg` to match Dracula's status bar background for
a seamless powerline transition.

## How it works

- The `.tmux` entry point reads your options and constructs a `status-left`
  format string containing a `#()` shell command.
- tmux calls `scripts/sessions_tab.sh` to render the session list at each
  status refresh.
- Hooks on `session-created`, `session-closed`, `session-renamed`, and
  `client-session-changed` trigger an immediate status refresh so the tab
  updates without polling.

## License

MIT
