# def_functions
# def_aliases
# conf_histories
# def_bindkeys
# conf_lscolor
# conf_prompt
# conf_anyenv
# conf_zmv
# conf_completions
# load_plugins

################################################################################

# ______________________________________________________________________________
# def_functions: 関数定義
# ------------------------------------------------------------------------------

function edit-file() {
  file=$(eval "${FZF_DEFAULT_COMMAND} 2>/dev/null | fzf ${FZF_DEFAULT_OPTS}")
  if [ -n "${file}" ]; then
    sh -c '</dev/tty vim "'${file}'"'
  fi
}
zle -N edit-file

function cd-project() { # {{{
	local selected
	local project
	selected=$(ghq list | fzf-select "github.com/kyoh86/")
	if [ -z "${selected}" ]; then
		return
	fi
  project=$(ghq root)/${selected}
	BUFFER="cd ${project}"
	zle accept-line
	# redisplay the command line
	zle -R -c
}
zle -N cd-project # }}}

function checkout-git-branch() { # {{{
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
zle -N checkout-git-branch # }}}

function fzf-select() {
	if [[ $# -gt 0 ]]; then
		fzf --query "$@"
	else
		fzf
	fi
}
zle -N fzf-select

function git-clbr() {
	git branches -X | grep '=>' | awk '{print $2}' | xargs git branch -D
}
zle -N git-clbr

function git-destroy() {
	git stash && git stash drop; git clean -fd
}
zle -N git-destroy

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

function brew() {
	env PATH=${PATH/${HOME}\/\.pyenv\/shims:/} command brew $@
}
zle -N brew 

# ジョブの復帰
function revive-job() {
	jobs | fzf | awk '{print $1}' | perl -pe 's/\[(\d+)\]/%$1/g' | xargs -n1 -r fg
}
zle -N revive-job

# ______________________________________________________________________________
# def_aliases: エイリアス設定
# ------------------------------------------------------------------------------

## GNU commands:

alias find=/usr/local/opt/findutils/bin/gfind
alias xargs=/usr/local/opt/findutils/bin/gxargs
alias grep="/usr/local/bin/ggrep --color=auto"

## git:

alias pull="git pull"
alias push="git push"


## vim:
alias vi=vim

## tmux:
alias tmux='TERM=xterm-256color tmux -f "${XDG_CONFIG_HOME:-${HOME}/.config}"/tmux/tmux.conf'

setopt extended_glob

# ______________________________________________________________________________
# conf_histories: コマンド履歴の設定
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

# ______________________________________________________________________________
# def_bindkeys: キーバインド設定
# ------------------------------------------------------------------------------

bindkey -e

bindkey '^xi' put-history
bindkey '^x^i' put-history

bindkey '^xl' insert-launchctl
bindkey '^x^l' insert-launchctl

## git系
bindkey '^xgb' checkout-git-branch
bindkey '^xg^b' checkout-git-branch
bindkey '^x^gb' checkout-git-branch
bindkey '^x^g^b' checkout-git-branch

bindkey '^xf' edit-file
bindkey '^x^f' edit-file

bindkey '^xp' cd-project
bindkey '^x^p' cd-project

## 環境切替

bindkey '^xva' switch-awsenv
bindkey '^xv^a' switch-awsenv
bindkey '^x^va' switch-awsenv
bindkey '^x^v^a' switch-awsenv

## ジョブの復帰
bindkey '^Z' revive-job

## delete key
bindkey '^d' delete-char

stty eof ''

# ______________________________________________________________________________
# conf_lscolor: lsの色設定
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

# ______________________________________________________________________________
# conf_prompt: プロンプト設定
# ------------------------------------------------------------------------------

autoload -Uz add-zsh-hook

function _update_git_info() {
	if [[ -z "${TMUX}" ]]; then
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
	else
		RPROMPT=""
		tmux refresh-client -S > /dev/null 2>&1
	fi
}
add-zsh-hook precmd _update_git_info

PROMPT="%(?,,%F{red}[%?]%f
)
%F{blue}$%f "

# ______________________________________________________________________________
# conf_anyenv: anyenv設定
# ------------------------------------------------------------------------------

## Python
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

## Node
export PATH="${PATH}:${HOME}/.nodenv/shims"

## Ruby
export PATH=${PATH}:${HOME}/.rbenv/bin && \

pyenv() {
  eval "$(command pyenv init -)"
  eval "$(command pyenv virtualenv-init -)"
}
nodenv() {
  eval "$(command nodenv init -)"
}
rbenv() {
  eval "$(command rbenv init -)"
}

# ______________________________________________________________________________
# conf_zmv: zmv パターンマッチリネームの設定
# ------------------------------------------------------------------------------

autoload -Uz zmv

alias mmv='noglob zmv -W'
alias mcp='noglob zmv -W -p "cp -r"'
alias mln='noglob zmv -W -L'
alias zcp='zmv -p "cp -r"'
alias zln='zmv -L'

# ______________________________________________________________________________
# conf_completions: 自動補完の設定
# ------------------------------------------------------------------------------

fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit
compinit -C

# ______________________________________________________________________________
# load_plugins: 各種サービスの読み込み
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

################################################################################

## ZSHRC 終了処理
export PATH=".:${PATH}"

## ZSHRC コンパイル
if [ ! -e ${ZDOTDIR:-${HOME}}/.zshrc.zwc ] || [ ${ZDOTDIR:-${HOME}}/.zshrc -nt ${ZDOTDIR:-${HOME}}/.zshrc.zwc ]; then
	zcompile ${ZDOTDIR:-${HOME}}/.zshrc
fi

## tmux起動
[[ -z "${TMUX}" && -z "${WINDOW}" && -n "${PS1}" ]] && tmux || :

# ZSHRC性能検査 (zshenvの先頭とセット)
# if (which zprof > /dev/null) ;then
#   zprof | less
# fi
