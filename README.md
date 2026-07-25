# Dotfiles

This repo contains my dotfiles for my Mac environment.
These are managed using GNU Stow to simplify the symlink-ing process.

### Requirements

Ensure you have the following installed on your system:

* zsh: Set as your default shell
* Git: To clone this repo
* [GNU Stow](https://www.gnu.org/software/stow/manual/stow.html): For managing symlinks
* [Neovim](https://neovim.io/doc/): For editing configuration files
* [Zed](https://zed.dev/docs): As an additional editor
* [Starship](https://starship.rs/guide/): For shell prompts
* [Tmux](https://github.com/tmux/tmux/wiki): For terminal multiplexing
* [Obsidian](https://help.obsidian.md/): For note management
* [Antigen](https://github.com/zsh-users/antigen): For zsh plugin management
* [Mise](https://mise.jdx.dev/): For managing runtimes
* [Pi](https://github.com/earendil-works/pi): Coding agent (config in `dot-pi/`)

### Layout

Everything uses stow's `--dotfiles` convention: `dot-foo` stows to `~/.foo`.

* `dot-config/` → `~/.config/` (nvim, zed, gh, mise, starship, scripts)
* `dot-pi/` → `~/.pi/` (agent settings, keybindings, themes, prompts; state and secrets stay unmanaged)
* `dot-zshrc`, `dot-gitconfig`, `dot-tmux.conf`, `dot-obsidian.vimrc` → home directory

The Ember theme family (Zed + Neovim + pi) is generated from a single palette in
`dot-config/scripts/gen_ember.py` — edit that and rerun it rather than hand-editing
the theme files.

### Installation

1. Clone the repository
   Clone this repository into your `$HOME` directory:

```
$ git clone git@github.com:sammcclenaghan/.dotfiles.git ~/.dotfiles
$ cd .dotfiles
```

2. Symlink Dotfiles Using GNU Stow
   Use GNU Stow to symlink the files to their respective locations:

```
$ stow --dotfiles --adopt .
```

3. Change .gitconfig.local
   Change the `user.name` and `user.email` information to your respective name and email

Video showing GNU Stow in action: [https://www.youtube.com/watch?v=CFzD9SekOew](https://www.youtube.com/watch?v=CFzD9SekOew)
