# Set FILTER env var to change default, and reset by unset FILTER
select_items_command() {
    eval "todoist --namespace --project-namespace \
        list --filter '${FILTER-!no date}' \
        | sort -k 3,4 | fzf --multi | cut -d ' ' -f 1 | tr '\n' ' '"
}

function insert-in-buffer () {
    if [ -n "$1" ]; then
        local new_left=""
        if [ -n "$LBUFFER" ]; then
            new_left="${new_left}${LBUFFER} "
        fi
        if [ -n "$2" ]; then
            new_left="${new_left}${2} "
        fi
        new_left="${new_left}$1"
        BUFFER=${new_left}${RBUFFER}
        CURSOR=${#new_left}
    fi
    zle reset-prompt
}

# todoist find item
function fzf-todoist-item () {
    local SELECTED_ITEMS="$(select_items_command)"
    insert-in-buffer $SELECTED_ITEMS
}
zle -N fzf-todoist-item
bindkey "^xtt" fzf-todoist-item

# todoist select date
function fzf-todoist-date () {
    date -v 1d &>/dev/null
    if [ $? -eq 0 ]; then
        # BSD date option
        OPTION="-v+#d"
    else
        # GNU date option
        OPTION="-d # day"
    fi

    local SELECTED_DATE="$(seq 0 30 | xargs -I# date \
        $OPTION '+%d/%m/%Y %a' | fzf | cut -d ' ' -f 1)"
    insert-in-buffer "'${SELECTED_DATE}'" "-d"
}
zle -N fzf-todoist-date
bindkey "^xtd" fzf-todoist-date

function todoist-exec-with-select-task () {
    BUFFER=
    for id in $( echo "$2" ); do
        BUFFER+="todoist $1 $id; "
    done
    CURSOR=$#BUFFER
    zle accept-line
}

# todoist close
function fzf-todoist-close() {
    local SELECTED_ITEMS="$(select_items_command)"
    zle reset-prompt
    todoist-exec-with-select-task close $SELECTED_ITEMS
}
zle -N fzf-todoist-close
bindkey "^xtc" fzf-todoist-close

# todoist open
function fzf-todoist-open() {
    local SELECTED_ITEMS="$(select_items_command)"
    todoist-exec-with-select-task "show --browse" $SELECTED_ITEMS
    zle reset-prompt
}
zle -N fzf-todoist-open
bindkey "^xto" fzf-todoist-open
