# dotfiles

## installation

1. setup git & zsh
2. register SSH key to GitHub
3. call below

```sh
curl "https://raw.githubusercontent.com/kyoh86/dotfiles/main/setup" | zsh
```

and create a `${DOTFILES}/git/config_host` like below.

```
[user]
	signingkey = <gpg key id>
[include]
	path = config_Linux
```

## my Ergodox layout

https://configure.ergodox-ez.com/ergodox-ez/layouts/MZajL/latest/0
:memo: if you want to change layout, login and edit it.
