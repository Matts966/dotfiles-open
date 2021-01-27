export LANG=ja_JP.UTF-8

# ZPlug
source ~/.zplug/init.zsh

zplug "docker/compose", use:contrib/completion/zsh

zplug "zsh-users/zsh-syntax-highlighting"

zplug "zsh-users/zsh-completions"
zplug "greymd/docker-zsh-completion"
zplug "zsh-users/zsh-autosuggestions"

# Vim mode that is compatible bindkey -e
zplug "softmoth/zsh-vim-mode", defer:1

zplug "junegunn/fzf", use:"shell/*.zsh", defer:2
zplug "b4b4r07/zsh-gomi", if:"which fzf", defer:3

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
    echo "compiling..."
    for f in $(find ~ -type f -name "*.zsh" 2> /dev/null); do zcompile $f; done
fi
zplug load

source ~/.todoist_functions_fzf.zsh

# Prompt using zsh-vim-mode
autoload -Uz colors; colors
autoload -Uz add-zsh-hook
autoload -Uz terminfo
terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
left_down_prompt_preexec() {
    print -rn -- $terminfo[el]
}
add-zsh-hook preexec left_down_prompt_preexec
update-prompt() {
    local keymap="$1"
    case $keymap in
        vicmd)
            PROMPT_2="$fg[green]-- NORMAL --$reset_color"
            ;;
        visual|vline)
            PROMPT_2="$fg[yellow]-- VISUAL --$reset_color"
            ;;
        main|viins|*)
            PROMPT_2="$fg[cyan]-- INSERT --$reset_color"
            ;;
    esac
    PROMPT="%F{cyan}%~%f
%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}%F{yellow}❯❯❯%f""%(?.%F{cyan}.%F{red})❯❯%f "
    zle || return
    zle reset-prompt
}
update-prompt
zle -N update-prompt
vim_mode_keymap_funcs=update-prompt

# bash like auto completion
bindkey '^i' expand-or-complete-prefix
setopt no_auto_remove_slash
# Not ignore directory delimiters
WORDCHARS=${WORDCHARS/\/}


export FZF_CTRL_T_OPTS='--bind "ctrl-v:execute(vim $(printf %q {}) < /dev/tty > /dev/tty)" --preview "bat --color=always --style=header,grid --line-range :100 {}"'
export BAT_THEME="iceberg"
export FZF_DEFAULT_OPTS='--height 100% --reverse --border --ansi'
# Iceberg
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg+:#1e2132,bg:#161821,spinner:#84a0c6,hl:#6b7089,fg:#c6c8d1,header:#6b7089,info:#b4be82,pointer:#84a0c6,marker:#84a0c6,fg+:#c6c8d1,prompt:#84a0c6,hl+:#84a0c6"

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


HISTSIZE=50000              # How many lines of history to keep in memory
HISTFILE=~/.zsh_history     # Where to save history to disk
SAVEHIST=50000              # Number of history entries to save to disk
HISTDUP=erase               # Erase duplicates in the history file
setopt    appendhistory     # Append history to the history file (no overwriting)
setopt    incappendhistory  # Immediately append to the history file, not just when a term is killed

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - --no-rehash)"

if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
    echo ".zshrc updated, compiling..."
    zcompile ~/.zshrc
fi

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi
