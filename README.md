# dotfiles

Claude Code / Codex CLI のグローバル設定を共有管理するリポジトリ。

## 構成

- `AGENTS.md` — Claude Code・Codex共通のグローバル開発ガイドライン（SSOT）
- `.claude/CLAUDE.md` — Claude Code用のエントリーポイント。`@` インポートで `AGENTS.md` を参照する
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

これにより、Claude Code（`~/.claude/CLAUDE.md` → `@~/dotfiles/AGENTS.md`）と
Codex CLI（`~/.codex/AGENTS.md` → `~/dotfiles/AGENTS.md`）の両方が、
それぞれ直接 `~/dotfiles/AGENTS.md` を参照する。

## 注意

- APIキー・認証情報などの機密情報はこのリポジトリに含めない
- `~/.claude/settings.json` や `~/.codex/config.toml` など、認証情報を含みうるファイルは管理対象外
