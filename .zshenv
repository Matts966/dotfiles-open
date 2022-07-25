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

. $HOME/.asdf/asdf.sh
fpath=($HOME/.asdf/completions $fpath)
source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"
# source <(asdf exec kubectl completion zsh)
. ~/.asdf/plugins/java/set-java-home.zsh

export BAT_THEME="iceberg"
export FZF_DEFAULT_OPTS='--height 100% --reverse --border --ansi'
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --bind ctrl-d:page-down,ctrl-u:page-up"
# Iceberg
if [[ $TERM_PROGRAM != "Apple_Terminal" ]]; then
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=spinner:#84a0c6,hl:#6b7089,fg:#c6c8d1,header:#6b7089,info:#b4be82,pointer:#84a0c6,marker:#84a0c6,fg+:#c6c8d1,prompt:#84a0c6,hl+:#84a0c6"
fi
export FZF_DEFAULT_COMMAND='fd --type=file --hidden --exclude ".git" --exclude "node_modules"'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

# zinit
source $HOME/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

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

# ghq
zinit ice as"program" from"gh-r" mv"ghq* -> ghq" pick"ghq/ghq"
zinit light x-motemen/ghq
# lazygit
# TODO: Use below instead of default golang package after 0.28.3 is released
# zinit ice as"program" from"gh-r" mv"lazygit* -> lazygit" pick"lazygit/lazygit"
# zinit light jesseduffield/lazygit

zinit light b4b4r07/zsh-gomi
alias rm='echo "This is not the command you are looking for, use gomi -s."; false'
