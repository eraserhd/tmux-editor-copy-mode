SCRIPTS_DIR="$(CDPATH= cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
source "$SCRIPTS_DIR/editors.sh"

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
    local is_alternate=$(tmux display-message -t "$target" '#{alternate_on}')
    local capture_args=( "-t" "$target" )
    if [[ $is_alternate -ne 0 ]]; then
        capture_args+=( "-a" )
    fi
    if keepANSI; then
        capture_args+=( "-e" )
    fi
    tmux capture-pane "${capture_args[@]}" -S- -E- -J -p |sed -e "s/[ 	][ 	]*$//" >"$file"
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
    local editor_type="$(getTmuxOption '@editor_copy_mode_type' ':')"
    if [[ $editor_type = : ]]; then
        editor_type="${EDITOR-vi}"
        editor_type="${editor_type%% *}"
        editor_type="${editor_type##*/}"
    fi
    printf '%s\n' "$editor_type"
}

getExtraEditorArgs() {
    local type=$(editorType)
    if [[ $(type -t "${type}ExtraArgs") = "function" ]]; then
        ${type}ExtraArgs
    fi
}

keepANSI() {
    local type=$(editorType)
    if [[ $(type -t "${type}KeepANSI") = "function" ]]; then
        ${type}KeepANSI
        return $?
    fi
    return 1
}
