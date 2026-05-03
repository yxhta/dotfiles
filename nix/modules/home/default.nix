{ ... }:
{
  imports = [
    ./packages.nix
    ./dotlinks.nix
  ];

  # home.username / home.homeDirectory are auto-derived from
  # users.users.${username} when home-manager runs as a nix-darwin module.
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
