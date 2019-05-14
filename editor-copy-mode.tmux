#! /usr/bin/env bash

SCRIPTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts"

tmux bind -Tctrlw N run-shell "${SCRIPTS}/copy-mode.sh #{pane_id}"
