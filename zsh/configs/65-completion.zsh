# ==========================================================================
# Completion
# ==========================================================================

# zsh-completions ships extra completion files under src/. sheldon clones
# the repo to ~/.local/share/sheldon/repos, but its init runs in
# 70-plugins.zsh — too late for compinit to pick up. Add the fpath here.
fpath=("$HOME/.local/share/sheldon/repos/github.com/zchee/zsh-completions/src" $fpath)

compdump_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$compdump_dir"
zcompdump="$compdump_dir/zcompdump"

autoload -Uz compinit
# Skip the security audit (compaudit) when zcompdump is fresh (<24h). The
# `(#qN.mh-24)` glob qualifier matches a regular file modified in the last
# 24 hours; if it matches, run the fast path with `-C`.
if [[ -n "$zcompdump"(#qN.mh-24) ]]; then
  compinit -C -d "$zcompdump"
else
  compinit -d "$zcompdump"
fi

# Byte-compile the dump so subsequent shells parse it from .zwc.
if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
  zcompile "$zcompdump"
fi
