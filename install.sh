#!/usr/bin/env bash
# Claude Code / Codex CLI のグローバル設定をこのリポジトリからシンボリックリンクする。
# 既存ファイルがある場合は "<path>.backup.<timestamp>" にリネームしてから上書きする。
# 何度実行しても安全（冪等）。
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1"
  local dst="$2"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "skip (already linked): $dst"
    return
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    local backup="${dst}.backup.$(date +%Y%m%d%H%M%S)"
    echo "backup: $dst -> $backup"
    mv "$dst" "$backup"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "linked: $dst -> $src"
}

# Claude Code は ~/.claude/CLAUDE.md から AGENTS.md を @ インポートする
link "$DOTFILES_DIR/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# Codex CLI は ~/.codex/AGENTS.md (SSOT) を直接見に行く
mkdir -p "$HOME/.codex"
link "$DOTFILES_DIR/AGENTS.md" "$HOME/.codex/AGENTS.md"

# Claude Code の権限・MCP設定
link "$DOTFILES_DIR/.claude/settings.json" "$HOME/.claude/settings.json"

# カスタムスキル（Claude Code・Codex共通。スキルごとに両方へリンクする。
# ~/.claude/skills/.system, ~/.codex/skills/.system は各ツールが自動インストール
# するシステムスキル置き場なので触らない）
mkdir -p "$HOME/.claude/skills"

# Codexのシステムスキルが ~/.claude 配下に混在しないよう、
# ~/.codex/skills も ~/.claude/skills と同様に実体ディレクトリ+スキルごとの個別リンクにする
if [ -L "$HOME/.codex/skills" ]; then
  backup="$HOME/.codex/skills.backup.$(date +%Y%m%d%H%M%S)"
  echo "backup: $HOME/.codex/skills -> $backup"
  mv "$HOME/.codex/skills" "$backup"
fi
mkdir -p "$HOME/.codex/skills"

for skill_dir in "$DOTFILES_DIR"/skills/*/; do
  skill_name="$(basename "$skill_dir")"
  link "${skill_dir%/}" "$HOME/.claude/skills/$skill_name"
  link "${skill_dir%/}" "$HOME/.codex/skills/$skill_name"
done

# Codex CLI の権限ルール
link "$DOTFILES_DIR/.codex/rules/default.rules" "$HOME/.codex/rules/default.rules"

echo "done."
