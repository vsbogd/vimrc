# Overview

The script uses [vim-plug](https://github.com/junegunn/vim-plug) to install
plugins.

Links:
- [Learn Vimscript the Hard
  Way](http://learnvimscriptthehardway.stevelosh.com/) - awesome online book
  about vim and vimscript;

# Installation

Install `vim-plug` using:
```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Then copy `.vimrc` to your home folder:
```sh
cp .vimrc ~
```

Open vim and execute:
```vim
:PlugInstall
```
