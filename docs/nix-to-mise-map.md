# Nix to mise migration map

`expected command(s)` は Nix を PATH から除外した状態で `command -v` により確認する。

| Nix attribute        | mise/brew package                       | expected command(s) | verification                              |
| -------------------- | --------------------------------------- | ------------------- | ----------------------------------------- |
| awscli2              | mise `aws-cli`                          | `aws`               | `command -v aws`                          |
| bottom               | mise `bottom`                           | `btm`               | `command -v btm`                          |
| btop                 | `brew:btop`                             | `btop`              | `command -v btop`                         |
| buf                  | mise `buf`                              | `buf`               | `command -v buf`                          |
| cloudflared          | `brew:cloudflared`                      | `cloudflared`       | `command -v cloudflared`                  |
| cmake                | mise `cmake`                            | `cmake`             | `command -v cmake`                        |
| cocoapods            | `brew:cocoapods`                        | `pod`               | `command -v pod`                          |
| delta                | mise `delta`                            | `delta`             | `command -v delta`                        |
| eza                  | `brew:eza`                              | `eza`               | `command -v eza`                          |
| fd                   | mise `fd`                               | `fd`                | `command -v fd`                           |
| ffmpeg               | mise `ffmpeg`                           | `ffmpeg`, `ffprobe` | `command -v ffmpeg && command -v ffprobe` |
| fzf                  | mise `fzf`                              | `fzf`               | `command -v fzf`                          |
| gh                   | mise `gh`                               | `gh`                | `command -v gh`                           |
| ghq                  | mise `ghq`                              | `ghq`               | `command -v ghq`                          |
| git                  | `brew:git`                              | `git`               | `command -v git`                          |
| git-filter-repo      | mise `pipx:git-filter-repo`             | `git-filter-repo`   | `command -v git-filter-repo`              |
| git-flow-avh         | `brew:git-flow`                         | `git-flow`          | `command -v git-flow`                     |
| git-lfs              | mise `git-lfs`                          | `git-lfs`           | `command -v git-lfs`                      |
| git-wt               | mise `git-wt`                           | `git-wt`            | `command -v git-wt`                       |
| gitleaks             | mise `gitleaks`                         | `gitleaks`          | `command -v gitleaks`                     |
| go-tools: goimports  | `go:golang.org/x/tools/cmd/goimports`   | `goimports`         | `command -v goimports`                    |
| gotools: stringer    | `go:golang.org/x/tools/cmd/stringer`    | `stringer`          | `command -v stringer`                     |
| gotools: guru        | `go:golang.org/x/tools/cmd/guru`        | `guru`              | `command -v guru`                         |
| gotools: staticcheck | `go:honnef.co/go/tools/cmd/staticcheck` | `staticcheck`       | `command -v staticcheck`                  |
| golangci-lint        | mise `golangci-lint`                    | `golangci-lint`     | `command -v golangci-lint`                |
| grpcurl              | mise `grpcurl`                          | `grpcurl`           | `command -v grpcurl`                      |
| jq                   | mise `jq`                               | `jq`                | `command -v jq`                           |
| lazydocker           | mise `lazydocker`                       | `lazydocker`        | `command -v lazydocker`                   |
| lazygit              | mise `lazygit`                          | `lazygit`           | `command -v lazygit`                      |
| libwebp              | `brew:webp`                             | `cwebp`, `dwebp`    | `command -v cwebp && command -v dwebp`    |
| neovim               | mise `neovim`                           | `nvim`              | `command -v nvim`                         |
| ngrok                | 手動 `brew install --cask ngrok`        | `ngrok`             | `command -v ngrok`                        |
| nushell              | mise `nushell`                          | `nu`                | `command -v nu`                           |
| postgresql           | `brew:postgresql@18`                    | `psql`, `postgres`  | `command -v psql && command -v postgres`  |
| prettierd            | mise `npm:@fsouza/prettierd`            | `prettierd`         | `command -v prettierd`                    |
| ripgrep              | mise `ripgrep`                          | `rg`                | `command -v rg`                           |
| sheldon              | mise `sheldon`                          | `sheldon`           | `command -v sheldon`                      |
| sqlite               | mise `sqlite`                           | `sqlite3`           | `command -v sqlite3`                      |
| terminal-notifier    | `brew:terminal-notifier`                | `terminal-notifier` | `command -v terminal-notifier`            |
| tmux                 | mise `tmux`                             | `tmux`              | `command -v tmux`                         |
| tree                 | `brew:tree`                             | `tree`              | `command -v tree`                         |
| tree-sitter          | mise `tree-sitter`                      | `tree-sitter`       | `command -v tree-sitter`                  |
| wget                 | `brew:wget`                             | `wget`              | `command -v wget`                         |
| zoxide               | mise `zoxide`                           | `zoxide`            | `command -v zoxide`                       |
| zstd                 | `brew:zstd`                             | `zstd`              | `command -v zstd`                         |

言語ランタイム (`go`, `node`, `python`, `ruby`, `bun`) と npm CLI は従来どおり
`mise/config.toml` で管理する。リポジトリ専用の `hk`, `treefmt`, `shfmt`,
`stylua`, `taplo`, `prettier` は root `mise.toml` に置く。
