{
  lib,
  dotfilesDir,
  ...
}:

let
  # Manifest: <repo-relative source> = <home-relative destination>.
  # Mirrors `embedded_manifest()` in bin/dotlink. Keep in sync until
  # bin/dotlink is removed.
  links = {
    # Zsh
    "zsh" = ".zsh";
    "zsh/zshrc" = ".zshrc";
    "zsh/zshenv" = ".zshenv";
    "zsh/sheldon/plugins.toml" = ".config/sheldon/plugins.toml";
    # Neovim
    "nvim" = ".config/nvim";
    # Tmux
    "tmux" = ".config/tmux";
    "tmux/tmux.conf" = ".tmux.conf";
    # Ghostty
    "ghostty" = ".config/ghostty";
    # Git
    "git/gitconfig" = ".gitconfig";
    "git/gitignore" = ".gitignore_global";
    "git/gitmessage" = ".gitmessage";
    "git/git_template" = ".git_template";
    # Mise
    "mise/config.toml" = ".config/mise/config.toml";
    # Lazygit
    "lazygit/config.yml" = ".config/lazygit/config.yml";
    # Starship
    "starship/starship.toml" = ".config/starship.toml";
  };

  linkLines = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (src: dest: "  link ${lib.escapeShellArg src} ${lib.escapeShellArg dest}") links
  );
in
{
  # Point each $HOME entry at the live repo (not a /nix/store snapshot)
  # so edits in the working tree are reflected without re-activation.
  # That's why this is a raw activation script and not `home.file`.
  home.activation.linkDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        DOTFILES=${lib.escapeShellArg dotfilesDir}

        link() {
          src="$DOTFILES/$1"
          dst="$HOME/$2"
          if [ ! -e "$src" ]; then
            echo "[dotlinks] source missing: $src" >&2
            return
          fi
          $DRY_RUN_CMD mkdir -p "$(dirname "$dst")"
          if [ -L "$dst" ]; then
            cur=$(readlink "$dst")
            if [ "$cur" = "$src" ]; then
              return
            fi
            $DRY_RUN_CMD rm "$dst"
          elif [ -e "$dst" ]; then
            echo "[dotlinks] conflict: $dst exists and is not a symlink; leaving in place" >&2
            return
          fi
          $DRY_RUN_CMD ln -s "$src" "$dst"
        }

    ${linkLines}
  '';
}
