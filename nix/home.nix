{ pkgs, lib, username, homeDirectory, ... }:

let
  has = builtins.hasAttr;
  opt = name: value: lib.optionals (has name pkgs) [ value ];
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
      libwebp
      wget
      zellij
      zoxide
      zstd
    ])
    ++ opt "lazydocker" pkgs.lazydocker
    ++ opt "rbenv" pkgs.rbenv
    ++ opt "ruby-build" pkgs."ruby-build"
    ++ opt "shopify-cli" pkgs."shopify-cli"
    ++ opt "stripe-cli" pkgs."stripe-cli"
    ++ opt "terminal-notifier" pkgs."terminal-notifier"
    ++ opt "turso" pkgs.turso
    ++ opt "fvm" pkgs.fvm
    ++ opt "maestro" pkgs.maestro
    ++ opt "claude-squad" pkgs."claude-squad"
    ++ opt "fzf-make" pkgs."fzf-make"
    ++ opt "git-flow-avh" pkgs."git-flow-avh";
}
