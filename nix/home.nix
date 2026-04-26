{
  pkgs,
  lib,
  username,
  homeDirectory,
  ...
}:

let
  # Add a package if the current nixpkgs revision exposes it. Avoids hard
  # failures when an attribute is renamed or temporarily missing upstream.
  opt = name: lib.optional (pkgs ? ${name}) pkgs.${name};
in
{
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages =
    (with pkgs; [
      awscli2
      bottom
      btop
      buf
      cloudflared
      cmake
      cocoapods
      delta
      direnv
      duckdb
      eza
      fd
      ffmpeg
      fzf
      gh
      ghq
      git
      git-filter-repo
      git-lfs
      golangci-lint
      grpcurl
      lazygit
      libwebp
      libyaml
      neovim
      ngrok
      nushell
      openssl
      pueue
      readline
      ripgrep
      sheldon
      supabase-cli
      tmux
      tree
      tree-sitter
      utf8proc
      vault
      wget
      zellij
      zoxide
      zstd
    ])
    ++ opt "claude-squad"
    ++ opt "fvm"
    ++ opt "fzf-make"
    ++ opt "git-flow-avh"
    ++ opt "lazydocker"
    ++ opt "maestro"
    ++ opt "rbenv"
    ++ opt "ruby-build"
    ++ opt "shopify-cli"
    ++ opt "stripe-cli"
    ++ opt "terminal-notifier"
    ++ opt "turso";
}
