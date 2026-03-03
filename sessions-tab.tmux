#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/scripts/utils.sh"

main() {
  local bg fg prefix_bg powerline sep right_sep_bg

  bg=$(get_tmux_option "@sessions-tab-bg" "#50fa7b")
  fg=$(get_tmux_option "@sessions-tab-fg" "#282a36")
  prefix_bg=$(get_tmux_option "@sessions-tab-prefix-bg" "#f1fa8c")
  powerline=$(get_tmux_option "@sessions-tab-powerline" "true")
  sep=$(get_tmux_option "@sessions-tab-powerline-sep" "")
  right_sep_bg=$(get_tmux_option "@sessions-tab-right-sep-bg" "default")

  local script="#($CURRENT_DIR/scripts/sessions_tab.sh)"

  local status_left
  if [[ "$powerline" == "true" ]]; then
    status_left="#[bg=${bg},fg=${fg}]#{?client_prefix,#[bg=${prefix_bg}],} ${script} #[fg=${bg},bg=${right_sep_bg}]#{?client_prefix,#[fg=${prefix_bg}],}${sep}"
  else
    status_left="#[bg=${bg},fg=${fg}]#{?client_prefix,#[bg=${prefix_bg}],} ${script} "
  fi

  tmux set-option -g status-left-length 80
  tmux set-option -g status-left "$status_left"

  # Auto-refresh status on session events
  tmux set-hook -ga session-created 'refresh-client -S'
  tmux set-hook -ga session-closed 'refresh-client -S'
  tmux set-hook -ga session-renamed 'refresh-client -S'
  tmux set-hook -ga client-session-changed 'refresh-client -S'
}

main
