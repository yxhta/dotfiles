# Re-pin nix profile dirs to the front of $path after every other init has
# run (mise activate, gcloud path.zsh.inc, etc.). They get pushed back during
# zshenv → tool-init → hooks; this restores the invariant "nix-managed CLIs
# win over Homebrew leftovers" that the rest of the repo assumes.
typeset -U path
path=(
  /run/current-system/sw/bin
  /etc/profiles/per-user/$USER/bin
  $HOME/.nix-profile/bin
  /nix/var/nix/profiles/default/bin
  $path
)
export PATH
