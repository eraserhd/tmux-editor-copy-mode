#! /usr/bin/env bats

source scripts/functions.sh

@test "countLines" {
    [[ $(countLines "tests/ten-lines.txt") = 10 ]]
}

@test "cursorLine, when file is same height as pane" {
    cursorLine -file tests/ten-lines.txt -x 0 -y 0 -width 80 -height 10 -lineVar line
    [[ 1 = $line ]]
    cursorLine -file tests/ten-lines.txt -x 0 -y 1 -width 80 -height 10 -lineVar line
    [[ 2 = $line ]]
    cursorLine -file tests/ten-lines.txt -x 0 -y 9 -width 80 -height 10 -lineVar line
    [[ 10 = $line ]]
}

@test "cursorLine, when file is longer than pane" {
    cursorLine -file tests/ten-lines.txt -x 0 -y 0 -width 80 -height 5 -lineVar line
    [[ 6 = $line ]]
    cursorLine -file tests/ten-lines.txt -x 0 -y 1 -width 80 -height 5 -lineVar line
    [[ 7 = $line ]]
}

@test "cursorLine, when lines have wrapped" {
}
