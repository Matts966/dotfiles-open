# bash like auto completion
bindkey '^i' expand-or-complete-prefix
setopt no_auto_remove_slash
# Not ignore directory delimiters
WORDCHARS=${WORDCHARS/\/}

# Ignore ctrl-d EOF and delete-char-or-list
setopt ignore_eof

# Git functions
bindkey -r '^g'
fbr() {
    local branches branch
    branches=$(git branch --all | grep -v HEAD) &&
        branch=$(echo "$branches" |
        fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
        git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
zle -N fbr
bindkey '^g^b' fbr

fshow() {
    git log --graph --all --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
        fzf --no-sort --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
            (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                            {}
FZF-EOF"
}
zle -N fshow
bindkey '^g^l' fshow

function agg() {
    openvim='{system("$EDITOR " $1 " +" $2 " < /dev/tty > /dev/tty")}'
    result=`rg --column --line-number --no-heading -- . 2> /dev/null | fzf --bind "ctrl-v:execute(printf %q {} | awk -F ':' '$openvim')"`
    if [ -z $result ]
    then
        zle reset-prompt
        return
    fi
    echo $result | awk -F ':' $openvim
    zle reset-prompt
}
zle -N agg
bindkey '^x^f' agg
