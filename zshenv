# Add XDG_CONFIG_HOME
export XDG_CONFIG_HOME=~/.config

# Add GOPATH
export GOPATH=$HOME/go

path=(
  $HOME/.asdf/bin

  # Go
  $GOPATH/bin

  # Cargo
  $HOME/.cargo/bin

  # Flutter
  $HOME/.pub-cache/bin
  $HOME/development/flutter/bin

  # Homebrew
  /usr/local/bin
  /usr/local/opt/make/libexec/gnubin
  /usr/local/opt/llvm/bin

  # WezTerm
  /Applications/WezTerm.app/Contents/MacOS

  $HOME/bin
  $PATH
)
export PATH

export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
