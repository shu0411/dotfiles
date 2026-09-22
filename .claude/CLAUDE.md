@~/dotfiles/AGENTS.md

## Issue駆動 + AIエージェント実装フロー

GitHub Issueを軸にした「人間が要求を書く → ローカルで設計 → `ready-for-claude` ラベルで実装 → PR」の
フロー。テンプレート・共通Actionの詳細は [shu0411/.github](https://github.com/shu0411/.github) を参照。
Claude Codeは文脈に応じて以下のいずれかとして動く。

### 1. ローカル: 設計フェーズ（`/design-issue <issue番号>`）

`design-issue` Skillを参照。

- GitHub Issueの簡単な要件を読み、既存コードを調査し、実装前設計を人間と対話しながら詰める
- 確定した設計を `gh issue edit` でIssue本文に反映する
- **実装・コミット・ブランチ作成・ラベル付与は行わない**。`ready-for-claude` を付けるかどうかは常に人間が判断する

### 2. GitHub Actions: 実装フェーズ（`ready-for-claude` ラベル起点）

各リポジトリの `.github/workflows/` から `shu0411/.github` の共通Action（`actions/implement-issue`）が
起動される。進め方・禁止事項・PR本文フォーマットは共通Actionのプロンプトが正で、個別リポジトリには書かない。

- 対象Issueの本文（設計済みの仕様書）とリポジトリの AGENTS.md / CLAUDE.md のルールに従って実装する
- 実装後、AGENTS.md に定義されたlint / test / typecheckコマンドを実行し、パスすることを確認する
