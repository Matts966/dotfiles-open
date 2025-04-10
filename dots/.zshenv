# zmodload zsh/zprof && zprof

export PATH=/opt/homebrew/opt/python@3.9/libexec/bin:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

typeset -U path PATH
if (( $+commands[sw_vers] )) && (( $+commands[arch] )); then
  path=(
	  $path
	  /opt/homebrew/bin(N-/)
	  /opt/homebrew/Cellar/jupyterlab/3.4.3/libexec/bin
  )
else
  path=(
	  $path
	  /usr/local/bin(N-/)
  )
fi

setopt magic_equal_subst

if [[ -n "${NVIM}" && -x "$(command -v nvr)" ]]; then
  export NVIM_LISTEN_ADDRESS=$NVIM
  alias vim="nvr --remote-tab"
  alias vi="nvr --remote-tab"
  export EDITOR="nvr --remote-tab-wait"
  export GIT_EDITOR="nvr --remote-tab-wait"
  export KUBE_EDITOR="nvr --remote-tab-wait"
  export VISUAL="nvr -cc split --remote-wait"
else
  alias vim="nvim"
  alias vi="nvim"
  export EDITOR="nvim"
  export GIT_EDITOR="nvim"
  export KUBE_EDITOR="nvim"
  export VISUAL="nvim"
fi

export BAT_THEME="iceberg"
export FZF_DEFAULT_OPTS='--height 100% --reverse --border --ansi'
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --bind ctrl-d:page-down,ctrl-u:page-up"
# Iceberg
if [[ $TERM_PROGRAM != "Apple_Terminal" ]]; then
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=spinner:#84a0c6,hl:#6b7089,fg:#c6c8d1,header:#6b7089,info:#b4be82,pointer:#84a0c6,marker:#84a0c6,fg+:#c6c8d1,prompt:#84a0c6,hl+:#84a0c6,border:#999999"
fi
export FZF_DEFAULT_COMMAND='fd --type=file --hidden --exclude ".git" --exclude "node_modules"'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export DOCKER_DEFAULT_PLATFORM=linux/amd64

source ~/.private_zshenv
export GPG_TTY=$(tty)
eval "$(~/.local/bin/mise activate zsh)"
autoload -U +X compinit && compinit
source <(~/.local/bin/mise completion zsh)
