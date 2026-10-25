# Dotfiles

My Mac setup, managed with [GNU Stow](https://www.gnu.org/software/stow/manual/stow.html).
Zed for code, [Rex](https://www.superlogical.com/rex) for terminals and coding agents.

## Install

```sh
xcode-select --install
# Homebrew: https://brew.sh
git clone git@github.com:sammcclenaghan/.dotfiles.git ~/.dotfiles
brew install stow && ~/.dotfiles/install.sh
brew bundle --global
```

`install.sh` creates `~/.config` and `~/.pi/agent` first, so Stow links each app's folder
inside them rather than the whole directory. Rerun it after adding files; it restows.

Then the things Homebrew doesn't cover:

- [Rex](https://www.superlogical.com/rex/docs/installation), then `rex skill setup` for agents
- [mise](https://mise.jdx.dev) (`curl https://mise.run | sh`), then `mise install` for Node,
  Ruby and the npm tools in `mise/config.toml` (Pi, rails-blocks MCP, Herb LSP)
- [rustup](https://rustup.rs), then `cargo install --git https://github.com/cemcatik/rexurrect`
  and `rexurrect autosave install`
- Claude Code and Kiro from their installers
- `~/.zshrc.local` for secrets (`OPENCODE_API_KEY`, `RAILS_BLOCKS_API_TOKEN`). It's git-ignored.

## Layout

Stow's `--dotfiles` convention: `dot-foo` links to `~/.foo`.

| Path | What |
|---|---|
| `dot-zshrc`, `dot-zprofile`, `dot-zshenv` | zsh. No plugin manager: plugins come from Homebrew |
| `dot-config/zsh/` | Vendored [rexurrect](https://github.com/cemcatik/rexurrect) recorder |
| `dot-config/rex/init.lua` | Rex: ⌘⇧E open pane in Zed, ⌘⇧O project session, ctrl-a h/j/k/l panes |
| `dot-config/zed/` | Zed settings, keymap, tasks, themes |
| `dot-config/nvim/` | Neovim (vim.pack, mason) |
| `dot-config/mise/` | Runtimes and global npm tools |
| `dot-config/git/ignore`, `dot-gitconfig` | Git |
| `dot-config/gh/`, `dot-config/starship.toml`, `dot-config/scripts/` | gh, prompt, scripts |
| `dot-pi/` | Pi agent settings (state and secrets stay unmanaged) |
| `dot-Brewfile` | Homebrew packages (`brew bundle --global`; refresh with `brew bundle dump --global -f`) |

The Ember theme family (Zed, Neovim, Pi) is generated from one palette in
`dot-config/scripts/gen_ember.py`. Edit that and rerun it rather than editing the theme files.

## Not tracked

Agent configs (`~/.claude`, `~/.codex`, opencode) hold work details and tokens, so they stay
out of this public repo, as does anything matching `*.local`.
