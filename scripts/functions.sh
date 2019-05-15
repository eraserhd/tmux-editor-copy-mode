SCRIPTS_DIR="$(CDPATH= cd $(dirname "${BASH_SOURCE[0]}") && pwd)"

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

cursorPosition() {
    local vars=() name file
    while (( $# > 0 )); do
        case "$1" in
            -file)
                file="$2"
                shift
                shift
                ;;
            -*)
                name="${1#-}"
                value="$2"
                vars+=( "-v" "${name}=${value}" )
                shift
                shift
                ;;
        esac
    done
    eval "$(awk ${vars[@]} -f "${SCRIPTS_DIR}/cursor-position.awk" "${file}")"
}

editorType() {
    local editor_type="${EDITOR-vi}"
    editor_type="${editor_type%% *}"
    editor_type="${editor_type##*/}"
    printf '%s\n' "$editor_type"
}
