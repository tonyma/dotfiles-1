#!/bin/sh

function _source_if() {
  [ -f ${1} ] && source ${1}
}

# zsh設定 {{{
# ------------------------------------------------------------------------------

# コマンド履歴の設定 {{{
HISTFILE=${HOME}/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
HISTORY_IGNORE="(ls|cd|rm|git|rmdir|mv|cp|export|exit)"
setopt extended_history       # 補完時にヒストリを自動的に展開
setopt hist_ignore_all_dups   # ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_space      # スペースで始まるコマンド行はヒストリリストから削除
setopt hist_reduce_blanks     # 余分な空白は詰めて記録
setopt hist_no_store          # historyコマンドは履歴に登録しない
setopt hist_verify            # ヒストリを呼び出してから実行する間に一旦編集可能
zshaddhistory() {
  emulate -L zsh
  [[ ${1%%$'\n'} != ${~HISTORY_IGNORE} ]]
}
# }}}

# プロンプト設定 {{{
autoload -Uz add-zsh-hook

if [ -z "${VIM_TERMINAL}" ] && [ -z "${NVIM_TERMINAL}" ] && which git-prompt > /dev/null 2>&1; then
  function _update_git_info() {
    status_string=$(git-prompt -s zsh)
    if [ $? -ne 0 ]; then
      # gitの情報を正しく取得できない場合は現在のパスを表示する
      if [[ "${PWD:h}" == "/" ]]; then
        RPROMPT="%F{blue}${PWD}%f"
      else
        RPROMPT="%F{blue}${PWD:h}%f%F{yellow}/${PWD:t}%f"
      fi
    else 
      RPROMPT="${status_string}"
    fi
  }
  add-zsh-hook precmd _update_git_info
fi

PROMPT="%(?,,%F{red}[%?]%f

)%F{blue}$%f "
# }}}

