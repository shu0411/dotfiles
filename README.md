# dotfiles

Claude Code / Codex CLI のグローバル設定を共有管理するリポジトリ。

## 構成

- `AGENTS.md` — Claude Code・Codex共通のグローバル開発ガイドライン（SSOT）
- `.claude/CLAUDE.md` — Claude Code用のエントリーポイント。`@` インポートで `AGENTS.md` を参照するほか、
  Issue駆動 + AIエージェント実装フローにおけるClaude Codeの動作モードを定義する
- `.claude/settings.json` — Claude Codeの権限・MCP設定
- `skills/` — カスタムスキル（Claude Code・Codex共通。各ツールが自動インストールする
  `.system` 配下のシステムスキルは対象外）
- `.codex/rules/default.rules` — Codex CLIの権限ルール
- `install.sh` — 各種シンボリックリンクを作成するセットアップスクリプト

## セットアップ（新しい環境で復元する場合）

```sh
git clone https://github.com/shu0411/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` は以下のシンボリックリンクを冪等に作成する（対象パスに既存ファイルがある場合は
`<path>.backup.<timestamp>` にリネームしてから上書きする）。

| リンク元（実体） | リンク先 |
| --- | --- |
| `~/dotfiles/.claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `~/dotfiles/AGENTS.md` | `~/.codex/AGENTS.md` |
| `~/dotfiles/.claude/settings.json` | `~/.claude/settings.json` |
| `~/dotfiles/skills/<name>` | `~/.claude/skills/<name>`（スキルごとに個別リンク） |
| `~/dotfiles/skills/<name>` | `~/.codex/skills/<name>`（スキルごとに個別リンク） |
| `~/dotfiles/.codex/rules/default.rules` | `~/.codex/rules/default.rules` |

これにより、Claude Code（`~/.claude/CLAUDE.md` → `@~/dotfiles/AGENTS.md`）と
Codex CLI（`~/.codex/AGENTS.md` → `~/dotfiles/AGENTS.md`）の両方が、
それぞれ直接 `~/dotfiles/AGENTS.md` を参照する。

スキルも同様に、`~/.claude/skills/<name>` と `~/.codex/skills/<name>` の両方から
それぞれ直接 `~/dotfiles/skills/<name>` を参照する。`.system`（各ツールが
自動インストールするシステムスキル置き場）はこのリポジトリでは管理せず、
`.gitignore` でも除外している。

新しいカスタムスキルを追加する場合は `~/dotfiles/skills/<name>/` にファイルを置き、
`install.sh` を再実行すればよい。

## TWG CLI の導入

Jira・Confluence などを Claude Code / Codex から利用するための Atlassian 公式 CLI。
macOS / Linux では、以下の公式コマンドで導入し、画面の案内に従って認証する。
セットアップ時にエージェント用スキルもインストールされるため、スキル本体は dotfiles では管理しない。

```bash
curl -fsSL https://teamwork-graph.atlassian.com/cli/install -o twg-install.sh
bash twg-install.sh
```

詳細は [公式セットアップ手順](https://support.atlassian.com/organization-administration/docs/get-started-with-twg-cli/) を参照。

## 注意

- APIキー・認証情報などの機密情報はこのリポジトリに含めない
- `~/.codex/config.toml` や `~/.claude/.credentials.json` など、認証情報を含みうるファイルは管理対象外
