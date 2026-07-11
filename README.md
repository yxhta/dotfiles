# dotfiles

Apple Silicon Mac 用 dotfiles。OS パッケージ、CLI、dotfile symlink、macOS
defaults、LaunchAgent、login shell を mise bootstrap で一元管理する。

## Fresh setup

```sh
mkdir -p ~/ghq/github.com/yxhta
git clone git@github.com:yxhta/dotfiles.git ~/ghq/github.com/yxhta/dotfiles
cd ~/ghq/github.com/yxhta/dotfiles

# vendored installerで ~/.local/bin/mise に恒久インストール
./bin/mise --version
./bin/mise trust
./bin/mise bootstrap --dry-run
./bin/mise bootstrap
hk install --mise
bin/doctor
```

`bin/mise` は `mise generate bootstrap -w ./bin/mise` の生成物を、インストール先が
`~/.local/bin/mise` になるよう調整している。`zsh/zshenv` が `~/.local/bin` を PATH
へ追加するので、初回適用後は shell を再起動して `mise` を直接使う。

`mise.toml` は bootstrap entrypoint と repo 開発ツールを管理する。同じリポジトリの
`mise/config.toml` は mise の標準探索で自動ロードされ、repo 外でも使う runtime と
CLI を管理し、bootstrap で `~/.config/mise/config.toml` へリンクされる。

dotfile の競合は自動バックアップされない。`--force-dotfiles` は既存対象を置換するため、
必ず `mise bootstrap dotfiles status` で対象を確認してから使う。設定からエントリを消しても
既存リンクは削除されない。

## Daily commands

```sh
mise bootstrap status
mise bootstrap dotfiles status --missing
mise bootstrap macos defaults status --missing
mise bootstrap --dry-run
mise bootstrap
mise install

treefmt
hk validate
hk check --all
hk install --mise
```

特定の hook step は `HK_SKIP_STEPS=gitleaks git commit ...`、pre-commit 全体は
`HK_SKIP_HOOK=pre-commit git commit ...` で一時的にスキップできる。

## Manual macOS steps

mise は Touch ID sudo を管理しない。`/etc/pam.d/sudo_local` に次を維持する。

```text
auth sufficient pam_tid.so
```

ホスト名は必要に応じて一度だけ手動設定する。

```sh
sudo scutil --set ComputerName <name>
sudo scutil --set HostName <name>
sudo scutil --set LocalHostName <name>
```

Nix 撤去前の既存 Mac では、まず nix-darwin をアンインストールし、その後 Determinate
Nix を削除する。実行前に Touch ID sudo と mise bootstrap の収束を確認すること。

```sh
sudo nix --extra-experimental-features "nix-command flakes" \
  run nix-darwin#darwin-uninstaller
sudo /nix/nix-installer uninstall
```

## Verification and rollback

パッケージ移行表は [docs/nix-to-mise-map.md](docs/nix-to-mise-map.md) を参照する。
Nix の profile path を除いた shell で全 `expected command(s)` を `command -v` する。
macOS defaults は additive で、設定を削除しても OS の値は戻らない。

Nix 削除後に旧構成へ戻す場合は、Determinate Nix を再インストールし、旧コミットへ戻して
`nix run nix-darwin#darwin-rebuild -- switch --flake ./nix#mac`（work は `#work`）を
実行する。
