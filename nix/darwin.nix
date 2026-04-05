{ pkgs, lib, ... }:

let
  unfreePackageNames = [
    "claude-squad"
    "ngrok"
    "shopify-cli"
    "stripe-cli"
    "turso"
    "vault"
  ];
in
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg: builtins.elem (lib.getName pkg) unfreePackageNames;

  programs.zsh.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  system.stateVersion = 6;
}
