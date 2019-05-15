#! /usr/bin/env bash

pane_id="$1"

SCRIPTS_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
source "$SCRIPTS_DIR/functions.sh"

file=$(capturePaneContents -t "${pane_id}")
getPaneProperties cursor_y cursor_x pane_width pane_height
cursorPosition -file $file \
    -y $cursor_y -x $cursor_x -width $pane_width -height $pane_height \
    -lineVar cursor_line -columnVar cursor_column

extra_editor_args=()
getExtraEditorArgs

"$EDITOR" "${extra_editor_args[@]}" "$file"
rm -f "$file"
tmux swap-pane -s :copy-mode.0 -t :
