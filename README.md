# dotfiles

Claude Code / Codex CLI のグローバル設定を共有管理するリポジトリ。

## 構成

- `AGENTS.md` — Claude Code・Codex共通のグローバル開発ガイドライン（SSOT）
- `.claude/CLAUDE.md` — Claude Code用のエントリーポイント。`@` インポートで `AGENTS.md` を参照する
- `.claude/settings.json` — Claude Codeの権限・MCP設定
- `.claude/skills/` — カスタムスキル（Claude Code・Codex共通。`~/.claude/skills/.system` 配下の
  システムスキルは対象外）
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
| `~/dotfiles/.claude/skills/<name>` | `~/.claude/skills/<name>`（スキルごとに個別リンク） |
| `~/dotfiles/.codex/rules/default.rules` | `~/.codex/rules/default.rules` |

これにより、Claude Code（`~/.claude/CLAUDE.md` → `@~/dotfiles/AGENTS.md`）と
Codex CLI（`~/.codex/AGENTS.md` → `~/dotfiles/AGENTS.md`）の両方が、
それぞれ直接 `~/dotfiles/AGENTS.md` を参照する。

スキルは `~/.codex/skills` が既に `~/.claude/skills/` へのシンボリックリンクになっているため、
`~/.claude/skills/<name>` を管理するだけで Claude Code・Codex CLI 両方から同じ内容を参照できる。
`~/.claude/skills/.system` はCodex CLIが自動インストールするシステムスキル置き場なので、
このリポジトリでは管理しない。

新しいカスタムスキルを追加する場合は `~/dotfiles/.claude/skills/<name>/` にファイルを置き、
`install.sh` を再実行すればよい。

## 注意

- APIキー・認証情報などの機密情報はこのリポジトリに含めない
- `~/.codex/config.toml` や `~/.claude/.credentials.json` など、認証情報を含みうるファイルは管理対象外
