# vim: set tabstop=2 shiftwidth=2 expandtab :

# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

######## zgenom ########

source "$ZGENOM/zgenom.zsh"

if ! zgenom saved; then
  zgenom oh-my-zsh

  local plugins=(
    z
    git
    fzf
    python
    colored-man-pages
    command-not-found
  )
  for p in $plugins
  do
    zgenom oh-my-zsh plugins/$p
  done

  local repos=(
    zsh-users/zsh-completions
    zsh-users/zsh-autosuggestions
    zdharma-continuum/fast-syntax-highlighting
    Tarrasch/zsh-autoenv
    thirteen37/fzf-alias
    djui/alias-tips
    hlissner/zsh-autopair
    zpm-zsh/colorize
    MenkeTechnologies/zsh-cargo-completion
    Licheam/zsh-ask
    jirutka/zsh-shift-select
  )
  for r in $repos
  do
    zgenom load $r
  done

  zgenom load romkatv/powerlevel10k powerlevel10k

  zgenom save
  zgenom compile "$HOME/.zshrc"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

######## Keybindings ########

bindkey "\e[1;3D" backward-word # ⌥←
bindkey "\e[1;3C" forward-word  # ⌥→
bindkey "\e[1;2H" beginning-of-line # fn-shift-←
bindkey "\e[1;2F" end-of-line # fn-shift-→

######## Utils ########

for file ("$DOTFILES_ROOT"/zsh_utils/*.zsh(.N)) source "$file"
for file ("$HOME"/.zsh_utils/*.zsh(.N)) source "$file"

