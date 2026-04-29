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
      readline
      ripgrep
      sheldon
      tmux
      tree
      tree-sitter
      utf8proc
      wget
      zoxide
      zstd
    ])
    ++ opt "fzf-make"
    ++ opt "git-flow-avh"
    ++ opt "lazydocker"
    ++ opt "terminal-notifier";
}
