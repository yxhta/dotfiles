{
  username,
  homeDirectory,
  ...
}:
{
  imports = [
    ./packages.nix
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
