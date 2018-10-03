# zmodload zsh/zprof && zprof # プロファイリング (zshrcの末尾とセット)

# 基本環境設定:
export LANG=ja_JP.UTF-8
export ARCHFLAGS="-arch x86_64"
export EDITOR="vim"
export COLORTERM="xterm-256color"
export TERM="xterm-256color"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

# Path環境変数の設定:
export PATH="/usr/local/bin:${PATH}"
export PATH="/usr/local/sbin:${PATH}"
export PATH="${PATH}:/bin"
export PATH="${PATH}:/usr/bin"
export PATH="${PATH}:/sbin"
export PATH="${PATH}:/usr/sbin"

## Go:
export GOPATH=${HOME}/go
export PATH="/usr/local/opt/go/libexec/bin:${PATH}:${HOME}/go/bin"
export GOROOT=/usr/local/opt/go/libexec

## Python:
export PYTHON_CONFIGURE_OPTS="--enable-framework"
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

## Node:
export PATH="${PATH}:${HOME}/.nodenv/shims:${HOME}/.nodenv/bin:./node_modules/.bin"

## Ruby:
export PATH=${PATH}:${HOME}/.rbenv/bin

## GNU commands:
export PATH="/usr/local/opt/gzip/bin:${PATH}"
export PATH="/usr/local/opt/openssl/bin:${PATH}"

## FZF (https://github.com/junegunn/fzf):
export FZF_DEFAULT_OPTS="--inline-info --no-mouse --extended --ansi --no-sort"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --maxdepth 10 --glob "!.git/*" --glob "!*.egg-info/*" --glob "!*/__pycache__/*" --glob "!.mypy_cache/*"'

## AWS:
export AWS_DEFAULT_PROFILE=default
export AWS_DEFAULT_REGION=us-east-1

## Scala:
export SCALA_HOME=/usr/local/bin/scala
export PATH=${PATH}:${SCALA_HOME}/bin

## zplug:
export ZPLUG_HOME=${HOME}/.zplug

## java:
export JAVA_HOME=`/usr/libexec/java_home`
export PATH=${JAVA_HOME}/bin:$PATH

## perl:
export PATH=${PATH}:${HOME}/perl5/bin

## loginitems
export PATH=${PATH}:${HOME}/.loginitems

## git
export PATH=$PATH:/usr/local/share/git-core/contrib/diff-highlight

# highlighters
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters

# zlib
export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"

## dotfiles自体
export DOTFILES=${HOME}/.config
export DOTS=${HOME}/.config
