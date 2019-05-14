#! /usr/bin/env bash

pane_id="$1"

SCRIPTS_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
source "$SCRIPTS_DIR/functions.sh"

file=$(capturePaneContents -t "${pane_id}")
getPaneProperties cursor_y cursor_x pane_width pane_height
line_count=$(countLines "$file")
cursor_line=$(( line_count - ( pane_height - cursor_y ) + 1 ))
cursor="${cursor_line}.${cursor_x},${cursor_line}.${cursor_x}"
kak -e "
   edit $file
   exec gj
   try %{
      ansi-render
   } catch %{
      exec -draft %{%s\x1B[\d;]+m<ret><a-d>}
   }
   write
   set-option buffer readonly true
   set-option window filetype tmux-copy
   delete-buffer *tmux-copy*
   rename-buffer *tmux-copy*
   select $cursor
   "
rm -f "$file"
tmux swap-pane -s :copy-mode.0 -t :
