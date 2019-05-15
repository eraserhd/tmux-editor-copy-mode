#! /usr/bin/env bash

pane_id="$1"

SCRIPTS_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
source "$SCRIPTS_DIR/functions.sh"

extra_editor_args=()

file=$(capturePaneContents -t "${pane_id}")
getPaneProperties cursor_y cursor_x pane_width pane_height
cursorPosition -file $file \
    -y $cursor_y -x $cursor_x -width $pane_width -height $pane_height \
    -lineVar cursor_line -columnVar cursor_column

kak -e "
   exec gj
   try %{
      ansi-render
   } catch %{
      exec -draft %{%s\x1B[\d;]+m<ret><a-d>}
   }
   write
   set-option buffer readonly true
   set-option window filetype tmux-copy
   try %{ delete-buffer *tmux-copy* }
   rename-buffer *tmux-copy*
   add-highlighter buffer/wrap wrap
   select ${cursor_line}.${cursor_column},${cursor_line}.${cursor_column}
   " "$file"

rm -f "$file"
tmux swap-pane -s :copy-mode.0 -t :
