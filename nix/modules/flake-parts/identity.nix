{ ... }:
let
  mkDarwinProfile =
    {
      hostname,
      username,
      dotfilesDir ? "/Users/${username}/dotfiles",
      system ? "aarch64-darwin",
    }:
    rec {
      inherit
        hostname
        username
        dotfilesDir
        system
        ;
      homeDirectory = "/Users/${username}";
    };

  # Single source of truth for per-environment user identity.
  darwinProfiles = {
    mac = mkDarwinProfile {
      hostname = "mac";
      username = "yxhta";
      dotfilesDir = "/Users/yxhta/ghq/github.com/yxhta/dotfiles";
    };

    work = mkDarwinProfile {
      hostname = "work";
      username = "yota.ito";
    };
  };

  # Default profile for legacy/default apps such as `nix run .#switch`.
  identity = darwinProfiles.mac;
in
{
  # flake-parts has separate scopes for top-level (`flake.*`) and
  # `perSystem` modules — inject `identity` into both.
  _module.args = {
    inherit darwinProfiles identity;
  };
  perSystem = _: {
    _module.args = {
      inherit darwinProfiles identity;
    };
  };
}
