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

echo "done."
