#! /usr/bin/env bash

pane_id="$1"

SCRIPTS_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"

tmux new-window -n copy-mode -d "${SCRIPTS_DIR}/run-editor.sh ${pane_id}"
tmux swap-pane -s :copy-mode.0 -t :
