export LANG=ja_JP.UTF-8

# zinit
source $HOME/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

zinit ice from"gh-r" as"program"
zinit load junegunn/fzf-bin
# Overwrite keybinds
zvm_after_init_commands+=('source ~/.keybinds.zsh')
zvm_after_init_commands+=('zinit ice multisrc"shell/*.zsh" && zinit light junegunn/fzf')
export FZF_CTRL_T_OPTS='--bind "ctrl-v:execute(vim $(printf %q {}) < /dev/tty > /dev/tty)" --preview "bat --color=always --style=header,grid --line-range :100 {}"'
export BAT_THEME="iceberg"
export FZF_DEFAULT_OPTS='--height 100% --reverse --border --ansi'
# Iceberg
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg+:#1e2132,bg:#161821,spinner:#84a0c6,hl:#6b7089,fg:#c6c8d1,header:#6b7089,info:#b4be82,pointer:#84a0c6,marker:#84a0c6,fg+:#c6c8d1,prompt:#84a0c6,hl+:#84a0c6"

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting

zinit ice from"gh-r" as"program" mv"docker* -> docker-compose" bpick"*linux*"
zinit load docker/compose

zinit wait lucid atload"zicompinit; zicdreplay" blockf for zsh-users/zsh-completions

PROMPT="%F{cyan}%~%f%F{yellow}@%m%f
%F{yellow}❯❯❯%f""%(?.%F{cyan}.%F{red})❯❯%f "



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

_floaterm() {
    if [[ $VIM ]]; then
        floaterm $@
    else
        nvim $@
    fi
}
alias vim='_floaterm'
