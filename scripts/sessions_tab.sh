#!/usr/bin/env bash
set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/utils.sh"

main() {
  local active_style active_format inactive_format separator
  active_style=$(get_tmux_option "@sessions-tab-active-style" "bold")
  active_format=$(get_tmux_option "@sessions-tab-active-format" "plain")
  inactive_format=$(get_tmux_option "@sessions-tab-inactive-format" "first-char")
  separator=$(get_tmux_option "@sessions-tab-separator" " ")

  local sessions_output
  sessions_output=$(tmux list-sessions -F "#{session_name} #{?session_attached,attached,detached}")

  local sessions_list=()
  while read -r name status; do
    [[ -z "$name" ]] && continue
    if [[ "$status" == "attached" ]]; then
      if [[ "$active_format" == "bracket" ]]; then
        name="[${name}]"
      fi
      if [[ "$active_style" != "none" ]]; then
        sessions_list+=("#[${active_style}]${name}#[no${active_style}]")
      else
        sessions_list+=("${name}")
      fi
    else
      case "$inactive_format" in
        first-char) sessions_list+=("${name:0:1}") ;;
        full)       sessions_list+=("${name}") ;;
      esac
    fi
  done <<< "$sessions_output"

  local IFS="$separator"
  echo "${sessions_list[*]}"
}

main
