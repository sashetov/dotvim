# vim code/diff browsing cheatsheet

Leader is `<space>`.

## Diff browsing (vim-fugitive + vim-gitgutter)

| Keys | What |
|---|---|
| `<space>gs` | `:Git` — status pane. In status: `s` stage hunk, `u` unstage, `=` toggle inline diff, `dv` open vertical diff, `cc` commit, `cC` amend |
| `<space>gd` | `:Gdiffsplit` — split view: working tree vs index. `]c`/`[c` jump hunks. `dp`/`do` push/pull hunks across the split |
| `<space>gD` | `:Gdiffsplit!` — same but prompts you to pick a different revision/branch to diff against |
| `<space>gb` | `:Git blame` — inline annotation. On a blame line: `o` open commit in split, `~` blame *before* this commit, `q` close |
| `<space>gl` | `:0Gclog` — git log of the current file. `<CR>` opens that commit's version of the file in the quickfix |
| `<space>go` | `:GBrowse` — open the current file/line on GitHub (works on a visual range too) |
| `]c` / `[c` | gitgutter: next / previous changed hunk in working tree |
| `:GitGutterPreviewHunk` | popup the diff for the hunk under cursor |
| `:GitGutterStageHunk` | git add just this hunk |
| `:GitGutterUndoHunk` | revert this hunk to index |

### Comparing a PR locally

```vim
:Git fetch origin pull/7256/head:pr-7256
:Git checkout pr-7256
:Gvdiff origin/master            " side-by-side diff vs master
```

### Resolving a merge conflict

In a conflicted file: `<space>gd` (or `:Gvdiff!`) opens three buffers — local / merged / remote. Use `:diffget //2` for "ours", `:diffget //3` for "theirs". `:Gwrite` to mark resolved.

## Fuzzy finding (fzf.vim)

| Keys | What |
|---|---|
| `<space>f` | `:Files` — files in project (ignores .git etc.) |
| `<space>g` | `:GFiles` — files tracked by git (faster on huge repos) |
| `<space>b` | `:Buffers` — open buffers |
| `<space>r` | `:Rg` — ripgrep across project; type, narrow, `<CR>` to jump |
| `<space>*` | ripgrep the word under cursor |
| `<space>l` | `:BLines` — fuzzy-jump lines in current buffer |
| `<space>L` | `:Lines` — fuzzy-jump across all open buffers |
| `<space>h` | `:History` — recently opened files |
| `<space>c` | `:Commits` — commits in this repo; `<CR>` shows the diff |
| inside fzf | `<C-t>` open in tab, `<C-x>` horizontal split, `<C-v>` vertical split, `<C-/>` toggle preview |

## Code navigation (coc.nvim, already wired in your config)

| Keys | What |
|---|---|
| `gd` | jump to definition |
| `gD` | jump to declaration |
| `gt` | jump to type definition |
| `gi` | jump to implementation |
| `gr` | jump to references (list) |
| `K` | hover docs |
| `[d` / `]d` | next / prev diagnostic |
| `<space>ca` | code actions (quick-fixes, refactors) |
| `<space>q` | diagnostics for current line |
| `<C-s>` (insert mode) | signature help |
| `:CocList symbols` | symbol search (fuzzy) — alternative to LSP-aware fzf |
| `:CocList outline` | symbols of current file |
| `:CocInstall coc-tsserver` | install a language server (you also have `g:coc_global_extensions` set so first start installs them all) |

## Built-in moves that pair well

| Keys | What |
|---|---|
| `<C-]>` / `<C-o>` / `<C-i>` | jump-to-tag / jump back / jump forward in jumplist |
| `gf` | open file path under cursor |
| `*` / `#` | search forward / backward for word under cursor |
| `%` | jump to matching paren/brace/tag |
| `]m` / `[m` | next / prev method-start (filetype-aware) |
| `:vimgrep /pat/ **/*.ts` then `:cn`/`:cp` | classic project-wide search with quickfix |
| `:b <tab>` | switch buffer by name (autocompletes) |
| `gd` (no plugin, native vim) | jump to local definition (LSP `gd` from coc overrides this for known filetypes) |

## Diff algorithm

We set `diffopt+=algorithm:histogram,indent-heuristic,vertical,internal`. Histogram is much better than the default Myers for code — it groups related hunks. `vertical` makes `:diffsplit` default to side-by-side.

## Project root awareness (vim-rooter)

Opens a file → cwd auto-changes to the project root (detected via `.git`, `package.json`, `go.mod`, `Cargo.toml`, `build.gradle{.kts}`, `pyproject.toml`). Means `:Files` and `:Rg` always anchor to the right scope without you cd'ing first.

## First-time coc setup

On first vim start after this update:
1. `:PlugStatus` to confirm plugins loaded.
2. coc will auto-install the language servers listed in `g:coc_global_extensions`. Wait for `:CocList extensions` to show them as `+` (active).
3. For TypeScript projects (jellyfin-web), node 18+ in PATH is required.
4. For Kotlin projects (jellyfin-android*), the kotlin-language-server jar will be auto-fetched by coc-kotlin; the project must have a `build.gradle`/`build.gradle.kts` for it to index.

## Quick recipe: review a PR end-to-end

```vim
:cd /path/to/repo
:Git fetch origin pull/7256/head:pr-7256
:Git checkout pr-7256
:Files                    " <space>f — see what's in the repo
:GFiles?                  " files changed in this branch vs index
:Git diff master --stat   " summary
:Gvdiff master            " side-by-side vs master for current file
" Walk hunks with ]c, preview with :GitGutterPreviewHunk
" Hover symbols with K, follow with gd
" Done? :Git checkout master && :Git branch -D pr-7256
```
