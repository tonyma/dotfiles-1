# zmodload zsh/zprof && zprof # プロファイリングをしたいときは、コメントを外す

# vim-pyenvがautoでバージョン指定してしまうため、
# pyenv shell x.x.x された状態と同等になってしまうのを回避する
unset PYENV_VERSION

## git
export PATH=$PATH:/usr/local/share/git-core/contrib/diff-highlight

## zsh
export SHELL="zsh"

# highlighters
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters

# zlib
export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"

if [ -f ${ZDOTDIR}/.zsh_secret ]; then
  source ${ZDOTDIR}/.zsh_secret
fi
