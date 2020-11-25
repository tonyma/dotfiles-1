# zmodload zsh/zprof && zprof # プロファイリングをしたいときは、コメントを外す

# vim-pyenvがautoでバージョン指定してしまうため、
# pyenv shell x.x.x された状態と同等になってしまうのを回避する
unset PYENV_VERSION

## zsh
export SHELL="zsh"

# zlib
export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"

if [ -f "${ZDOTDIR}/.zsh_secret" ]; then
  source "${ZDOTDIR}/.zsh_secret"
fi

gsettings set org.gnome.desktop.peripherals.keyboard repeat true >/dev/null 2>&1 || :
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 50 >/dev/null 2>&1 || :
gsettings set org.gnome.desktop.peripherals.keyboard delay 200 >/dev/null 2>&1 || :
