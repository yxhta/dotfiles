{ ... }:
let
  identity = rec {
    # Single source of truth for the user identity. Change these and
    # nothing else to use this flake on a host with a different user.
    username = "yxhta";
    homeDirectory = "/Users/${username}";
    dotfilesDir = "${homeDirectory}/dotfiles";

    # Default host targeted by `flake.darwinConfigurations`.
    hostname = "mac";
    system = "aarch64-darwin";
  };
in
{
  # flake-parts has separate scopes for top-level (`flake.*`) and
  # `perSystem` modules — inject `identity` into both.
  _module.args.identity = identity;
  perSystem = _: { _module.args.identity = identity; };
}
