# bash like auto completion
bindkey '^i' expand-or-complete-prefix
setopt no_auto_remove_slash
# Not ignore directory delimiters
WORDCHARS=${WORDCHARS/\/}

# Ignore ctrl-d EOF and delete-char-or-list
setopt ignore_eof

# Emacs bindings
bindkey -e

# Git functions
bindkey -r '^g'

gcd() {
  repo=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*") && cd $(ghq root)/$repo
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

function _kubectx() {
  BUFFER="kubectx"
  zle accept-line
}
zle -N _kubectx
bindkey '^k^k' _kubectx
function _kubens() {
  BUFFER="kubens"
  zle accept-line
}
zle -N _kubens
bindkey '^k^n' _kubens

# Open vim for editing commands
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
