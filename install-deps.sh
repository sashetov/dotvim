#!/usr/bin/env bash
# Install external language-server binaries used by the dotvim coc setup.
# Tested on Ubuntu 24.04. Requires sudo for the apt section; everything else
# lands in $HOME (~/.local/bin, ~/go/bin, ~/.cargo/bin, npm/gem user dirs).

set -euo pipefail

LOCAL_BIN="$HOME/.local/bin"
LOCAL_OPT="$HOME/.local/opt"
mkdir -p "$LOCAL_BIN" "$LOCAL_OPT"

have() { command -v "$1" >/dev/null 2>&1; }

# ----- apt: clangd, ripgrep, ruby, perl LSP, optional powershell -----
if have apt; then
  echo "=== apt packages ==="
  sudo apt update
  sudo apt install -y \
    clangd \
    ripgrep \
    ruby ruby-dev \
    libperl-languageserver-perl
  # PowerShell (optional). Comment out if you don't write .ps1 files.
  if ! have pwsh; then
    sudo snap install powershell --classic || \
      echo "snap install failed; skip pwsh or install manually from MS apt repo"
  fi
fi

# ----- go install: gopls, sqls -----
if have go; then
  echo "=== go installs ==="
  go install golang.org/x/tools/gopls@latest
  go install github.com/sqls-server/sqls@latest
  for b in gopls sqls; do
    src="$(go env GOPATH)/bin/$b"
    [[ -x "$src" ]] && ln -sf "$src" "$LOCAL_BIN/$b"
  done
fi

# ----- cargo install: taplo (rust-analyzer comes via rustup component) -----
if have cargo; then
  echo "=== cargo installs ==="
  cargo install --locked taplo-cli
  if ! have rust-analyzer; then
    rustup component add rust-analyzer || true
  fi
fi

# ----- npm globals: js/ts/php/docker/bash LSPs -----
if have npm; then
  echo "=== npm installs ==="
  npm install -g \
    bash-language-server \
    intelephense \
    dockerfile-language-server-nodejs \
    vscode-langservers-extracted
  npm_bin="$(npm prefix -g)/bin"
  for b in bash-language-server intelephense docker-langserver \
           vscode-json-language-server vscode-html-language-server \
           vscode-css-language-server vscode-eslint-language-server \
           vscode-markdown-language-server; do
    [[ -x "$npm_bin/$b" ]] && ln -sf "$npm_bin/$b" "$LOCAL_BIN/$b"
  done
fi

# ----- gem: solargraph -----
if have gem; then
  echo "=== gem installs ==="
  gem install --user-install solargraph
  sol="$(echo "$HOME"/.local/share/gem/ruby/*/bin/solargraph 2>/dev/null | head -1)"
  [[ -x "$sol" ]] && ln -sf "$sol" "$LOCAL_BIN/solargraph"
fi

# ----- direct downloads to ~/.local/bin -----
dl_release() {
  # dl_release <repo> <asset-pattern> <out-name> [strip-prefix]
  local repo="$1" pat="$2" out="$3" strip="${4:-}"
  local url
  url="$(curl -sL "https://api.github.com/repos/$repo/releases/latest" \
    | grep -oE "\"browser_download_url\": \"[^\"]+\"" \
    | grep -E "$pat" | head -1 | cut -d '"' -f 4)"
  if [[ -z "$url" ]]; then
    echo "skip   $repo (no asset matching $pat)"
    return
  fi
  echo "fetch  $repo -> $LOCAL_BIN/$out"
  case "$url" in
    *.zip)      curl -sL "$url" -o /tmp/_dl.zip && unzip -oq /tmp/_dl.zip -d /tmp/_dl_out
                find /tmp/_dl_out -type f -name "$out*" -executable -exec mv {} "$LOCAL_BIN/$out" \;
                rm -rf /tmp/_dl.zip /tmp/_dl_out ;;
    *.tar.gz|*.tgz)
                curl -sL "$url" -o /tmp/_dl.tar.gz && mkdir -p /tmp/_dl_out && tar -xzf /tmp/_dl.tar.gz -C /tmp/_dl_out
                find /tmp/_dl_out -type f -name "$out" -executable -exec mv {} "$LOCAL_BIN/$out" \;
                rm -rf /tmp/_dl.tar.gz /tmp/_dl_out ;;
    *)          curl -sL "$url" -o "$LOCAL_BIN/$out" && chmod +x "$LOCAL_BIN/$out" ;;
  esac
}

echo "=== github release downloads ==="