# 自動補完の設定 {{{
if [ -d /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi
plugins=(zsh-completions zsh-syntax-highlighting $plugins)
autoload -Uz compinit && compinit
# }}}

# 色名による指定を有効にする {{{
autoload -Uz colors
colors
# }}}

# キーバインド設定 {{{
bindkey -e
bindkey '^d' delete-char
# }}}

# ZSHコマンドハイライト設定 {{{
HIGHLIGHTING='/usr/local/share/zsh-syntax-highlighting'
if [ ! -d "${HIGHLIGHTING}" ]; then
  HIGHLIGHTING='/usr/share/zsh/plugins/zsh-syntax-highlighting'
fi

if [ -d "${HIGHLIGHTING}/highlighters" ]; then
  export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR="${HIGHLIGHTING}/highlighters"
  for f in $(find "${HIGHLIGHTING}/highlighters" -name "*.zsh"); do
    if [ ! -e "${f}.zwc" ] || [ "${f}" -nt "${f}.zwc" ]; then
      zcompile "${f}" > /dev/null 2>&1 || :
    fi
  done
  _source_if "${HIGHLIGHTING}/zsh-syntax-highlighting.zsh"
fi
# }}}

# その他の設定 {{{
setopt extended_glob

stty eof ''
# }}}

# }}}

# コマンドカスタマイズ {{{
# ------------------------------------------------------------------------------

# lsの色設定 {{{
# 色の設定
export LSCOLORS=Exfxcxdxbxegedabagacad
# 補完時の色の設定
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
# 補完候補に色を付ける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# }}}

# zmv パターンマッチリネームの設定 {{{
autoload -Uz zmv

alias mmv='noglob zmv -W'
alias mcp='noglob zmv -W -p "cp -r"'
alias mln='noglob zmv -W -L'
alias zcp='zmv -p "cp -r"'
alias zln='zmv -L'
# }}}

# }}}

# ツールの設定 {{{
# ------------------------------------------------------------------------------

# fzf {{{
_source_if ~/.fzf.zsh
# }}}

# asdf {{{
_source_if /opt/asdf-vm/asdf.sh
# }}}

# anyenv {{{

if [[ -f ${DOTFILES}/lazyenv/lazyenv.bash ]]; then
  source ${DOTFILES}/lazyenv/lazyenv.bash

  if command -v direnv >/dev/null 2>&1 ; then
    eval "$( command direnv hook zsh )"
  fi

  if command -v goenv >/dev/null 2>&1 ; then
    eval "$( command goenv init - )"
  fi

  _nodenv_init() {
    eval "$(command nodenv init -)"
  }

  list="ls"
  if command -v gls >/dev/null 2>&1 ; then
    list="gls"
  fi
  eval "$(lazyenv.load _nodenv_init `$list --color=never ~/.nodenv/shims 2>/dev/null` nodenv)"
  
  _rbenv_init() {
    eval "$(command rbenv init -)"
  }
  eval "$(lazyenv.load _rbenv_init `$list --color=never ~/.rbenv/shims 2>/dev/null` rbenv)"
  
  _pyenv_init() {
    eval "$(command pyenv init -)"
    eval "$(command pyenv virtualenv-init -)"
  }
  eval "$(lazyenv.load _pyenv_init `$list --color=never ~/.pyenv/shims 2>/dev/null` pyenv)"
fi
# }}}

# Java {{{

function java() {
  unset -f java
  eval "export JAVA_HOME=system('/usr/libexec/java_home')"
  eval "export PATH=\$JAVA_HOME.'/bin:'.\$PATH"
  java $@
}

# }}}

# vimとの連携設定 {{{
# 現在のパスをタイトルとして渡す
if [[ -n "${VIM_TERMINAL}" ]]; then
  function _update_term_title() {
    # sets the tab title to current dir
    echo -ne "\033]0;${PWD}\007"
    echo -ne "\033]51;[\"call\", \"Tapi_UpdateStatus\", [\"${PWD}\"]]\07"
  }
  add-zsh-hook precmd _update_term_title
  # vim-editerm用の設定
  if [[ "${VIM_EDITERM_SETUP}" != "" ]]; then
    source "${VIM_EDITERM_SETUP}" 
  fi
fi
#
# コマンドをVimで編集する
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
# }}}

# }}}

# 環境別の設定 {{{
[ -f $ZDOTDIR/.zshrc_`uname` ] && . $ZDOTDIR/.zshrc_`uname`
# }}}

# 自作関数 {{{
# ------------------------------------------------------------------------------

# メール添付ファイルとかよく圧縮するのダルいの回避 {{{
function mailarch() {
  if [ $# -lt 2 ]; then
    echo "Not enough arguments" >&2
    echo "Usage: $0 <zip filename> <source files...>" >&2
    return 1
  fi

  if [[ ! "$1" =~ "\.zip$" ]]; then
    echo "Invalid argument(1): zip filename must end with '.zip'." >&2
    echo "Usage: $0 <zip filename> <source files...>" >&2
    return 1
  fi

  if ! command -v pwgen >/dev/null 2>&1; then
    echo "Command not found: pwgen" >&2
    echo "brew install pwgen" >&2
    return 1
  fi

  echo "Encrypting files..." >&2
  local pw="$(pwgen -s 8)"
  echo -n "Copied a password to the clipboard: "; echo -n "${pw}" | tee >(pbcopy); echo ""

  local -a args=(-erP "$pw" "$@")
  command zip $args

  echo "Files are encrypted to $1"
}
# }}}

# }}}

# ブランチ切り替え {{{
function switch-git-branch() {
  local selected
  selected=$(
    git-branches --color !current \
      | fzf -0 -n 2..3 \
      | awk '{print $2}' \
  )
  if [ -z "${selected}" ]; then
    return
  fi
  BUFFER="git switch $selected"
  zle accept-line
  # redisplay the command line
  zle -R -c
}
zle -N switch-git-branch
bindkey '^xgb' switch-git-branch
bindkey '^xg^b' switch-git-branch
bindkey '^x^gb' switch-git-branch
bindkey '^x^g^b' switch-git-branch
# }}}

# Issueを開く {{{
function show-github-issue() {
  local selected
  selected=$(
    gh issue list --state open --limit 100 \
      | fzf --preview 'gh issue view -p {1}' \
      | cut -f1
  )
  if [ -z "${selected}" ]; then
    return
  fi
  BUFFER="gh issue view $selected"
  zle accept-line
  # redisplay the command line
  zle -R -c
}
zle -N show-github-issue
bindkey '^xgi' show-github-issue
bindkey '^xg^i' show-github-issue
bindkey '^x^gi' show-github-issue
bindkey '^x^g^i' show-github-issue
# }}}

# コマンド履歴検索 {{{
function put-history() {
  local selected
  selected=$(
    history -n 1 | grep -v '.\{200,\}' | awk '!a[$0]++' \
      | fzf --no-sort --query="$LBUFFER"
  )
  if [ -z "${selected}" ]; then
    return
  fi
  BUFFER="$selected"
  CURSOR=$#BUFFER
  # redisplay the command line
  zle -R -c
}
zle -N put-history
bindkey '^xi' put-history
bindkey '^x^i' put-history
# }}}

# AWS環境切り替え {{{
function switch-awsenv() {
  local selected
  selected=$(
    cat ~/.aws/credentials |
      perl -ne'print $1."\n" if(/^\[(?!default\])([^\]]+)\]/)' |
      fzf
  )
  if [ -z "${selected}" ]; then
    return
  fi
  BUFFER="export AWS_DEFAULT_PROFILE=${selected}"
  zle accept-line
  # redisplay the command line
  zle -R -c
}
zle -N switch-awsenv
bindkey '^xva' switch-awsenv
bindkey '^xv^a' switch-awsenv
bindkey '^x^va' switch-awsenv
bindkey '^x^v^a' switch-awsenv
# }}}

# 中断ジョブの復帰 {{{
function revive-job() {
  jobs | fzf | awk '{print $1}' | perl -pe 's/\[(\d+)\]/%$1/g' | xargs -n1 -r fg
}
zle -N revive-job
bindkey '^Z' revive-job
# }}}

# update bins {{{
update() {
  if (( $# > 0 )) ; then
    while (( $# > 0 )); do
      update-$1
      shift
    done
  else
    update-paru
    update-pip
    update-go
    update-yarn
    update-brew
    update-gordon
    update-vim-plug
    echo done
  fi
}

# update pip {{{
function update-pip {
  echo updating pip
  pushd ~
  if command -v pyenv >/dev/null 2>&1 ; then
    eval "$(pyenv init -)"
    pyenv versions --bare | while read version; do
      pyenv shell ${version}
      unset PIP_REQUIRE_VIRTUALENV
      pyenv exec pip install --upgrade pip
      pyenv exec pip install -U -r ~/.config/pyenv/default-packages
    done
  elif command -v pip > /dev/null 2>&1 ; then
    unset PIP_REQUIRE_VIRTUALENV
    pip install --user -U -r ~/.config/pyenv/default-packages
  fi
  popd
}
# }}}

# update go/bin {{{
function update-go {
  # ローカルで開発作業してるときはgo/binに色々ノイズが乗りがちなので、
  # Make cleanが定義されてたら呼び出す
  make clean || :
  echo updating go
  pushd ~
  local bin="\"$(go env GOPATH)/bin/\""
  local fmt="\"%.$((${#$(go env GOPATH)}+5))s\""
  fmt="$(
    echo -n "{{if eq ${bin} (printf ${fmt} .Target)}}";
    echo -n "{{.Target}} {{.ImportPath}}";
    echo -n "{{end}}";
  )" 
  go list -f "${fmt}" all 2>/dev/null | while read line ; do
    local pkg="${line##* }"
    if [ -x "${line%% *}" ]; then
      echo "update ${pkg}"
      go get -u "${pkg}" || :
    fi
  done
  gogh list --primary --format full-file-path | while read project; do
    cd "${project}"
    echo "$(go list -f "${fmt}" ./... 2>/dev/null || :)" | while read line ; do
      local pkg="${line##* }"
      if [ -x "${line%% *}" ]; then
        echo "update ${pkg}"
        go get -u "${pkg}" || :
      fi
    done
  done
  popd
}
# }}}

# update yarn global {{{
function update-yarn {
  echo updating yarn
  pushd ~
  yarn global upgrade --latest
  popd
}
alias update-js=update-yarn
alias update-npm=update-yarn
# }}}

# update brew {{{
function update-brew {
  echo updating brew
  pushd ~
  if command -v brew >/dev/null 2>&1 ; then
    brew upgrade --fetch-HEAD
  fi
  popd
}
# }}}

# update pacman {{{
function update-paru {
  echo updating paru
  pushd ~
  if command -v paru >/dev/null 2>&1 ; then
    paru -Suuyy --cleanafter --rebuild --redownload --noconfirm
    if paru -Q neovim-nightly-bin >/dev/null 2>&1; then
      echo "neovim will be updated by paru if necessary"
    else
      tmpdir="$(mktemp -d)"
      trap "rm -rfv $tmpdir" EXIT
      git clone https://github.com/neovim/neovim "$tmpdir/neovim"
      pushd "$tmpdir/neovim" && make -j4
      sudo make install
      popd
    fi
  fi
  popd
}
# }}}

# update vim-plug {{{
function update-vim-plug {
  echo updating vim-plug
  if [ -d "${DOTFILES}" ]; then
    pushd "${DOTFILES}"
    git submodule update --init --recursive
    popd >/dev/null 2>&1
  fi
  if [ -d "${VIM_PLUG_DIR}" ]; then
    set +m
    pushd "${VIM_PLUG_DIR}"
    ls -1d *(/) | while read -r p; do
      echo "updating ${p}"
      (
        git -C ${p} pull --quiet --no-verify --autostash --depth 1
        echo "${p} done"
      ) &
    done
    wait >/dev/null 2>&1
    set -m
    echo "updating vim-plug: DONE"
    popd >/dev/null 2>&1
  fi
}
# }}}

# update gordon {{{
function update-gordon {
  echo updating gordon
  pushd ~
  if command -v gordon >/dev/null 2>&1 ; then
    gordon update --all
  fi
  popd
}
# }}}
# }}}

# }}}

# ZSHRC 終了処理 {{{
# ------------------------------------------------------------------------------
export PATH=".:${PATH}"

# ZSHRC コンパイル{{{
if [ ! -e ${ZDOTDIR:-${HOME}}/.zshrc.zwc ] || [ ${ZDOTDIR:-${HOME}}/.zshrc -nt ${ZDOTDIR:-${HOME}}/.zshrc.zwc ]; then
  zcompile ${ZDOTDIR:-${HOME}}/.zshrc
fi
# }}}

# ZSHRC性能検査 {{{
if (which zprof > /dev/null) ;then
  zprof | less
fi
# }}}

# }}}
