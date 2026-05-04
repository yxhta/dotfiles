{
  pkgs,
  lib,
  ...
}:

let
  # Add a package if the current nixpkgs revision exposes it. Avoids hard
  # failures when an attribute is renamed or temporarily missing upstream.
  opt = name: lib.optional (pkgs ? ${name}) pkgs.${name};
in
{
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
      eza
      fd
      ffmpeg
      fzf
      gh
      ghq
      git
      git-filter-repo
      git-lfs
      gitleaks
      go-tools
      golangci-lint
      gotools
      grpcurl
      lazygit
      libwebp
      libyaml
      neovim
      ngrok
      nushell
      openssl
      prettierd
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
    ++ lib.concatMap opt [
      "git-flow-avh"
      "lazydocker"
      "terminal-notifier"
    ];
}
