# zmodload zsh/zprof && zprof

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

export PATH="/usr/local/opt/llvm/bin:$PATH"
if [ command -v xcrun &> /dev/null ]; then export LDFLAGS="-L$(xcrun --show-sdk-path)/usr/lib"; fi
# export LDFLAGS="-L/usr/local/opt/llvm/lib"
# export CPPFLAGS="-I/usr/local/opt/llvm/include"

export IDF_PATH=$HOME/esp/esp-idf
export PATH=$PATH:$HOME/esp/xtensa-esp32-elf/bin

typeset -U path PATH
path=(
	$path
	/opt/homebrew/bin(N-/)
	/usr/local/bin(N-/)
)
if (( $+commands[sw_vers] )) && (( $+commands[arch] )); then
	[[ -x /usr/local/bin/brew ]] && alias brew="arch -arch x86_64 /usr/local/bin/brew"
	alias x64='exec arch -x86_64 /bin/zsh'
	alias a64='exec arch -arm64e /bin/zsh'
	switch-arch() {
	if  [[ "$(uname -m)" == arm64 ]]; then
		arch=x86_64
	elif [[ "$(uname -m)" == x86_64 ]]; then
		arch=arm64e
	fi
	exec arch -arch $arch /bin/zsh
}
fi

setopt magic_equal_subst

if [[ -n "${NVIM_LISTEN_ADDRESS}" && -x "$(command -v nvr)" ]]; then
  alias vim="nvr --remote-tab"
  alias vi="nvr --remote-tab"
  export EDITOR="nvr --remote-tab"
  export GIT_EDITOR="nvr --remote-tab-wait"
  export VISUAL="nvr -cc split --remote-wait +'setlocal bufhidden=wipe'"
else
  alias vim="nvim"
  alias vi="nvim"
  export EDITOR="nvim"
  export GIT_EDITOR="nvim"
  export VISUAL="nvim"
fi
