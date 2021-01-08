export LANG=ja_JP.UTF-8

# ZPlug
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "t413/zsh-background-notify"
bgnotify_threshold=2
zplug "docker/compose", use:contrib/completion/zsh
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "greymd/docker-zsh-completion"
zplug "b4b4r07/zsh-gomi", if:"which fzf"
zplug "junegunn/fzf", use:"shell/*.zsh"
zplug "trystan2k/zsh-tab-title"

bindkey '^i' expand-or-complete-prefix
setopt no_auto_remove_slash

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load

export RIPGREP_CONFIG_PATH=~/.ripgreprc
export FZF_CTRL_T_COMMAND='rg --files 2> /dev/null'
export BAT_THEME="Monokai Extended Bright"
_gen_fzf_default_opts() {
    local color00='#272822'
    local color01='#383830'
    local color02='#49483e'
    local color03='#75715e'
    local color04='#a59f85'
    local color05='#f8f8f2'
    local color06='#f5f4f1'
    local color07='#f9f8f5'
    local color08='#f92672'
    local color09='#fd971f'
    local color0A='#f4bf75'
    local color0B='#a6e22e'
    local color0C='#a1efe4'
    local color0D='#66d9ef'
    local color0E='#ae81ff'
    local color0F='#cc6633'

    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"\
" --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
" --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
" --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"
}
_gen_fzf_default_opts
export FZF_CTRL_T_OPTS='--bind "ctrl-v:execute(vim $(printf %q {}) < /dev/tty > /dev/tty)" --height 100% --reverse --border --preview "bat --color=always --style=header,grid --line-range :100 {}"'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function peco-history-selection() {
    BUFFER=`history -r -f 1 | peco | awk '{c="";for(i=4;i<=NF;i++) c=c $i" "; print c}'`
    CURSOR=$#BUFFER
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

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
    }
zle -N _lazygit
bindkey '^g^g' _lazygit

# Spotify
stty stop undef
stty start undef
spotify-tui() {
BUFFER=spt
zle accept-line
zle reset-prompt
}
zle -N spotify-tui
bindkey '^s' spotify-tui

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

alias ag='ag --hidden'
function agg() {
    openvim='{system("vim " $1 " +" $2 " < /dev/tty > /dev/tty")}'
    result=`ag . 2> /dev/null | fzf --reverse --border --bind "ctrl-v:execute(printf %q {} | awk -F ':' '$openvim')"`
    if [ -z $result ]
    then
        return
    fi
    echo $result | awk -F ':' $openvim
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


PROMPT="%F{yellow}%~%f"$'\n'"%(?.%F{blue}.%F{red})❯%f "
autoload colors
colors
PROMPT="%{$fg[yellow]%}%~"$'\n'"%(?.%F{blue}.%F{red})❯%f "" %{$reset_color%}"


HISTSIZE=5000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000               #Number of history entries to save to disk
HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/matts966/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/matts966/Downloads/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/matts966/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/matts966/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
