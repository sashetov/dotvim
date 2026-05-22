#!/usr/bin/env bash
# Bootstrap this dotvim setup on a fresh machine.
# - Symlinks ~/.vimrc -> ~/.vim/.vimrc
# - Symlinks ~/.vim/coc-settings.json -> repo coc-settings.json (already in repo)
# - Installs vim-plug into ~/.vim/autoload/plug.vim
# - Runs :PlugInstall headlessly
# - Seeds ~/.config/coc/extensions/package.json and runs npm install there
#
# It does NOT install language-server binaries; see install-deps.sh for that.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ "$REPO" != "$HOME/.vim" ]] && {
  echo "expected this script under \$HOME/.vim, got: $REPO" >&2
  exit 1
}

STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/.vim/backup/$STAMP"

echo "dotvim install"
echo "repo:    $REPO"
echo "backup:  $BACKUP"
echo

mkdir -p "$BACKUP" "$HOME/.vim/swapfiles" "$HOME/.vim/autoload"

link_to_self() {
  local target_rel="$1" dst="$2"
  local src="$REPO/$target_rel"
  if [[ -L "$dst" ]]; then
    if [[ "$(readlink -f "$dst")" == "$src" ]]; then
      echo "ok       $dst"
      return
    fi
    echo "relink   $dst (was -> $(readlink "$dst"))"
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    echo "backup   $dst -> $BACKUP/"
    mv "$dst" "$BACKUP/$(basename "$dst")"
  else
    echo "create   $dst -> $src"
  fi
  ln -s "$src" "$dst"
}

# ~/.vimrc points at ~/.vim/.vimrc (so vim sources the repo vimrc).
link_to_self ".vimrc" "$HOME/.vimrc"

# vim-plug bootstrap
if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
  echo "fetch    vim-plug"
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Install plugins headlessly.
echo "running  :PlugInstall (this may take a minute on first run)"
vim -Nes -u "$HOME/.vimrc" -c 'PlugInstall --sync' -c 'qa!' || true

# Seed coc extension list directly so we don't depend on headless :CocInstall
# (which is unreliable in -es mode). The vimrc's g:coc_global_extensions will
# also pull anything new on first interactive launch.
mkdir -p "$HOME/.config/coc/extensions"
cd "$HOME/.config/coc/extensions"
if [[ ! -f package.json ]]; then
  echo '{"dependencies":{}}' > package.json
fi

python3 - <<'PY'
import json, pathlib
p = pathlib.Path("package.json")
pkg = json.loads(p.read_text())
pkg.setdefault("dependencies", {})
wanted = [
    "coc-marketplace", "coc-snippets", "coc-pairs",
    "coc-json", "coc-yaml", "coc-xml", "coc-toml",
    "coc-html", "coc-css",
    "coc-tsserver", "coc-eslint", "coc-prettier",
    "coc-pyright", "coc-go", "coc-rust-analyzer", "coc-clangd",
    "coc-sh", "coc-vimlsp", "coc-java", "coc-kotlin",
    "coc-docker", "coc-sumneko-lua", "coc-markdownlint",
    "coc-webpack", "coc-perl", "coc-powershell",
]
for w in wanted:
    pkg["dependencies"].setdefault(w, "*")
p.write_text(json.dumps(pkg, indent=2))
print("coc extensions seeded:", len(wanted))
PY

echo "running  npm install in ~/.config/coc/extensions"
npm install --no-audit --no-fund

echo
echo "done. external language-server binaries are NOT installed by this script;"
echo "see EXTERNAL-DEPS.md or run ./install-deps.sh (Ubuntu) for those."
