#!/bin/bash

function install() {
  name=$1
  basename=${name##*/}
  git submodule add -- "https://github.com/${name}"   "./pack/personal/opt/${basename}" > /dev/null 2>&1
  echo "packadd ${basename}"
}

install kyoh86/telescope-gogh.nvim
