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
  # Determinate Nix manages the Nix installation itself; let it.
  # nix-darwin must not touch /etc/nix/nix.conf or the daemon.
  nix.enable = false;

  nixpkgs.config.allowUnfreePredicate =
    pkg: builtins.elem (lib.getName pkg) unfreePackageNames;

  programs.zsh.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.yxhta = {
    name = "yxhta";
    home = "/Users/yxhta";
  };

  system.stateVersion = 6;
}
