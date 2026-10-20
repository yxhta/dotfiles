#!/bin/sh
set -eu

repo=$(cd "$(dirname "$0")/../../.." && pwd)
mise_bin="$HOME/.local/bin/mise"
[ -x "$mise_bin" ] || mise_bin=$(command -v mise)

usage() {
  echo "usage: $0 up|doctor|shell|down <run-id>" >&2
  echo "       $0 send <run-id> <tmux-keys>..." >&2
  echo "       $0 capture <run-id> <artifact-name>" >&2
  exit 2
}

[ $# -ge 2 ] || usage
cmd=$1
id=$2
shift 2

sandbox="${TMPDIR:-/tmp}"
sandbox="${sandbox%/}/verify-dotfiles/$id"
sbhome="$sandbox/home"
artifacts="$HOME/.local/state/verify-dotfiles/$id"
sock="verify-dotfiles-$id"

in_sandbox() {
  env HOME="$sbhome" MISE_TRUSTED_CONFIG_PATHS="$repo" "$@"
}

share_real_home_tool_dirs() {
  for dir in .local/bin .local/share/mise .local/share/sheldon/repos; do
    ln -s "$HOME/$dir" "$sbhome/$dir"
  done
}

case "$cmd" in
  up)
    if [ -e "$sandbox" ]; then
      echo "sandbox exists: $sandbox (run down first)" >&2
      exit 1
    fi
    mkdir -p "$sbhome/.local/share/sheldon" "$artifacts"
    share_real_home_tool_dirs
    cd "$repo"
    in_sandbox "$mise_bin" bootstrap dotfiles apply --yes
    echo "sandbox HOME: $sbhome"
    echo "artifacts:    $artifacts"
    ;;
  doctor)
    [ -d "$sbhome" ] || {
      echo "FAIL no sandbox at $sbhome" >&2
      exit 1
    }
    cd "$repo"
    status=$(in_sandbox "$mise_bin" bootstrap dotfiles status)
    if printf '%s\n' "$status" | grep -v ' applied$' | grep -q .; then
      printf '%s\n' "$status" | grep -v ' applied$' >&2
      echo "FAIL dotfiles not all applied" >&2
      exit 1
    fi
    echo "OK   dotfiles all applied"
    case "$(readlink "$sbhome/.zshrc")" in
      "$repo"/*) echo "OK   links point at $repo" ;;
      *)
        echo "FAIL .zshrc links outside this checkout: $(readlink "$sbhome/.zshrc")" >&2
        exit 1
        ;;
    esac
    if tmux -L "$sock" has-session -t main 2>/dev/null; then
      echo "OK   tmux shell up (socket $sock)"
    else
      echo "--   no tmux shell (run: $0 shell $id)"
    fi
    ;;
  shell)
    tmux -L "$sock" new-session -d -s main -x 200 -y 50 \
      env -i HOME="$sbhome" TERM=xterm-256color PATH=/usr/bin:/bin \
      USER="$USER" LANG=en_US.UTF-8 MISE_TRUSTED_CONFIG_PATHS="$repo" \
      zsh -l -i
    echo "tmux -L $sock attach -t main  # to watch"
    ;;
  send)
    [ $# -ge 1 ] || usage
    tmux -L "$sock" send-keys -t main "$@"
    ;;
  capture)
    [ $# -eq 1 ] || usage
    mkdir -p "$(dirname "$artifacts/$1")"
    tmux -L "$sock" capture-pane -p -S - -t main >"$artifacts/$1"
    echo "$artifacts/$1"
    ;;
  down)
    tmux -L "$sock" kill-server 2>/dev/null || true
    rm -rf "$sandbox"
    echo "removed $sandbox; kept $artifacts"
    ;;
  *) usage ;;
esac
