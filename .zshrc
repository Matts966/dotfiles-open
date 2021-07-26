export LANG=ja_JP.UTF-8

# zinit
source $HOME/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Overwrite keybinds
source ~/.keybinds.zsh
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf
zinit ice multisrc"shell/*.zsh" id-as"junegunn/fzf_completions" pick"/dev/null"
zinit light junegunn/fzf
export FZF_CTRL_T_OPTS='--bind "ctrl-v:execute(vim $(printf %q {}) < /dev/tty > /dev/tty)" --preview "bat --color=always --style=header,grid --line-range :100 {}"'
export BAT_THEME="iceberg"
export FZF_DEFAULT_OPTS='--height 100% --reverse --border --ansi'
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --bind ctrl-d:page-down,ctrl-u:page-up"
# Iceberg
if [[ $TERM_PROGRAM != "Apple_Terminal" ]]; then
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=spinner:#84a0c6,hl:#6b7089,fg:#c6c8d1,header:#6b7089,info:#b4be82,pointer:#84a0c6,marker:#84a0c6,fg+:#c6c8d1,prompt:#84a0c6,hl+:#84a0c6"
fi
export FZF_DEFAULT_COMMAND='fd --type=file --hidden --exclude ".git" --exclude "node_modules"'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting

zinit light agkozak/zsh-z

zinit lucid has'docker' for \
  as'completion' is-snippet \
  'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker' \
  as'completion' is-snippet \
  'https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose'

zstyle ':fzf-tab:*' fzf-bindings 'tab:toggle+down'
zstyle ':fzf-tab:*' fzf-flags --height 100%

zinit light MichaelAquilina/zsh-auto-notify
export AUTO_NOTIFY_THRESHOLD=5
AUTO_NOTIFY_IGNORE+=("spt" "docker run" "poetry shell" "lazygit" "nnn" "k9s")

# rg
zinit ice as"program" from"gh-r" mv"ripgrep* -> rg" pick"rg/rg"
zinit light BurntSushi/ripgrep
# bat
zinit ice as"program" from"gh-r" mv"bat* -> bat" pick"bat/bat" atclone"./bat/bat cache --build" # for iceberg theme
zinit light sharkdp/bat
# fd
zinit ice as"program" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zinit light sharkdp/fd
# delta
zinit ice as"program" from"gh-r" mv"delta* -> delta" pick"delta/delta"
zinit light dandavison/delta
# spt
zinit ice as"program" from"gh-r"
zinit light Rigellute/spotify-tui
# tokei
zinit ice as"program" from"gh-r"
zinit light XAMPPRocky/tokei

# gh
zinit ice as"program" from"gh-r" mv"gh* -> gh" pick"gh/bin/gh"
zinit light cli/cli

# k9s
zinit ice from"gh-r" as"program"; zinit light derailed/k9s
# kind
zinit ice from"gh-r" as"program" mv"kind* -> kind"
zinit light kubernetes-sigs/kind
# j2p2j
zinit ice from"gh-r" as"program" mv"j2p2j* -> j2p2j"
zinit light tamuhey/j2p2j
# ghq
zinit ice as"program" from"gh-r" mv"ghq* -> ghq" pick"ghq/ghq"
zinit light x-motemen/ghq
# lazygit
# TODO: Use below instead of default golang package after 0.28.3 is released
# zinit ice as"program" from"gh-r" mv"lazygit* -> lazygit" pick"lazygit/lazygit"
# zinit light jesseduffield/lazygit

zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
  zsh-users/zsh-completions \
  light-mode Aloxaf/fzf-tab

zinit light b4b4r07/zsh-gomi
alias rm='echo "This is not the command you are looking for, use gomi -s."; false'

PROMPT="%F{cyan}%~%f%F{yellow}@%m%f
%F{yellow}❯❯❯%f""%(?.%F{cyan}.%F{red})❯❯%f "

HISTSIZE=50000              # How many lines of history to keep in memory
HISTFILE=~/.zsh_history     # Where to save history to disk
SAVEHIST=50000              # Number of history entries to save to disk
HISTDUP=erase               # Erase duplicates in the history file
setopt    appendhistory     # Append history to the history file (no overwriting)
setopt    incappendhistory  # Immediately append to the history file, not just when a term is killed
setopt    globdots          # Show hidden files in completion

if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
  echo ".zshrc updated, compiling..."
  zcompile ~/.zshrc
fi

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi

source <(kubectl completion zsh)

source $HOME/.asdf/asdf.sh
fpath=($HOME/.asdf/completions $fpath)
eval "$(direnv hook zsh)"
direnv() { asdf exec direnv "$@"; }
