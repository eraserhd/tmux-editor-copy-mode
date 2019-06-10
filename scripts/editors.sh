# Kakoune

kakExtraArgs() {
    declare -g extra_editor_args
    extra_editor_args+=(
        "-e"
        "
           exec gj
           try %{
              ansi-render
           } catch %{
              exec -draft %{%s\x1B\[[\d;]+m<ret><a-d>}
           }
           try %{ exec -draft '%s\h$<ret><a-d>' }
           write
           set-option buffer readonly true
           set-option window filetype tmux-copy
           try %{ delete-buffer *tmux-copy* }
           rename-buffer *tmux-copy*
           add-highlighter buffer/wrap wrap
           select ${cursor_line}.${cursor_column},${cursor_line}.${cursor_column}
        "
    )
}

kakKeepANSI() {
    return 0
}
