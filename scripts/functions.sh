
getTmuxOption() {
    local option="$1"
    local defaultValue="$2"
    local optionValue=$(tmux show-option -gqv "$option")
    if [[ -n $optionValue ]]; then
        printf '%s' "$optionValue"
    else
        printf '%s' "$defaultValue"
    fi
}

capturePaneContents() {
    local file
    local target
    while (( $# > 0 )); do
        case "$1" in
            -t)
                 shift
                 target="$1"
                 ;;
            -*)  printf 'capturePaneContents: invalid switch %s\n' "$1" >&2
                 return 1
                 ;;
        esac
        shift
    done
    file=$(mktemp)
    tmux capture-pane -t "$target" -S- -E- -J -e -p |sed -e "s/[ 	][ 	]*$//" >"$file"
    printf '%s\n' "$file"
}

getPaneProperties() {
    local format=''
    local property
    for property in "$@"; do
        format="${format}#{${property}} "
    done
    declare -g "$@"
    read -r "$@" < <(tmux display-message -t "$pane_id" -p "$format")
}

countLines() {
    local file="$1"
    awk '{line_count+=1}END{print line_count}' "$file"
}

cursorPosition() {
    local x y width height lineVar file
    while (( $# > 0 )); do
        case "$1" in
            -x) shift; x="$1";;
            -y) shift; y="$1";;
            -width) shift; width="$1";;
            -height) shift; height="$1";;
            -lineVar) shift; lineVar="$1";;
            -file) shift; file="$1";;
        esac
        shift
    done

    local line_count=$(countLines "$file")
    eval "${lineVar}=$(( line_count - ( height - y ) + 1 ))"
}
