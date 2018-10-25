################################################################################

# キーバインド設定 {{{
# ------------------------------------------------------------------------------
bindkey -e
bindkey '^d' delete-char
# }}}

# 機能定義 {{{
# ------------------------------------------------------------------------------

## FZF呼び出し(utility) {{{
function fzf-select() {
	if [[ $# -gt 0 ]]; then
		fzf --query "$@"
	else
		fzf
	fi
}
zle -N fzf-select
## }}}

## プロジェクト管理 {{{

typeset -a project_owners
project_owners=(kyoh86 wcl48 wacul)
function cd-project() {
	local selected
	local project
  local query
  query="^github.com/ /${(j:/ | /:)project_owners}/ /"
  selected=$( ghq list | fzf --query "${query}" --bind 'ctrl-x:execute(read -sq "REPLY?remove {}?" < /dev/tty ; echo -ne "\e[2K" ; [[ "${REPLY}" == "y" ]] && rm -r "$(ghq root)"/{} && echo -n " removed {}")+abort')
	if [[ ${?} -ne 0 || -z "${selected}" ]]; then
    zle accept-line
    zle -R -c
    echo ${selected}
		return
	fi
  project=$(ghq root)/${selected}
	BUFFER="cd ${project}"
	zle accept-line
	# redisplay the command line
	zle -R -c
}
zle -N cd-project
bindkey '^xp' cd-project
bindkey '^x^p' cd-project

function new-project() {
  local owner
  owner=$( ( IFS=$'\n'; echo "${project_owners[*]}" ) | fzf --prompt "PROJECT OWNER? > " --reverse --height 30%)
  if [[ -z "${owner}" ]]; then
    return
  fi

  local project_name
  autoload -Uz read-from-minibuffer
  # vared -i '' -f '' -p "${fg_bold[blue]}PROJECT NAME? > ${reset_color}" -c project_name
  echo -n "${fg_bold[blue]}"
  read-from-minibuffer "PROJECT NAME? > "
  zle -I
  echo -n "${reset_color}"
  project_name=${REPLY}
  if [[ -z "${project_name}" ]]; then
    return
  fi

  local project_dir
  project_dir="$(ghq root)/github.com/${owner}/${project_name}"
  if [[ -d ${project_dir} ]]; then
    echo "${fg[red]}The project already exists${reset_color}"
    return
  fi
  if [[ -e ${project_dir} ]]; then
    echo "${fg[red]}An object already exists"
    ls -lad --color=never "${project_dir}"
    echo -n "${reset_color}"
    return
  fi
	BUFFER="mkdir -p '${project_dir}' && cd '${project_dir}' && git init && hub create ${owner}/${project_name}"
	zle accept-line
	# redisplay the command line
	zle -R -c
}
zle -N new-project
bindkey '^xn' new-project
bindkey '^x^n' new-project
## }}}

## ブランチ切り替え {{{
function checkout-git-branch() {
	local selected
	selected=$(
		git-branches --color --exclude-current \
			| fzf -0 -n 2..3 \
			| awk '{print $2}' \
	)
	if [ -z "${selected}" ]; then
		return
	fi
	BUFFER="git checkout $selected"
	zle accept-line
	# redisplay the command line
	zle -R -c
}
zle -N checkout-git-branch
bindkey '^xgb' checkout-git-branch
bindkey '^xg^b' checkout-git-branch
bindkey '^x^gb' checkout-git-branch
bindkey '^x^g^b' checkout-git-branch
## }}}

## LaunchCtlジョブ選択 {{{
function insert-launchctl() {
	local selected
	selected=$(
		launchctl list | tail -n +2 | awk '{print $3}' \
			| fzf-select
	)
	if [ -z "${selected}" ]; then
		return
	fi
	LBUFFER+="$selected"
	CURSOR=$#LBUFFER
	# redisplay the command line
	zle -R -c
}
zle -N insert-launchctl
bindkey '^xl' insert-launchctl
bindkey '^x^l' insert-launchctl
## }}}

## コマンド履歴検索 {{{
function put-history() {
	local selected
	selected=$(
		history -n 1 | grep -v '.\{200,\}' | awk '!a[$0]++' \
			| fzf-select --no-sort --query="$LBUFFER"
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
## }}}

## AWS環境切り替え {{{
function switch-awsenv() {
	local selected
	selected=$(
		cat ~/.aws/credentials |
			perl -ne'print $1."\n" if(/^\[(?!default\])([^\]]+)\]/)' |
			fzf-select
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
## }}}

## Homebrew pyenv 衝突の回避 {{{
function brew() {
	env PATH=${PATH/${HOME}\/\.pyenv\/shims:/} command brew $@
}
zle -N brew
## }}}

## 中断ジョブの復帰 {{{
function revive-job() {
	jobs | fzf | awk '{print $1}' | perl -pe 's/\[(\d+)\]/%$1/g' | xargs -n1 -r fg
}
zle -N revive-job
bindkey '^Z' revive-job
## }}}

# }}}

# GNU commands {{{
# ------------------------------------------------------------------------------
alias find=/usr/local/opt/findutils/bin/gfind
alias xargs=/usr/local/opt/findutils/bin/gxargs
alias grep="/usr/local/bin/ggrep --color=auto"
# }}}

# コマンド履歴の設定 {{{
# ------------------------------------------------------------------------------

HISTFILE=${HOME}/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history       # 補完時にヒストリを自動的に展開
setopt hist_ignore_all_dups   # ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_space      # スペースで始まるコマンド行はヒストリリストから削除
setopt hist_reduce_blanks     # 余分な空白は詰めて記録
setopt hist_no_store          # historyコマンドは履歴に登録しない
setopt hist_verify            # ヒストリを呼び出してから実行する間に一旦編集可能
# }}}

# 色名による指定を有効にする {{{
autoload -Uz colors
colors
# }}}

# lsの色設定 {{{
# ------------------------------------------------------------------------------
# 色の設定
export LSCOLORS=Exfxcxdxbxegedabagacad
# 補完時の色の設定
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
# lsコマンド時、自動で色がつく
export CLICOLOR=true
# 補完候補に色を付ける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
alias ls="gls --color"
# }}}

# プロンプト設定 {{{
# ------------------------------------------------------------------------------

autoload -Uz add-zsh-hook

if [[ -z "${VIM_TERMINAL}" ]]; then
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

# vimとの連携設定 {{{
if [[ -n "${VIM_TERMINAL}" ]]; then
  # 現在のパスをタイトルとして渡す
  function _update_term_title() {
    # sets the tab title to current dir
    echo -ne "\033]0;${PWD}\007"
  }
  add-zsh-hook precmd _update_term_title

  # vimを置換える
  function _drop_vim_file() {
    echo -ne "\033]51;[\"drop\", \"${1}\"]\07"
  }
  alias vim=_drop_vim_file
  alias vi=_drop_vim_file
fi
# }}}

# anyenv設定 {{{
# ------------------------------------------------------------------------------

## Python {{{
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

eval "$(command pyenv init -)"
eval "$(command pyenv virtualenv-init -)"
## }}}

## Node {{{
export PATH="${PATH}:${HOME}/.nodenv/shims"
export PATH="${PATH}:${HOME}/.nodenv/bin"

eval "$(nodenv init -)"
## }}}

## Ruby {{{
export PATH=${PATH}:${HOME}/.rbenv/bin

eval "$(command rbenv init -)"
## }}}

# }}}

# zmv パターンマッチリネームの設定 {{{
# ------------------------------------------------------------------------------
autoload -Uz zmv

alias mmv='noglob zmv -W'
alias mcp='noglob zmv -W -p "cp -r"'
alias mln='noglob zmv -W -L'
alias zcp='zmv -p "cp -r"'
alias zln='zmv -L'
# }}}

# 自動補完の設定 {{{
# ------------------------------------------------------------------------------
fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit
compinit -C
# }}}

# 各種サービスの読み込み {{{
# ------------------------------------------------------------------------------
function _source_exists() {
	for file in "${(Oa)@}"; do
		if [ -f ${file} ]; then
			source ${file}
		fi
	done
}

for f in $(find ${ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR} -name "*.zsh"); do
  if [ ! -e "${f}.zwc" ] || [ "${f}" -nt "${f}.zwc" ]; then
    zcompile $f
  fi
done

_source_exists \
	~/.fzf.zsh \
	${ZDOTDIR}/.zsh_secret \
	/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# }}}

# その他の設定 {{{
# ------------------------------------------------------------------------------
setopt extended_glob

stty eof ''
# }}}

################################################################################

# ZSHRC 終了処理 {{{
# ------------------------------------------------------------------------------
export PATH=".:${PATH}"

if [[ -z "${VIM_TERMINAL}" ]]; then
  exec vim || :
fi
## ZSHRC コンパイル{{{
if [ ! -e ${ZDOTDIR:-${HOME}}/.zshrc.zwc ] || [ ${ZDOTDIR:-${HOME}}/.zshrc -nt ${ZDOTDIR:-${HOME}}/.zshrc.zwc ]; then
	zcompile ${ZDOTDIR:-${HOME}}/.zshrc
fi
## }}}

# ZSHRC性能検査 (zshenvの先頭とセット)
# if (which zprof > /dev/null) ;then
#   zprof | less
# fi
# }}}
