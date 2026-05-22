# External language-server binaries

The vim config calls out to coc.nvim, which delegates per-language work to the
binaries listed below. `install.sh` does the vim-side setup only. Run
`./install-deps.sh` (Ubuntu) to grab everything in one go, or install
piecemeal as needed.

## What gets installed where

| Language        | LSP binary                | Source                                                    | Notes                                                  |
|-----------------|---------------------------|-----------------------------------------------------------|--------------------------------------------------------|
| C/C++           | `clangd`                  | apt `clangd`                                              |                                                        |
| Go              | `gopls`                   | `go install golang.org/x/tools/gopls@latest`              |                                                        |
| SQL             | `sqls`                    | `go install github.com/sqls-server/sqls@latest`           |                                                        |
| Rust            | `rust-analyzer`           | `rustup component add rust-analyzer` (or coc-rust-analyzer auto-fetch) |                                       |
| TOML            | `taplo`                   | `cargo install --locked taplo-cli`                        |                                                        |
| Bash            | `bash-language-server`    | `npm i -g bash-language-server`                           | also needs `shellcheck` for diagnostics                |
| PHP             | `intelephense`            | `npm i -g intelephense`                                   |                                                        |
| Dockerfile      | `docker-langserver`       | `npm i -g dockerfile-language-server-nodejs`              |                                                        |
| JSON/HTML/CSS   | `vscode-*-language-server`| `npm i -g vscode-langservers-extracted`                   | fallback when coc-json/coc-html bundled servers miss   |
| Ruby            | `solargraph`              | `gem install --user-install solargraph`                   |                                                        |
| Terraform/HCL   | `terraform-ls`            | releases.hashicorp.com                                    |                                                        |
| Helm            | `helm_ls`                 | github.com/mrjosh/helm-ls releases                        |                                                        |
| Clojure         | `clojure-lsp`             | github.com/clojure-lsp/clojure-lsp releases (native zip)  |                                                        |
| Markdown        | `marksman`                | github.com/artempyanykh/marksman releases                 |                                                        |
| Lua             | `lua-language-server`     | github.com/LuaLS/lua-language-server releases             |                                                        |
| Kotlin          | `kotlin-language-server`  | github.com/fwcd/kotlin-language-server releases           |                                                        |
| C#              | `OmniSharp`               | github.com/OmniSharp/omnisharp-roslyn releases            | `coc-settings.json` points at `~/.local/opt/omnisharp/omnisharp-launcher.sh` |
| Perl            | `Perl::LanguageServer`    | apt `libperl-languageserver-perl`                         |                                                        |
| PowerShell      | `pwsh`                    | `snap install powershell --classic` (or MS apt repo)      | only needed if you actually edit `.ps1` files          |
| Java            | bundled with coc-java     | -                                                         |                                                        |
| TypeScript/JS   | bundled with coc-tsserver | -                                                         |                                                        |
| Python          | bundled with coc-pyright  | -                                                         |                                                        |

## Languages without a stub binary here

- **Nix** — `nil` doesn't ship prebuilt binaries (`cargo install` errors as
  it's a library crate). On nix-flavored boxes, install via
  `nix profile install github:oxalica/nil`. The `coc-settings.json`
  has no nix block right now.

## On a fresh Ubuntu box

```sh
git clone git@github.com:sashetov/dotvim ~/.vim
cd ~/.vim
./install.sh        # vim-side
./install-deps.sh   # LSP binaries (Ubuntu)
```
