#! /usr/bin/env bats

source scripts/functions.sh

@test "countLines" {
    [[ $(countLines "tests/ten-lines.txt") = 10 ]]
}

@test "computeCursorLine, when file is same height as pane" {
    [[ 1 = $(computeCursorLine -file tests/ten-lines.txt -x 0 -y 0 -width 80 -height 10) ]]
    [[ 2 = $(computeCursorLine -file tests/ten-lines.txt -x 0 -y 1 -width 80 -height 10) ]]
    [[ 10 = $(computeCursorLine -file tests/ten-lines.txt -x 0 -y 9 -width 80 -height 10) ]]
}
