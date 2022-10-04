# Add XDG_CONFIG_HOME
export XDG_CONFIG_HOME=~/.config

# Add homebrew binaries
export PATH="/usr/local/bin:$PATH"

# Add GOPATH
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# For PHP
# export PATH=~/.composer/vendor/bin:$PATH

# Add my custom commands
export PATH="$HOME/bin:$PATH"

# Add Cargo PATH
export PATH="$HOME/.cargo/bin:$PATH"

# Add Flutter PATH
export PATH="$HOME/development/flutter/bin:$PATH"
export PATH="$PATH":"$HOME/.pub-cache/bin:$PATH"

# make
export PATH="$PATH":"$(brew --prefix)/opt/make/libexec/gnubin:$PATH"

# clang
export PATH="$PATH":"$(brew --prefix)/opt/llvm/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
