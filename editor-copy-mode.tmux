#! /usr/bin/env bash

SCRIPTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts"
source "$SCRIPTS/functions.sh"

keys=$(getTmuxOption '@editor_copy_mode_keys' 'N ctrlw:N')
for key in $keys; do
    if [[ "$key" = *:* ]]; then
        bindArgs=( "-T${key%%:*}" "${key#*:}" )
    else
        bindArgs=( "$key" )
    fi
    tmux bind "${bindArgs[@]}" run-shell "${SCRIPTS}/copy-mode.sh #{pane_id}" 2>/dev/null
done
