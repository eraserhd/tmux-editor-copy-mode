#! /usr/bin/env bats

source scripts/functions.sh

@test "countLines" {
    [[ $(countLines "tests/ten-lines.txt") = 10 ]]
}
