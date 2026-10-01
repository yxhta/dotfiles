# 001 mrの検索と詳細表示を整える

- Status: NEEDS_REVISION
- Commit: e21fbc7
- Severity: LOW
- Category: Cohesion & tokens、情報設計
- Estimated scope: `zsh/functions/mr`、`tests/mr.zsh`の2ファイル

ユーザーの希望により、mrのプレビューは削除した。
このプランには古いプレビューの提案が含まれるため、そのまま実行しない。
再開時は一覧だけのUIに合わせて内容を改訂する。

## Problem

`mr`はzshの関数で、引数なしの場合だけmiseのタスクをfzfで選択する。
タスク名と説明の視覚的な区別がなく、詳細領域が一覧より広い。
上部の操作ガイドも検索欄と競合している。
これはコードからの評価であり、改善後の見た目は端末で確認する必要がある。

`zsh/functions/mr:20`の現在の行データは次のとおり。

```zsh
rows=$(jq -r '.[] | [.name, (.description // "")] | @tsv' <<< "$tasks") || return
```

`zsh/functions/mr:26`の現在の表示設定は次のとおり。

```zsh
if selected=$(printf '%s\n' "$rows" | fzf \
  --no-multi --height=80% --reverse --border \
  --border-label=' mise tasks ' --prompt='Task> ' \
  --header='Enter: run  Esc: cancel  Ctrl-/: preview' \
  --delimiter=$'\t' \
  --preview='mise tasks info -- {1}' \
  --preview-window='right:55%:wrap,<80(down:50%:wrap)' \
  --bind='ctrl-/:toggle-preview'); then
```

## Target

| Before               | After                                         | Why                        |
| -------------------- | --------------------------------------------- | -------------------------- |
| 名前と説明が同じ強さ | 名前は太字、説明はdim、選択行全体を強調       | 実行対象を見分けやすくする |
| 詳細が幅の55%        | 詳細は40%、名前・説明・コマンド・定義元を表示 | 一覧に幅を確保する         |
| 上部に操作説明       | 検索欄は上、キーガイドは下                    | 情報を役割ごとに配置する   |

表示と実行名を分離する。TSVの第1列は元の名前、第2列は太字の名前、第3列はdimの説明。
fzfには第2列以降を表示し、選択結果は元の行を受け取る。
第1列の抽出と引用付き実行は既存の処理を維持する。

```zsh
rows=$(jq -r '.[] | [.name, ("\u001b[1m" + .name + "\u001b[0m"), ("\u001b[2m" + (.description // "") + "\u001b[0m")] | @tsv' <<< "$tasks") || return
```

表示設定を次の形に置き換える。
プレビューは定義を読むだけで、コマンドを実行しない。
`{1}`はfzfが引用するため、さらに引用符で囲まない。

```zsh
if selected=$(printf '%s\n' "$rows" | fzf \
  --ansi --no-multi --height=80% --reverse --border=rounded \
  --border-label=' mise tasks ' --prompt='Search tasks > ' \
  --info=inline-right --highlight-line \
  --footer='↑↓ move  Enter run  Esc cancel  Ctrl-/ details' \
  --delimiter=$'\t' --with-nth=2.. \
  --preview='mise tasks info --json -- {1} | jq -r '\''
    .name, "", (.description // ""), "", "COMMAND",
    (if ((.run // []) | length) > 0 then .run[] else (.file // "No command defined") end),
    "", "SOURCE", (.source // "Unknown")
  '\''' \
  --preview-window='right,40%,wrap,border-left,<100(down,45%,wrap,border-top)' \
  --bind='ctrl-/:toggle-preview'); then
```

端末のテーマを尊重する。固定RGB色、独自のカラーテーマ、アニメーションは追加しない。
コマンドパレットはキーボード操作に即時反応させる。

## Repo conventions to follow

- 自作zsh関数は`zsh/functions/`に置く。`zsh/zshrc:5`のローダーが読み込む。
- `zsh/configs/70-plugins.zsh:24`に共通のfzf設定がある。変更はmrのオプションだけに限定する。
- `tests/mr.zsh`は実際の`mr`を呼び、miseに渡る引数をNUL区切りで比較している。このチェックを維持する。
- mise、jq、fzfは導入済み。依存を追加しない。

## Steps

1. `zsh/functions/mr`のrows生成をTargetの3列TSVに置き換える。
2. 同ファイルのfzf表示設定をTargetに置き換える。引数付きの委譲、依存チェック、空一覧、選択名の抽出、終了コード処理は変更しない。
3. `tests/mr.zsh`の入力行比較を3列に更新する。期待値は次のリテラルにする。fzfのスタブは元の行を返すままにする。

   ```zsh
   [[ "$(cat "$test_dir/fzf-input")" == $'task with space\t\e[1mtask with space\e[0m\t\e[2mA tab\\tand\\nnewline\e[0m' ]]
   ```

4. 実際のfzfで表示用ANSIが実行名に混入しないことを検証する。スタブのテストだけで完了としない。

## Boundaries

- 編集対象は`zsh/functions/mr`と`tests/mr.zsh`だけ。
- `herdr/config.toml`など既存の変更、共通fzf設定、alias設定を変更しない。
- 選択後は`mise run "$task"`相当を維持する。現在のmiseでは`mise run -- "$task"`にすると別のタスク選択が開いたため、`--`を挿入しない。
- 複数選択、履歴、並列実行、実行確認ダイアログ、依存追加は対象外。
- プレビューに環境変数の一覧を追加しない。
- 対象のコードが抜粋と異なる場合は、変更内容を確認してから進める。

## Verification

機械的な確認を行う。

```sh
zsh -n zsh/functions/mr tests/mr.zsh
zsh tests/mr.zsh
git diff --check
hk validate
TREEFMT_NO_CACHE=1 hk check --all
```

テストは`mr checks passed`、各コマンドは終了コード0になること。
最後のチェックはformatterを起動するため、レビュー対象外の変更を事前・事後で確認する。

操作確認には一時ディレクトリのmise.tomlで次の無害なタスクを使用する。

```toml
[tasks.hello]
description = "Print a safe greeting"
run = "echo MR_UI_OK"

[tasks.verify-long-task-name]
description = "Check the description search"
run = "echo MR_SECOND_OK"
```

そのディレクトリをmiseでtrustし、`source /Users/yota.ito/ghq/github.com/yxhta/dotfiles/zsh/functions/mr`して`mr`を開く。

- 140列の端末で一覧が左、詳細が右に並ぶ。80列では詳細が下に切り替わる。
- 名前・説明の強弱と選択行を確認する。暗いテーマと明るいテーマの双方で説明が読めること。dimが読みにくい端末では説明のdimだけを外し、名前の太字を維持する。
- `greeting`で説明からhelloを検索できる。
- ↑↓で移動すると対応する名前・コマンドがプレビューに出る。カーソル移動やプレビューだけではタスクが実行されない。
- Ctrl-/で詳細を切り替え、検索文字列と選択対象が維持される。
- Enterで`MR_UI_OK`が一度だけ出力される。追加のmise選択画面が出ない。
- Escで戻り、タスクの出力がない。
- キーガイドが下部にあり、検索欄と長いタスク名が読みやすい。

Done whenは機械的な確認と上記の操作確認がすべて通ること。
アニメーションを追加しないため、スローモーションやブラウザのDevTools確認は対象外。
