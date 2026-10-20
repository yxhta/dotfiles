_cache_init() {
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  local name="$1" bin="$2"
  shift 2
  local cache="$cache_dir/init-$name.zsh"
  local pathfile="$cache.path"
  local real="${bin:A}"
  if [[ ! -s "$cache" || ! -f "$pathfile" || "$(< "$pathfile")" != "$real" ]]; then
    mkdir -p "$cache_dir"
    "$bin" "$@" > "$cache" || return 1
    print -r -- "$real" > "$pathfile"
    zcompile "$cache" 2>/dev/null
  fi
  source "$cache"
}

if command -v starship >/dev/null 2>&1; then
  _cache_init starship "$(command -v starship)" init zsh --print-full-init
fi

if [ -x "$HOME/.local/bin/mise" ]; then
  _cache_init mise "$HOME/.local/bin/mise" activate zsh
fi

export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"

if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/path.zsh.inc"
fi

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

if command -v uv >/dev/null 2>&1; then
  uv() {
    unfunction uv
    eval "$(command uv generate-shell-completion zsh)"
    command uv "$@"
  }
fi

if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  gcloud() {
    unfunction gcloud
    . "$HOME/google-cloud-sdk/completion.zsh.inc"
    command gcloud "$@"
  }
fi
export CLOUDSDK_PYTHON="${CLOUDSDK_PYTHON:-/usr/local/bin/python3}"

if command -v zoxide >/dev/null 2>&1; then
  _cache_init zoxide "$(command -v zoxide)" init zsh --cmd cd
  (( ${+aliases[zi]} )) && unalias zi
fi

if command -v git-wt >/dev/null 2>&1; then
  _cache_init git-wt "$(command -v git-wt)" --init zsh
fi
