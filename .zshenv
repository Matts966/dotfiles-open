# zmodload zsh/zprof && zprof

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/matts966/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/matts966/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/matts966/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/matts966/google-cloud-sdk/completion.zsh.inc'; fi

export GOPATH=$HOME/go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
