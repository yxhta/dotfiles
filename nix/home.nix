{ pkgs, lib, ... }:

let
  has = builtins.hasAttr;
  opt = name: value: lib.optionals (has name pkgs) [ value ];
in
{
  home.username = "a24-033";
  home.homeDirectory = "/Users/REDACTED";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages =
    (with pkgs; [
      awscli2
      btop
      buf
      cloudflared
      cmake
      cocoapods
      direnv
      duckdb
      eza
      fd
      fzf
      gh
      ghq
      git
      golangci-lint
      grpcurl
      lazygit
      libyaml
      neovim
      nushell
      openssl
      pueue
      readline
      ripgrep
      tmux
      tree
      utf8proc
      vault
      webp
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
