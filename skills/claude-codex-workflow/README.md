# claude-codex-workflow

Claude Code を監督役にして、実装とレビューを Codex に委譲する品質ループのスキル。

- **Claude(監督)**: オーケストレーション・独立検証・最終レビュー。ファイル編集はしない
- **Codex(実装)**: `codex:codex-rescue` サブエージェント経由。唯一の書き込み役
- **Codex(レビュー)**: companion script のネイティブレビュー。編集禁止

## 前提条件

- Claude Code に `codex` プラグイン(openai-codex)がインストール済みであること
- Codex CLI が認証済みであること(未認証なら `/codex:setup` を実行)
- git リポジトリ内で使うこと

## 使い方

Claude Code のセッション内で、次のように依頼するとスキルが発動する:

```text
この機能を Codex に実装させて、レビューまで回して
```

```text
codex ループで <タスク内容> をやって
```

依頼時に指定できること(省略時は Claude が確認またはデフォルトを使用):

| 項目                              | デフォルト                                 |
| --------------------------------- | ------------------------------------------ |
| 受け入れ基準                      | 依頼内容から Claude が導出                 |
| 検証コマンド(テスト・ビルド等)    | リポジトリの慣習から推測                   |
| 最大修正サイクル数                | 3                                          |
| Codex のモデル / reasoning effort | Codex 側デフォルト(明示指定時のみ引き渡し) |

## 動作の流れ

1. Claude が目標・受け入れ基準・検証コマンドを確定し、git のベースラインを記録
2. Codex に実装を委譲(長時間タスクはバックグラウンド実行)。実行中は Claude が短い状況メモを報告
3. Claude が `git diff` とテスト実行で独立検証
4. Codex ネイティブレビューを実行。指摘があれば `--resume` で Codex に差し戻し、2〜4 をループ
5. 通常レビューがクリーンになったら `adversarial-review`(より厳しいレビュー)を最終ゲートとして実行。指摘があれば同様に差し戻してこのゲートを再実行
6. adversarial レビューも通ったら Claude が最終レビュー
7. `status` / `changed` / `verified` / `review` / `risks` の最終レポートを出力

## トラブルシューティング

- **プラグインが見つからない**: `~/.claude/plugins/cache/openai-codex/` が存在するか確認し、なければ codex プラグインをインストールする
- **Codex が未認証**: `/codex:setup` を実行する
- **レビュー役の Codex がファイルを編集した**: 汚染としてループが停止する。差分を確認して続行方法を指示する
- **最大サイクル到達後も指摘が残る**: 残った指摘は最終レポートの `risks` に載る。継続する場合は再度依頼する

## 補足

- `/codex:review` コマンド自体は `disable-model-invocation: true` のため Claude から呼べない。このスキルはプラグインの companion script(`codex-companion.mjs review`)を直接実行することでレビューを自動化している
- レビューのスコープは自動解決(working tree が dirty なら未コミット差分、クリーンならデフォルトブランチとのブランチ差分)。修正サイクル中は通常の `review`、クリーン後の最終ゲートに `adversarial-review` を使う。急ぎのときは依頼時に「クイックで」と伝えれば adversarial ゲートをスキップできる
- このスキルは codex プラグインと Agent tool に依存する Claude Code 専用。Codex 側から読み込む想定はないため `agents/openai.yaml` は置いていない
