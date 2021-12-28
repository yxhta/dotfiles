# Add XDG_CONFIG_HOME
export XDG_CONFIG_HOME=~/.config

# Add homebrew binaries
export PATH="/usr/local/bin:$PATH"

# Add GOPATH
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH="$PATH:/usr/local/go/bin"

# For PHP
# export PATH=~/.composer/vendor/bin:$PATH

# Add my custom commands
export PATH="$HOME/bin:$PATH"

# Add Cargo PATH
export PATH="$HOME/.cargo/bin:$PATH"

# Add Flutter PATH
export PATH="`pwd`/flutter/bin:$PATH"
