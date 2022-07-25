export LANG=ja_JP.UTF-8

# Overwrite keybinds
source ~/.keybinds.zsh
zinit ice multisrc"shell/*.zsh" id-as"junegunn/fzf_completions" pick"/dev/null"
zinit light junegunn/fzf
export FZF_CTRL_T_OPTS='--bind "ctrl-v:execute(vim $(printf %q {}) < /dev/tty > /dev/tty)" --preview "bat --color=always --style=header,grid --line-range :100 {}"'

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
AUTO_NOTIFY_IGNORE+=("spt" "docker run" "poetry shell" "lazygit" "nnn" "k9s", "kubectx")

# kind
zinit ice from"gh-r" as"program" mv"kind* -> kind"
zinit light kubernetes-sigs/kind
# j2p2j
zinit ice from"gh-r" as"program" mv"j2p2j* -> j2p2j"
zinit light tamuhey/j2p2j
zinit light jonmosco/kube-ps1

zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
  zsh-users/zsh-completions \
  light-mode Aloxaf/fzf-tab

KUBE_PS1_SYMBOL_ENABLE=false
KUBE_PS1_CTX_COLOR=yellow
PROMPT="%F{cyan}%~%f%F{yellow}@%m%f
"
PROMPT=$PROMPT'$(kube_ps1)
'
PROMPT=$PROMPT"%F{yellow}❯❯❯%f""%(?.%F{cyan}.%F{red})❯❯%f "

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