# terraform-ls (HashiCorp release archive, not GitHub releases)
TF_LS_VER="$(curl -s https://api.github.com/repos/hashicorp/terraform-ls/releases/latest \
  | grep -m1 tag_name | sed -E 's/.*"v([^"]+)".*/\1/')"
curl -sL "https://releases.hashicorp.com/terraform-ls/${TF_LS_VER}/terraform-ls_${TF_LS_VER}_linux_amd64.zip" \
  -o /tmp/tf-ls.zip
unzip -oq /tmp/tf-ls.zip terraform-ls -d "$LOCAL_BIN/"
chmod +x "$LOCAL_BIN/terraform-ls"
rm -f /tmp/tf-ls.zip

dl_release mrjosh/helm-ls 'helm_ls_linux_amd64$' helm_ls
dl_release artempyanykh/marksman 'marksman-linux-x64$' marksman

# clojure-lsp native zip
CL_VER="$(curl -s https://api.github.com/repos/clojure-lsp/clojure-lsp/releases/latest \
  | grep -m1 tag_name | tr -d '", ' | sed 's/tag_name://')"
curl -sL "https://github.com/clojure-lsp/clojure-lsp/releases/download/${CL_VER}/clojure-lsp-native-static-linux-amd64.zip" \
  -o /tmp/cljlsp.zip
unzip -oq /tmp/cljlsp.zip -d "$LOCAL_BIN/"
chmod +x "$LOCAL_BIN/clojure-lsp"
rm -f /tmp/cljlsp.zip

# lua-language-server (tar.gz with bin/)
LLS_VER="$(curl -s https://api.github.com/repos/LuaLS/lua-language-server/releases/latest \
  | grep -m1 tag_name | tr -d '", v' | sed 's/tag_name://')"
mkdir -p "$LOCAL_OPT/lua-language-server"
curl -sL "https://github.com/LuaLS/lua-language-server/releases/download/${LLS_VER}/lua-language-server-${LLS_VER}-linux-x64.tar.gz" \
  -o /tmp/lls.tar.gz
tar -xzf /tmp/lls.tar.gz -C "$LOCAL_OPT/lua-language-server"
ln -sf "$LOCAL_OPT/lua-language-server/bin/lua-language-server" "$LOCAL_BIN/lua-language-server"
rm -f /tmp/lls.tar.gz

# kotlin-language-server
KLS_VER="$(curl -s https://api.github.com/repos/fwcd/kotlin-language-server/releases/latest \
  | grep -m1 tag_name | tr -d '", ' | sed 's/tag_name://')"
curl -sL "https://github.com/fwcd/kotlin-language-server/releases/download/${KLS_VER}/server.zip" \
  -o /tmp/kls.zip
rm -rf "$LOCAL_OPT/kotlin-language-server"
unzip -oq /tmp/kls.zip -d "$LOCAL_OPT/"
mv "$LOCAL_OPT/server" "$LOCAL_OPT/kotlin-language-server"
ln -sf "$LOCAL_OPT/kotlin-language-server/bin/kotlin-language-server" "$LOCAL_BIN/kotlin-language-server"
rm -f /tmp/kls.zip

# shellcheck (static binary tarball)
SC_VER="v0.10.0"
curl -sL "https://github.com/koalaman/shellcheck/releases/download/${SC_VER}/shellcheck-${SC_VER}.linux.x86_64.tar.xz" \
  -o /tmp/sc.tar.xz
tar -xJf /tmp/sc.tar.xz -C /tmp
mv "/tmp/shellcheck-${SC_VER}/shellcheck" "$LOCAL_BIN/shellcheck"
chmod +x "$LOCAL_BIN/shellcheck"
rm -rf "/tmp/sc.tar.xz" "/tmp/shellcheck-${SC_VER}"

# omnisharp (C#)
OS_VER="$(curl -s https://api.github.com/repos/OmniSharp/omnisharp-roslyn/releases/latest \
  | grep -m1 tag_name | tr -d '", ' | sed 's/tag_name://')"
mkdir -p "$LOCAL_OPT/omnisharp"
curl -sL "https://github.com/OmniSharp/omnisharp-roslyn/releases/download/${OS_VER}/omnisharp-linux-x64-net6.0.tar.gz" \
  -o /tmp/os.tar.gz
tar -xzf /tmp/os.tar.gz -C "$LOCAL_OPT/omnisharp"
cat > "$LOCAL_OPT/omnisharp/omnisharp-launcher.sh" <<'LAUNCH'
#!/usr/bin/env bash
exec "$HOME/.local/opt/omnisharp/OmniSharp" "$@"
LAUNCH
chmod +x "$LOCAL_OPT/omnisharp/omnisharp-launcher.sh"
rm -f /tmp/os.tar.gz

echo
echo "done. verify with: command -v gopls rust-analyzer terraform-ls helm_ls"
echo "                    clojure-lsp sqls marksman lua-language-server"
echo "                    bash-language-server intelephense solargraph"
echo "                    kotlin-language-server taplo shellcheck"
