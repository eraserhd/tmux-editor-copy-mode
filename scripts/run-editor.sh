#! /usr/bin/env bash

pane_id="$1"

SCRIPTS_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"

file=$(mktemp)
tmux capture-pane -t "${pane_id}" -S- -E- -J -e -p |sed -e "s/[ 	][ 	]*$//" >"$file"
cursor_y=$(tmux display-message -t "${pane_id}" -p "#{cursor_y}")
cursor_x=$(tmux display-message -t "${pane_id}" -p "#{cursor_x}")
pane_height=$(tmux display-message -t "${pane_id}" -p "#{pane_height}")
line_count="$(wc -l "$file" |awk "{print \$1}")"
sel_line=$(( line_count - ( pane_height - cursor_y ) + 1 ))
cursor="${sel_line}.${cursor_x},${sel_line}.${cursor_x}"
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
