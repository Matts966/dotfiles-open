# bash like auto completion
bindkey '^i' expand-or-complete-prefix
setopt no_auto_remove_slash
# Not ignore directory delimiters
WORDCHARS=${WORDCHARS/\/}

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

gcd() {
    repo=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*") &&
        cd $(ghq root)/$repo
            zle reset-prompt
}
zle -N gcd
bindkey '^g^r' gcd

_lazygit() {
    git status &> /dev/null
    if [[ $? -eq 0 ]]; then
        lazygit
        return
    fi
    # zle's returns code is always 0...
    repo=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*") && cd $(ghq root)/$repo && lazygit
    zle reset-prompt
}
zle -N _lazygit
bindkey '^g^g' _lazygit

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
bindkey '^g^s' fshow


# cd with fzf without buffer, otherwise delete-char-or-list
setopt ignore_eof
cdr() {
    if [[ -z $BUFFER ]]; then
        local dir
        dir=$(find . -path '*/\.*' -prune \
            -o -type d -print 2> /dev/null | fzf +m) &&
            cd "$dir"
                    zle reset-prompt
                    return
    fi
    zle delete-char-or-list
}
zle -N cdr
bindkey '^D' cdr

function agg() {
    openvim='{system("vim " $1 " +" $2 " < /dev/tty > /dev/tty")}'
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

alias fgg='_fgg'
function _fgg() {
    wc=$(jobs | grep '\[[0-9]\+\]' | wc -l | tr -d ' ')
    if [ $wc -eq 1 ]; then
        fg
        return
    fi
    if [ $wc -ne 0 ]; then
        job=$(jobs | awk -F "suspended" "{print $1 $2}"|sed -e "s/\-//g" -e "s/\+//g" -e "s/\[//g" -e "s/\]//g" | grep -v pwd | fzf | awk "{print $1}")
        wc_grep=$(echo $job | grep -v grep | grep 'suspended')
        if [ "$wc_grep" != "" ]; then
            fg %$job
            return
        fi
    fi
    echo "\nNo job found"
}
fancy-ctrl-z () {
if [[ $#BUFFER -eq 0 ]]; then
    fgg
else
    zle push-input
fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# Open vim for editing commands
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
