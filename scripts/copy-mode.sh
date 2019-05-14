#! /usr/bin/env bash

SCRIPTS_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"

pane_id=$(tmux display-message -p '#D')
tmux new-window -n copy-mode -d "${SCRIPTS_DIR}/run-editor.sh ${pane_id}"
tmux swap-pane -s :copy-mode.0 -t :
