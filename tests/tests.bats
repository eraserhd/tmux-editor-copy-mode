#! /usr/bin/env bats

source scripts/functions.sh

@test "cursorPosition, when file is same height as pane" {
    cursorPosition -file tests/ten-lines.txt -x 0 -y 0 -width 80 -height 10 -lineVar line
    [[ 1 = $line ]]
    cursorPosition -file tests/ten-lines.txt -x 0 -y 1 -width 80 -height 10 -lineVar line
    [[ 2 = $line ]]
    cursorPosition -file tests/ten-lines.txt -x 0 -y 9 -width 80 -height 10 -lineVar line
    [[ 10 = $line ]]
}

@test "cursorPosition, when file is longer than pane" {
    cursorPosition -file tests/ten-lines.txt -x 0 -y 0 -width 80 -height 5 -lineVar line
    [[ 6 = $line ]]
    cursorPosition -file tests/ten-lines.txt -x 0 -y 1 -width 80 -height 5 -lineVar line
    [[ 7 = $line ]]
}

@test "cursorPosition returns the file line, not the screen line, when lines wrap" {
    skip "not working yet"
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
    cursorPosition -file "$file" -x 0 -y 4 -width 5 -height 5 -lineVar line
    [[ 5 = $line ]]
    cursorPosition -file "$file" -x 0 -y 2 -width 5 -height 5 -lineVar line
    [[ 3 = $line ]]
    cursorPosition -file "$file" -x 0 -y 1 -width 5 -height 5 -lineVar line
    [[ 3 = $line ]]
    rm -f "$file"
}
