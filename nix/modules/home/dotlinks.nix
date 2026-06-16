{
  config,
  dotfilesDir,
  ...
}:

let
  # Symlink an entry under $HOME directly into the live working tree.
  # mkOutOfStoreSymlink requires an absolute path *string* under flakes —
  # passing a path literal would copy into /nix/store and defeat live editing.
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${path}";
in
{
  # Zsh
  home.file.".zsh".source = link "zsh";
  home.file.".zshrc".source = link "zsh/zshrc";
  home.file.".zshenv".source = link "zsh/zshenv";
  xdg.configFile."sheldon/plugins.toml".source = link "zsh/sheldon/plugins.toml";

  # Neovim
  xdg.configFile."nvim".source = link "nvim";

  # Tmux
  xdg.configFile."tmux".source = link "tmux";
  home.file.".tmux.conf".source = link "tmux/tmux.conf";

  # Ghostty
  xdg.configFile."ghostty".source = link "ghostty";

  # Git
  home.file.".gitconfig".source = link "git/gitconfig";
  home.file.".gitignore_global".source = link "git/gitignore";
  home.file.".gitmessage".source = link "git/gitmessage";
  home.file.".git_template".source = link "git/git_template";

  # Mise
  xdg.configFile."mise/config.toml".source = link "mise/config.toml";

  # Lazygit
  xdg.configFile."lazygit/config.yml".source = link "lazygit/config.yml";

  # Starship
  xdg.configFile."starship.toml".source = link "starship/starship.toml";

  # User scripts (tat, ccd, cxd, doctor, …) — $HOME/bin is on PATH via zshenv
  home.file."bin".source = link "bin";
}
