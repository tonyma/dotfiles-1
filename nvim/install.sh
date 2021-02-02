#!/bin/bash

function install() {
  name=$1
  basename=${name##*/}
  git submodule add -- "https://github.com/${name}"   "./pack/personal/opt/${basename}" > /dev/null 2>&1
  echo "packadd ${basename}"
}

install osyo-manga/vim-operator-jump_side
install simeji/winresizer
install machakann/vim-sandwich
install thinca/vim-quickrun
install lambdalisue/readablefold.vim
install machakann/vim-swap
install ryanoasis/vim-devicons
install vim-scripts/sudo.vim

