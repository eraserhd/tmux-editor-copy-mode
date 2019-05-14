#! /usr/bin/env bats

source scripts/functions.sh

@test "countLines" {
    [[ $(countLines "tests/ten-lines.txt") = 10 ]]
}

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

@test "cursorPosition, when lines have wrapped" {
}
