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
  )
else
  path=(
	  $path
	  /usr/local/bin(N-/)
  )
fi

setopt magic_equal_subst

if [[ -n "${NVIM_LISTEN_ADDRESS}" && -x "$(command -v nvr)" ]]; then
  alias vim="nvr --remote-tab"
  alias vi="nvr --remote-tab"
  export EDITOR="nvr --remote-tab-wait +'setlocal bufhidden=wipe'"
  export GIT_EDITOR="nvr --remote-tab-wait +'setlocal bufhidden=wipe'"
  export KUBE_EDITOR="nvr --remote-tab-wait +'setlocal bufhidden=wipe'"
  export VISUAL="nvr -cc split --remote-wait +'setlocal bufhidden=wipe'"
else
  alias vim="nvim"
  alias vi="nvim"
  export EDITOR="nvim"
  export GIT_EDITOR="nvim"
  export KUBE_EDITOR="nvim"
  export VISUAL="nvim"
fi
