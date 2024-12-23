# Dotfiles
This repo contains my dotfiles for my Mac environment.
These are managed using GNU Stow to simplify the symlink-ing process.

### Requirements
Ensure you have the following installed on your system:
- zsh: Set as your default shell
- Git: To clone this repo
- [GNU Stow](https://www.gnu.org/software/stow/manual/stow.html): For managing symlinks

### Installation
1. Clone the repository
Clone this repository into your `$HOME` directory:
```
$ git clone git@github.com/sammcclenaghan/dotfiles.git ~/.dotfiles
$ cd .dotfiles
```
2. Symlink Dotfiles Using GNU Stow
Use GNU Stow to symlink the files to their respective locations:
```
$ stow --dotfiles .
```

Video showing GNU Stow in action: [https://www.youtube.com/watch?v=CFzD9SekOew](https://www.youtube.com/watch?v=CFzD9SekOew)
