#! /usr/bin/env bats

source scripts/functions.sh

@test "cursorPosition, when file is same height as pane" {
    cursorPosition -file tests/ten-lines.txt -x 0 -y 0 -width 80 -height 10 -lineVar line -columnVar column
    [[ 1 = $line ]]
    [[ 1 = $column ]]
    cursorPosition -file tests/ten-lines.txt -x 0 -y 1 -width 80 -height 10 -lineVar line -columnVar column
    [[ 2 = $line ]]
    [[ 1 = $column ]]
    cursorPosition -file tests/ten-lines.txt -x 0 -y 9 -width 80 -height 10 -lineVar line -columnVar column
    [[ 10 = $line ]]
    [[ 1 = $column ]]
}

@test "cursorPosition, when file is longer than pane" {
    cursorPosition -file tests/ten-lines.txt -x 0 -y 0 -width 80 -height 5 -lineVar line -columnVar column
    [[ 6 = $line ]]
    cursorPosition -file tests/ten-lines.txt -x 0 -y 1 -width 80 -height 5 -lineVar line -columnVar column
    [[ 7 = $line ]]
}

@test "cursorPosition returns the file (not screen) position when lines wrap" {
    local file=$(mktemp)
    cat >"$file" <<EOF
a
b
1234567
c
d
EOF
    # This will display as:
    # b       (line 2)
    # 12345   (line 3)
    # 67      (line 3)
    # c       (line 4)
    # d       (line 5)
    cursorPosition -file "$file" -x 0 -y 4 -width 5 -height 5 -lineVar line -columnVar column
    [[ 5 = $line ]]
    [[ 1 = $column ]]
    cursorPosition -file "$file" -x 0 -y 2 -width 5 -height 5 -lineVar line -columnVar column
    [[ 3 = $line ]]
    [[ 6 = $column ]]
    cursorPosition -file "$file" -x 1 -y 2 -width 5 -height 5 -lineVar line -columnVar column
    [[ 3 = $line ]]
    [[ 7 = $column ]]
    cursorPosition -file "$file" -x 0 -y 1 -width 5 -height 5 -lineVar line -columnVar column
    [[ 3 = $line ]]
    [[ 1 = $column ]]
    rm -f "$file"
}

@test "edtiorType" {
    [[ kak = $(EDITOR=kak editorType) ]]
    [[ kak = $(EDITOR=/usr/local/bin/kak editorType) ]]
    [[ vi = $(unset EDITOR; editorType) ]]
    [[ kak = $(EDITOR='/usr/bin/kak --extra' editorType) ]]
}

@test "getExtraEditorArgs" {
    EDITOR=rando getExtraEditorArgs
    [[ 0 = ${#extra_editor_args[@]} ]]

    extra_editor_args=()
    EDITOR=kak getExtraEditorArgs
    [[ 2 = ${#extra_editor_args[@]} ]]
    [[ "-e" = ${extra_editor_args[0]} ]]
}
