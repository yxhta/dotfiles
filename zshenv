# Add XDG_CONFIG_HOME
export XDG_CONFIG_HOME=~/.config

# Add GOPATH
export GOPATH=$HOME/go

# Set PATH
typeset -U path
path=(
  $HOME/.asdf/bin
  $GOPATH/bin
  $HOME/.cargo/bin
  $HOME/.pub-cache/bin
  $HOME/development/flutter/bin
  /usr/local/bin
  /usr/local/opt/make/libexec/gnubin
  /usr/local/opt/llvm/bin
  /Applications/WezTerm.app/Contents/MacOS
  $HOME/bin
  $path
)
export PATH

# Load Cargo environment
. "$HOME/.cargo/env"
