if [ "$TERM_PROGRAM" = "vscode" ]
then
  tmux new-session -A -s $(PWD)
fi

export LANG=ja_JP.UTF-8

# zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit ice from"gh-r" as"program"
zinit light junegunn/fzf

# gh
zinit ice as"program" from"gh-r" mv"gh* -> gh" pick"gh/bin/gh"
zinit light cli/cli

zinit load b4b4r07/zsh-gomi
alias rm='echo "This is not the command you are looking for, use gomi -s."; false'

# Overwrite keybinds
source ~/.keybinds.zsh
zinit ice multisrc"shell/*.zsh" id-as"junegunn/fzf_completions" pick"/dev/null"
zinit light junegunn/fzf
export FZF_CTRL_T_OPTS='--bind "ctrl-v:execute(vim $(printf %q {}) < /dev/tty > /dev/tty)" --preview "bat --color=always --style=header,grid --line-range :100 {}"'

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting

zinit lucid has'docker' for \
  as'completion' is-snippet \
  'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker' \
  as'completion' is-snippet \
  'https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose'

zstyle ':fzf-tab:*' fzf-bindings 'tab:toggle+down'
zstyle ':fzf-tab:*' fzf-flags --height 100%

zinit light MichaelAquilina/zsh-auto-notify
export AUTO_NOTIFY_THRESHOLD=5
AUTO_NOTIFY_IGNORE+=("spt" "docker run" "poetry shell" "lazygit" "nnn" "k9s" "kubectx" "google")

# kind
zinit ice from"gh-r" as"program" mv"kind* -> kind"
zinit light kubernetes-sigs/kind
# j2p2j
zinit ice from"gh-r" as"program" mv"j2p2j* -> j2p2j"
zinit light tamuhey/j2p2j

zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
  zsh-users/zsh-completions \
  light-mode Aloxaf/fzf-tab

PROMPT="%F{cyan}%~%f%F{yellow}@%m%f
"
zinit light jonmosco/kube-ps1
KUBE_PS1_SYMBOL_ENABLE=false
KUBE_PS1_CTX_COLOR=yellow
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
source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
